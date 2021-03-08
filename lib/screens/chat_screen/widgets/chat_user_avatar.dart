import 'package:flutter/material.dart';

import '../../../utils/color_generator.dart';

class ChatUserAvatar extends StatelessWidget {
  final String avatarLink;
  final String name;
  final String userId;

  const ChatUserAvatar({
    Key key,
    this.avatarLink,
    this.name,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: generateColorFor(userId),
        child: Text(
          name[0],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
