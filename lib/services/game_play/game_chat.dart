import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_nats/dart_nats.dart';
import 'dart:developer';

import 'package:pokerapp/models/player_info.dart';

// GameChat class wraps communication between NATS and games chat widget.
class GameChat {
  Stream<Message> stream;
  Client client;
  String chatChannel;
  bool active;
  PlayerInfo currentPlayer;
  List<ChatMessage> messages;
  GameChat(this.currentPlayer, this.chatChannel, this.client, this.stream,
      this.active);

  void start() {
    if (!this.active) {
      return;
    }
    this.messages = new List<ChatMessage>();
    this.stream.listen((Message message) {
      if (!active) return;
      log('chat message received');

      // handle messages
    });
  }

  void close() {
    this.active = false;
  }

  void sendText(String text) {
    dynamic body = jsonEncode({
      'playerID': this.currentPlayer.id,
      'text': text,
      'type': 'TEXT',
    });
    this.client.pub(this.chatChannel, body);
  }
}

class ChatMessage {
  String messageId; // uuid
  String text;
  String type;
  String giphyLink;
  Uint8List audio;
  int fromPlayer;
  DateTime received;
  int smileyCount;
  int likeCount;
  int downCount;
}
