import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';

import 'JanusPlugin.dart';
import 'JanusSession.dart';
import 'JanusTransport.dart';
import 'JanusClient.dart';

class JanusEngine extends ChangeNotifier {
  JanusClient engine;

  bool isJoined = false, muted = false, enableSpeakerphone = true;

  String uuid;
  int playerId;
  String janusUrl = 'ws://139.59.57.29:8188/';
  String janusToken;
  String janusSecret;
  String roomPin;
  int roomId;

  //String janusSecret = 'janusrocks';
  WebSocketJanusTransport transport;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  JanusPlugin plugin;
  JanusSession session;
  bool initialized = false;
  bool joined = false;
  GameState gameState;
  bool initializing = false;

  JanusEngine(
      {this.janusUrl,
      this.janusToken,
      this.janusSecret,
      this.gameState,
      this.roomId,
      this.roomPin,
      this.uuid,
      this.playerId}) {}

  void disposeObject() {
    if (initialized) {
      leaveChannel();
    }
    engine = null;
  }

  Widget audioWidget() {
    log('audio widget is called');
    return Container();
    // return Container(
    //     color: Colors.red,
    //     height: 0,
    //     width: 0,
    //     child: RTCVideoView(
    //       _remoteRenderer,
    //     ));
  }

  createRoom() async {
    var request = {
      'request': 'create',
      'room': this.roomId,
      'audiolevel_event': true,
      'audio_level_average': 60,
      'pin': 'abcd'
    };
    try {
      final response = await plugin.send(data: request);
      debugPrint('createRoom returned ${jsonEncode(response)}');
    } catch (err) {
      debugPrint('createRoom failed ${err.toString()}');
    }
  }

