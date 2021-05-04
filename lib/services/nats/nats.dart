import 'dart:convert';
import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/services/app/util_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/main.dart';

class Nats {
  Client _client;
  Client _clientPub;
  String _playerChannel;
  bool _initialized = false;
  Subscription _playerSub;

  Future<void> init(String playerChannel) async {
    String natsUrl = await UtilService.getNatsURL();
    _client = Client();
    _clientPub = Client();
    _playerChannel = playerChannel;
    log('Player channel: $playerChannel');

    // chop the scheme and port number
    natsUrl = natsUrl
        .replaceFirst('nats://', '')
        .replaceFirst('tls://', '')
        .replaceFirst(':4222', '');
    await _client.connect(natsUrl);

    // todo: do we need two clients?
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
    if (_playerSub != null) {
      _playerSub.unSub();
    }

    if (_client != null) {
      _client.close();
    }

    if (_clientPub != null) {
      _client.close();
    }
  }

  String get playerChannel {
    return this._playerChannel;
  }

  subscribePlayerMessages() {
    log('subscribing to ${this._playerChannel}');
    this._playerSub = this.subClient.sub(this._playerChannel);

    _playerSub.stream.listen((Message message) {
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

        final alert = AlertDialog(
          title: Text('Waitlist Seating'),
          content: Text('$title \n$subTitle'),
          actions: [
            ElevatedButton(
              //textColor: Color(0xFF6200EE),
              onPressed: () {
                Navigator.of(navigatorKey.currentContext).pop();
                navigatorKey.currentState.pushNamed(
                  Routes.game_play,
                  arguments: gameCode,
                );
              },
              child: Text('Accept'),
            ),
            ElevatedButton(
              //textColor: Color(0xFF6200EE),
              onPressed: () {
                Navigator.of(navigatorKey.currentContext).pop();
              },
              child: Text('Decline'),
            ),
          ],
        );
        // show the dialog
        showDialog(
          context: navigatorKey.currentContext,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    });
  }
}
