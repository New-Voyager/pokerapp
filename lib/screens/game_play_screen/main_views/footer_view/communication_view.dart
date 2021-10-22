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
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/video_conf/video_conf_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/voice_text_widget.dart';

//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/ion/ion.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
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

  Widget _videoButton(AppTheme theme) {
    final String videoSvg = "assets/images/game/mic.svg";

    return Container(
      margin: EdgeInsets.only(top: 10.dp),
      child: CircleImageButton(
        onTap: () async {
          log('video button clicked');

          final IonAudioConferenceService ion =
              widget.gameContextObject.ionAudioConferenceService;

          // first leave the current ion session
          await ion.leave();

          // then join back an ion session with isVideo as true
          await ion.join(isVideo: true);

          showBottomSheet(
            context: context,
            builder: (_) => ListenableProvider.value(
              value: widget.gameContextObject,
              child: VideoConfWidget(),
            ),
          );
        },
        theme: theme,
        svgAsset: videoSvg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    final communicationState = gameState.communicationState;
    // final chat = SvgPicture.asset('assets/images/game/chat.svg',
    //     width: 16, height: 16, color: theme.primaryColorWithDark());
    final chat = "assets/images/game/chat.svg";

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
                        child: CircleImageButton(
                          onTap: () {
                            log('on chat clicked');
                            widget.chatVisibilityChange();
                          },
                          theme: theme,
                          svgAsset: chat,
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

                // video button
                bool showVideoButton = true;

                if (showVideoButton) {
                  children.add(_videoButton(theme));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: children,
                );
              },
            ));
  }

  Widget talkingAnimation(Function onTap, AppTheme theme) {
    List<String> svgAssets = [
      'assets/images/game/mic-step2.svg',
      'assets/images/game/mic-step3.svg',
      'assets/images/game/mic-step2.svg',
      'assets/images/game/mic-step1.svg'
    ];

    return RotateImagesButton(
      onTap: onTap,
      svgImages: svgAssets,
      theme: theme,
    );
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
    IconData icon,
    VoidCallback onClick,
  }) {
    final theme = AppTheme.getTheme(context);

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
            CircleImageButton(
              theme: theme,
              icon: icon,
              onTap: onClick,
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
                                icon: myMic,
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
                                icon: Icons.call_end,
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
                                icon: soundOn,
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
                                icon: Icons.close,
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
      String child;

      if (state.muted) {
        child = 'assets/images/game/mic-mute.svg';
      } else {
        child = 'assets/images/game/mic.svg';
      }
      mic = CircleImageButton(
          onTap: () async {
            log('mic is tapped');
            _vnShowAudioConfOptions.value = true;
          },
          theme: theme,
          svgAsset: child);
      log('audio is ${state.muted ? "muted" : "on"}: $mic');
    }

    if (state.audioConferenceStatus == AudioConferenceStatus.LEFT) {
      mic = CircleImageButton(
          onTap: () async {},
          disabled: true,
          svgAsset: "assets/images/game/mic-mute.svg",
          theme: theme);
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
