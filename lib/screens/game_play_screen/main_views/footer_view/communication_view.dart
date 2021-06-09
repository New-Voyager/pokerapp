import 'dart:developer';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/pulsating_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/voice_text_widget.dart';
//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final currentPlayerSeat =
        gameState.getSeatByPlayer(gameState.currentPlayerId);
    if (currentPlayerSeat == null) {
      return SizedBox.shrink();
    }

    // TODO: We need to refactor this code
    // We need to use AudioConferenceState as provider
    // Using seat provider here is incorrect
    final audioConfState = gameState.getAudioConfState();
    var ret = ListenableProvider<AudioConferenceState>(
      create: (_) => audioConfState,
      builder: (context, _) => Consumer<AudioConferenceState>(
        builder: (_, audioConfState, __) {
          List<Widget> children = [];
          if (audioConfState != null &&
              (!gameState.audioConfEnabled ||
                  audioConfState.status == AudioConferenceStatus.FAILED)) {
            children.addAll(voiceTextWidgets(widget.chatService));
          } else {
            children.addAll(janusAudioWidgets(gameState, audioConfState));
          }

          children.add(
            GestureDetector(
              onTap: widget.chatVisibilityChange,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.chat,
                  size: 35,
                  color: AppColors.appAccentColor,
                ),
              ),
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children,
          );
        },
      ),
    );
    return ret;
  }

  janusAudioWidgets(GameState gameState, AudioConferenceState state) {
    Color iconColor = Colors.grey;
    Color micColor = Colors.grey;
    Widget mic;

    if (state != null) {
      if (state.status == AudioConferenceStatus.CONNECTING) {
        iconColor = Colors.yellow;
      } else if (state.status == AudioConferenceStatus.CONNECTED) {
        iconColor = Colors.green;
        micColor = AppColors.appAccentColor;
      }

      // log('Audio status: ${state.status.toString()} iconColor: ${iconColor.toString()} muted: ${state.muted} talking: ${state.talking}');

      if (state?.talking ?? false) {
        mic = PulsatingCircleIconButton(
          child: Icon(
            Icons.keyboard_voice,
            color: Colors.white,
            size: 24,
          ),
          onTap: () {
            if (state.status == AudioConferenceStatus.CONNECTED) {
              gameState.janusEngine.muteUnmute();
            }
          },
          color: Colors.red,
          radius: 0.5,
        );
      }
    }

    if (mic == null) {
      mic = Icon(
        state.muted ? Icons.mic_off : Icons.mic,
        size: 35,
        color: micColor,
      );
    }

    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Icon(
          Icons.circle,
          size: 15,
          color: iconColor,
        ),
      ),
      GestureDetector(
        onTap: () {
          if (state.status == AudioConferenceStatus.CONNECTED) {
            gameState.janusEngine.muteUnmute();
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: mic,
        ),
      ),
    ];
  }

  voiceTextWidgets(GameMessagingService chatService) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Icon(
          Icons.circle,
          size: 15,
          color: Colors.grey,
        ),
      ),
      VoiceTextWidget(
        recordStart: () => record(),
        recordStop: (int dur) {
          return stopRecording(false, dur);
        },
        recordCancel: () => stopRecording(true, 0),
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
        widget.chatService.sendAudio(data, 2);
      }
      outputFile.deleteSync();
    }
  }

  stopRecording(bool cancelled, int duration) async {
    if (await AudioRecorder.isRecording) {
      log('Stop recording');
      await AudioRecorder.stop();
      var outputFile = File(_audioFile);
      if (outputFile.existsSync()) {
        var length = await outputFile.length();
        log('File length: $length');
      }

      if (!cancelled) {
        // send the audio data in the chat channel
        var data = await outputFile.readAsBytes();
        log("DURATION 1 :   :  $duration");

        widget.chatService.sendAudio(data, duration);
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
