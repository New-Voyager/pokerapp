import 'dart:async';
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:livekit_client/livekit_client.dart';

class LivekitAudioConference extends Disposable {
  final String sfuUrl;
  final String confRoom;
  final String token;
  final PlayerInfo player;
  final GameMessagingService chatService;
  final GameState gameState;
  EventsListener<RoomEvent> _listener;
  Room _room;
  LivekitAudioConference(this.gameState, this.confRoom, this.chatService,
      this.sfuUrl, this.token, this.player);

  Future<void> join() async {
    log('LiveKit: joining the server');
    _room = await LiveKitClient.connect(
      sfuUrl,
      token,
    );
    await _room.localParticipant.setMicrophoneEnabled(true);
    unmuteMe();
    _listener = _room.createListener();
    _listener.listen((p0) {
      onEvent(p0);
    });
    log('LiveKit: ${_room.localParticipant.trackPublications.length}');
    log('LiveKit: joined successfully');
  }

  @override
  FutureOr onDispose() {
    leave();
  }

  Future<void> leave() async {
    log('LiveKit: leaving the room');
    if (_listener != null) {
      _listener.dispose();
    }
    _listener = null;

    if (_room != null) {
      _room.disconnect().then((value) {
        _room = null;
        log('LiveKit: left successfully');
      }).onError((error, stackTrace) {
        log('Error closing the room');
      });
    }
  }

  void onEvent(RoomEvent e) {
    if (e is SpeakingChangedEvent) {
      final speakingEvent = e as SpeakingChangedEvent;
      if (speakingEvent.speaking) {
        log('LiveKit: Player: ${speakingEvent.participant.identity} is speaking');
      } else {
        // not speaking
        log('LiveKit: Player: ${speakingEvent.participant.identity} is not speaking');
      }
    } else if (e is ActiveSpeakersChangedEvent) {
      Set<int> currentSpeakers = Set<int>();
      for (final speaker in e.speakers) {
        currentSpeakers.add(int.parse(speaker.identity));
      }

      for (final speaker in e.speakers) {
        log('LiveKit: Player: ${speaker.identity} is speaking');
      }

      if (e.speakers.length == 0) {
        log('LiveKit: No one is speaking');
      }

      for (final seat in gameState.seats) {
        if (seat.player != null) {
          if (seat.player.talking) {
            // player is already talking

            if (!currentSpeakers.contains(seat.player.playerId)) {
              // stopped talking
              seat.player.talking = false;
              seat.notify();
              if (seat.player.isMe) {
                gameState.communicationState.talking = false;
                gameState.communicationState.notify();
              }
            }
          } else {
            // player was not talking before
            if (currentSpeakers.contains(seat.player.playerId)) {
              seat.player.talking = true;
              seat.notify();
              if (seat.player.isMe) {
                gameState.communicationState.talking = true;
                gameState.communicationState.notify();
              }
            }
          }
        }
      }
    }
  }

  void muteMe() {
    if (_room == null) {
      return;
    }
    if (_room.localParticipant.trackPublications.length > 0) {
      for (final trackId in _room.localParticipant.trackPublications.keys) {
        _room.localParticipant.trackPublications[trackId].mute();
      }
    }
    log('LiveKit: I am muted');
  }

  void unmuteMe() {
    if (_room == null) {
      return;
    }
    if (_room.localParticipant.trackPublications.length > 0) {
      for (final trackId in _room.localParticipant.trackPublications.keys) {
        _room.localParticipant.trackPublications[trackId].unmute();
      }
    }
    log('LiveKit: I am unmuted');
    //_room.localParticipant.setMicrophoneEnabled(true);
  }

  void muteOthers() {
    for (final key in _room.participants.keys) {
      final participant = _room.participants[key];
      if (participant != null) {
        if (participant.audioTracks.length > 0) {
          participant.audioTracks[0].enabled = false;
        }
      }
    }
  }

  void unmuteOthers() {
    for (final key in _room.participants.keys) {
      final participant = _room.participants[key];
      if (participant != null) {
        if (participant.audioTracks.length > 0) {
          participant.audioTracks[0].enabled = true;
        }
      }
    }
  }
}
