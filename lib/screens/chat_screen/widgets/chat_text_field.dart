import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData icon;
  final Function onTap;
  final Function onSend;
  final Function onEmojiSelectTap;
  final Function onGifSelectTap;
  final AppTextScreen appScreenText;

  const ChatTextField({
    Key key,
    this.appScreenText,
    this.textEditingController,
    this.icon,
    this.onTap,
    this.onSend,
    this.onEmojiSelectTap,
    this.onGifSelectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        color: theme.fillInColor,
        child: Row(
          children: [
            // gif button
            _buildTextFieldIcon(
              icon: icon,
              onPressed: onGifSelectTap,
              color: theme.secondaryColorWithDark(),
            ),
            // emoji button
            _buildTextFieldIcon(
              padding: false,
              icon: Icons.emoji_emotions,
              onPressed: onEmojiSelectTap,
              color: theme.secondaryColorWithDark(),
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
                  hintText: appScreenText['ENTERMESSAGE'],
                  hintStyle: AppDecorators.getSubtitle3Style(theme: theme),
                ),
              ),
            ),

            // send button
            _buildTextFieldIcon(
              icon: Icons.send,
              onPressed: onSend,
              color: theme.accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldIcon(
      {IconData icon, Color color, Function onPressed, bool padding = true}) {
    return Container(
      child: Padding(
        padding: padding
            ? const EdgeInsets.only(left: 5)
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
