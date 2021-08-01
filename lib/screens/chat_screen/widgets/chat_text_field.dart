import 'package:flutter/material.dart';

import '../utils.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData icon;
  final Function onTap;
  final Function onSend;
  final Function onEmojiSelectTap;
  final Function onGifSelectTap;

  const ChatTextField({
    Key key,
    this.textEditingController,
    this.icon,
    this.onTap,
    this.onSend,
    this.onEmojiSelectTap,
    this.onGifSelectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: chatHeaderColor,
      child: Row(
        children: [
          // gif button
          _buildTextFieldIcon(
            icon: icon,
            onPressed: onGifSelectTap,
            color: iconColor,
          ),

          Expanded(
            child: TextFormField(
              controller: textEditingController,
              onTap: onTap,
              style: TextStyle(color: Colors.white),
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Message',
                hintStyle: TextStyle(
                  color: iconColor,
                ),
              ),
            ),
          ),

          // emoji button
          _buildTextFieldIcon(
            padding: false,
            icon: Icons.emoji_emotions,
            onPressed: onEmojiSelectTap,
            color: iconColor,
          ),

          // send button
          _buildTextFieldIcon(
            icon: Icons.send,
            onPressed: onSend,
            color: Color.fromARGB(255, 0, 160, 233),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldIcon(
      {IconData icon, Color color, Function onPressed, bool padding = true}) {
    return Container(
      child: Padding(
        padding: padding
            ? const EdgeInsets.symmetric(horizontal: 5)
            : const EdgeInsets.all(0.0),
        child: IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
