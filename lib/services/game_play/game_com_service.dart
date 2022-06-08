import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/nats/message.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/nats/subscription.dart';
import 'package:pokerapp/services/test/test_service.dart';

class GameComService {
  // Client _client;
  // Client _clientPub;
  bool active;

  String gameToPlayerChannel;
  String handToAllChannel;
  String handToPlayerChannel;
  String playerToHandChannel;
  String handToPlayerTextChannel;
  String gameChatChannel;
  String tournamentChannel;

  Subscription _gameToPlayerChannelSubs;
  Subscription _handToAllChannelSubs;
  Subscription _handToPlayerChannelSubs;
  Subscription _handToPlayerTextChannelSubs;
  Subscription _gameChatChannelSubs;
  Subscription _tournamentChannelSubs;

  StreamController<Message> _gameToPlayerChannelInternal =
      StreamController.broadcast();
  StreamController<Message> _handToAllChannelInternal =
      StreamController.broadcast();
  StreamController<Message> _handToPlayerChannelInternal =
      StreamController.broadcast();
  StreamController<Message> _handToPlayerTextChannelInternal =
      StreamController.broadcast();
  StreamController<Message> _gameChatChannelInternal =
      StreamController.broadcast();
  StreamController<Message> _tournamentChannelInternal =
      StreamController.broadcast();

  // current player info
  PlayerInfo currentPlayer;

  // game chat object
  GameMessagingService _chat;

  GameMessagingService get chat => _chat;

  Nats _nats;

  GameComService({
    @required this.currentPlayer,
    @required this.gameToPlayerChannel,
    @required this.handToAllChannel,
    @required this.handToPlayerChannel,
    @required this.playerToHandChannel,
    @required this.handToPlayerTextChannel,
    @required this.gameChatChannel,
    @required this.tournamentChannel,
  }) {
    // _client = Client();
    // _clientPub = Client();
    log('handToAllChannel: $handToAllChannel');
    this.active = false;
  }

  Future<void> reconnect(Nats nats) async {
    _close();
    active = false;

    // init
    return init(nats, isReconnect: true);
  }

  Future<void> init(Nats nats, {final bool isReconnect = false}) async {
    // if already active, do not resubscribe again
    if (active) return;

    // subscribe
    log('subscribing to ${this.gameToPlayerChannel}');
    _gameToPlayerChannelSubs = nats.clientSub.sub(this.gameToPlayerChannel);
    _gameToPlayerChannelSubs.stream
        .listen((event) => _gameToPlayerChannelInternal.add(event));

    log('subscribing to ${this.handToAllChannel}');
    _handToAllChannelSubs = nats.clientSub.sub(this.handToAllChannel);
    _handToAllChannelSubs.stream
        .listen((event) => _handToAllChannelInternal.add(event));

    log('subscribing to ${this.handToPlayerChannel}');
    _handToPlayerChannelSubs = nats.clientSub.sub(this.handToPlayerChannel);
    _handToPlayerChannelSubs.stream
        .listen((event) => _handToPlayerChannelInternal.add(event));

    log('subscribing to ${this.handToPlayerTextChannel}');
    _handToPlayerTextChannelSubs =
        nats.clientSub.sub(this.handToPlayerTextChannel);
    _handToPlayerTextChannelSubs.stream
        .listen((event) => _handToPlayerTextChannelInternal.add(event));

    log('subscribing to ${this.gameChatChannel}');
    _gameChatChannelSubs = nats.clientSub.sub(this.gameChatChannel);
    _gameChatChannelSubs.stream
        .listen((event) => _gameChatChannelInternal.add(event));

    if (this.tournamentChannel != null) {
      log('subscribing to ${this.tournamentChannel}');
      _tournamentChannelSubs = nats.clientSub.sub(this.tournamentChannel);
      _tournamentChannelSubs.stream
          .listen((event) => _tournamentChannelInternal.add(event));
    }

    if (this._chat == null) {
      this._chat = GameMessagingService(
        this.currentPlayer,
        this.gameChatChannel,
        nats,
        _gameChatChannelInternal.stream, // use the internal stream here
        true,
      );
      this._chat.start();
    }

    this._nats = nats;
    this.active = true;
  }

  void sendPlayerToHandChannel(String data) {
    assert(active);
    this._nats.clientPub.pubString(this.playerToHandChannel, data);
  }

  bool sendProtoPlayerToHandChannel(Uint8List data) {
    assert(active);
    return this._nats.clientPub.pub(this.playerToHandChannel, data);
  }

  void _close() {
    // _gameToPlayerChannelSubs?.unSub();
    _gameToPlayerChannelSubs?.close();

    // _handToAllChannelSubs?.unSub();
    _handToAllChannelSubs?.close();

    // _handToPlayerChannelSubs?.unSub();
    _handToPlayerChannelSubs?.close();

    // _handToPlayerTextChannelSubs?.unSub();
    _handToPlayerTextChannelSubs?.close();

    // _gameChatChannelSubs?.unSub();
    _gameChatChannelSubs?.close();

    // tournament channel
    _tournamentChannelInternal?.close();
  }

  void dispose() {
    log('game com service -- disposing');

    // unsub
    _gameToPlayerChannelSubs?.unSub();
    _handToAllChannelSubs?.unSub();
    _handToPlayerChannelSubs?.unSub();
    _handToPlayerTextChannelSubs?.unSub();
    _gameChatChannelSubs?.unSub();
    _gameChatChannelSubs?.unSub();

    // close
    _close();

    // close the internal streams
    _gameToPlayerChannelInternal.close();
    _handToAllChannelInternal.close();
    _handToPlayerChannelInternal.close();
    _handToPlayerTextChannelInternal.close();
    _gameChatChannelInternal.close();
    _tournamentChannelInternal.close();

    active = false;
    // _client?.close();
    // _clientPub?.close();
  }

  Stream<Message> get gameToPlayerChannelStream {
    // assert(active);
    return _gameToPlayerChannelInternal.stream;
  }

  Stream<Message> get handToAllChannelStream {
    assert(active);
    return _handToAllChannelInternal.stream;
  }

  Stream<Message> get handToPlayerTextChannelStream {
    assert(active);
    return _handToPlayerTextChannelInternal.stream;
  }

  Stream<Message> get handToPlayerChannelStream {
    assert(active);
    return _handToPlayerChannelInternal.stream;
  }

  Stream<Message> get gameChatChannelStream {
    assert(active);
    return _gameChatChannelInternal.stream;
  }

  Stream<Message> get tournamentChannelStream {
    assert(active);
    return _tournamentChannelInternal.stream;
  }

  GameMessagingService get gameMessaging {
    if (TestService.isTesting) {
      return this._chat;
    }
    // assert(active);
    return this._chat;
  }
}
