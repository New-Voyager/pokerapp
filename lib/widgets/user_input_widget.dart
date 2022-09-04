import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

class UserInputWidget extends StatelessWidget {
  final VoidCallback onGifClick;
  final VoidCallback onMessagesClick;
  final VoidCallback onSendClick;
  final VoidCallback onEmojiClick;
  final TextEditingController editingController;
  final bool allowGif;
  final bool allowGameTexts;

  // final _textVn = ValueNotifier<String>('');

  UserInputWidget({
    this.allowGif = true,
    this.allowGameTexts = false,
    @required this.onGifClick,
    @required this.onMessagesClick,
    @required this.onSendClick,
    @required this.onEmojiClick,
    @required this.editingController,
  });

  Widget _buildTextField(AppTheme theme) {
    AppTextScreen _appScreenText = getAppTextScreen('gameChat');

    return Container(
      decoration: AppDecorators.generalListItemWidget(stroke: false),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          // text field
          Expanded(
            child: TextField(
              onTap: () {
                // _vnShowEmojiPicker.value = false;
              },
              controller: editingController,
              // onChanged: (value) => _textVn.value = value,
              style: AppDecorators.getSubtitle2Style(theme: theme)
                  .copyWith(color: theme.supportingColor),
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                hintText: _appScreenText['typeAMessage'],
              ),
            ),
          ),

          // emoji button
          GestureDetector(
            onTap: onEmojiClick,
            child: Icon(
              Icons.emoji_emotions_outlined,
              size: 25,
              color: theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    List<Widget> children = [];
    if (allowGif) {
      /* gif drawer button */

      children.add(GestureDetector(
        onTap: onGifClick,
        child: Icon(
          Icons.add_circle_outline,
          size: 25,
          color: theme.accentColor,
        ),
      ));
      children.add(const SizedBox(width: 10));
    }

    if (allowGameTexts) {
      children.add(
        // button
        GestureDetector(
          onTap: onMessagesClick,
          child: Icon(
            Icons.list,
            size: 25,
            color: theme.accentColor,
          ),
        ),
      );
    }
    children.addAll([
      /* main text field */
      Expanded(child: _buildTextField(theme)),

      /* send button */
      GestureDetector(
        onTap: onSendClick,
        child: Icon(
          Icons.send_outlined,
          color: theme.accentColor,
          size: 25,
        ),
      ),
    ]);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: children,
      ),
    );
  }
}
