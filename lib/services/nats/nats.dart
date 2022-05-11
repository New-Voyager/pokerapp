import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/services/app/util_service.dart';
import 'package:pokerapp/services/nats/message.dart';
import 'package:provider/provider.dart';

import 'client.dart';
import 'subscription.dart';
import 'wsclient.dart';

class Nats {
  WSClient get clientSub => _clientSub;
  WSClient _clientSub;

  WSClient get clientPub => _clientPub;
  WSClient _clientPub;

  String _natsUrl;
  String _playerChannel;
  bool _initialized = false;
  Subscription _playerSub;
  BuildContext _providerContext;
  Map<String, Subscription> _clubSubs = Map<String, Subscription>();
  Function(String) playerNotifications;
  Function(String) clubNotifications;

  // functions listens for disconnection
  List<Function> disconnectListeners = [];

  Nats(this._providerContext) {}

  bool get connectionBroken {
    if (_clientPub.status == Status.disconnected ||
        _clientSub.status == Status.disconnected) {
      _clientPub.close();
      _clientSub.close();
      return true;
    }
    if (_clientPub.status == Status.closed ||
        _clientSub.status == Status.closed) {
      _clientPub.close();
      _clientSub.close();
      return true;
    }
    return false;
  }

  Future<void> reconnect() async {
    // if we dont have the player channel yet, dont call reconnect wait for init
    if (_playerChannel == null) return;

    log('network_reconnect: Nats reconnect method invoked');

    close();
    await init(_playerChannel);
    reconnectClubMessages();
  }

  void onDisconnect() {
    for (final listener in disconnectListeners) {
      listener();
    }
  }

  Future<bool> tryReconnect() async {
    try {
      Client client = Client();
      await client.connect(_natsUrl);
      if (client.status == Status.connected) {
        client.close();
        return true;
      }
    } catch (err) {
      log('Trying to connect to Nats $_natsUrl failed');
    }
    return false;
  }

  Future<void> init(String playerChannel) async {
    String natsUrl = await UtilService.getNatsURL();

    // instantiate new clients
    _clientSub = WSClient();
    _clientPub = WSClient();

    _playerChannel = playerChannel;
    _clubSubs = Map<String, Subscription>();
    log('Player channel: $playerChannel');

    // chop the scheme and port number
    natsUrl = natsUrl
        .replaceFirst('nats://', '')
        .replaceFirst('tls://', '')
        .replaceFirst(':4222', '');

    natsUrl = 'ws://192.168.0.108:8090';
    _natsUrl = natsUrl;
    await _clientSub.wsconnect(natsUrl);
    await _clientPub.wsconnect(natsUrl);
    _clientSub.onDisconnect = onDisconnect;

    // subscribe for player messages
    this.subscribePlayerMessages();

    _initialized = true;
  }

  // Client get subClient {
  //   return this._client;
  // }

  // Client get pubClient {
  //   return this._clientPub;
  // }

  bool get initialized {
    return this._initialized;
  }

  void close() {
    _playerSub?.close();

    if (_clubSubs != null) {
      for (final clubSub in _clubSubs.values) {
        clubSub.close();
      }
    }

    _clientSub?.close();
    _clientPub?.close();
    _initialized = false;
  }

  String get playerChannel {
    return this._playerChannel;
  }

  void reconnectClubMessages() {
    for (final clubCode in _clubSubs.keys) {
      String clubChannel = 'club.$clubCode';
      Subscription clubSub = this.clientSub.sub(clubChannel);
      _clubSubs[clubChannel] = clubSub;
      clubSub.stream.listen((Message message) {
        if (clubNotifications != null) {
          clubNotifications(message.string);
        }
      });
    }
  }

  void _updateAppState(String message) {
    final data = jsonDecode(message);

    final String type = data['type'];
    final String changed = data['changed'];

    if (type == 'CLUB_UPDATED') {
      final clubCode = data['clubCode'];

      if (changed == 'NEW_MEMBER') {
        Future.delayed(Duration(seconds: 3), () {
          appState.cacheService.getMembers(clubCode, update: true);
        });
      } else {
        // update club home page model
        appState.cacheService
            .getClubHomePageData(clubCode, update: true)
            .then((value) {
          if (changed == 'NEW_GAME') {
            // a new game has started in any of the club, set to refresh the live games screen
            appState.setNewGame(true);
          } else if (changed == 'GAME_ENDED') {
            // a game in the club is ended, refresh the live games, as well as the game record
            appState.setGameEnded(true);
          }
        }).onError((error, stackTrace) {});
      }
    }
  }

  subscribeClubMessages(String clubCode) {
    String clubChannel = 'club.$clubCode';
    if (_clubSubs.containsKey(clubChannel)) {
      return;
    }
    log('subscribing to club $clubChannel');
    Subscription clubSub = this._clientSub.sub(clubChannel);
    _clubSubs[clubChannel] = clubSub;
    clubSub.stream.listen((Message message) {
      if (clubNotifications != null) {
        clubNotifications(message.string);
        _updateAppState(message.string);
      }
    });
  }

  subscribePlayerMessages() {
    log('subscribing to ${this._playerChannel}');
    this._playerSub = this._clientSub.sub(this._playerChannel);

    _playerSub.stream.listen((Message message) async {
      /*
        {
          "type": "WAITLIST_SEATING",
          "gameCode": "CG-Q8QC9I95J54N8BM",
          "gameType": "HOLDEM",
          "smallBlind": 1,
          "bigBlind": 2,
          "title": "HOLDEM 1/2",
          "clubName": "test",
          "expTime": "2021-05-03T15:03:27.304Z",
          "requestId": "af4b966a-eee7-4bee-8f79-8aa5ec34543e"
        }      
      */
      log('message in player channel: ${message.string}');
      if (playerNotifications != null) {
        playerNotifications(message.string);
      }
    });
  }
}
