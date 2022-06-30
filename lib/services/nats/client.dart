import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'common.dart';
import 'inbox.dart';
import 'message.dart';
import 'subscription.dart';

enum ReceiveState {
  idle, //op=msg -> msg
  msg, //newline -> idle

}

///status of the nats client
enum Status {
  /// discontected or not connected
  disconnected,

  ///connected to server
  connected,

  ///alread close by close or server
  closed,

  ///automatic reconnection to server
  reconnecting,

  ///connecting by connect() method
  connecting,

  // draining_subs,
  // draining_pubs,
}

class Pub {
  final String subject;
  final List<int> data;
  final String replyTo;

  Pub(this.subject, this.data, this.replyTo);
}

///NATS client
class Client {
  bool _wsConnection = false;
  String _uri;
  WebSocketChannel _channel;
  Socket _socket; // socket channel
  Info _info;
  Completer _pingCompleter;
  Function onDisconnect;

  ///status of the client
  var status = Status.disconnected;

  ///server info
  Info get info => _info;

  final _subs = <int, Subscription>{};
  final _backendSubs = <int, bool>{};
  final _pubBuffer = <Pub>[];

  int _ssid = 0;
  static final connectDefault = ConnectOption(verbose: false);

  Future<bool> connect(String uri,
      {int timeout = 5, bool retry = false, int retryInterval = 10}) async {
    final uriComponents = Uri.parse(uri);
    if (uriComponents.scheme == 'ws' || uriComponents.scheme == 'wss') {
      _wsConnection = true;
      return wsconnect(uri,
          timeout: timeout, retry: retry, retryInterval: retryInterval);
    } else {
      _wsConnection = false;
      String host = uriComponents.host;
      int port = uriComponents.port;
      if (host.isEmpty) {
        host = uri;
      }
      if (port == 0) {
        port = 4222;
      }
      return socketConnect(host,
          port: port,
          timeout: timeout,
          retry: retry,
          retryInterval: retryInterval);
    }
  }

  /// Connect to NATS server
  Future<bool> wsconnect(String uri,
      {int timeout = 5, bool retry = false, int retryInterval = 10}) async {
    if (status != Status.disconnected && status != Status.closed) {
      return Future.error('Error: status not disconnected and not closed');
    }

    try {
      status = Status.disconnected;
      _uri = uri;
      _channel = WebSocketChannel.connect(Uri.parse(uri));
      status = Status.connected;
      log('dartnats: Connected');
      _backendSubscriptAll();
      _flushPubBuffer();

      _buffer = [];
      _channel.stream.listen((d) {
        _buffer.addAll(d);
        String buf = String.fromCharCodes(_buffer);
        // log('listen: $buf');
        while (_receiveState == ReceiveState.idle && _buffer.contains(13)) {
          _processOp();
        }
      }, onDone: () {
        log('dartnats: onDone loop disconnected');
        status = Status.disconnected;
        _channel.sink.close();
        if (onDisconnect != null) {
          Future.delayed(const Duration(milliseconds: 100), () {
            onDisconnect();
          });
        }
      }, onError: (err) {
        log('dartnats: onError (${err.toString()}) loop disconnected');
        status = Status.disconnected;
        _channel.sink.close();
      });
      return true;
    } catch (err) {
      close();
    }
    return false;
  }

  /// Connect to NATS server
  Future<bool> socketConnect(String host,
      {int port = 4222,
      ConnectOption connectOption,
      int timeout = 5,
      bool retry = false,
      int retryInterval = 10}) async {
    if (status != Status.disconnected && status != Status.closed) {
      return Future.error('Error: status not disconnected and not closed');
    }

    if (connectOption == null) {
      connectOption = ConnectOption(verbose: false);
    }

    try {
      status = Status.disconnected;
      _socket =
          await Socket.connect(host, port, timeout: Duration(seconds: timeout));
      status = Status.connected;
      log('dartnats: Connected');
      _addConnectOption(connectOption);
      _backendSubscriptAll();
      _flushPubBuffer();

      _buffer = [];
      _socket.listen((d) {
        _buffer.addAll(d);
        while (_receiveState == ReceiveState.idle && _buffer.contains(13)) {
          _processOp();
        }
      }, onDone: () {
        log('dartnats: onDone loop disconnected');
        status = Status.disconnected;
        _socket.close();
        if (onDisconnect != null) {
          Future.delayed(Duration(milliseconds: 100), () {
            onDisconnect();
          });
        }
      }, onError: (err) {
        log('dartnats: onError loop disconnected');
        status = Status.disconnected;
        _socket.close();
      });
      return true;
    } catch (err) {
      close();
    }
    return false;
  }

