import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:flutter/foundation.dart';
import 'package:pokerapp/resources/app_apis.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameComService {
  Client _client;
  Client _clientPub;
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
    _clientPub = Client();
    this.initiated = false;
  }

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await _client.connect(sharedPreferences.getString(AppConstants.NATS_URL));
    await _clientPub.connect(sharedPreferences.getString(AppConstants.NATS_URL));

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
