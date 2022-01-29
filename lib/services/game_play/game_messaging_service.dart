import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/services/nats/message.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'dart:developer';

import 'package:pokerapp/models/player_info.dart';

const MAX_CHAT_BUFSIZE = 20;
const kWaitBeforeStopMessageCollection = const Duration(seconds: 1);
const kTestMessageType = 'TEST';
const kTextMessageType = 'TEXT';
const kRequestMessageMessageType = 'REQUEST_MESSAGE';
const kReceivedMessageMessageType = 'RECEIVED_MESSAGE';
const kAudioMessageType = 'AUDIO';
const kGiphyMessageType = 'GIPHY';
const kAnimationMessageType = 'ANIMATION';
const kCardsMessageType = 'CARDS';
const kRabbitMessageType = 'RABBIT';
const kPlayerInfoMessageType = 'PLAYER_INFO';
const kAudioConfMessageType = 'AUDIOCONF';

// GameChat class wraps communication between NATS and games chat widget.
class GameMessagingService {
  Stream<Message> stream;
  Nats nats;
  String chatChannel;
  bool active;
  PlayerInfo currentPlayer;
  List<ChatMessage> messages = [];
  List<String> playedAudio = [];
  GameState gameState;

  GameMessagingService(
    this.currentPlayer,
    this.chatChannel,
    this.nats,
    this.stream,
    this.active,
  );

  Function onText;
  Function onAudio;
  Function onGiphy;
  Function onAnimation;
  Function onCards;
  Function onRabbitHunt;
  Function onAudioConfMessage;

  // to get my information
  Function getMyInfo;
  Function(GamePlayerInfo) onPlayerInfo;

  Uuid uuid;

