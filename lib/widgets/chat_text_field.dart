import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmojiVisible;
  final bool isKeyboardVisible;
  final Function onBlurred;
  final focusNode;

  ChatTextField(
      {@required this.controller,
      @required this.isEmojiVisible,
      @required this.isKeyboardVisible,
      @required this.onBlurred,
      @required this.focusNode});

  void onClickedEmoji() async {
    if (isEmojiVisible) {
      focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      // await Future.delayed(Duration(microseconds: 100));
    }
    onBlurred();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsNew.chatInputBgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 15),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter text here",
            suffixIcon: GestureDetector(
              onTap: onClickedEmoji,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  isEmojiVisible
                      ? Icons.keyboard_rounded
                      : Icons.emoji_emotions_outlined,
                  size: 25,
                  color: Colors.black,
                ),
              ),
            )),
      ),
    );
  }
}
