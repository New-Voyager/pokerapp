import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:flutter/foundation.dart';
import 'package:pokerapp/resources/app_apis.dart';

class GameComService {
  Client _client;

  String gameToPlayerChannel;
  String handToAllChannel;
  String handToPlayerChannel;
  String playerToHandChannel;

  Subscription _gameToPlayerChannelSubs;
  Subscription _handToAllChannelSubs;
  Subscription _handToPlayerChannelSubs;

  GameComService({
    @required this.gameToPlayerChannel,
    @required this.handToAllChannel,
    @required this.handToPlayerChannel,
    @required this.playerToHandChannel,
  }) {
    _client = Client();
    _client.connect(AppApis.baseUrl);

    // subscribe
    log('subscribing to ${this.gameToPlayerChannel}');
    _gameToPlayerChannelSubs = _client.sub(this.gameToPlayerChannel);

    log('subscribing to ${this.handToAllChannel}');
    _handToAllChannelSubs = _client.sub(this.handToAllChannel);

    log('subscribing to ${this.handToPlayerChannel}');
    _handToPlayerChannelSubs = _client.sub(this.handToPlayerChannel);
  }

  bool sendPlayerToHandChannel(String data) =>
      this._client.pubString(this.playerToHandChannel, data);

  void dispose() {
    _gameToPlayerChannelSubs.unSub();
    _handToAllChannelSubs.unSub();
    _handToPlayerChannelSubs.unSub();

    _client?.close();
  }

  Stream<Message> get gameToPlayerChannelStream =>
      _gameToPlayerChannelSubs.stream;

  Stream<Message> get handToAllChannelStream => _handToAllChannelSubs.stream;

  Stream<Message> get handToPlayerChannelStream =>
      _handToPlayerChannelSubs.stream;
}
