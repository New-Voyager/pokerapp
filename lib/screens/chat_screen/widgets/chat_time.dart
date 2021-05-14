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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: width * 0.02, bottom: height * 0.01),
        child: Text(
          dateString(date),
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: height * 0.0165,
          ),
        ),
      ),
    );
  }
}
