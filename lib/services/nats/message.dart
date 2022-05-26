///message model sending from NATS server
import 'dart:convert';
import 'dart:typed_data';

/// Message class
class Message {
  ///subscriber id auto generate by client
  final int sid;

  /// subject  and replyto
  final String subject, replyTo;
  // final Client _client;

  ///payload of data in byte
  final Uint8List data;

  ///constructure
  Message(this.subject, this.sid, this.data, {this.replyTo});

  ///payload in string
  String get string => utf8.decode(data);
}
