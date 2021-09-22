import 'dart:convert';
import 'dart:developer';

import 'package:flutter_ion/flutter_ion.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
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

  Future<void> initialize() async {}

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

  List<Participant> participants = [];
  IonAudioConferenceService(this.gameState, this.chatService, this.sfuUrl,
      this.confRoom, this.player);

  join() async {
    return;
    try {
      if (_connector != null) {
        return;
      }
      _connector = IonBaseConnector(sfuUrl);
      _rtc = new IonSDKSFU(_connector);
      _rtc.ontrack = onTrack;
      _rtc.onspeaker = onSpeakers;
      await _rtc.connect();
      String playerId = this.player.id.toString();
      await _rtc.join(this.confRoom, playerId);
      log('ION: $playerId joined the conference');
      var localStream = await LocalStream.getUserMedia(
          constraints: Constraints(audio: true, video: false));

      await _rtc.publish(localStream);
      log('RTC: name: $playerId  stream id ${localStream.stream.id}');
      _streamId = localStream.stream.id;
      Participant participant = Participant(stream: localStream, remote: false);
      participant.playerId = this.player.id;
      participant.name = this.player.name;
      participant.playerUuid = this.player.uuid;
      participants.add(participant);
      chatService.onAudioConfMessage = onAudioConfMessage;
      chatService.sendAudioConfResponse(localStream.stream.id);
      chatService.sendAudioConfRequest();
    } catch (err) {
      close();
      throw err;
    }
  }

  void leave() {
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
    }
  }

  close() {
    if (_rtc != null) {
      _rtc.close();
    }
    if (_connector != null) {
      _connector.close();
    }
  }

  onTrack(MediaStreamTrack track, RemoteStream remoteStream) {
    // on new track
    if (track.kind == 'audio') {
      print(
          'RTC: ontrack: remote stream => ${remoteStream.id} stream id: ${remoteStream.stream.id} ownerTag: ${remoteStream.stream.ownerTag}');
      final newParticipant = Participant(stream: remoteStream, remote: true)
        ..initialize();
      participants.add(newParticipant);
    }
  }

  void onSpeakers(Map<String, dynamic> data) {
    log('RTC: onSpeakers ${jsonEncode(data)}');
    String method = '';
    if (data.containsKey("method")) {
      method = data["method"];
    }
    if (method == 'audioLevels' && data.containsKey("params")) {
      List<Participant> speakers = [];
      for (final streamId in data["params"]) {
        for (final participant in participants) {
          if (participant.streamId == streamId) {
            speakers.add(participant);
          }
        }
      }

      List<int> talking = [];
      List<int> stoppedTalking = [];

      for (final participant in participants) {
        Participant speaker;
        for (final participantSpeaker in speakers) {
          if (participantSpeaker.playerId == participant.playerId) {
            // one of the speaker
            speaker = participantSpeaker;
            break;
          }
        }

        if (speaker == null) {
          // not a speaker
          if (participant.isTalking) {
            log('ION: ${participant.name} stopped talking');
            stoppedTalking.add(participant.playerId);
          }
          participant.isTalking = false;
          if (participant.me) {
            gameState.communicationState.talking = false;
            gameState.communicationState.notify();
          }
        } else {
          // speaking
          log('ION: ${participant.name} is talking');
          if (!participant.isTalking) {
            talking.add(participant.playerId);
          }
          participant.isTalking = true;
          if (participant.me) {
            gameState.communicationState.talking = true;
            gameState.communicationState.notify();
          }
        }

        // update the UI
        gameState.talking(talking);
        gameState.stoppedTalking(stoppedTalking);
      }
    }
  }

  // onAudioConfMessage called when a chat broadcast message is received for audio conference
  // type: AUDIO_CONF
  // method: PUBLISH
  // stream: {
  //   playerId: <>
  //   playerUuid: <>
  //   streamId: <>
  // }

  // type: AUDIO_CONF
  // method: REQUEST_STREAM_ID
  onAudioConfMessage(String data) {
    Map<String, dynamic> message = jsonDecode(data);
    if (message.containsKey('method')) {
      String method = message['method'];
      if (method == 'REQUEST_STREAM_ID') {
        // someone is requesting stream id
        chatService.sendAudioConfResponse(this._streamId);
      } else if (method == 'PUBLISH') {
        // someone is publishing their stream id
        log('AUDIOCONF: New stream found. $data');
        final String streamId = message['streamId'];
        if (streamId == _streamId) {
          // my stream id, ignore
        } else {
          final participant = getParticipantByStreamId(streamId);
          if (participant != null) {
            // set player id information
            // 'playerID': this.currentPlayer.id,
            // 'name': this.currentPlayer.name,
            // 'playerUuid': this.currentPlayer.uuid,
            participant.playerId = message['playerId'];
            participant.name = message['name'];
            participant.playerUuid = message['uuid'];
          }
        }
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
}
