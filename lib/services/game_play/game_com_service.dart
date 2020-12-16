import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:flutter/foundation.dart';
import 'package:pokerapp/resources/app_apis.dart';

class GameComService {
  Client _client;
  bool initiated;

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
    this.initiated = false;
  }

  Future<void> init() async {
    // todo: better way to do this?
    await _client.connect(AppApis.natsHost);

    // subscribe
    log('subscribing to ${this.gameToPlayerChannel}');
    _gameToPlayerChannelSubs = _client.sub(this.gameToPlayerChannel);

    log('subscribing to ${this.handToAllChannel}');
    _handToAllChannelSubs = _client.sub(this.handToAllChannel);

    log('subscribing to ${this.handToPlayerChannel}');
    _handToPlayerChannelSubs = _client.sub(this.handToPlayerChannel);

    this.initiated = true;
  }

  void sendPlayerToHandChannel(String data) {
    assert(initiated);
    this._client.pubString(this.playerToHandChannel, data);
  }

  void dispose() {
    _gameToPlayerChannelSubs?.unSub();
    _handToAllChannelSubs?.unSub();
    _handToPlayerChannelSubs?.unSub();
    initiated = false;
    _client?.close();
  }

  Stream<Message> get gameToPlayerChannelStream {
    assert(initiated);
    return _gameToPlayerChannelSubs.stream;
  }

  Stream<Message> get handToAllChannelStream {
    assert(initiated);
    return _handToAllChannelSubs.stream;
  }

  Stream<Message> get handToPlayerChannelStream {
    assert(initiated);
    return _handToPlayerChannelSubs.stream;
  }
}
