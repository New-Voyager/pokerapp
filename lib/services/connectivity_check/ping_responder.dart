import 'dart:convert';
import 'dart:math';
import 'package:fixnum/fixnum.dart' as $fixnum;

import 'package:dart_nats/dart_nats.dart';
import 'package:pokerapp/proto/handmessage.pb.dart';

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
    String s = new String.fromCharCodes(natsMsg.data);
    final data = base64Decode(s);

    final PingPongMessage message = PingPongMessage.fromBuffer(data);

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
    msg.playerId = $fixnum.Int64.parseInt(this.playerId.toString());
    final encoded = base64Encode(msg.writeToBuffer());
    final data = utf8.encode(encoded);

    //String msgStr = msg.toJson();
    this.client.pub(this.pongChannel, data);
  }
}
/*
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
*/