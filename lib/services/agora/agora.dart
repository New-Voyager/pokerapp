import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class Agora extends ChangeNotifier {
  // following data are jusr for testing
  String id = "32bf46ef6f7d4af698d633b7b09a2aa3";
  String token =
      "00632bf46ef6f7d4af698d633b7b09a2aa3IAB3yZiKTpaiMliECTmVM48rMhftRqc9VgMPOQTFpUS6geLcsooAAAAAEABFd1n8nNUoYAEAAQCb1Shg";

  RtcEngine engine;

  bool isJoined = false, openMicrophone = true, enableSpeakerphone = true;

  String gameCode;
  String uuid;
  Agora({this.gameCode, this.uuid});
  Future initEngine() async {
    engine = await RtcEngine.create(id);
    this._addListeners();
    await engine.enableAudio();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
  }

  void disposeAgora() {
    engine?.destroy();
  }

  _addListeners() {
    print("check");
    engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess ${channel} ${uid} ${elapsed}');
        /* setState(() {
          isJoined = true;
        });*/
      },
      leaveChannel: (stats) {
        log('leaveChannel ${stats.toJson()}');
        /*  setState(() {
          isJoined = false;
        });*/
      },
    ));
  }

  joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    print("gameCode $gameCode uuid $uuid");
    await engine?.joinChannel(
        token, 'test1', null, 0); //test1 = gameCode , 0 =uuid
  }

  leaveChannel() async {
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
