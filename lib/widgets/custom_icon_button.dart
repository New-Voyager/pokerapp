import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final IconData icon;
  final String svgPath;
  final Color buttonColor;
  IconTextButton(
      {Key key,
      this.text,
      this.onTap,
      this.icon,
      this.svgPath,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 50),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor.withAlpha(200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
