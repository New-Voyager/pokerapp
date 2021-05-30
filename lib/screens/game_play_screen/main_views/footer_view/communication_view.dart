import 'dart:developer';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:provider/provider.dart';

//TODO: We need to get GameChatService here and record audio and send audio
// via game chat channel for the games that don't use live audio.
class CommunicationView extends StatefulWidget {
  final Function chatVisibilityChange;
  final GameMessagingService chatService;

  CommunicationView(this.chatVisibilityChange, this.chatService);

  @override
  _CommunicationViewState createState() => _CommunicationViewState();
}

class _CommunicationViewState extends State<CommunicationView> {
  bool _recordingCancelled;
  String _audioFile;

  Widget build2(BuildContext context) {
    var ret = Consumer<ValueNotifier<Agora>>(
      builder: (_, agora, __) {
        bool liveAudio = agora.value != null;
        var children = [];
        if (liveAudio) {
          children.addAll(liveAudioWidgets(agora));
        } else {
          children.addAll(audioChatWidgets());
        }

        children.add(GestureDetector(
          onTap: widget.chatVisibilityChange,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.chat,
              size: 35,
              color: AppColors.appAccentColor,
            ),
          ),
        ));

        return Column(
          children: children,
        );
      },
    );
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final currentPlayerSeat =
        gameState.getSeatByPlayer(gameState.currentPlayerId);
    if (currentPlayerSeat == null) {
      return SizedBox.shrink();
    }

    var ret = ListenableProvider<Seat>(
        create: (_) => currentPlayerSeat,
        builder: (context, _) => Consumer<Seat>(
              builder: (_, seat, __) {
                var children = [];

                children = janusAudioWidgets(gameState, seat);

                children.add(GestureDetector(
                  onTap: widget.chatVisibilityChange,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.chat,
                      size: 35,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ));

                return Column(
                  children: children,
                );
              },
            ));
    return ret;
  }

  janusAudioWidgets(GameState gameState, Seat seat) {
    return [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          Icons.circle,
          size: 15,
          color: AppColors.positiveColor,
        ),
      ),
      GestureDetector(
        onTap: () {
          gameState.janusEngine.muteUnmute();
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Icon(
            seat.player == null
                ? Icons.arrow_circle_down
                : seat.player.muted
                    ? Icons.mic_off
                    : Icons.mic,
            size: 35,
            color: AppColors.appAccentColor,
          ),
        ),
      ),
    ];
  }

  liveAudioWidgets(ValueNotifier<Agora> agora) {
    return [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          Icons.circle,
          size: 15,
          color: AppColors.positiveColor,
        ),
      ),
      GestureDetector(
        onTap: () {
          agora.value.switchMicrophone();
          setState(() {
            agora.value.openMicrophone = !agora.value.openMicrophone;
          });
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Icon(
            agora.value.openMicrophone ? Icons.mic : Icons.mic_off,
            size: 35,
            color: AppColors.appAccentColor,
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          print("speaker ${agora.value.enableSpeakerphone}");
          agora.value.switchSpeakerphone();
          setState(() {
            agora.value.enableSpeakerphone = !agora.value.enableSpeakerphone;
          });
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Icon(
            agora.value.enableSpeakerphone
                ? Icons.volume_up
                : Icons.volume_mute,
            size: 35,
            color: AppColors.appAccentColor,
          ),
        ),
      ),
    ];
  }

  audioChatWidgets() {
    return [
      GestureDetector(
        onLongPress: () => onMicPress(context),
        onLongPressEnd: (LongPressEndDetails details) =>
            onMicPressEnd(context, details),
        child: Icon(
          Icons.mic,
          color: AppColors.appAccentColor,
          size: 40,
        ),
      ),
      SizedBox(height: 15),
    ];
  }

  void onMicPress(BuildContext context) {
    record();
    log('Mic is pressed');
  }

  void onMicPressEnd(BuildContext context, LongPressEndDetails details) async {
    if (await AudioRecorder.isRecording) {
      log('Stop recording');
      await AudioRecorder.stop();
      var outputFile = File(_audioFile);
      if (outputFile.existsSync()) {
        var length = await outputFile.length();
        log('File length: $length');
      }

      if (!_recordingCancelled) {
        // send the audio data in the chat channel
        var data = await outputFile.readAsBytes();
        widget.chatService.sendAudio(data);
      }
      outputFile.deleteSync();
    }
  }

  Future<void> record() async {
    log('start recording');
    // Request Microphone permission if needed
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw Exception("Microphone permission not granted");
    _recordingCancelled = false;
    Directory tempDir = await getTemporaryDirectory();
    _audioFile = '${tempDir.path}/chat1.aac';
    var outputFile = File(_audioFile);

    if (outputFile.existsSync()) {
      log('audio file $outputFile is deleted');
      outputFile.deleteSync();
    }
    AudioRecorder.start(path: outputFile.path);
  }
}
