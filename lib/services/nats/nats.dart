import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:pokerapp/services/app/util_service.dart';

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
      log('message in player channel: ${message.string}');
    });
  }
}