  void listen({
    void onText(ChatMessage _),
    void onAudio(ChatMessage _),
    void onGiphy(ChatMessage _),
    void onAnimation(ChatMessage _),
    void onCards(ChatMessage _),
    void onRabbitHunt(ChatMessage _),
    void onAudioConfMessage(dynamic _),
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

    if (onAudioConfMessage != null) {
      this.onAudioConfMessage = onAudioConfMessage;
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
    if (message == null) return;

    // handle messages
    if (message.type == kTextMessageType || message.type == kGiphyMessageType) {
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

      if (message.type == kTextMessageType) {
        if (this.onText != null) {
          this.messages.add(message);
          this.onText(message);
        }
      }

      if (message.type == kAudioMessageType) {
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

      if (message.type == kGiphyMessageType) {
        if (this.onGiphy != null) {
          this.messages.add(message);
          this.onGiphy(message);
        }
      }

      if (message.type == kAnimationMessageType) {
        if (this.onAnimation != null) {
          this.onAnimation(message);
        }
      }

      if (message.type == kCardsMessageType) {
        if (this.onCards != null) {
          this.onCards(message);
        }
      }

      if (message.type == kRabbitMessageType) {
        if (this.onRabbitHunt != null) {
          this.onRabbitHunt(message);
        }
      }

      // audio conf message
      if (message.type == kAudioConfMessageType &&
          this.onAudioConfMessage != null) {
        this.onAudioConfMessage(message.data);
      }

      // audio conf message
      if (message.type == kPlayerInfoMessageType) {
        this._onPlayerInfo(message.data);
      }

      // req for message
      if (message.type == kRequestMessageMessageType) {
        _messageRequested(message);
      }

      if (message.type == kReceivedMessageMessageType) {
        _requestedMessagesReceived(message);
      }
    }
  }

  void _sendChatMessages(List<String> rawMessages) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'type': kReceivedMessageMessageType,
      'data': rawMessages,
      'count': rawMessages.length,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });

    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  void _messageRequested(ChatMessage message) {
    /// If the message request is NOT from me, do not bother
    if (message.fromPlayer != currentPlayer.id) return;

    /// I have no messages to share - this should never happen
    if (messages.length == 0) return;

    /// I have some messages, procced to share
    List<String> rawMessages = messages.map((m) => m.toJson()).toList();

    _sendChatMessages(rawMessages);
  }

  /// fills the `messages` array in this class with the new messages,
  /// if the received message length is more
  void _requestedMessagesReceived(ChatMessage chatMessage) {
    if (chatMessage.messageCount > messages.length) {
      List rawMessage = jsonDecode(chatMessage.data);
      List<ChatMessage> receivedMessages =
          rawMessage.map<ChatMessage>((d) => ChatMessage.fromJson(d)).toList();

      messages.clear();
      messages.addAll(receivedMessages);
      gameState.gameChatNotifState.notifyNewMessage();
    }
  }

  void _askForChatMessages(int fromPlayer) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': fromPlayer,
      'type': kRequestMessageMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  /// playerId, noChatMessages Map
  final Map<int, int> _playerWithMaxMessages = {};
  bool _isCollecting = false;

  /// this function waits for 1 second to collect all player's max message count
  /// then proccesses it
  void _handleCollection() async {
    await Future.delayed(kWaitBeforeStopMessageCollection);

    int playerId = -1;
    int maxx = -1;

    for (final d in _playerWithMaxMessages.entries) {
      if (maxx < d.value) {
        maxx = d.value;
        playerId = d.key;
      }
    }

    /// ofcourse, `playerId` should never be -1 here
    if (playerId == -1) return;

    _askForChatMessages(playerId);

    _isCollecting = false;
  }

  void _handleChatMessagesRequest(String json) {
    /// I have messages, I do not need to participant in message collection
    if (messages.isNotEmpty) return;

    final data = jsonDecode(json);
    final int noChatMessages = data['noChatMessages'] as int;
    final int playerId = data['playerID'] as int;

    /// if the player has no chat messages, he can't help
    /// `noChatMessages` referes to Number of Chat Messages, it's not a `boolean`
    if (noChatMessages == 0) return;

    _playerWithMaxMessages[playerId] = noChatMessages;

    if (_isCollecting == false) {
      _isCollecting = true;
      _handleCollection();
    }
  }

  void close() {
    this.active = false;
  }

  void _onPlayerInfo(String message) {
    Map<String, dynamic> json = jsonDecode(message);
    if (json['method'] == 'REQUEST') {
      // another player is requesting my information
      this.sendMyInfo();
    } else if (json['method'] == 'PUBLISH') {
      // another player is publishing his/her information
      final playerInfo = GamePlayerInfo.fromJson(json);
      _handleChatMessagesRequest(message);
      if (this.onPlayerInfo != null) {
        this.onPlayerInfo(playerInfo);
      }
    }
  }

  void sendMyInfo() {
    if (this.getMyInfo != null) {
      GamePlayerInfo playerInfo = this.getMyInfo();
      if (playerInfo == null) {
        return;
      }
      dynamic body = jsonEncode({
        'id': uuid.v1(),
        'playerID': this.currentPlayer.id,
        'name': this.currentPlayer.name,
        'type': kPlayerInfoMessageType,
        'method': 'PUBLISH',
        'streamId': playerInfo.streamId ?? '',
        'namePlateId': playerInfo.namePlateId,
        'muted': this.gameState.playerLocalConfig.mute,
        'sent': DateTime.now().toUtc().toIso8601String(),
        'noChatMessages': messages.length,
      });
      this.nats.clientPub.pubString(this.chatChannel, body);
    }
  }

  void sendText(String text) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'text': text,
      'type': kTextMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
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
      'type': kRabbitMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  void sendAudio(Uint8List audio, int duration) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'audio': base64Encode(audio),
      'duration': duration,
      'type': kAudioMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  void sendGiphy(String giphyLink) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'playerID': this.currentPlayer.id,
      'name': this.currentPlayer.name,
      'link': giphyLink,
      'type': kGiphyMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  void sendAnimation(int fromSeat, int toSeat, String animation) {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'from': fromSeat,
      'name': this.currentPlayer.name,
      'to': toSeat,
      'animation': animation,
      'type': kAnimationMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
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
      'type': kCardsMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
      'text': currentHandNum,
    });
    // log('GameScreen: $body');
    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  // void sendAudioConfResponse(String streamId) {
  //   dynamic body = jsonEncode({
  //     'id': uuid.v1(),
  //     'playerID': this.currentPlayer.id,
  //     'name': this.currentPlayer.name,
  //     'playerUuid': this.currentPlayer.uuid,
  //     'streamId': streamId,
  //     'method': 'PUBLISH',
  //     'type': kAudioConfMessageType,
  //     'sent': DateTime.now().toUtc().toIso8601String(),
  //   });
  //   this.nats.clientPub.pubString(this.chatChannel, body);
  // }

  void requestPlayerInfo() {
    dynamic body = jsonEncode({
      'id': uuid.v1(),
      'method': 'REQUEST',
      'type': kPlayerInfoMessageType,
      'sent': DateTime.now().toUtc().toIso8601String(),
    });
    this.nats.clientPub.pubString(this.chatChannel, body);
  }