  void _backendSubscriptAll() {
    _backendSubs.clear();
    _subs.forEach((sid, s) async {
      _sub(s.subject, sid, queueGroup: s.queueGroup);
      // s.backendSubscription = true;
      _backendSubs[sid] = true;
    });
  }

  void _flushPubBuffer() {
    _pubBuffer.forEach((p) {
      _pub(p);
    });
  }

  List<int> _buffer = [];
  ReceiveState _receiveState = ReceiveState.idle;
  String _receiveLine1 = '';
  void _processOp() async {
    // we have got a chunk of data from previous message
    if (_receiveLine1.isNotEmpty) {
      _processMsg();
    }
    while (true) {
      ///find endline
      var nextLineIndex = _buffer.indexWhere((c) {
        if (c == 13) {
          return true;
        }
        return false;
      });
      if (nextLineIndex == -1) return;

      var line =
          String.fromCharCodes(_buffer.sublist(0, nextLineIndex)); // retest
      log(line);

      if (_buffer.length > nextLineIndex + 2) {
        _buffer.removeRange(0, nextLineIndex + 2);
      } else {
        _buffer = [];
      }

      ///decode operation
      var i = line.indexOf(' ');
      String op, data;
      if (i != -1) {
        op = line.substring(0, i).trim().toLowerCase();
        data = line.substring(i).trim();
      } else {
        op = line.trim().toLowerCase();
        data = '';
      }

      ///process operation
      switch (op) {
        case 'msg':
          _receiveState = ReceiveState.msg;
          _receiveLine1 = line;
          _processMsg();
          break;
        case 'info':
          _info = Info.fromJson(jsonDecode(data));
          break;
        case 'ping':
          _add('pong');
          break;
        case '-err':
          _processErr(data);
          break;
        case 'pong':
          log('[${DateTime.now().toString()}] PONG');
          _pingCompleter.complete();
          break;
        case '+ok':
          //do nothing
          break;
      }
    }
  }

  void _processErr(String data) {
    close();
  }

  void _processMsg() {
    var s = _receiveLine1.split(' ');
    var subject = s[1];
    var sid = int.parse(s[2]);
    String replyTo;
    int length;
    if (s.length == 4) {
      length = int.parse(s[3]);
    } else {
      replyTo = s[3];
      length = int.parse(s[4]);
    }
    if (_buffer.length < length) {
      //_prevMsgHeader = _receiveLine1
      _receiveState = ReceiveState.idle;
      return;
    }
    var payload = Uint8List.fromList(_buffer.sublist(0, length));
    // _buffer = _buffer.sublist(length + 2);
    if (_buffer.length > length + 2) {
      _buffer.removeRange(0, length + 2);
    } else {
      _buffer = [];
    }

    if (_subs[sid] != null) {
      if (!_subs[sid].closed) {
        _subs[sid].add(Message(subject, sid, payload, replyTo: replyTo));
      }
    }
    _receiveLine1 = '';
    _receiveState = ReceiveState.idle;
  }

  /// get server max payload
  int maxPayload() => _info.maxPayload;

  ///ping server current not implement pong verification
  Future ping() {
    _pingCompleter = Completer();
    _add('ping');
    log('[${DateTime.now().toString()}] PING');
    return _pingCompleter.future;
  }

  ///default buffer action for pub
  var defaultPubBuffer = true;

  ///publish by byte (Uint8List) return true if sucess sending or buffering
  ///return false if not connect
  bool pub(String subject, Uint8List data, {String replyTo, bool buffer}) {
    buffer ??= defaultPubBuffer;
    if (status != Status.connected) {
      if (buffer) {
        _pubBuffer.add(Pub(subject, data, replyTo));
      } else {
        return false;
      }
    }

    if (replyTo == null || replyTo == '') {
      _add('pub $subject ${data.length}');
    } else {
      _add('pub $subject $replyTo ${data.length}');
    }
    _addByte(data);

    return true;
  }

