import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/tickr.dart';

class LivenessSender {
  int gameId;
  String gameCode;
  int playerId;
  Nats nats;
  String clientAliveSubject;

  Ticker timer;

  LivenessSender(
    this.gameId,
    this.gameCode,
    this.playerId,
    this.nats,
    this.clientAliveSubject,
  ) {
    this.timer = Ticker();
  }

  void sendAliveMsg() {
    ClientAliveMsg msg =
        new ClientAliveMsg(this.gameId, this.gameCode, this.playerId);
    Uint8List data = msg.toProto();
    this.nats.clientPub.pub(this.clientAliveSubject, data);
  }

  void close() {
    log('LivenessSender: Close');
    if (timer != null) {
      timer.close();
      timer = null;
    }
  }

  void start() {
    log('LivenessSender: Start');
    // start a timer
    timer.start(this.sendAliveMsg);
  }

  void stop() {
    log('LivenessSender: Stop');
    timer.stop();
  }
}

class ClientAliveMsg {
  int gameId;
  String gameCode;
  int playerId;

  ClientAliveMsg(
    this.gameId,
    this.gameCode,
    this.playerId,
  );

  Uint8List toProto() {
    proto.ClientAliveMessage clientAliveMsg = new proto.ClientAliveMessage();
    clientAliveMsg.playerId = $fixnum.Int64(this.playerId);
    clientAliveMsg.gameCode = this.gameCode;
    clientAliveMsg.gameId = $fixnum.Int64(this.gameId);
    return clientAliveMsg.writeToBuffer();
  }

  String toJson() => jsonEncode({
        'gameId': this.gameId,
        'gameCode': this.gameCode,
        'playerId': this.playerId,
      });
}
