import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String heading;

  HeadingWidget({
    @required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
      child: Text(
        heading.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 25.0,
            color: const Color(0xfff4f4f4),
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: const Color(0xff00FFB1),
                blurRadius: 40.0,
              ),
              Shadow(
                color: const Color(0xff00FFB1),
                blurRadius: 30.0,
                offset: const Offset(0.0, 5.0),
              ),
            ]),
      ),
    );
  }
}
