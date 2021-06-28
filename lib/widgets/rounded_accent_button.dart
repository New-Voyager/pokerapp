import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RoundedAccentButton extends StatelessWidget {
  final Function onTapFunction;
  final String text;
  RoundedAccentButton({Key key, this.onTapFunction, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        child: Text(
          text,
          style: AppStylesNew.joinTextStyle,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.pw,
          vertical: 3.ph,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.pw),
          image: DecorationImage(
            image: AssetImage(
              AppAssetsNew.pathJoinBackground,
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber,
              offset: Offset(1.pw, 0),
              blurRadius: 5.pw,
            )
          ],
        ),
      ),
    );
  }
}
