import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
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
import 'package:record/record.dart';

class CommunicationView extends StatefulWidget {
  final Function chatVisibilityChange;
  final GameMessagingService chatService;
  final GameContextObject gameContextObject;

  CommunicationView(
      this.chatVisibilityChange, this.chatService, this.gameContextObject);

  @override
  _CommunicationViewState createState() => _CommunicationViewState();
}

class _CommunicationViewState extends State<CommunicationView> {
  final ValueNotifier<bool> _vnShowAudioConfOptions =
      ValueNotifier<bool>(false);
  bool _recordingCancelled;
  String _audioFile;
  final _audioRecorder = Record();
  bool _isRecording = false;
  @override
  void initState() {
    // TODO: implement initState
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    final communicationState = gameState.communicationState;
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
                bool gameChatEnabled = (gameState.gameSettings.chat ?? true);
                bool playerChatEnabled =
                    (gameState.playerLocalConfig.showChat ?? true);
                if (gameChatEnabled && playerChatEnabled) {
                  children.add(
                    // chat button
                    Consumer<GameChatNotifState>(
                      builder: (_, gcns, __) => Badge(
                        animationType: BadgeAnimationType.scale,
                        showBadge: gcns.hasUnreadMessages,
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        badgeContent: Text(gcns.count.toString()),
                        child: GameCircleButton(
                          onClickHandler: () {
                            log('on chat clicked');
                            widget.chatVisibilityChange();
                          },
                          child: chat,
                        ),
                      ),
                    ),
                  );

                  // gap
                  children.add(SizedBox(
                    height: 10.dp,
                  ));
                }

                // mic button
                bool showVoiceText = true;
                bool audioConf = gameState.audioConfEnabled ?? false;

                if (audioConf &&
                    gameState.playerLocalConfig.inAudioConference) {
                  if (communicationState.audioConferenceStatus ==
                      AudioConferenceStatus.CONNECTED) {
                    children.add(audioConferenceWidget(gameState, theme));
                    showVoiceText = false;
                  }
                }

                if (showVoiceText) {
                  children.addAll(voiceTextWidgets(widget.chatService));
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
        SvgPicture.asset('assets/images/game/mic-step2.svg',
            width: 16, height: 16, color: theme.primaryColorWithDark()),
        SvgPicture.asset('assets/images/game/mic-step3.svg',
            width: 16, height: 16, color: theme.primaryColorWithDark()),
        SvgPicture.asset('assets/images/game/mic-step2.svg',
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
      VoiceTextWidget(
        recordStart: () => record(),
        recordStop: (int dur) {
          return stopRecording(false, dur);
        },
        recordCancel: () => stopRecording(true, 0),
      ),
    ];
  }

  void onMicPress(BuildContext context) {
    record();
    log('Mic is pressed');
  }

  void onMicPressEnd(BuildContext context, LongPressEndDetails details) async {
    if (await _audioRecorder.isRecording()) {
      log('Stop recording');
      await _audioRecorder.stop();
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
    if (await _audioRecorder.isRecording()) {
      log('Stop recording');
      await _audioRecorder.stop();
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
    _audioRecorder.start(path: outputFile.path);
  }

  Widget _buildMenuButton({
    @required String title,
    Widget child,
    IconData iconData,
    String imagePath,
    VoidCallback onClick,
  }) {
    final tmp = title.split(' ');
    if (tmp.length > 1) {
      title = tmp[0] + '\n' + tmp[1];
    }

    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: onClick,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // button
            GameCircleButton(
              child: child,
              iconData: iconData,
              imagePath: imagePath,
            ),

            // text
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget audioConferenceWidget(GameState gameState, AppTheme theme) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        ListenableProvider<MeTalkingState>(
          create: (_) => gameState.communicationState.talkingState,
          child: Consumer<MeTalkingState>(
              builder: (_, __, ___) => audioConferenceMic(gameState, theme)),
        ),

        // other buttons
        ValueListenableBuilder<bool>(
            valueListenable: _vnShowAudioConfOptions,
            builder: (_, showAudioConfOptions, child) {
              IconData myMic = Icons.mic_rounded;
              if (gameState.communicationState.muted) {
                myMic = Icons.mic_off_rounded;
              }

              IconData soundOn = Icons.volume_up_sharp;
              if (gameState.communicationState.mutedAll) {
                soundOn = Icons.volume_off_sharp;
              }

              return AnimatedSwitcher(
                transitionBuilder: (child, animation) => SizeTransition(
                  axis: Axis.horizontal,
                  sizeFactor: animation,
                  child: child,
                ),
                duration: const Duration(milliseconds: 200),
                child: showAudioConfOptions
                    ? Container(
                        color: theme.primaryColorWithDark(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // mute button
                            _buildMenuButton(
                                title: gameState.communicationState.muted
                                    ? 'Unmute'
                                    : 'Mute',
                                child: Icon(
                                  myMic,
                                  size: 24,
                                  color: theme.primaryColorWithDark(),
                                ),
                                onClick: () {
                                  // handle on mute tap
                                  if (!gameState.communicationState.muted) {
                                    widget.gameContextObject
                                        .ionAudioConferenceService
                                        .mute();
                                    gameState.communicationState.muted = true;
                                  } else {
                                    widget.gameContextObject
                                        .ionAudioConferenceService
                                        .unmute();
                                    gameState.communicationState.muted = false;
                                  }
                                }),

                            // sep
                            const SizedBox(width: 10),

                            // hangup button
                            _buildMenuButton(
                                title: 'Hangup',
                                child: Icon(
                                  Icons.call_end,
                                  size: 24,
                                  color: theme.primaryColorWithDark(),
                                ),
                                onClick: () {
                                  _vnShowAudioConfOptions.value = false;
                                  // handle on hangup
                                  gameState.playerLocalConfig
                                      .inAudioConference = false;
                                  widget.gameContextObject.leaveAudio();
                                  gameState.communicationState.notify();
                                }),

                            // sep
                            const SizedBox(width: 10),

                            // audio on off
                            _buildMenuButton(
                                title: gameState.communicationState.mutedAll
                                    ? 'On'
                                    : 'Off',
                                child: Icon(
                                  soundOn,
                                  size: 24,
                                  color: theme.primaryColorWithDark(),
                                ),
                                onClick: () {
                                  // handle on mute all
                                  if (!gameState.communicationState.mutedAll) {
                                    widget.gameContextObject
                                        .ionAudioConferenceService
                                        .muteAll();
                                    gameState.communicationState.mutedAll =
                                        true;
                                  } else {
                                    widget.gameContextObject
                                        .ionAudioConferenceService
                                        .unmuteAll();
                                    gameState.communicationState.mutedAll =
                                        false;
                                  }
                                }),

                            // sep
                            const SizedBox(width: 10),

                            // close button
                            _buildMenuButton(
                                title: 'Close',
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: theme.primaryColorWithDark(),
                                ),
                                onClick: () {
                                  _vnShowAudioConfOptions.value = false;
                                }),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            }),
      ],
    );
  }

  Widget audioConferenceMic(GameState gameState, AppTheme theme) {
    log('AUDIOCONF: Mic is rebuilding');
    Color iconColor = Colors.grey;
    Widget mic;
    CommunicationState state = gameState.communicationState;
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
          log('AUDIOCONF: mic is tapped');
          _vnShowAudioConfOptions.value = true;
          if (state.audioConferenceStatus == AudioConferenceStatus.CONNECTED) {}
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
            _vnShowAudioConfOptions.value = true;
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
    return mic;
  }
}

// if (status == AppConstants.PLAYING &&
//     (communicationState.audioConferenceStatus ==
//             AudioConferenceStatus.CONNECTED ||
//         communicationState.audioConferenceStatus ==
//             AudioConferenceStatus.LEFT)) {
//   if (gameState.audioConfEnabled) {
//     if (gameState.useAgora) {
//       // debugLog(gameState.gameCode, 'Show agora audio widgets');
//       // log('Show agora audio widgets');
//       children.addAll(agoraAudioWidgets(
//           gameState, communicationState, theme));
//     } else {
//       log('User is playing and audio conference connected, showing janusAudioWidgets');
//       children.addAll(janusAudioWidgets(
//           gameState, communicationState, theme));
//     }
//   } else {
//     // when the user turns off audio conf
//     log('User turned off audio conf, showing audioChatWidgets');
//     if (gameState.gameSettings.chat ?? true) {
//       children.addAll(voiceTextWidgets(widget.chatService));
//     }
//   }
// } else if (gameChatEnabled && playerChatEnabled) {
//   children.addAll(voiceTextWidgets(widget.chatService));
// }
