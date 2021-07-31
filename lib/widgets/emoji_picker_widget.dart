import 'package:flutter/material.dart';

const List<String> _emojis = [
  '😊',
  '😀',
  '😁',
  '😅',
  '😂',
  '😇',
  '😍',
  '😜',
  '🤔',
  '🙄',
  '😴',
  '🤐',
  '😔',
  '😑',
  '😧',
  '😥',
  '😩',
  '😡',
  '👻',
  '🤠',
  '😎',
  '🤡',
  '💋',
  '👏',
  '🤞',
  '🖕',
  '👍',
  '👎',
  '🙏',
];

class EmojiPicker extends StatelessWidget {
  final Function onEmojiSelected;

  EmojiPicker({
    @required void this.onEmojiSelected(String _),
  });

  Widget _buildSingleEmojiChild(String emoji) => InkWell(
        onTap: () {
          onEmojiSelected(emoji);
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.20,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Wrap(
          children:
              _emojis.map((emoji) => _buildSingleEmojiChild(emoji)).toList(),
        ),
      ),
    );
  }
}

/*
😊
😀
😁
😅
😂
😇
😍
😜
🤔
🙄
😴'
🤐
😔
😑
😧
😥
😩
😡
👻
🤠
😎    
🤡
💋
👏
🤞
🖕
👍
👎
🙏
*/
