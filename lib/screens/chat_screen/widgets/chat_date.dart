import 'package:flutter/material.dart';

import '../utils.dart';

class ChatDateTime extends StatelessWidget {
  final DateTime date;

  const ChatDateTime({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.02, horizontal: width * 0.015),
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
