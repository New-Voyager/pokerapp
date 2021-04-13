import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:flutter/foundation.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/app/util_service.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';

class GameComService {
  Client _client;
  Client _clientPub;
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
  GameChatService _chat;

  GameComService({
    @required this.currentPlayer,
    @required this.gameToPlayerChannel,
    @required this.handToAllChannel,
    @required this.handToPlayerChannel,
    @required this.playerToHandChannel,
    @required this.gameChatChannel,
  }) {
    _client = Client();
    _clientPub = Client();
    this.active = false;
  }

  Future<void> init() async {
    // if already active, do not resubscribe again
    if (active) return;

    String natsUrl = await UtilService.getNatsURL();

    // chop the scheme and port number
    natsUrl = natsUrl
        .replaceFirst('nats://', '')
        .replaceFirst('tls://', '')
        .replaceFirst(':4222', '');
    await _client.connect(natsUrl);

    // todo: do we need two clients?
    await _clientPub.connect(natsUrl);

    // subscribe
    log('subscribing to ${this.gameToPlayerChannel}');
    _gameToPlayerChannelSubs = _client.sub(this.gameToPlayerChannel);

    log('subscribing to ${this.handToAllChannel}');
    _handToAllChannelSubs = _client.sub(this.handToAllChannel);

    log('subscribing to ${this.handToPlayerChannel}');
    _handToPlayerChannelSubs = _client.sub(this.handToPlayerChannel);

    log('subscribing to ${this.gameChatChannel}');
    _gameChatChannelSubs = _client.sub(this.gameChatChannel);
    this._chat = GameChatService(this.currentPlayer, this.gameChatChannel,
        this._clientPub, _gameChatChannelSubs.stream, true);
    this._chat.start();
    this.active = true;
  }

  void sendPlayerToHandChannel(String data) {
    assert(active);
    this._clientPub.pubString(this.playerToHandChannel, data);
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
    chat.close();

    active = false;
    _client?.close();
    _clientPub?.close();
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

  GameChatService get chat {
    assert(active);
    return this._chat;
  }
}
