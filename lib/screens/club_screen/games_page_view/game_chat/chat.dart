import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/widgets/chat_text_field.dart';
import 'package:pokerapp/widgets/emoji_picker_widget.dart';

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
  @override
  void initState() {
    super.initState();
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
          isMicVisible
              ? Icon(
                  Icons.mic,
                  size: 25,
                )
              : Icon(
                  Icons.send_outlined,
                  size: 25,
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
}
