import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class NewButton extends StatelessWidget {
  final String text;
  final Function onTapFunc;
  final ButtonStyle style;
  NewButton({this.text, this.onTapFunc, this.style});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTapFunc,
      style: style,
      child: Container(
        child: Text(
          text,
          style: TextStyle(color: AppColorsNew.newTextColor),
        ),
      ),
    );
  }
}
