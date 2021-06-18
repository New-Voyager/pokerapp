import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'package:dart_nats/dart_nats.dart';
import 'dart:developer';

import 'package:pokerapp/models/player_info.dart';

const MAX_CHAT_BUFSIZE = 20;

// GameChat class wraps communication between NATS and games chat widget.
class GameMessagingService {
  Stream<Message> stream;
  Client client;
  String chatChannel;
  bool active;
  PlayerInfo currentPlayer;
  List<ChatMessage> messages = [];

  GameMessagingService(
    this.currentPlayer,
    this.chatChannel,
    this.client,
    this.stream,
    this.active,
  );

  Function onText;
  Function onAudio;
  Function onGiphy;
  Function onAnimation;
  Function onCards;

  Uuid uuid;

  void listen({
    void onText(ChatMessage _),
    void onAudio(ChatMessage _),
    void onGiphy(ChatMessage _),
    void onAnimation(ChatMessage _),
    void onCards(ChatMessage _),
  }) {
    if (onAudio != null) {
      this.onAudio = onAudio;
    }

    if (onText != null) {
      this.onText = onText;
    }

    if (onGiphy != null) {
      this.onGiphy = onGiphy;
    }

    if (onAnimation != null) {
      this.onAnimation = onAnimation;
    }

    if (onCards != null) {
      this.onCards = onCards;
    }
  }

  void start() {
    if (!this.active) {
      return;
    }
    this.uuid = Uuid();
    this.stream.listen((Message natsMsg) {
      if (!active) return;
      handleMessage(natsMsg);
    });
  }

  void handleMessage(Message natsMsg) {
    log('chat message received: $messages');

    // handle messages
    if (this.messages.length > MAX_CHAT_BUFSIZE) {
      this.messages.removeAt(0);
    }

    final ChatMessage message = ChatMessage.fromMessage(natsMsg.string);

    if (message != null) {
      if (this.messages.length > 0) {
        // check to see whether a message was already there
        for (final prevM in this.messages) {
          if (prevM.messageId == message.messageId) return;
        }
      }
      log('message.type = ${message.type}');

      if (message.type == 'TEXT') {
        if (this.onText != null) {
          this.messages.add(message);
          this.onText(message);
        }
      }

      if (message.type == 'AUDIO') {
        if (this.onAudio != null) {
          this.onAudio(message);
        }
      }

      if (message.type == 'GIPHY') {
        if (this.onGiphy != null) {
          this.messages.add(message);
          this.onGiphy(message);
        }
      }

      if (message.type == 'ANIMATION') {
        if (this.onAnimation != null) {
          this.onAnimation(message);
        }
      }

      if (message.type == 'CARDS') {
        if (this.onCards != null) {
          this.onCards(message);
        }
      }
    }
  }

  void close() {
    this.active = false;
  }

  void sendText(String text) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'text': text,
      'type': 'TEXT',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
    log('message sent: $text');
  }

  void sendAudio(Uint8List audio, int duration) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'audio': base64Encode(audio),
      'duration': duration,
      'type': 'AUDIO',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
  }

  void sendGiphy(String giphyLink) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'link': giphyLink,
      'type': 'GIPHY',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
  }

  void sendAnimation(int fromSeat, int toSeat, String animation) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'from': fromSeat,
      'name': this.currentPlayer.name,
      'to': toSeat,
      'animation': animation,
      'type': 'ANIMATION',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
  }

  void sendCards(
    int currentHandNum,
    List<int> cards,
    int seatNo,
  ) {
    final body = jsonEncode({
      'id': uuid.v1(),
      'seatNo': seatNo,
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'cards': cards,
      'type': 'CARDS',
      'sent': DateTime.now().toUtc().toIso8601String(),
      'text': currentHandNum,
    });

    this.client.pubString(this.chatChannel, body);
  }
}

class ChatMessage {
  String messageId; // uuid
  String text;
  String type;
  String giphyLink;
  Uint8List audio;
  int duration;
  int fromPlayer;
  DateTime received;
  int smileyCount;
  int likeCount;
  int downCount;
  String animationID;
  int fromSeat;
  int toSeat;
  int seatNo;
  List<int> cards;
  String fromName;

  static ChatMessage fromMessage(String data) {
    try {
      var message = jsonDecode(data);
      ChatMessage msg = new ChatMessage();
      msg.type = message['type'].toString();
      msg.fromName = message['name'].toString();
      if (msg.type == 'TEXT') {
        msg.text = message['text'].toString();
      } else if (msg.type == 'AUDIO') {
        if (message['audio'] != null) {
          msg.audio = base64Decode(message['audio'].toString());
          msg.duration = message['duration'] ?? 0;
        } else {
          return null;
        }
      } else if (msg.type == 'GIPHY') {
        msg.giphyLink = message['link'];
      } else if (msg.type == 'ANIMATION') {
        msg.animationID = message['animation'];
      } else if (msg.type == 'CARDS') {
        msg.text = message['text'].toString();
        msg.seatNo = message['seatNo'] == null
            ? -1
            : int.parse(message['seatNo'].toString());
        msg.cards =
            message['cards'].map<int>((e) => int.parse(e.toString())).toList();
      }

      if (msg.type == 'ANIMATION') {
        msg.fromSeat = int.parse(
            message['from'] == null ? '0' : message['from'].toString());
        msg.toSeat =
            int.parse(message['to'] == null ? '0' : message['to'].toString());
      } else {
        msg.fromPlayer = int.parse(
            message['playerID'] == null ? '0' : message['playerID'].toString());
      }
      msg.received = DateTime.parse(message['sent'].toString());
      msg.messageId = message['id'].toString();

      return msg;
    } catch (Exception) {
      return null;
    }
  }
}
