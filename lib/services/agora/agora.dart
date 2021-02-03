import 'dart:developer';

import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/resources/api_keys.dart';

class Agora {
  final String gameCode;
  String clubRegion = 'NA';
  RtcEngine _engine = null;
  RtcChannel _channel = null;

  Agora(this.gameCode);

  void create() async {
    // TODO: Handle other regions
    var areaCode = AreaCode.GLOB;
    if (clubRegion == 'NA') {
      areaCode = AreaCode.NA;
    }

    _engine =
        await RtcEngine.createWithAreaCode(ApiKeys.AGORA_API_KEY, areaCode);
    _channel = await RtcChannel.create(gameCode);
    this._addListener(_channel);
  }

  _addListener(RtcChannel channel) {
    String channelId = channel.channelId;
    channel.setEventHandler(
        RtcChannelEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      log('joinChannelSuccess $channel $uid $elapsed');
    }, userJoined: (uid, elapsed) {
      log('userJoined ${channel.channelId} $uid $elapsed');
    }, userOffline: (uid, reason) {
      log('userOffline ${channel.channelId} $uid $reason');
    }, leaveChannel: (stats) {
      log('leaveChannel ${channel.channelId} ${stats.toJson()}');
    }));
  }

  join() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone].request();
    }
  }
}
