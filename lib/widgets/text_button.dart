import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

class TextButton extends StatelessWidget {
  TextButton({
    @required this.text,
    @required this.onTap,
    this.split = false,
  });

  final String text;
  final Function onTap;
  final bool split;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        split ? text?.replaceFirst(" ", "\n") ?? 'Text' : text ?? 'Text',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppAssets.fontFamilyLato,
          fontSize: 16.0,
          color: AppColors.appAccentColor,
        ),
      ),
    );
  }
}
