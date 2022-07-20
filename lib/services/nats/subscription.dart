///subscription model
import 'dart:async';
import 'dart:developer';

import 'client.dart';
import 'message.dart';

/// subscription class
class Subscription {
  ///subscriber id (audo generate)
  final int sid;

  ///subject and queuegroup of this subscription
  final String subject, queueGroup;

  final Client _client;

  final _controller = StreamController<Message>(sync: true);

  Stream<Message> _stream;
  bool _closed = true;

  ///constructure
  Subscription(this.sid, this.subject, this._client, {this.queueGroup}) {
    _stream = _controller.stream.asBroadcastStream();
    _closed = false;
  }

  ///
  void unSub() {
    _client.unSub(this);
  }

  ///Stream output when server publish message
  Stream<Message> get stream => _stream;

  ///sink messat to listener
  void add(Message msg) {
    // log('Socket: Stream Sink Message: [${DateTime.now().toIso8601String()}] msg: ${msg.sid} subject: ${msg.subject} data: ${msg.data.toString()}');
    _controller.sink.add(msg);
    // log('Socket: Stream Sink Message: DONE [${DateTime.now().toIso8601String()}] msg: ${msg.sid} subject: ${msg.subject} data: ${msg.data.toString()}');
  }

  ///close the stream
  void close() {
    _controller.close();
    _closed = true;
  }

  bool get closed => _closed;
}
