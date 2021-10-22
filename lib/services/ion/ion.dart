import 'dart:convert';
import 'dart:developer';

import 'package:flutter_ion/flutter_ion.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';

class Participant {
  // name, player id, playerUuid are initialized later
  String name = '';
  int playerId = 0;
  String playerUuid = '';

  bool isMuted = false;
  bool isTalking = false;
  bool isSelfMute;
  Object stream;
  LocalStream localStream;
  RTCVideoRenderer renderer = RTCVideoRenderer();
  bool me = false;
  bool remote;

  String get streamId => remote
      ? (stream as RemoteStream).stream.id
      : (stream as LocalStream).stream.id;

  MediaStream get mediaStream =>
      remote ? (stream as RemoteStream).stream : (stream as LocalStream).stream;

  String get title =>
      (remote ? 'Remote' : 'Local') + ' ' + streamId.substring(0, 8);

  Participant({
    this.stream,
    this.isMuted = false,
    this.isTalking = false,
    this.isSelfMute = false,
    this.remote = false,
  });

  Future<void> initialize() async {
    await renderer.initialize();
  }

  void dispose() async {
    if (!remote) {
      await (stream as LocalStream).unpublish();
      mediaStream.getTracks().forEach((element) {
        element.stop();
      });
      await mediaStream.dispose();
    }
  }

  void preferLayer(Layer layer) {
    if (remote) {
      (stream as RemoteStream).preferLayer?.call(layer);
    }
  }

  void mute() async {
    if (remote) {
      log('RTC: $name is muted');
      (stream as RemoteStream).mute?.call('audio');
      isMuted = true;
    } else {
      final localStream = (stream as LocalStream);
      isMuted = true;
      var track = localStream.getTrack('audio');
      if (track != null) {
        track.setMicrophoneMute(true);
      }
    }
  }

  void unmute() async {
    if (remote) {
      log('RTC: $name is unmuted');
      (stream as RemoteStream).unmute?.call('audio');
      isMuted = false;
    } else {
      final localStream = (stream as LocalStream);
      var track = localStream.getTrack('audio');
      isMuted = false;
      if (track != null) {
        track.setMicrophoneMute(false);
      }
    }
  }
}

class IonAudioConferenceService {
  final String sfuUrl;
  final String confRoom;
  final PlayerInfo player;
  final GameMessagingService chatService;
  final GameState gameState;
  IonBaseConnector _connector;
  IonSDKSFU _rtc;
  String _streamId;
  bool _inConference = false;
  bool _closed = false;
  bool _isVideo = false;

  List<Participant> participants = [];

  IonAudioConferenceService(
    this.gameState,
    this.chatService,
    this.sfuUrl,
    this.confRoom,
    this.player,
  );

  RTCVideoRenderer getVideoRenderer(int playerId) {
    // this returns the video renderer of a participant
    for (final p in participants) {
      if (p.playerId == playerId) {
        return p.renderer;
      }
    }
    return null;
  }

  void updatePlayerId(String streamId, int playerId) {
    for (final participant in participants) {
      if (participant.streamId == streamId) {
        participant.playerId = playerId;
      }
    }
  }

  join({bool isVideo = false}) async {
    this._isVideo = isVideo;

    try {
      if (_connector != null) {
        return;
      }
      _closed = false;
      _connector = IonBaseConnector(sfuUrl);
      _rtc = new IonSDKSFU(_connector);
      _rtc.ontrack = onTrack;
      _rtc.onspeaker = onSpeakers;
      await _rtc.connect();
      if (_closed) return;
      String playerId = this.player.id.toString();
      await _rtc.join(this.confRoom, playerId);
      if (_closed) return;
      log('ION: $playerId joined the conference');

      var localStream = await LocalStream.getUserMedia(
        constraints: Constraints(audio: true, video: _isVideo),
      );

      await _rtc.publish(localStream);
      if (_closed) return;
      log('RTC: name: $playerId  stream id ${localStream.stream.id}');
      _streamId = localStream.stream.id;
      Participant participant = Participant(stream: localStream, remote: false);
      participant.playerId = this.player.id;
      participant.name = this.player.name;
      participant.playerUuid = this.player.uuid;
      participants.add(participant);
      if (gameState.me != null) {
        gameState.me.streamId = localStream.stream.id;

        if (_isVideo) {
          await participant.initialize();
          participant.renderer.srcObject = localStream.stream;
        }
      }
      _inConference = true;
    } catch (err) {
      close();
      throw err;
    }
  }

  Future<void> leave() async {
    // on leaving set the _isVideo value to default, i.e. false
    _isVideo = false;

    if (participants.length == 0) {
      return;
    }
    // find me
    Participant me;
    for (final participant in participants) {
      if (participant.playerId == this.player.id) {
        me = participant;
        break;
      }
    }
    if (me != null) {
      for (int i = 0; i < participants.length; i++) {
        if (participants[i].playerId == me.playerId) {
          participants.removeAt(i);
          break;
        }
      }
      me.dispose();

      gameState.communicationState.talking = false;
      final mySeat = gameState.mySeat;
      if (mySeat != null) {
        mySeat.player.talking = false;
        mySeat.notify();
      }
      _inConference = false;
    }
    gameState.communicationState.audioConferenceStatus =
        AudioConferenceStatus.LEFT;

    await close();
  }

