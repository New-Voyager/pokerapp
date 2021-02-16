import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:pokerapp/widgets/chat_text_field.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'game_giphys.dart';

const int SAMPLE_RATE = 8000;

class GameChat extends StatefulWidget {
  final GameChatService chatService;
  final Function chatVisibilityChange;

  static final GlobalKey<_GameChatState> globalKey = GlobalKey();

  GameChat(this.chatService, this.chatVisibilityChange) : super(key: globalKey);

  @override
  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> {
  TextEditingController controller = TextEditingController();
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  bool isMicVisible = true;
  bool isGiphyVisible = false;
  String tempPath;
  bool _recorderIsInit = false;
  StreamSubscription _recordingDataSubscription;
  String _audioFile;
  bool _recordingCancelled = false;
  double height;
  final ScrollController _scrollController = ScrollController();
  // FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  final focusNode = FocusNode();
  List<ChatMessage> chatMessages = [];
  @override
  void initState() {
    super.initState();

    chatMessages.addAll(widget.chatService.messages.reversed);
    scrollToBottomOfChat(scrollTime: 100, waitTime: 200);

    widget.chatService.listen(onText: (ChatMessage message) {
      print("text dsa ${message.text}");
      setState(() {
        chatMessages.add(message);
      });
    }, onGiphy: (ChatMessage giphy) {
      setState(() {
        chatMessages.add(giphy);
      });
      scrollToBottomOfChat(scrollTime: 1, waitTime: 1);
    });

    // _recorder.openAudioSession().then((value) {
    //   setState(() {
    //     _recorderIsInit = true;
    //   });
    //   scrollToBottomOfChat(scrollTime: 1, waitTime: 1);
    // });

    controller.addListener(() {
      if (controller.text.trim() != '') {
        setState(() {
          isMicVisible = false;
        });
      } else {
        setState(() {
          isMicVisible = true;
        });
      }
    });
    KeyboardVisibility.onChange.listen((bool isKeyboardVisible) {
      if (mounted) {
        setState(() {
          this.isKeyboardVisible = isKeyboardVisible;
        });
        if (isKeyboardVisible && isEmojiVisible) {
          setState(() {
            isEmojiVisible = false;
          });
        }
      }
    });
  }

  scrollToBottomOfChat({int waitTime = 1, int scrollTime = 1}) {
    Future.delayed(Duration(milliseconds: waitTime), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: scrollTime),
          curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Container(
      color: AppColors.screenBackgroundColor,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: isEmojiVisible || isKeyboardVisible || isGiphyVisible
          ? height / 2
          : height / 3.5,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.chatVisibilityChange,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: AppColors.appAccentColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              shrinkWrap: true,
              itemBuilder: (contex, index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatMessages[index].type.toString() + ' : ',
                        style: AppStyles.clubCodeStyle,
                      ),
                      chatMessages[index].text != null
                          ? Text(
                              chatMessages[index].text,
                              style: AppStyles.itemInfoSecondaryTextStyle,
                            )
                          : CachedNetworkImage(
                              imageUrl: chatMessages[index].giphyLink,
                              height: 150,
                              width: 150,
                              placeholder: (_, __) => Center(
                                child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator()),
                              ),
                              fit: BoxFit.cover,
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
          inputBox(),
          Offstage(
            child: EmojiPickerWidget(
              onEmojiSelected: onEmojiSelected,
            ),
            offstage: !isEmojiVisible,
          ),
        ],
      ),
    );
  }

  inputBox() {
    return Container(
      color: AppColors.screenBackgroundColor,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: _openGifDrawer,
            child: Icon(
              Icons.add_circle_outline,
              size: 25,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ChatTextField(
                controller: controller,
                onBlurred: toggleEmojiKeyboard,
                isEmojiVisible: isEmojiVisible,
                isKeyboardVisible: isKeyboardVisible,
                focusNode: focusNode,
              ),
            ),
          ),
          GestureDetector(
            onLongPress: () => onMicPress(context),
            onLongPressEnd: (LongPressEndDetails details) =>
                onMicPressEnd(context, details),
            onTap: () => onSendPress(context),
            child: isMicVisible
                ? Container()
                : GestureDetector(
                    onTap: () {
                      if (controller.text.trim() != '') {
                        widget.chatService.sendText(controller.text.trim());
                        setState(() {
                          controller.clear();
                        });
                      }
                    },
                    child: Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  void _openGifDrawer() async {
    focusNode.unfocus();
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GameGiphies(widget.chatService),
    );
  }

  void onEmojiSelected(String emoji) => setState(() {
        controller.text = controller.text + emoji;
      });

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  Future<bool> onBackPress() {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      toggleEmojiKeyboard();

      // Navigator.pop(context);
    }
    return Future.value(false);
  }

  void onMicPress(BuildContext context) {
    if (!isMicVisible) {
      return;
    }
    record();
    log('Mic is pressed');
  }

  void onMicPressEnd(BuildContext context, LongPressEndDetails details) async {
    if (!isMicVisible) {
      return;
    }
    log('Mic is released');
    // if (_recorder.isRecording) {
    //   log('Stop recording');
    //   _recorder.stopRecorder();

    //   var outputFile = File(_audioFile);
    //   if (outputFile.existsSync()) {
    //     var length = await outputFile.length();
    //     log('File length: $length');
    //   }

    //   if (!_recordingCancelled) {
    //     // send the audio data in the chat channel
    //     var data = await outputFile.readAsBytes();
    //     // play the audio for testing
    //     // await _audioPlayer.startPlayerFromStream(
    //     //     sampleRate: SAMPLE_RATE, codec: Codec.pcm16);
    //     // await _audioPlayer.feedFromStream(data);

    //     widget.chatService.sendAudio(data);
    //   }
    //   outputFile.deleteSync();
    // }

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

  void onSendPress(BuildContext context) {
    if (isMicVisible) {
      return;
    }
  }

  @override
  void dispose() {
    // _recorder.stopRecorder();
    // _recorder.closeAudioSession();
    // _recorder = null;

    super.dispose();
  }

  Future<void> record() async {
    assert(_recorderIsInit);
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

    // log('Recording started now');
    // try {
    //   await _recorder.startRecorder(
    //     toFile: _audioFile,
    //     codec: Codec.pcm16,
    //     sampleRate: SAMPLE_RATE,
    //   );
    //   log('recording successful ${_recorder.isRecording}');
    // } catch (e) {
    //   log(e.toString());
    // }
    print("Start recording: $outputFile");
    await AudioRecorder.start(
        path: outputFile.path, audioOutputFormat: AudioOutputFormat.AAC);
    setState(() {});

    // run a timer and stop after 10 seconds
  }
}
