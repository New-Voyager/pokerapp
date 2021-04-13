import 'package:flutter/material.dart';

import '../utils.dart';

class ChatDateTime extends StatelessWidget {
  final DateTime date;

  const ChatDateTime({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: chatHeaderColor,
      ),
      child: Text(
        formatDate(date),
        style: TextStyle(color: Colors.white.withOpacity(0.4)),
      ),
    );
  }
}
