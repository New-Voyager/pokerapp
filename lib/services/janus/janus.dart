import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:janus_client/JanusClient.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class JanusEngine extends ChangeNotifier {
  JanusClient engine;

  bool isJoined = false, openMicrophone = true, enableSpeakerphone = true;

  int gameId;
  String gameCode;
  String uuid;
  int playerId;
  String janusUrl = 'ws://143.110.189.156:8188/';
  String janusToken;
  String janusSecret = 'janusrocks';
  WebSocketJanusTransport transport;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  JanusPlugin plugin;
  JanusSession session;
  bool initialized = false;
  JanusEngine({this.gameId, this.gameCode, this.uuid, this.playerId});
  void disposeObject() {
    if (initialized) {
      leaveChannel();
    }
    //engine?.
  }

  joinChannel(String janusToken) async {
    initialized = false;
    janusToken = 'test';
    this.janusToken = janusToken;
    if (this.janusToken.isEmpty) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    print("gameCode $gameCode uuid $uuid");
    if (engine == null) {
      transport = WebSocketJanusTransport(url: janusUrl);
      engine = JanusClient(
          withCredentials: true,
          apiSecret: janusSecret,
          transport: transport,
          iceServers: []);
      initialized = true;
      await _localRenderer.initialize();
      await _remoteRenderer.initialize();

      session = await engine.createSession();
      plugin = await session.attach(JanusPlugins.AUDIO_BRIDGE);
      await plugin.initializeMediaDevices(
          mediaConstraints: {"audio": true, "video": false});

      var join = {
        'request': 'join',
        'room': this.gameId,
        'pin': 'abcd',
        'id': playerId
      };
      await plugin.send(data: join);

      // to play audio from the remote
      plugin.remoteStream.listen((event) {
        _remoteRenderer.srcObject = event;
      });

      plugin.messages.listen((msg) async {
        if (msg.event['plugindata'] != null) {
          if (msg.event['plugindata']['data'] != null) {
            var data = msg.event['plugindata']['data'];
            if (data['audiobridge'] == 'joined') {
              // player joined
              RTCSessionDescription offer = await plugin.createOffer(
                  offerToReceiveVideo: false, offerToReceiveAudio: true);
              var publish = {"request": "configure"};
              await plugin.send(data: publish, jsep: offer);
            } else if (data['audiobridge'] == 'event') {
              var participants = data['participants'];
              // get participant changes like player talking
            }
          }
        }

        if (msg.jsep != null) {
          print('got remote jsep');
          await plugin.handleRemoteJsep(msg.jsep);
        }
      });
    }
  }

  leaveChannel() async {
    if (this.janusToken.isEmpty) {
      return;
    }
    log('player $uuid left audio channel');
    await plugin?.send(data: {"request": "leave"});
    await plugin?.hangup();
    plugin?.dispose();
    session?.dispose();
    _localRenderer?.dispose();
    _remoteRenderer?.dispose();
    engine = null;
  }

  switchMicrophone() {}

  switchSpeakerphone() {}
}
