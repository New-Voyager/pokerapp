import 'dart:convert';

import 'package:dart_nats/dart_nats.dart';

class PingResponder {
  int playerId;
  Stream<Message> stream;
  Client client;
  String pongChannel;
  bool active;
  List<PingPongMessage> messages = [];

  PingResponder(
    this.playerId,
    this.pongChannel,
    this.client,
    this.stream,
    this.active,
  );

  void start() {
    if (!this.active) {
      return;
    }
    this.stream.listen((Message natsMsg) {
      if (!active) return;
      handleMessage(natsMsg);
    });
  }

  void handleMessage(Message natsMsg) {
    final PingPongMessage message = PingPongMessage.fromMessage(natsMsg.string);
    this.sendResponse(message);
  }

  void close() {
    this.active = false;
  }

  void sendResponse(PingPongMessage msg) {
    msg.playerId = this.playerId;
    String msgStr = msg.toJson();
    this.client.pubString(this.pongChannel, msgStr);
  }
}

class PingPongMessage {
  int gameId;
  String gameCode;
  int playerId;
  int seq;

  static PingPongMessage fromMessage(String data) {
    try {
      var message = jsonDecode(data);
      PingPongMessage msg = new PingPongMessage();

      msg.gameId = int.parse(message['gameId'].toString());
      msg.gameCode = message['gameCode'].toString();
      if (message['playerId'] != null) {
        msg.playerId = int.parse(message['playerId'].toString());
      }
      msg.seq = int.parse(message['seq'].toString());

      return msg;
    } catch (Exception) {
      return null;
    }
  }

  String toJson() => jsonEncode({
        'gameId': this.gameId,
        'gameCode': this.gameCode,
        'playerId': this.playerId,
        'seq': this.seq,
      });
}
