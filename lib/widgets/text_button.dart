import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  TextButton({
    @required this.text,
    @required this.onTap,
  });

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(text ?? 'Text'),
    );
  }
}
