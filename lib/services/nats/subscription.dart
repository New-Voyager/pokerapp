///subscription model
import 'dart:async';

import 'client.dart';
import 'message.dart';

/// subscription class
class Subscription {
  ///subscriber id (audo generate)
  final int sid;

  ///subject and queuegroup of this subscription
  final String subject, queueGroup;

  final Client _client;

  final _controller = StreamController<Message>();

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
    _controller.sink.add(msg);
  }

  ///close the stream
  void close() {
    _controller.close();
    _closed = true;
  }

  bool get closed => _closed;
}
