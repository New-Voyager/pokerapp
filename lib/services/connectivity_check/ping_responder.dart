import 'dart:convert';
import 'dart:math';

import 'package:dart_nats/dart_nats.dart';

class PingResponder {
  int playerId;
  Stream<Message> stream;
  Client client;
  String pongChannel;
  bool active;
  List<PingPongMessage> messages = [];

  // For debugging
  bool debug = true;
  Random rng = new Random();

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

    if (debug) {
      // Don't respond to the network check sometimes, so that we can see the
      // view change.
      if (rng.nextInt(10) < 3) {
        this.sendResponse(message);
      }
    } else {
      this.sendResponse(message);
    }
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
