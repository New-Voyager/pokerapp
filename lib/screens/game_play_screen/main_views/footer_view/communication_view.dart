import 'dart:developer';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/pulsating_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/voice_text_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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
    log('CommunicationView:  ::build::');

    final gameState = GameState.getState(context);
    final communicationState = gameState.getCommunicationState();
    final chat = SvgPicture.asset('assets/images/game/chat.svg',
        width: 16, height: 16, color: Colors.black);

    return ListenableProvider<CommunicationState>(
        create: (_) => communicationState,
        builder: (context, _) => Consumer<CommunicationState>(
              builder: (context, communicationState, __) {
                List<Widget> children = [];
                log('PlayerStatus = ${gameState.myState.status}, '
                    'audioConferenceStatus = ${communicationState.audioConferenceStatus}, '
                    'voiceChatEnable = ${communicationState.voiceChatEnable}');

                if (gameState.myState.status == PlayerStatus.PLAYING &&
                    communicationState.audioConferenceStatus ==
                        AudioConferenceStatus.CONNECTED) {
                  if (gameState.settings.audioConf) {
                    log('User is playing and audio conference connected, showing janusAudioWidgets');
                    children.addAll(
                        janusAudioWidgets(gameState, communicationState));
                  } else {
                    // when the user turns off audio conf
                    log('User turned off audio conf, showing audioChatWidgets');
                    children.addAll(audioChatWidgets());
                  }
                } else if (communicationState.voiceChatEnable) {
                  log('Showing voiceChatWidgets');
                  children.addAll(voiceTextWidgets(widget.chatService));
                }

                if (communicationState.showTextChat) {
                  children.add(
                    Consumer<GameChatNotifState>(
                      builder: (_, gcns, __) => Badge(
                        animationType: BadgeAnimationType.scale,
                        showBadge: gcns.hasUnreadMessages,
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        badgeContent: Text(gcns.count.toString()),
                        child: GameCircleButton(
                          onClickHandler: widget.chatVisibilityChange,
                          child: chat,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: children,
                );
              },
            ));
  }

  Widget talkingAnimation(Function onTap) {
    Widget child = BlinkWidget(
      children: [
        SvgPicture.asset('assets/images/game/mic-step1.svg',
            width: 16, height: 16, color: Colors.black),
        SvgPicture.asset('assets/images/game/mic-step2.svg',
            width: 16, height: 16, color: Colors.black),
        SvgPicture.asset('assets/images/game/mic-step3.svg',
            width: 16, height: 16, color: Colors.black),
        SvgPicture.asset('assets/images/game/mic-step1.svg',
            width: 16, height: 16, color: Colors.black),
      ],
    );
    return GameCircleButton(onClickHandler: onTap, child: child);
  }

  janusAudioWidgets(GameState gameState, CommunicationState state) {
    Color iconColor = Colors.grey;
    Widget mic;

    if (state != null) {
      if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTING) {
        iconColor = Colors.yellow;
      } else if (state.audioConferenceStatus ==
          AudioConferenceStatus.CONNECTED) {
        iconColor = Colors.green;
      }

      log('Audio status: ${state.audioConferenceStatus.toString()} iconColor: ${iconColor.toString()} muted: ${state.muted} talking: ${state.talking}');

      if (state?.talking ?? false) {
        mic = talkingAnimation(() {
          log('mic is tapped');
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.janusEngine.muteUnmute();
          }
        });
      }
    }

    if (mic == null) {
      Widget child;
      if (state.muted) {
        child = SvgPicture.asset('assets/images/game/mic-mute.svg',
            width: 16, height: 16, color: Colors.black);
      } else {
        child = SvgPicture.asset('assets/images/game/mic.svg',
            width: 16, height: 16, color: Colors.black);
      }
      mic = GameCircleButton(
          onClickHandler: () {
            log('mic is tapped');
            if (state.audioConferenceStatus ==
                AudioConferenceStatus.CONNECTED) {
              gameState.janusEngine.muteUnmute();
            }
          },
          child: child);
      log('audio is muted: $mic');
    }

    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Icon(
          Icons.circle,
          size: 15.pw,
          color: iconColor,
        ),
      ),
      GestureDetector(
        onTap: () {
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.janusEngine.muteUnmute();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
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
          color: AppColorsNew.newGreenButtonColor,
          size: 34.pw,
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
