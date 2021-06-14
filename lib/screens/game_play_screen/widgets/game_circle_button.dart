import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class GameCircleButton extends StatelessWidget {
  final VoidCallback onClickHandler;
  final String imagePath;
  final IconData iconData;

  const GameCircleButton({
    Key key,
    this.onClickHandler,
    this.imagePath,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = Container(
      height: 32.pw,
      width: 32.pw,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColorsNew.newActiveBoxColor,
          border: Border.all(
              color: Color(
                  0xff8b4513))), //AppColors.gameButtonBorderColor)), //Colors.yellow)),
      padding: EdgeInsets.all(5.pw),
      margin: EdgeInsets.symmetric(
        horizontal: 5.pw,
        vertical: 5.pw,
      ),
      child: imagePath != null
          ? SvgPicture.asset(
              imagePath,
              height: 24.pw,
              width: 24.pw,
              // color: AppColorsNew.newGreenButtonColor,
            )
          : Center(
              child: Icon(
              iconData,
              size: 20.pw,
              color: Colors.black, //AppColorsNew.newGreenButtonColor,
            )),
    );

    if (onClickHandler != null) {
      return InkWell(onTap: onClickHandler, child: button);
    } else {
      return button;
    }
  }
}
