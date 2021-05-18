import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:janus_client/JanusClient.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class JanusEngine extends ChangeNotifier {
  JanusClient engine;

  bool isJoined = false, muted = false, enableSpeakerphone = true;

  int gameId;
  String gameCode;
  String uuid;
  int playerId;
//  String janusUrl = 'ws://143.110.189.156:8188/';
  String janusUrl = 'ws://139.59.57.29:8188/';
  //String janusUrl = 'wss://master-janus.onemandev.tech/websocket';
  String janusToken;
  String janusSecret = 'janusrocks';
  //String janusSecret = 'SecureIt';
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

  Widget audioWidget() {
    log('audio widget is called');
    return Container(
              color: Colors.red,
              height: 20,
              width: 0,
              child: RTCVideoView(
                _remoteRenderer,
              )
    );
  }
  createRoom() async {
    var request = {
      'request': 'create',
      'room': this.gameId,
    };
    try {
      final response = await plugin.send(data: request);
      debugPrint('createRoom returned ${jsonEncode(response)}');
    } catch(err) {
      debugPrint('createRoom failed ${err.toString()}');
    }
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
          //apiSecret: janusSecret,
          transport: transport,
          iceServers: [
           RTCIceServer(
              url: "stun:stun2.l.google.com:19302",
              //url: "stun:stun1.l.google.com:19302",
              username: "",
              credential: "")  
          ]);
      initialized = true;
      await _localRenderer.initialize();
      await _remoteRenderer.initialize();

      session = await engine.createSession();

      bool audio = true;
      if (audio) {
        plugin = await session.attach(JanusPlugins.AUDIO_BRIDGE);
        await plugin.initializeMediaDevices(
            mediaConstraints: {"audio": true, "video": false});

        // create a room
        createRoom();

        var join = {
          'request': 'join',
          'room': this.gameId,
          'pin': 'abcd',
          'id': playerId
        };
        try {
          final response = await plugin.send(data: join);
          debugPrint('Joined the room ${jsonEncode(response)}');
        } catch(err) {
          debugPrint('No room in that name. error: ${err.toString()}');
        }
      } else {
        // echo test
        plugin = await session.attach(JanusPlugins.ECHO_TEST);
        await plugin.initializeMediaDevices(
            mediaConstraints: {"audio": true, "video": false});
        var echoAudio = {
          'audio': true,
        };
        try {
          final response = await plugin.send(data: echoAudio);
          debugPrint('Joined the room ${jsonEncode(response)}');
        } catch(err) {
          debugPrint('No room in that name. error: ${err.toString()}');
        }
      }

      debugPrint('session id: ${session.sessionId} plugin handle id: ${plugin.handleId}');

      // to play audio from the remote
      plugin.remoteStream.listen((event) {
        _remoteRenderer.srcObject = event;
        notifyListeners();
      });

      plugin.messages.listen((msg) async {
        if (msg.event['plugindata'] != null) {
          if (msg.event['plugindata']['data'] != null) {
            var data = msg.event['plugindata']['data'];
            if (data['echotest'] == 'event') {
              if (data['result'] == 'ok') {
                RTCSessionDescription offer = await plugin.createOffer(
                    offerToReceiveVideo: false, offerToReceiveAudio: true);
                var publish = {"request": "configure"};
                await plugin.send(data: publish, jsep: offer);
              }
            }
            else if (data['audiobridge'] == 'joined') {
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

  void mute() async {
    var data = {
      "request" : "mute",
      "room" : gameId,
      "id" : playerId,
    };
    try {
      await plugin.send(data: data);
      muted = true;
    } catch(err) {
      log('mute operation failed. err: ${err.toString()}');
    }
  }

  void unmute() async {
    var data = {
      "request" : "mute",
      "room" : gameId,
      "id" : playerId,
    };
    try {
      await plugin.send(data: data);
      muted = true;
    } catch(err) {
      log('mute operation failed. err: ${err.toString()}');
    }
  }
}
