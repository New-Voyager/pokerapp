import 'dart:developer';

import 'package:dart_nats/dart_nats.dart';
import 'package:nats/nats.dart';

void tmp() {}

void main() async {
  print('connecting');
  var _client = NatsClient('192.168.1.103', 4222);

  await _client.connect(onConnect: tmp);

  await Future.delayed(const Duration(milliseconds: 500));

  print('connected');

  // subscribe
  var _one = _client.subscribe('one', 'hand.7B9CL7.player.all');
  var _two = _client.subscribe('two', 'game.7B9CL7.player');

  await Future.delayed(const Duration(milliseconds: 500));

  print('subscribed');

  _one.listen((event) {
    log('one');
  });

  _two.listen((event) {
    log('two:');
  });

  _client.publish('hellow', 'hand.7B9CL7.player.all');

  await Future.delayed(const Duration(days: 1));

  print('end');
}