  ///publish by string
  bool pubString(String subject, String str,
      {String replyTo, bool buffer = true}) {
    return pub(subject, Uint8List.fromList(utf8.encode(str)),
        replyTo: replyTo, buffer: buffer);
  }

  bool _pub(Pub p) {
    if (p.replyTo == null) {
      _add('pub ${p.subject} ${p.data.length}');
    } else {
      _add('pub ${p.subject} ${p.replyTo} ${p.data.length}');
    }
    _addByte(p.data);

    return true;
  }

  ///subscribe to subject option with queuegroup
  Subscription sub(String subject, {String queueGroup}) {
    _ssid++;
    var s = Subscription(_ssid, subject, this, queueGroup: queueGroup);
    _subs[_ssid] = s;
    if (status == Status.connected) {
      _sub(subject, _ssid, queueGroup: queueGroup);
      _backendSubs[_ssid] = true;
    }
    return s;
  }

  void _sub(String subject, int sid, {String queueGroup}) {
    if (queueGroup == null) {
      _add('sub $subject $sid');
    } else {
      _add('sub $subject $queueGroup $sid');
    }
  }

  ///unsubscribe
  bool unSub(Subscription s) {
    if (s == null) {
      return false;
    }
    var sid = s.sid;

    if (_subs[sid] == null) return false;
    _unSub(sid);
    _subs.remove(sid);
    s.close();
    _backendSubs.remove(sid);
    return true;
  }

  ///unsubscribe by id
  bool unSubById(int sid) {
    if (_subs[sid] == null) return false;
    return unSub(_subs[sid]);
  }

  //todo unsub with max msgs

  void _unSub(int sid, {String maxMsgs}) {
    if (maxMsgs == null) {
      _add('unsub $sid');
    } else {
      _add('unsub $sid $maxMsgs');
    }
  }

  bool _add(String str) {
    if (_wsConnection) {
      if (_channel == null) return false; //todo throw error
      _channel.sink.add(utf8.encode(str + '\r\n'));
    } else {
      if (_socket == null) return false; //todo throw error

      _socket.add(utf8.encode(str + '\r\n'));
    }
    return true;
  }

  bool _addByte(List<int> msg) {
    if (_wsConnection) {
      if (_channel == null) return false; //todo throw error
      _channel.sink.add(msg);
      _channel.sink.add(utf8.encode('\r\n'));
    } else {
      if (_socket == null) return false; //todo throw error

      _socket.add(msg);
      _socket.add(utf8.encode('\r\n'));
    }
    return true;
  }

  final _inboxs = <String, Subscription>{};

  /// Request will send a request payload and deliver the response message,
  /// or an error, including a timeout if no message was received properly.
  Future<Message> request(String subj, Uint8List data,
      {String queueGroup, Duration timeout}) {
    timeout ??= const Duration(seconds: 2);

    if (_inboxs[subj] == null) {
      var inbox = newInbox();
      _inboxs[subj] = sub(inbox, queueGroup: queueGroup);
    }

    var stream = _inboxs[subj].stream;
    var respond = stream.take(1).single;
    pub(subj, data, replyTo: _inboxs[subj].subject);

    // todo timeout

    return respond;
  }

  /// requestString() helper to request()
  Future<Message> requestString(String subj, String data,
      {String queueGroup, Duration timeout}) {
    return request(subj, Uint8List.fromList(data.codeUnits),
        queueGroup: queueGroup, timeout: timeout);
  }

  ///close connection to NATS server unsub to server but still keep subscription list at client
  void close() {
    _backendSubs.forEach((_, s) => s = false);
    _inboxs.clear();
    if (_channel != null) {
      _channel.sink.close();
    }
    if (_socket != null) {
      _socket?.close();
    }
    status = Status.closed;
  }

  void _addConnectOption(ConnectOption c) {
    _add('connect ' + jsonEncode(c.toJson()));
  }
}
