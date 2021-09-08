import 'dart:developer';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/voice_text_widget.dart';
//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:provider/provider.dart';

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
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    final communicationState = gameState.getCommunicationState();
    final chat = SvgPicture.asset('assets/images/game/chat.svg',
        width: 16, height: 16, color: theme.primaryColorWithDark());

    return ListenableProvider<CommunicationState>(
        create: (_) => communicationState,
        builder: (context, _) => Consumer<CommunicationState>(
              builder: (context, communicationState, __) {
                List<Widget> children = [];
                String status = gameState.myStatus;
                log('PlayerStatus = ${status}, '
                    'audioConferenceStatus = ${communicationState.audioConferenceStatus}, '
                    'voiceChatEnable = ${communicationState.voiceChatEnable}');
                if (status == AppConstants.PLAYING &&
                    (communicationState.audioConferenceStatus ==
                            AudioConferenceStatus.CONNECTED ||
                        communicationState.audioConferenceStatus ==
                            AudioConferenceStatus.LEFT)) {
                  if (gameState.audioConfEnabled) {
                    if (gameState.useAgora) {
                      // debugLog(gameState.gameCode, 'Show agora audio widgets');
                      // log('Show agora audio widgets');
                      children.addAll(agoraAudioWidgets(
                          gameState, communicationState, theme));
                    } else {
                      log('User is playing and audio conference connected, showing janusAudioWidgets');
                      children.addAll(janusAudioWidgets(
                          gameState, communicationState, theme));
                    }
                  } else {
                    // when the user turns off audio conf
                    log('User turned off audio conf, showing audioChatWidgets');
                    children.addAll(audioChatWidgets(theme));
                  }
                } else if (communicationState.voiceChatEnable) {
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

  Widget talkingAnimation(Function onTap, AppTheme theme) {
    Widget child = BlinkWidget(
      children: [
        SvgPicture.asset('assets/images/game/mic-step1.svg',
            width: 16, height: 16, color: theme.primaryColorWithDark()),
        SvgPicture.asset('assets/images/game/mic-step2.svg',
            width: 16, height: 16, color: theme.primaryColorWithDark()),
        SvgPicture.asset('assets/images/game/mic-step3.svg',
            width: 16, height: 16, color: theme.primaryColorWithDark()),
        SvgPicture.asset('assets/images/game/mic-step1.svg',
            width: 16, height: 16, color: theme.primaryColorWithDark()),
      ],
    );
    return GameCircleButton(onClickHandler: onTap, child: child);
  }

  janusAudioWidgets(
      GameState gameState, CommunicationState state, AppTheme theme) {
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
        mic = talkingAnimation(() async {
          log('mic is tapped');
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.janusEngine.muteUnmute();
            //Alerts.showNotification(titleText: "AudioConfigChanged from anim");
          }
        }, theme);
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
          onClickHandler: () async {
            log('mic is tapped');
            if (state.audioConferenceStatus ==
                AudioConferenceStatus.CONNECTED) {
              gameState.janusEngine.muteUnmute();
            }
          },
          child: child);
      log('audio is ${state.muted ? "muted" : "on"}: $mic');
    }

    if (state.audioConferenceStatus == AudioConferenceStatus.LEFT) {
      Widget child = SvgPicture.asset('assets/images/game/mic-mute.svg',
          width: 16, height: 16, color: Colors.black);

      mic = GameCircleButton(
          disabled: true, onClickHandler: () async {}, child: child);
    }
    bool confOn = true;
    final confOnIcon = SvgPicture.asset('assets/images/game/conf-on.svg',
        width: 16, height: 16, color: Colors.black);
    final confOffIcon = SvgPicture.asset('assets/images/game/conf-off.svg',
        width: 16, height: 16, color: Colors.black);
    Widget child;
    if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
      // child = Stack(children: [
      //   Align(
      //       alignment: Alignment.topCenter,
      //       child: Icon(
      //         Icons.circle,
      //         size: 5.pw,
      //         color: iconColor,
      //       )),
      //   confOnIcon
      // ]);
      child = confOnIcon;
    } else {
      child = confOffIcon;
      confOn = false;
    }
    final confIcon = GameCircleButton(
        onClickHandler: () async {
          log('mic is tapped');
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.janusEngine.leaveChannel(notify: true);

            // inform the user that we left the audio conference
            Alerts.showNotification(
                titleText: "Conference",
                svgPath: 'assets/images/game/conf-on.svg',
                subTitleText: 'You left the audio conference');
          } else {
            gameState.janusEngine.joinChannel(gameState.janusEngine.janusToken);
            Alerts.showNotification(
                titleText: "Conference",
                svgPath: 'assets/images/game/conf-on.svg',
                subTitleText: 'You joined the audio conference');
          }
        },
        child: child);
    List<Widget> widgets = [];
    widgets.add(GestureDetector(
      onTap: () async {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: confIcon,
      ),
    ));
    if (confOn) {
      widgets.add(GestureDetector(
        onTap: () async {
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.janusEngine.muteUnmute();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: mic,
        ),
      ));
    }

    return widgets;
  }

  agoraAudioWidgets(
      GameState gameState, CommunicationState state, AppTheme theme) {
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
        mic = talkingAnimation(() async {
          log('mic is tapped');
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            if (gameState.agoraEngine.micMuted) {
              Alerts.showNotification(
                  titleText: "Conference",
                  svgPath: 'assets/images/game/conf-on.svg',
                  subTitleText: 'Mic is unmuted');
            } else {
              Alerts.showNotification(
                  titleText: "Conference",
                  svgPath: 'assets/images/game/conf-on.svg',
                  subTitleText: 'Mic is muted');
            }

            gameState.agoraEngine.switchMicrophone();
            //Alerts.showNotification(titleText: "AudioConfigChanged from anim");
          }
        }, theme);
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
          onClickHandler: () async {
            log('mic is tapped');
            if (state.audioConferenceStatus ==
                AudioConferenceStatus.CONNECTED) {
              if (gameState.agoraEngine.micMuted) {
                Alerts.showNotification(
                    titleText: "Conference",
                    svgPath: 'assets/images/game/conf-on.svg',
                    subTitleText: 'Mic is unmuted');
              } else {
                Alerts.showNotification(
                    titleText: "Conference",
                    svgPath: 'assets/images/game/conf-on.svg',
                    subTitleText: 'Mic is muted');
              }
              gameState.agoraEngine.switchMicrophone();
            }
          },
          child: child);
      log('audio is ${state.muted ? "muted" : "on"}: $mic');
    }

    if (state.audioConferenceStatus == AudioConferenceStatus.LEFT) {
      Widget child = SvgPicture.asset('assets/images/game/mic-mute.svg',
          width: 16, height: 16, color: Colors.black);

      mic = GameCircleButton(
          disabled: true, onClickHandler: () async {}, child: child);
    }
    bool confOn = true;
    final confOnIcon = SvgPicture.asset('assets/images/game/conf-on.svg',
        width: 16, height: 16, color: Colors.black);
    final confOffIcon = SvgPicture.asset('assets/images/game/conf-off.svg',
        width: 16, height: 16, color: Colors.black);
    Widget child;
    if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
      // child = Stack(children: [
      //   Align(
      //       alignment: Alignment.topCenter,
      //       child: Icon(
      //         Icons.circle,
      //         size: 5.pw,
      //         color: iconColor,
      //       )),
      //   confOnIcon
      // ]);
      child = confOnIcon;
    } else {
      child = confOffIcon;
      confOn = false;
    }
    final confIcon = GameCircleButton(
        onClickHandler: () async {
          log('mic is tapped');
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.agoraEngine.leaveChannel();

            // inform the user that we left the audio conference
            Alerts.showNotification(
                titleText: "Conference",
                svgPath: 'assets/images/game/conf-on.svg',
                subTitleText: 'You left the audio conference');
          } else {
            gameState.agoraEngine.joinChannel(gameState.agoraToken);
            Alerts.showNotification(
                titleText: "Conference",
                svgPath: 'assets/images/game/conf-on.svg',
                subTitleText: 'You joined the audio conference');
          }
        },
        child: child);
    List<Widget> widgets = [];
    widgets.add(GestureDetector(
      onTap: () async {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: confIcon,
      ),
    ));
    if (confOn) {
      widgets.add(GestureDetector(
        onTap: () async {
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {
            gameState.agoraEngine.switchMicrophone();
            //gameState.janusEngine.muteUnmute();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: mic,
        ),
      ));
    }

    return widgets;
  }

  voiceTextWidgets(GameMessagingService chatService) {
    return <Widget>[
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      //   child: Icon(
      //     Icons.circle,
      //     size: 15,
      //     color: Colors.grey,
      //   ),
      // ),
      VoiceTextWidget(
        recordStart: () => record(),
        recordStop: (int dur) {
          return stopRecording(false, dur);
        },
        recordCancel: () => stopRecording(true, 0),
      ),
    ];
  }

  audioChatWidgets(AppTheme theme) {
    return [
      GestureDetector(
        onLongPress: () => onMicPress(context),
        onLongPressEnd: (LongPressEndDetails details) =>
            onMicPressEnd(context, details),
        child: Icon(
          Icons.mic,
          color: theme.accentColor,
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
