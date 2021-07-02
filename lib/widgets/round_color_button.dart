import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RoundedColorButton extends StatelessWidget {
  final Function onTapFunction;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  RoundedColorButton({
    Key key,
    this.onTapFunction,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        child: Text(
          text,
          style: AppStylesNew.joinTextStyle.copyWith(
            color: textColor ?? AppColorsNew.newTextColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.pw,
          vertical: 3.ph,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.pw),
            color: backgroundColor ?? AppColorsNew.darkGreenShadeColor,
            border: Border.all(
                color: borderColor ??
                    backgroundColor ??
                    AppColorsNew.yellowAccentColor)),
      ),
    );
  }
}
