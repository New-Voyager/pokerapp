import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class GameCircleButton extends StatelessWidget {
  final VoidCallback onClickHandler;
  final String imagePath;
  final IconData iconData;
  final Widget child;
  final Color color;
  final bool disabled;
  const GameCircleButton({
    Key key,
    this.onClickHandler,
    this.imagePath,
    this.iconData,
    this.child,
    this.color,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    Widget child = this.child;
    Widget svg;
    if (imagePath != null) {
      if (color != null) {
        svg = SvgPicture.asset(
          imagePath,
          height: 24.pw,
          width: 24.pw,
          color: color,
        );
      } else {
        svg = SvgPicture.asset(
          imagePath,
          height: 24.pw,
          width: 24.pw,
        );
      }
    }
    if (child == null) {
      child = svg != null
          ? Center(child: svg)
          : Center(
              child: Icon(
              iconData,
              color: theme
                  .primaryColorWithDark(), //AppColorsNew.newGreenButtonColor,
            ));
    }

    Color buttonColor = theme.accentColor;
    if (disabled) {
      buttonColor = AppColorsNew.disabledColor;
    }
    final button = Container(
      height: 36.pw,
      width: 36.pw,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: buttonColor,
      ),
      padding: EdgeInsets.all(5.pw),
      // margin: EdgeInsets.symmetric(
      //   horizontal: 2.pw,
      //   vertical: 2.pw,
      // ),
      child: child,
    );

    if (onClickHandler != null) {
      return InkWell(onTap: onClickHandler, child: button);
    } else {
      return button;
    }
  }
}
