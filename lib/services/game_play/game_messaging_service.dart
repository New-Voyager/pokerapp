import 'dart:convert';
import 'dart:typed_data';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/services/nats/client.dart';
import 'package:pokerapp/services/nats/message.dart';
import 'package:uuid/uuid.dart';

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
  List<String> playedAudio = [];

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
  Function onRabbitHunt;

  Uuid uuid;

  void listen({
    void onText(ChatMessage _),
    void onAudio(ChatMessage _),
    void onGiphy(ChatMessage _),
    void onAnimation(ChatMessage _),
    void onCards(ChatMessage _),
    void onRabbitHunt(ChatMessage _),
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

    if (onRabbitHunt != null) {
      this.onRabbitHunt = onRabbitHunt;
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
    final ChatMessage message = ChatMessage.fromMessage(natsMsg.string);

    // handle messages
    if (message.type == 'TEXT' || message.type == 'GIPHY') {
      if (this.messages.length > MAX_CHAT_BUFSIZE) {
        this.messages.removeAt(0);
      }
    }

    if (message != null) {
      if (this.messages.length > 0) {
        // check to see whether a message was already there
        for (final prevM in this.messages) {
          if (prevM.messageId == message.messageId) return;
        }
      }

      if (message.type == 'TEXT') {
        if (this.onText != null) {
          this.messages.add(message);
          this.onText(message);
        }
      }

      if (message.type == 'AUDIO') {
        if (this.onAudio != null) {
          if (playedAudio.indexOf(message.messageId) == -1) {
            playedAudio.add(message.messageId);
            if (playedAudio.length >= MAX_CHAT_BUFSIZE) {
              playedAudio.removeAt(0);
            }
            this.onAudio(message);
          }
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

      if (message.type == 'RABBIT') {
        if (this.onRabbitHunt != null) {
          this.onRabbitHunt(message);
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

  void sendRabbitHunt(RabbitState rs) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'playerCards': rs.myCards,
      'boardCards': rs.communityCards,
      'revealedCards': rs.revealedCards,
      'handNo': rs.handNo,
      'type': 'RABBIT',
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.client.pubString(this.chatChannel, body);
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
    log('GameScreen: $body');
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

  int handNo;
  List<int> playerCards;
  List<int> boardCards;
  List<int> revealedCards;

  static ChatMessage fromMessage(String data) {
    List<int> _getCardsFrom(var cards) =>
        cards.map<int>((e) => int.parse(e.toString())).toList();

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
        msg.cards = _getCardsFrom(message['cards']);
      } else if (msg.type == 'RABBIT') {
        msg.playerCards = _getCardsFrom(message['playerCards']);
        msg.boardCards = _getCardsFrom(message['boardCards']);
        msg.revealedCards = _getCardsFrom(message['revealedCards']);
        msg.handNo = int.parse(message['handNo'].toString());
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
