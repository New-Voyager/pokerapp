import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';

class EmojiPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiPickerWidget({
    @required this.onEmojiSelected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => EmojiPicker(
        HiveDatasource.getInstance.getBox(BoxType.EMOJI_BOX),
        rows: 4,
        columns: 8,
        onEmojiSelected: (emoji, category) {
          onEmojiSelected(emoji.emoji);
          Navigator.pop(context);
        },
      );
}
