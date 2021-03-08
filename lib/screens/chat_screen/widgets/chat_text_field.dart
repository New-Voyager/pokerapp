import 'package:flutter/material.dart';

import '../utils.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData icon;
  final Function onTap;
  final Function onSave;
  final Function onEmoji;

  const ChatTextField({
    Key key,
    this.textEditingController,
    this.icon,
    this.onTap,
    this.onSave,
    this.onEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: chatHeaderColor,
      child: Row(
        children: [
          _buildTextFieldIcon(
            icon: icon,
            onPressed: onEmoji,
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
          _buildTextFieldIcon(
            icon: Icons.send,
            onPressed: onSave,
            color: Color.fromARGB(255, 0, 160, 233),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldIcon({IconData icon, Color color, Function onPressed}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
