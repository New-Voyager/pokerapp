import 'dart:convert';
import 'dart:typed_data';
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:pokerapp/services/nats/nats.dart';

class LivenessSender {
  int gameId;
  String gameCode;
  int playerId;
  Nats nats;
  String clientAliveSubject;

  LivenessSender(
    this.gameId,
    this.gameCode,
    this.playerId,
    this.nats,
    this.clientAliveSubject,
  );

  void sendAliveMsg() {
    ClientAliveMsg msg =
        new ClientAliveMsg(this.gameId, this.gameCode, this.playerId);
    Uint8List data = msg.toProto();
    this.nats.clientPub.pub(this.clientAliveSubject, data);
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
