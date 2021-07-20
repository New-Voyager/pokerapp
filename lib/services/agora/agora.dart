import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/resources/api_keys.dart';

class Agora extends ChangeNotifier {
  RtcEngine engine;

  bool isJoined = false, openMicrophone = true, enableSpeakerphone = true;

  String gameCode;
  String uuid;
  int playerId;
  String agoraToken;
  Agora({this.gameCode, this.uuid, this.playerId});
  Future initEngine() async {
    engine = await RtcEngine.create(ApiKeys.AGORA_API_KEY);
    this._addListeners();
    await engine.enableAudio();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
  }

  void disposeObject() {
    if (isJoined) {
      leaveChannel();
    }
    engine?.destroy();
  }

  _addListeners() {
    print("check");
    engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess $channel $uid $elapsed');
        isJoined = true;
      },
      leaveChannel: (stats) {
        log('leaveChannel ${stats.toJson()}');
        isJoined = false;
      },
    ));
  }

  joinChannel(String agoraToken) async {
    this.agoraToken = agoraToken;
    if (this.agoraToken.isEmpty) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    print("gameCode $gameCode uuid $uuid");
    await engine?.joinChannel(this.agoraToken, this.gameCode, null,
        this.playerId); //test1 = gameCode , 0 =uuid
  }

  leaveChannel() async {
    if (this.agoraToken.isEmpty) {
      return;
    }
    log('player $uuid left audio channel');
    await engine?.leaveChannel();
  }

  switchMicrophone() {
    engine
        ?.enableLocalAudio(!openMicrophone)
        ?.then((value) {})
        ?.catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  switchSpeakerphone() {
    engine
        ?.setEnableSpeakerphone(!enableSpeakerphone)
        ?.then((value) {})
        ?.catchError((err) {
      log('setEnableSpeakerphone $err');
    });
  }
}
