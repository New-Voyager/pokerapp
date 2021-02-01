import 'dart:convert';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

import 'package:dart_nats/dart_nats.dart';
import 'dart:developer';

import 'package:pokerapp/models/player_info.dart';

const MAX_CHAT_BUFSIZE = 20;

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
  Function onText;
  Function onAudio;
  Function onGiphy;
  Uuid uuid;
  void listen({
    Function onText,
    Function onAudio,
    Function onGiphy,
  }) {
    this.onText = onText;
    this.onAudio = onAudio;
    this.onGiphy = onGiphy;
  }

  void start() {
    if (!this.active) {
      return;
    }
    this.uuid = Uuid();
    this.messages = List<ChatMessage>();
    this.stream.listen((Message natsMsg) {
      if (!active) return;
      log('chat message received');

      // handle messages
      if (this.messages.length > MAX_CHAT_BUFSIZE) {
        this.messages.removeLast();
      }
      final message = ChatMessage.fromMessage(natsMsg.string);
      if (message != null) {
        if (this.messages.length > 0) {
          // check to see whether a message was already there
          for (final element in this.messages) {
            if (element.messageId == message.messageId) {
              return;
            }
          }
        }

        this.messages.insert(0, message);

        if (message.type == 'TEXT') {
          if (this.onText != null) {
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
            this.onGiphy(message);
          }
        }
      }
    });
  }

  void close() {
    this.active = false;
  }

  void sendText(String text) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'text': text,
      'type': 'TEXT',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
    log('message sent: $text');
  }

  void sendAudio(Uint8List audio) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'audio': base64Encode(audio),
      'type': 'AUDIO',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
  }

  void sendGiphy(String giphyLink) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'link': giphyLink,
      'type': 'GIPHY',
      'sent': DateTime.now().toUtc().toIso8601String(),
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
  int fromPlayer;
  DateTime received;
  int smileyCount;
  int likeCount;
  int downCount;

  static ChatMessage fromMessage(String data) {
    try {
      var message = jsonDecode(data);
      ChatMessage msg = new ChatMessage();
      msg.type = message['type'].toString();
      if (msg.type == 'TEXT') {
        msg.text = message['text'].toString();
      } else if (msg.type == 'AUDIO') {
        if (message.audio != null) {
          msg.audio = base64Decode(message['audio'].toString());
        } else {
          return null;
        }
      } else if (msg.type == 'GIPHY') {
        msg.giphyLink = message['link'];
      }

      msg.fromPlayer = int.parse(
          message['playerID'] == null ? '0' : message['playerID'].toString());
      msg.received = DateTime.parse(message['sent'].toString());
      msg.messageId = message['id'].toString();
      return msg;
    } catch (Exception) {
      return null;
    }
  }
}
