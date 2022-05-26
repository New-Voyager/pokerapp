import 'dart:convert';
import 'dart:developer';
import 'dart:io';

//import 'package:flutter_ion/flutter_ion.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';

/*
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
  String streamId = '';

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
  }) {
    if (this.stream != null) {
      streamId = remote
          ? (stream as RemoteStream).stream.id
          : (stream as LocalStream).stream.id;
    }
  }

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
    if (stream == null) {
      return;
    }

    if (remote) {
      log('RTC: $name [${this.streamId}] is muted');
      (stream as RemoteStream).mute?.call('audio');
      isMuted = true;
    } else {
      log('RTC: $name [${this.streamId}] local is muted');
      final localStream = (stream as LocalStream);
      isMuted = true;
      var track = localStream.getTrack('audio');
      if (track != null) {
        track.setMicrophoneMute(true);
      }
    }
  }

  void unmute() async {
    if (stream == null) {
      return;
    }

    if (remote) {
      log('RTC: $name [${this.streamId}] is unmuted');
      (stream as RemoteStream).unmute?.call('audio');
      isMuted = false;
    } else {
      log('RTC: $name [${this.streamId}] local is unmuted');
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
  String localStreamId = '';
  Connector _connector;
  RTC _rtc;
  JsonRPCSignal _signal;
  Client _client;
  bool _inConference = false;
  bool _closed = false;
  LocalStream localStream;

  List<Participant> participants = [];
  IonAudioConferenceService(this.gameState, this.chatService, this.sfuUrl,
      this.confRoom, this.player);

  void updatePlayerId(String streamId, int playerId) {
    log('AudioConf: Update stream $streamId playerId: $playerId');

    bool foundStream = false;
    // remove existing participant with the same player id
    for (int i = 0; i < participants.length; i++) {
      if (participants[i].playerId == playerId) {
        if (participants[i].streamId == streamId) {
          foundStream = true;
        } else {
          participants.removeAt(i);
        }
      }
    }

    if (foundStream) {
      return;
    }

    bool found = false;
    for (final participant in participants) {
      if (participant.streamId == streamId) {
        participant.playerId = playerId;
        found = true;
        break;
      }
    }

    if (!found) {
      Participant participant = Participant(stream: null, remote: true);
      participant.playerId = playerId;
      participant.name = 'unknown';
      participant.streamId = streamId;
      participants.add(participant);
    }
  }

  join() async {
    try {
      if (_connector != null) {
        return;
      }
      _closed = false;
      final signal = JsonRPCSignal(sfuUrl);
      _signal = signal;

      // _connector = Connector(sfuUrl);
      // _rtc = new RTC(_connector);
      // _rtc.ontrack = onTrack;
      // _rtc.onspeaker = onSpeakers;
      //await _rtc.connect();
      if (_closed) return;
      String playerId = this.player.id.toString();
      Client client = await Client.create(
          sid: this.confRoom, uid: playerId, signal: signal);
      _client = client;
      client.ontrack = onTrack;
      client.onspeaker = onSpeakers;
      //await _rtc.join(this.confRoom, playerId, JoinConfig());
      if (_closed) return;
      log('RTC: $playerId joined the conference');
      var constraints = Constraints.defaults;
      constraints.video = false;
      constraints.simulcast = true;
      var localStream = await LocalStream.getUserMedia(constraints: constraints);
      // var localStream = await LocalStream.getUserMedia(
      //     constraints: Constraints(audio: true, video: false));
      if (PlatformUtils.isIOS) {
        localStream.getTrack('audio').enableSpeakerphone(true);
      }
      await client.publish(localStream);
      //await _rtc.publish(localStream);
      if (_closed) return;
      localStreamId = localStream.stream.id;
      log('AudioConf: playerId: $playerId  stream id ${localStream.stream.id}');

      // remove existing me
      for (int i = 0; i < participants.length; i++) {
        if (participants[i].playerId == playerId) {
          participants.removeAt(i);
          break;
        }
      }
      Participant participant = Participant(stream: localStream, remote: false);
      participant.playerId = this.player.id;
      participant.name = this.player.name;
      participant.playerUuid = this.player.uuid;
      participants.add(participant);
      this.localStream = localStream;

      if (gameState.me != null) {
        gameState.me.streamId = localStream.stream.id;
      }
      log('AudioConf: Join name: $playerId  ${localStream.stream.id} in the conference');
      _inConference = true;
      // if (gameState.communicationState.muted) {
      //   mute();
      // } else {
      //   unmute();
      // }
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
    close();
  }

  close() {
    _closed = true;
    if (_rtc != null) {
      _rtc.close();
    }
    _rtc = null;
    if (_connector != null) {
      _connector.close();
    }
    _connector = null;

    if (_client != null) {
      _client.close();
    }
    _client = null;

    if (_signal != null) {
      _signal.close();
    }
    _signal = null;
  }

  onTrack(MediaStreamTrack track, RemoteStream remoteStream) {
    // on new track
    if (track.kind == 'audio') {
      log('AudioConf: ontrack: remote stream => ${remoteStream.id} stream id: ${remoteStream.stream.id} ownerTag: ${remoteStream.stream.ownerTag}');
      final newParticipant = Participant(stream: remoteStream, remote: true)
        ..initialize();

      bool found = false;
      for (int i = 0; i < participants.length; i++) {
        if (participants[i].streamId == remoteStream.id) {
          log('AudioConf: ontrack: Found remote stream => ${remoteStream.id} stream id: ${remoteStream.stream.id} ownerTag: ${remoteStream.stream.ownerTag}');
          participants[i].stream = remoteStream;
          participants[i].remote = true;
          found = true;
          break;
        }
      }
      if (!found) {
        log('AudioConf: ontrack: Not Found remote stream => ${remoteStream.id} stream id: ${remoteStream.stream.id} ownerTag: ${remoteStream.stream.ownerTag}');
        participants.add(newParticipant);
      }
    }
  }

  void onSpeakers(Map<String, dynamic> data) {
    //log('AudioConf: onSpeakers ${jsonEncode(data)}');
    String method = '';
    if (data.containsKey("method")) {
      method = data["method"];
    }
    if (method == 'audioLevels' && data.containsKey("params")) {
      List<Seat> speakers = [];
      for (final streamId in data["params"]) {
        Participant participant = getParticipantByStreamId(streamId);
        if (participant != null) {
          //log('AudioConf: onSpeakers ${participant.playerId} ${participant.name}');
          if (participant.playerId != null) {
            final seat = gameState.getSeatByPlayer(participant.playerId);
            if (seat != null) {
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
            log('AudioConf: ${seat.player.name} stopped talking');
            stoppedTalking.add(seat);
          }
        } else {
          // speaking
          log('AudioConf: ${seat.player.name} is talking');
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
      if (participant.playerId == this.player.id &&
          participant.streamId == this.localStreamId) {
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
      if (me != null) {
        if (this.localStream != null) {
          var track = localStream.getTrack('audio');
          if (track != null) {
            track.setMicrophoneMute(true);
          }
        }
        //me.mute();
      }
    }
  }

  void unmute() {
    // if the current player is in the conference, mute
    if (_inConference) {
      final me = this.me();
      if (me != null) {
        if (this.localStream != null) {
          var track = localStream.getTrack('audio');
          if (track != null) {
            track.setMicrophoneMute(false);
          }
        }
        //me.unmute();
      }
    }
  }
}
*/
