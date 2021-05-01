import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:flutter/foundation.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';

class GameComService {
  // Client _client;
  // Client _clientPub;
  bool active;

  String gameToPlayerChannel;
  String handToAllChannel;
  String handToPlayerChannel;
  String playerToHandChannel;
  String gameChatChannel;

  Subscription _gameToPlayerChannelSubs;
  Subscription _handToAllChannelSubs;
  Subscription _handToPlayerChannelSubs;
  Subscription _gameChatChannelSubs;

  // current player info
  PlayerInfo currentPlayer;

  // game chat object
  GameMessagingService _chat;

  Nats _nats;

  GameComService({
    @required this.currentPlayer,
    @required this.gameToPlayerChannel,
    @required this.handToAllChannel,
    @required this.handToPlayerChannel,
    @required this.playerToHandChannel,
    @required this.gameChatChannel,
  }) {
    // _client = Client();
    // _clientPub = Client();
    this.active = false;
  }

  Future<void> init(Nats nats) async {
    // if already active, do not resubscribe again
    if (active) return;

    // subscribe
    log('subscribing to ${this.gameToPlayerChannel}');
    _gameToPlayerChannelSubs = nats.subClient.sub(this.gameToPlayerChannel);

    log('subscribing to ${this.handToAllChannel}');
    _handToAllChannelSubs = nats.subClient.sub(this.handToAllChannel);

    log('subscribing to ${this.handToPlayerChannel}');
    _handToPlayerChannelSubs = nats.subClient.sub(this.handToPlayerChannel);

    log('subscribing to ${this.gameChatChannel}');
    _gameChatChannelSubs = nats.subClient.sub(this.gameChatChannel);

    this._chat = GameMessagingService(
      this.currentPlayer,
      this.gameChatChannel,
      nats.pubClient,
      _gameChatChannelSubs.stream,
      true,
    );
    this._chat.start();
    this._nats = nats;
    this.active = true;
  }

  void sendPlayerToHandChannel(String data) {
    assert(active);
    this._nats.pubClient.pubString(this.playerToHandChannel, data);
  }

  void dispose() {
    log('game com service -- disposing');
    _gameToPlayerChannelSubs?.unSub();
    _gameToPlayerChannelSubs?.close();

    _handToAllChannelSubs?.unSub();
    _handToAllChannelSubs?.close();

    _handToPlayerChannelSubs?.unSub();
    _handToPlayerChannelSubs?.close();

    _gameChatChannelSubs?.unSub();
    _gameChatChannelSubs?.close();
    gameMessaging.close();

    active = false;
    // _client?.close();
    // _clientPub?.close();
  }

  Stream<Message> get gameToPlayerChannelStream {
    assert(active);
    return _gameToPlayerChannelSubs.stream;
  }

  Stream<Message> get handToAllChannelStream {
    assert(active);
    return _handToAllChannelSubs.stream;
  }

  Stream<Message> get handToPlayerChannelStream {
    assert(active);
    return _handToPlayerChannelSubs.stream;
  }

  Stream<Message> get gameChatChannelStream {
    assert(active);
    return _gameChatChannelSubs.stream;
  }

  GameMessagingService get gameMessaging {
    if (TestService.isTesting) {
      return this._chat;
    }
    assert(active);
    return this._chat;
  }
}
