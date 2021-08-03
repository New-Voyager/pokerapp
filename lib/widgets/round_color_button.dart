import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RoundedColorButton extends StatelessWidget {
  final Function onTapFunction;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  RoundedColorButton({
    Key key,
    this.onTapFunction,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
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
            fontSize: fontSize ?? 10.dp,
          ),
          textAlign: TextAlign.center,
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

class RoundedYellowButton extends RoundedColorButton {
  final Function onTapFunction;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  RoundedYellowButton({
    Key key,
    this.onTapFunction,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
  }) : super(
            key: key,
            onTapFunction: onTapFunction,
            text: text,
            backgroundColor: AppColorsNew.yellowAccentColor,
            textColor: AppColorsNew.btnTextColor,
            borderColor: AppColorsNew.yellowAccentColor,
            fontSize: fontSize);
}

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

class RoundedIconButton2 extends RoundIconButton {
  RoundedIconButton2({
    Function onTap,
    IconData icon,
    double size,
    Color bgColor,
    Color iconColor,
  }) : super(
            onTap: onTap,
            icon: icon,
            size: size,
            bgColor: AppColorsNew.yellowAccentColor,
            iconColor: AppColorsNew.roundBtn2IconColor);
}

// InkWell(
//         onTap: isActive ? onPressed : null,
//         child: Opacity(
//           opacity: isActive ? 1.0 : 0.50,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.60),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: AppColorsNew.newGreenButtonColor,
//                 width: 3.0,
//               ),
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Icon(
//               iconData,
//               color: AppColorsNew.newGreenButtonColor,
//               size: 30.0,
//             ),
//           ),
//         ),
//       );
