import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    this.onTap,
    this.icon,
  });
  final Function onTap;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColorsNew.newSelectedGreenColor,
        ),
        padding: EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 20,
          color: AppColorsNew.newTextColor,
        ),
      ),
    );
  }
}