  joinChannel(String janusToken) async {
    if (initializing) {
      log('janus: in the process of initializing. Skipping');
      return;
    }
    initializing = true;
    initialized = false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    final start = DateTime.now();
    log('janus: Change audio status to connecting');
    //this.gameState.getAudioConfState().connecting();
    log('janus: engine: ${engine}');
    if (engine == null) {
      log('janus: Using websocket');
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
    }

    _localRenderer = new RTCVideoRenderer();
    _remoteRenderer = new RTCVideoRenderer();

    log('janus: engine is initialized');
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    log('janus: initialized renderes');

    log('janus: creating session');
    session = await engine.createSession();
    log('janus: session is created');

    bool audio = true;
    if (audio) {
      log('janus: attaching audio bridge plugin');
      plugin = await session.attach(JanusPlugins.AUDIO_BRIDGE);
      log('janus: attached audio bridge plugin');
      await plugin.initializeMediaDevices(
          mediaConstraints: {"audio": true, "video": false});

      // create a room
      // if (gameState.currentPlayer.isAdmin()) {
      //   createRoom();
      // }

      log('janus: joining audio room ${this.roomId}');
      var join = {
        'request': 'join',
        'room': this.roomId,
        'pin': 'abcd',
        'id': playerId
      };
      try {
        final response = await plugin.send(data: join);
        log('janus: joined audio room ${this.roomId} ${jsonEncode(response)}');
        this.gameState.getCommunicationState().connected();
        joined = true;
      } catch (err) {
        debugPrint('No room in that name. error: ${err.toString()}');
        log('janus: failed to join audio room ${this.roomId} ${err.toString()}');
        this.gameState.getCommunicationState().failed();
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
        this.gameState.getCommunicationState().connected();
      } catch (err) {
        debugPrint('No room in that name. error: ${err.toString()}');
      }
    }
    final end = DateTime.now();
    final duration = end.difference(start);
    debugPrint(
        'session id: ${session.sessionId} plugin handle id: ${plugin.handleId}. Time take to initialize: ${duration.inSeconds}');

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
          } else if (data['audiobridge'] == 'joined') {
            log('janus: creating offer for the audio conference');
            // player joined
            RTCSessionDescription offer = await plugin.createOffer(
                offerToReceiveVideo: false, offerToReceiveAudio: true);
            var publish = {"request": "configure"};
            await plugin.send(data: publish, jsep: offer);
            log('janus: offer is sent to plugin');
            listParticipants();
          } else if (data['audiobridge'] == 'event') {
            debugPrint('audiobridge: $data');
            var participants = data['participants'];
            updateParticipants(participants);
          } else if (data['audiobridge'] == 'talking') {
            var seat = gameState.getSeatByPlayer(data['id']);
            debugPrint(
                '${seat.player.isMe} audiobridge: ${data["id"]} is talking');
            seat.player.talking = true;
            debugPrint('seat info $seat');
            if (seat.player.isMe) {
              gameState.getCommunicationState().talking = true;
            }

            seat.notify();
          } else if (data['audiobridge'] == 'stopped-talking') {
            debugPrint('audiobridge: ${data["id"]} stopped talking');
            var seat = gameState.getSeatByPlayer(data['id']);
            seat.player.talking = false;
            debugPrint('seat info $seat');
            if (seat.player.isMe) {
              gameState.getCommunicationState().talking = false;
            }
            seat.notify();
          }
        }
      }

      if (msg.jsep != null) {
        log('jsep: ${msg.jsep}');
        await plugin.handleRemoteJsep(msg.jsep);
      }
    });
    initializing = false;
  }

  leaveChannel() async {
    if (!initialized || !joined) {
      return;
    }
    try {
      log('janus: leave ${this.roomId}');
      if (joined) {
        log('player $uuid left audio channel');
        await plugin?.send(data: {"request": "leave"});
        joined = false;
      }
      await plugin?.hangup();

      if (_localRenderer != null) {
        log('janus: local renderer ${this.roomId} disposed');
        _localRenderer?.dispose();
        _localRenderer = null;
      }

      if (_remoteRenderer != null) {
        log('janus: remote renderer ${this.roomId} disposed');
        _remoteRenderer?.dispose();
        _remoteRenderer = null;
      }

      if (plugin != null) {
        log('janus: plugin ${this.roomId} disposed');
        plugin?.dispose();
        plugin = null;
      }

      if (session != null) {
        log('janus: session ${this.roomId} disposed');
        session?.dispose();
        session = null;
      }
      log('janus: engine ${this.roomId} disposed');
    } catch (err) {
      log('Leaving channel caught exception');
    }
    initialized = false;
    joined = false;
    engine = null;
  }

  void updateParticipants(var participantsList) {
    if (participantsList is List && participantsList != null) {
      for (final element in participantsList) {
        final seat = gameState.getSeatByPlayer(element['id']);
        if (seat != null) {
          seat.player.muted = element['muted'] ?? false;
          if (seat.player.muted) {
            if (seat.player.isMe) {
              gameState.getCommunicationState().muted = true;
            }
            seat.player.showMicOff = true;
            seat.notify();
            Timer(Duration(seconds: 1), () {
              seat.player.showMicOff = false;
              seat.notify();
            });
          } else {
            if (seat.player.isMe) {
              gameState.getCommunicationState().muted = false;
            }
            seat.player.showMicOn = true;
            seat.notify();
            Timer(Duration(seconds: 1), () {
              seat.player.showMicOn = false;
              seat.notify();
            });
          }
          seat.player.talking = element['talking'] ?? false;
          if (seat.player.talking) {
            log('Audio ${seat.player.name} is talking');
            if (seat.player.isMe) {
              gameState.getCommunicationState().talking = true;
            }
          } else {
            log('Audio ${seat.player.name} is not talking');
            if (seat.player.isMe) {
              gameState.getCommunicationState().talking = false;
            }
          }

          if (seat.player.playerId == playerId) {
            seat.notify();
          }
        }
      }
    }
  }

  void muteUnmute() {
    final currentPlayer = gameState.getSeatByPlayer(playerId)?.player;
    if (currentPlayer != null) {
      if (currentPlayer.muted) {
        currentPlayer.muted = false;
        unmute();
        log('janus: mic is unmuted');
        joinChannel(this.janusToken);
      } else {
        currentPlayer.muted = true;
        mute();
        log('janus: mic is muted');
        // leave the channel
        leaveChannel();
      }
    }
  }

  void joinLeaveAudioConference() {
    if (gameState.gameSettings.audioConf) {
      log('joining audio conference');
      joinChannel(this.janusToken);
    } else {
      log('leaving audio conference');
      leaveChannel();
    }
  }

  void mute() async {
    var data = {
      "request": "mute",
      "room": this.roomId,
      "id": this.playerId,
    };
    try {
      await plugin.send(data: data);
      muted = true;
    } catch (err) {
      log('mute operation failed. err: ${err.toString()}');
    }
  }

  void unmute() async {
    var data = {
      "request": "unmute",
      "room": this.roomId,
      "id": this.playerId,
    };
    try {
      await plugin.send(data: data);
      muted = false;
    } catch (err) {
      log('unmute operation failed. err: ${err.toString()}');
    }
  }

  void mutePlayer(int playerId) async {
    var data = {
      "request": "mute",
      "room": this.roomId,
      "id": playerId,
    };
    try {
      await plugin.send(data: data);
      muted = true;
    } catch (err) {
      log('mute operation failed. err: ${err.toString()}');
    }
  }

  void unmutePlayer(int playerId) async {
    var data = {
      "request": "mute",
      "room": this.roomId,
      "id": playerId,
    };
    try {
      await plugin.send(data: data);
      muted = true;
    } catch (err) {
      log('unmute operation failed. err: ${err.toString()}');
    }
  }

  void listParticipants() async {
    var data = {
      "request": "listparticipants",
      "room": this.roomId,
    };
    try {
      final resp = await plugin.send(data: data);
      if (resp['plugindata']['data']['participants'] != null) {
        updateParticipants(resp['plugindata']['data']['participants']);
      }
    } catch (err) {
      log('list participants operation failed. err: ${err.toString()}');
    }
  }
}