  // void sendAudioConfRequest() {
  //   dynamic body = jsonEncode({
  //     'id': uuid.v1(),
  //     'method': 'REQUEST_STREAM_ID',
  //     'type': kAudioConfMessageType,
  //     'sent': DateTime.now().toUtc().toIso8601String(),
  //   });
  //   this.nats.clientPub.pubString(this.chatChannel, body);
  // }
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
  String data;
  int messageCount;

  int handNo;
  List<int> playerCards;
  List<int> boardCards;
  List<int> revealedCards;

  ChatMessage();

  factory ChatMessage.fromJson(String json) {
    ChatMessage message = new ChatMessage();
    final data = jsonDecode(json);

    message.messageId = data['messageId'];
    message.fromName = data['fromName'];
    message.fromPlayer = data['fromPlayer'];
    message.received = DateTime.parse(data['received']);
    message.type = data['type'];
    message.text = data['text'];
    message.giphyLink = data['giphyLink'];

    return message;
  }

  String toJson() {
    final dataMap = {
      'messageId': messageId,
      'fromName': fromName,
      'fromPlayer': fromPlayer,
      'received': received.toIso8601String(),
      'type': type,
    };

    if (text != null) dataMap['text'] = text;
    if (giphyLink != null) dataMap['giphyLink'] = giphyLink;

    return jsonEncode(dataMap);
  }

  static ChatMessage fromMessage(String data) {
    List<int> _getCardsFrom(var cards) =>
        cards.map<int>((e) => int.parse(e.toString())).toList();

    try {
      var message = jsonDecode(data);
      String type = message['type'].toString();

      ChatMessage msg = new ChatMessage();
      msg.type = kTestMessageType;
      msg.type = type;
      msg.data = data;

      if (message['name'] != null) {
        msg.fromName = message['name'].toString();
      }

      if (msg.type == kTextMessageType) {
        msg.text = message['text'].toString();
      } else if (msg.type == kAudioMessageType) {
        if (message['audio'] != null) {
          msg.audio = base64Decode(message['audio'].toString());
          msg.duration = message['duration'] ?? 0;
        } else {
          return null;
        }
      } else if (msg.type == kGiphyMessageType) {
        msg.giphyLink = message['link'];
      } else if (msg.type == kAnimationMessageType) {
        msg.animationID = message['animation'];
      } else if (msg.type == kCardsMessageType) {
        // log('RevealCards: ${data}');
        msg.text = message['text'].toString();
        msg.seatNo = message['seatNo'] == null
            ? -1
            : int.parse(message['seatNo'].toString());
        msg.cards = _getCardsFrom(message['cards']);
      } else if (msg.type == kRabbitMessageType) {
        msg.playerCards = _getCardsFrom(message['playerCards']);
        msg.boardCards = _getCardsFrom(message['boardCards']);
        msg.revealedCards = _getCardsFrom(message['revealedCards']);
        msg.handNo = int.parse(message['handNo'].toString());
      } else if (msg.type == kReceivedMessageMessageType) {
        msg.data = jsonEncode(message['data']);
        msg.messageCount = message['count'];
      }

      if (msg.type == kAnimationMessageType) {
        msg.fromSeat = int.parse(
            message['from'] == null ? '0' : message['from'].toString());
        msg.toSeat =
            int.parse(message['to'] == null ? '0' : message['to'].toString());
      } else {
        msg.fromPlayer = int.parse(
            message['playerID'] == null ? '0' : message['playerID'].toString());
      }

      if (message['sent'] != null) {
        msg.received = DateTime.parse(message['sent'].toString());
      }
      if (message['id'] != null) {
        msg.messageId = message['id'].toString();
      }
      return msg;
    } catch (err) {
      log('Error: ${err.toString()}, ${err.stackTrace}');
      return null;
    }
  }
}

class GamePlayerInfo {
  String namePlateId;
  String streamId;
  int playerId;
  bool muted = false;
  String uuid;
  String name;
  GamePlayerInfo();
  factory GamePlayerInfo.fromJson(dynamic json) {
    GamePlayerInfo info = GamePlayerInfo();
    info.namePlateId = json['namePlateId'] ?? "0";
    info.streamId = json['streamId'] ?? '';
    info.playerId = int.parse(json['playerID'].toString());
    info.muted = json['muted'] ?? false;
    info.uuid = json['uuid'] ?? '';
    info.name = json['name'] ?? '';
    return info;
  }
}
