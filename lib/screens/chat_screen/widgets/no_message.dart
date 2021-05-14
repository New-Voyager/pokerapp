import 'package:flutter/material.dart';

class NoMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.message_rounded,
          size: height * 0.07,
          color: Colors.white.withOpacity(0.5),
        ),
        Text(
          'No message',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: height * 0.023,
          ),
        )
      ],
    );
  }
}
