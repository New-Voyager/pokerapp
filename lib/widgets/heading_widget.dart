import 'package:flutter/material.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HeadingWidget extends StatelessWidget {
  final String heading;

  HeadingWidget({
    @required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.pw,
        vertical: 20.0.ph,
      ),
      child: Text(
        heading.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0.dp,
            color: const Color(0xfff4f4f4),
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: const Color(0xff00FFB1),
                blurRadius: 40.0.pw,
              ),
              Shadow(
                color: const Color(0xff00FFB1),
                blurRadius: 30.0.pw,
                offset: Offset(0.0, 5.0.pw),
              ),
            ]),
      ),
    );
  }
}