  Future<void> close() async {
    for (final p in participants) {
      // FIXME: we cannot dispose here - it causes error, need to find a way to dispose off
      // await p.renderer.dispose()
    }

    _closed = true;
    if (_rtc != null) {
      _rtc.close();
    }
    _rtc = null;
    if (_connector != null) {
      _connector.close();
    }
    _connector = null;
  }

  void onTrack(MediaStreamTrack track, RemoteStream remoteStream) async {
    // on new track
    if (track.kind == 'audio') {
      log('RTC: ontrack: remote stream => ${remoteStream.id} stream id: ${remoteStream.stream.id} ownerTag: ${remoteStream.stream.ownerTag}');
      final newParticipant = Participant(stream: remoteStream, remote: true)
        ..initialize();
      participants.add(newParticipant);
    }

    if (track.kind == 'video') {
      log('RTC: ontrack: remote stream => ${remoteStream.id} stream id: ${remoteStream.stream.id} ownerTag: ${remoteStream.stream.ownerTag}');
      final newParticipant = Participant(stream: remoteStream, remote: true);
      await newParticipant.initialize();

      // set the srcObject
      newParticipant.renderer.srcObject = remoteStream.stream;

      participants.add(newParticipant);
      chatService.sendMyInfo();
    }
  }

  void onSpeakers(Map<String, dynamic> data) {
    log('RTC: onSpeakers ${jsonEncode(data)}');
    String method = '';
    if (data.containsKey("method")) {
      method = data["method"];
    }
    if (method == 'audioLevels' && data.containsKey("params")) {
      List<Seat> speakers = [];
      for (final streamId in data["params"]) {
        for (final seat in gameState.seats) {
          if (seat.player != null) {
            if (seat.player.streamId == streamId) {
              speakers.add(seat);
            }
          }
        }
      }

      List<Seat> talking = [];
      List<Seat> stoppedTalking = [];

      for (final seat in gameState.seats) {
        if (seat.player == null) {
          continue;
        }
        bool speaking = false;
        for (final speakerFromConf in speakers) {
          if (seat.serverSeatPos == speakerFromConf.serverSeatPos) {
            speaking = true;
            break;
          }
        }

        if (!speaking) {
          // not a speaker
          if (seat.player.talking) {
            log('RTC: ${seat.player.name} stopped talking');
            stoppedTalking.add(seat);
          }
        } else {
          // speaking
          log('RTC: ${seat.player.name} is talking');
          if (!seat.player.talking) {
            talking.add(seat);
          }
        }

        // update the UI
        gameState.talking(talking);
        gameState.stoppedTalking(stoppedTalking);
      }
    }
  }

  Participant getParticipantByStreamId(String streamId) {
    for (final participant in participants) {
      if (participant.streamId == streamId) {
        return participant;
      }
    }
    return null;
  }

  Participant me() {
    Participant meObject;
    for (final participant in participants) {
      if (participant.playerId == this.player.id) {
        meObject = participant;
        break;
      }
    }
    return meObject;
  }

  void muteUnmutePlayer(String streamId) {
    Participant participant = getParticipantByStreamId(streamId);
    if (participant != null) {
      if (participant.isMuted) {
        participant.unmute();
      } else {
        participant.mute();
      }
    }
  }

  bool isPlayerMuted(String streamId) {
    Participant participant = getParticipantByStreamId(streamId);
    if (participant != null) {
      return participant.isMuted;
    }
    return false;
  }

  void mutePlayer(String streamId) {
    Participant participant = getParticipantByStreamId(streamId);
    if (participant != null) {
      participant.mute();
    }
  }

  void unmutePlayer(String streamId) {
    Participant participant = getParticipantByStreamId(streamId);
    if (participant != null) {
      participant.unmute();
    }
  }

  void muteAll() {
    // if the current player is in the conference, mute
    if (_inConference) {
      for (final participant in participants) {
        if (participant.playerId == this.player.id) {
          // me
          continue;
        }
        participant.mute();
      }
    }
  }

  void unmuteAll() {
    // if the current player is in the conference, mute
    if (_inConference) {
      for (final participant in participants) {
        participant.unmute();
      }
    }
  }

  void mute() {
    // if the current player is in the conference, mute
    if (_inConference) {
      final me = this.me();
      if (me != null && !me.isMuted) {
        me.mute();
      }
    }
  }

  void unmute() {
    // if the current player is in the conference, mute
    if (_inConference) {
      final me = this.me();
      if (me != null && me.isMuted) {
        me.unmute();
      }
    }
  }
}
