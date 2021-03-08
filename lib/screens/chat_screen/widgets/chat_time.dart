import 'package:flutter/material.dart';

import '../utils.dart';

class ChatTimeWidget extends StatelessWidget {
  final bool isSender;
  final DateTime date;

  const ChatTimeWidget({
    Key key,
    this.isSender,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Text(
          dateString(date),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
