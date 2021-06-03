import 'package:flutter/material.dart';

class NoMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.message_rounded,
          size: 70,
          color: Colors.white.withOpacity(0.5),
        ),
        Text(
          'No message',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        )
      ],
    );
  }
}

class CircularProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Loading messages...',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        CircularProgressIndicator(),
        SizedBox(height: 15)
      ],
    );
  }
}
