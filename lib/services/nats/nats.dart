import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/util_service.dart';
import 'package:pokerapp/services/nats/message.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/main.dart';
import 'package:provider/provider.dart';

import 'client.dart';
import 'subscription.dart';

class Nats {
  Client _client;
  Client _clientPub;
  String _playerChannel;
  bool _initialized = false;
  Subscription _playerSub;
  BuildContext _providerContext;
  Map<String, Subscription> _clubSubs = Map<String, Subscription>();

  Nats(this._providerContext);

  Future<void> reconnect() async {
    log('network_reconnect: Nats reconnect method invoked');

    close();
    await init(_playerChannel);
  }

  Future<void> init(String playerChannel) async {
    String natsUrl = await UtilService.getNatsURL();

    if (_client == null) _client = Client();
    if (_clientPub == null) _clientPub = Client();

    _playerChannel = playerChannel;
    _clubSubs = Map<String, Subscription>();
    log('Player channel: $playerChannel');

    // chop the scheme and port number
    natsUrl = natsUrl
        .replaceFirst('nats://', '')
        .replaceFirst('tls://', '')
        .replaceFirst(':4222', '');

    await _client.connect(natsUrl);
    await _clientPub.connect(natsUrl);

    // subscribe for player messages
    this.subscribePlayerMessages();

    _initialized = true;
  }

  Client get subClient {
    return this._client;
  }

  Client get pubClient {
    return this._clientPub;
  }

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

    _client?.close();
    _clientPub?.close();
    _client = null;
    _clientPub = null;
  }

  String get playerChannel {
    return this._playerChannel;
  }

  subscribeClubMessages(String clubCode) {
    String clubChannel = 'club.$clubCode';
    if (_clubSubs.containsKey(clubChannel)) {
      return;
    }
    log('subscribing to club $clubChannel');
    Subscription clubSub = this.subClient.sub(clubChannel);
    _clubSubs[clubChannel] = clubSub;
    clubSub.stream.listen((Message message) {
      log('message in club channel: ${message.string}');
      dynamic json = jsonDecode(message.string);
      String changed = json['changed'];
      String clubCode = json['clubCode'];
      final clubChangeState = _providerContext.read<ClubsUpdateState>();
      clubChangeState.updatedClubCode = clubCode;
      clubChangeState.notify();
      if (changed == 'CLUB_CHAT') {
        // club chat message
      }
    });
  }

  subscribePlayerMessages() {
    log('subscribing to ${this._playerChannel}');
    this._playerSub = this.subClient.sub(this._playerChannel);

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
      dynamic json = jsonDecode(message.string);
      String type = json['type'].toString();
      String gameCode = json['gameCode'].toString();
      if (type == 'WAITLIST_SEATING') {
        String game = '';
        if (json["gameType"] != null) {
          String gameType = json["gameType"].toString();
          String sb = DataFormatter.chipsFormat(
              double.parse(json['smallBlind'].toString()));
          String bb = DataFormatter.chipsFormat(
              double.parse(json['bigBlind'].toString()));
          game = ' at $gameType $sb/$bb';
        }
        String title = 'Do you want to take a open seat $game?';
        String subTitle = 'Code: ${json["gameCode"]}';
        if (json['clubName'] != null) {
          subTitle = subTitle + '\n' + 'Club: ${json["clubName"]}';
        }
        final message =
            'A seat open in game $game.\n\nDo you want to take the open seat?';

        final res = await showWaitlistInvitation(
            navigatorKey.currentContext, message, 10);
        if (res) {
          navigatorKey.currentState.pushNamed(
            Routes.game_play,
            arguments: gameCode,
          );
        }
      }
    });
  }
}
