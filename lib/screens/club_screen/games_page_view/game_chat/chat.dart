import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:pokerapp/widgets/chat_text_field.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';

const int SAMPLE_RATE = 8000;

class GameChat extends StatefulWidget {
  final GameChatService chatService;
  GameChat(this.chatService);

  @override
  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> {
  TextEditingController controller = TextEditingController();
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  bool isMicVisible = true;
  String tempPath;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _recorderIsInit = false;
  StreamSubscription _recordingDataSubscription;
  String _audioFile;
  bool _recordingCancelled = false;
  @override
  void initState() {
    super.initState();

    _recorder.openAudioSession().then((value) {
      setState(() {
        _recorderIsInit = true;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Spacer(),
            inputBox(),
            Offstage(
              child: EmojiPickerWidget(
                onEmojiSelected: onEmojiSelected,
              ),
              offstage: !isEmojiVisible,
            ),
          ],
        ),
      ),
    );
  }

  inputBox() {
    return Container(
      color: AppColors.chatInputBgColor,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.add_circle_outline,
            size: 25,
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
              ),
            ),
          ),
          GestureDetector(
            onLongPress: () => onMicPress(context),
            onLongPressEnd: (LongPressEndDetails details) =>
                onMicPressEnd(context, details),
            onTap: () => onSendPress(context),
            child: isMicVisible
                ? Icon(
                    Icons.mic,
                    size: 25,
                  )
                : Icon(
                    Icons.send_outlined,
                    size: 25,
                  ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
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
      Navigator.pop(context);
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
    if (_recorder.isRecording) {
      log('Stop recording');
      _recorder.stopRecorder();

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

  Future<IOSink> createFile() async {
    Directory tempDir = await getTemporaryDirectory();
    tempPath = '${tempDir.path}/chat.pcm';
    File outputFile = File(tempPath);
    if (outputFile.existsSync()) await outputFile.delete();
    return outputFile.openWrite();
  }

  @override
  void dispose() {
    _recorder.stopRecorder();
    _recorder.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  Future<void> record() async {
    assert(_recorderIsInit);
    log('start recording');
    // Request Microphone permission if needed
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");
    _recordingCancelled = false;
    Directory tempDir = await getTemporaryDirectory();
    _audioFile = '${tempDir.path}/chat.aac';
    var outputFile = File(_audioFile);

    if (outputFile.existsSync()) {
      log('audio file $outputFile is deleted');
      outputFile.deleteSync();
    }

    log('Recording started now');
    try {
      await _recorder.startRecorder(
        toFile: outputFile.path,
        codec: Codec.pcm16,
        sampleRate: SAMPLE_RATE,
      );
      log('recording successful ${_recorder.isRecording}');
    } catch (e) {
      log(e.toString());
    }

    setState(() {});
  }
}
