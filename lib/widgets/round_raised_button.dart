import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

class RoundRaisedButton extends StatelessWidget {
  const RoundRaisedButton({
    @required this.onButtonTap,
    @required this.buttonText,
    this.color,
    this.radius,
    this.verticalPadding,
    this.fontSize = 18.0,
  });

  final double fontSize;
  final Function onButtonTap;
  final String buttonText;
  final Color color;
  final double radius;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 20),
      ),
      color: color ?? Colors.white,
      onPressed: onButtonTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: verticalPadding ?? 10.0,
        ),
        child: Text(
          buttonText ?? 'Button Text Goes Here',
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class RoundRaisedButtonWithTimer extends StatelessWidget {
  const RoundRaisedButtonWithTimer({
    @required this.onButtonTap,
    @required this.buttonText,
    this.color,
    this.radius,
    this.verticalPadding,
    this.fontSize = 18.0,
    this.timerWidget,
  });

  final double fontSize;
  final Function onButtonTap;
  final String buttonText;
  final Color color;
  final double radius;
  final double verticalPadding;
  final Widget timerWidget;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 20),
      ),
      color: color ?? Colors.white,
      onPressed: onButtonTap,
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: verticalPadding ?? 10.0,
          ),
          child: Container(
            height: 30,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                buttonText ?? 'Button Text Goes Here',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppAssets.fontFamilyLato,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              //timerWidget,
            ]),
          )),
    );
  }
}
