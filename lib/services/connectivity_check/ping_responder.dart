import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:fixnum/fixnum.dart' as $fixnum;

import 'package:dart_nats/dart_nats.dart';

class PingResponder {
  int playerId;
  Stream<Message> stream;
  Client client;
  String pongChannel;
  bool active;
  List<PingPongMessage> messages = [];

  // For debugging
  bool debug = false;
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
    final PingPongMessage message = PingPongMessage.fromProto(natsMsg.data);

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
    // msg.playerId = this.playerId;
    // String msgStr = msg.toJson();
    // this.client.pubString(this.pongChannel, msgStr);
    Uint8List data = msg.toProto(this.playerId);
    this.client.pub(this.pongChannel, data);
  }
}

class PingPongMessage {
  int gameId;
  String gameCode;
  int playerId;
  int seq;
  proto.PingPongMessage pongMsg;

  static PingPongMessage fromMessage(String data) {
    try {
      var message = jsonDecode(data);
      PingPongMessage msg = new PingPongMessage();

      msg.gameId = int.parse(message['gameId'].toString());
      msg.gameCode = message['gUint8ListameCode'].toString();
      if (message['playerId'] != null) {
        msg.playerId = int.parse(message['playerId'].toString());
      }
      msg.seq = int.parse(message['seq'].toString());

      return msg;
    } catch (Exception) {
      return null;
    }
  }

  static PingPongMessage fromProto(Uint8List data) {
    try {
      final message = proto.PingPongMessage.fromBuffer(data);
      PingPongMessage msg = new PingPongMessage();
      msg.pongMsg = message;

      msg.gameId = message.gameId.toInt();
      msg.gameCode = message.gameCode;
      if (message.playerId != null) {
        msg.playerId = message.playerId.toInt();
      }
      msg.seq = message.seq;
      return msg;
    } catch (Exception) {
      return null;
    }
  }

  Uint8List toProto(int playerId) {
    pongMsg.playerId = $fixnum.Int64(playerId);
    return pongMsg.writeToBuffer();
  }

  String toJson() => jsonEncode({
        'gameId': this.gameId,
        'gameCode': this.gameCode,
        'playerId': this.playerId,
        'seq': this.seq,
      });
}
