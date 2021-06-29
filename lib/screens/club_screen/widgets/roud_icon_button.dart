import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    this.onTap,
    this.icon,
    this.size,
    this.bgColor,
    this.iconColor,
  });
  final Function onTap;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final double size;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? AppColorsNew.newSelectedGreenColor,
        ),
        padding: EdgeInsets.all(6),
        child: Icon(
          icon,
          size: size ?? 20,
          color: iconColor ?? AppColorsNew.newTextColor,
        ),
      ),
    );
  }
}
