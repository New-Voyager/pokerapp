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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
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
