import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class ReplayButton extends StatelessWidget {
  final Function onTapFunction;
  ReplayButton({this.onTapFunction});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColorsNew.appAccentColor,
        ),
        child: Text(
          'Replay',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
