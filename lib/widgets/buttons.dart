import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_styles.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'blinking_widget.dart';

class RoundRectButton extends StatelessWidget {
  RoundRectButton({
    @required this.text,
    @required this.onTap,
    @required this.theme,
    this.fontSize,
    this.split = false,
    this.adaptive = true,
    this.icon,
  });

  final bool adaptive;
  final String text;
  final AppTheme theme;
  final Function onTap;
  final bool split;
  final double fontSize;
  final Icon icon;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // playsound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.pw,
          vertical: 3.ph,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.pw),
          border: Border.all(
              color: theme.roundedButtonBorderColor ??
                  theme.roundedButtonBackgroundColor,
              width: 1.pw),
          color: theme.roundedButtonBackgroundColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: icon,
              ),
              visible: icon != null,
            ),
            Text(
              split ? text?.replaceFirst(" ", "\n") ?? 'Text' : text ?? 'Text',
              textAlign: TextAlign.center,
              style: (fontSize == null)
                  ? theme.roundedButtonTextStyle.copyWith(
                      color: theme.roundButtonTextColor,
                      fontWeight: FontWeight.bold,
                    )
                  : theme.roundedButtonTextStyle.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.roundButtonTextColor),
            )
          ],
        ),
      ),
    );
  }
}

class RoundRectButton2 extends StatelessWidget {
  RoundRectButton2({
    @required this.text,
    @required this.onTap,
    @required this.theme,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String text;
  final AppTheme theme;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // playsound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20.pw),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.pw,
          vertical: 10.pw,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.pw),
          color: theme.roundedButton2BackgroundColor,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              split ? text?.replaceFirst(" ", "\n") ?? 'Text' : text ?? 'Text',
              textAlign: TextAlign.center,
              style: theme.roundedButton2TextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorWithDark()),
            )
          ],
        ),
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  CircleImageButton({
    @required this.onTap,
    @required this.theme,
    this.asset,
    this.svgAsset,
    this.icon,
    this.caption,
    this.disabled = false,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final String caption;
  final AppTheme theme;
  final Function onTap;
  final bool disabled;
  final bool split;

  Widget build(BuildContext context) {
    Color buttonColor = theme.accentColor;
    Color buttonBackGround = Colors.black;
    Color buttonBorder = theme.accentColor;

    // Color buttonColor = Color(0xffC99200);
    // Color buttonBackGround = Colors.black;
    // Color buttonBorder = Color(0xffC99200);

    // List<BoxShadow> shadow = [
    //     BoxShadow(
    //       color: buttonBackGround,
    //       blurRadius: 1,
    //       spreadRadius: 1,
    //       offset: Offset(1, 0),
    //     )
    //   ];

    Widget image = Container();
    if (asset != null) {
      image = ColorFiltered(
        child: Image.asset(asset),
        colorFilter: ColorFilter.mode(buttonColor, BlendMode.srcATop),
      );
    } else if (svgAsset != null) {
      image = SvgPicture.asset(
        svgAsset,
        width: 24,
        height: 24,
        color: buttonColor,
      );
    } else if (icon != null) {
      image = Icon(
        icon,
        size: 24,
        color: buttonColor,
      );
    }
    TextStyle textStyle = TextStyle(
      fontSize: 12.dp,
      color: Colors.white, //theme.circleImageButtonBorderColor,
    );
    if (theme.circleImageButtonTextStyle != null) {
      textStyle = textStyle.merge(theme.circleImageButtonTextStyle);
    }

    return InkWell(
      onTap: () {
        // play sound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(2.pw),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: buttonBackGround,
              // boxShadow: shadow,
              border: Border.all(
                color: buttonBorder,
                width: 2.0,
              ),
              //borderRadius: BorderRadius.circular(20.pw),
            ),
            child: Center(child: image),
          ),
          (caption != null)
              ? Padding(
                  padding: EdgeInsets.only(top: 8.pw),
                  child: Text(
                    caption,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class CircleImageButtonOld extends StatelessWidget {
  CircleImageButtonOld({
    @required this.onTap,
    @required this.theme,
    this.asset,
    this.svgAsset,
    this.icon,
    this.caption,
    this.disabled = false,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final String caption;
  final AppTheme theme;
  final Function onTap;
  final bool disabled;
  final bool split;

  Widget build(BuildContext context) {
    Widget image = Container();
    if (asset != null) {
      image = ColorFiltered(
        child: Image.asset(asset),
        colorFilter: ColorFilter.mode(
            theme.circleImageButtonImageColor, BlendMode.srcATop),
      );
    } else if (svgAsset != null) {
      image = SvgPicture.asset(
        svgAsset,
        color: theme.circleImageButtonImageColor,
      );
    } else if (icon != null) {
      image = Icon(
        icon,
        size: 24.pw,
        color: theme.circleImageButtonImageColor,
      );
    }
    TextStyle textStyle = TextStyle(
      fontSize: 12.dp,
      color: Colors.white, //theme.circleImageButtonBorderColor,
    );
    if (theme.circleImageButtonTextStyle != null) {
      textStyle = textStyle.merge(theme.circleImageButtonTextStyle);
    }

    return InkWell(
      onTap: () {
        // play sound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.pw,
            height: 40.pw,
            padding: EdgeInsets.all(2.pw),
            decoration: BoxDecoration(
              color: theme.circleImageButtonBackgroundColor,
              border: Border.all(
                color: theme.circleImageButtonBorderColor ??
                    theme.circleImageButtonBackgroundColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20.pw),
            ),
            child: Center(child: image),
          ),
          (caption != null)
              ? Padding(
                  padding: EdgeInsets.only(top: 8.pw),
                  child: Text(
                    caption,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class CircleImageButton2 extends StatelessWidget {
  CircleImageButton2({
    @required this.onTap,
    @required this.theme,
    this.asset,
    this.svgAsset,
    this.icon,
    this.caption,
    this.disabled = false,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final String caption;
  final AppTheme theme;
  final Function onTap;
  final bool disabled;
  final bool split;

  Widget build(BuildContext context) {
    Widget image = Container();
    if (asset != null) {
      image = ColorFiltered(
        child: Image.asset(asset),
        colorFilter: ColorFilter.mode(
            theme.circleImageButtonImageColor, BlendMode.srcATop),
      );
    } else if (svgAsset != null) {
      image = SvgPicture.asset(
        svgAsset,
        color: theme.circleImageButtonImageColor,
      );
    } else if (icon != null) {
      image = Icon(
        icon,
        size: 20.pw,
        color: theme.circleImageButtonImageColor,
      );
    }
    TextStyle textStyle = TextStyle(
      fontSize: 12.dp,
      color: Colors.white, //theme.circleImageButtonBorderColor,
    );
    if (theme.circleImageButtonTextStyle != null) {
      textStyle = textStyle.merge(theme.circleImageButtonTextStyle);
    }

    return InkWell(
      onTap: () {
        // play sound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24.pw,
            height: 24.pw,
            // padding: EdgeInsets.all(2.pw),
            decoration: BoxDecoration(
              color: theme.circleImageButtonBackgroundColor,
              border: Border.all(
                color: theme.circleImageButtonBorderColor ??
                    theme.circleImageButtonBackgroundColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20.pw),
            ),
            child: Center(child: image),
          ),
        ],
      ),
    );
  }
}

class RotateImagesButton extends StatelessWidget {
  RotateImagesButton({
    @required this.onTap,
    @required this.theme,
    @required this.svgImages,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final List<String> svgImages;
  final AppTheme theme;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    List<Widget> svgWidget = [];

    svgImages.forEach((element) {
      svgWidget.add(SvgPicture.asset(element,
          width: 16, height: 16, color: theme.primaryColorWithDark()));
    });

    Widget blinkWidget = BlinkWidget(
      children: svgWidget,
    );

    return InkWell(
      onTap: () {
        // play sound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.circleImageButtonBackgroundColor,
              border: Border.all(
                  color: theme.circleImageButtonBorderColor, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(child: blinkWidget),
          ),
        ],
      ),
    );
  }
}

class ConfirmYesButton extends StatelessWidget {
  ConfirmYesButton({
    @required this.onTap,
    @required this.theme,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final AppTheme theme;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // playsound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 32.0,
        height: 32.0,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: theme.confirmYesButtonBackgroundColor, width: 2),
          color: Colors.black,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            color: theme.confirmYesButtonBackgroundColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class ConfirmNoButton extends StatelessWidget {
  ConfirmNoButton({
    @required this.onTap,
    @required this.theme,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final AppTheme theme;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // playsound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 32.0,
        height: 32.0,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: theme.confirmNoButtonBackgroundColor, width: 2),
          color: Colors.black,
        ),
        child: Center(
          child: Icon(
            Icons.close,
            color: theme.confirmNoButtonBackgroundColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class ConfirmNoButton2 extends StatelessWidget {
  ConfirmNoButton2({
    @required this.onTap,
    @required this.theme,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final AppTheme theme;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // playsound
        this.onTap();
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 24.0,
        height: 24.0,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: theme.confirmNoButtonBackgroundColor,
        ),
        child: Center(
          child: Icon(
            Icons.close,
            color: theme.confirmNoButtonIconColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class IconAndTitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final Widget child;
  IconAndTitleWidget({this.icon, this.text, this.onTap, this.child});
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTap();
          },
          child: child ??
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColorWithDark(),
                    boxShadow: [
                      BoxShadow(
                        color: theme.secondaryColor,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 0),
                      ),
                    ]),
                child: Icon(
                  icon ?? Icons.info,
                  size: 20.dp,
                  color: theme.supportingColor,
                ),
                padding: EdgeInsets.all(16),
              ),
        ),
        InkWell(
          onTap: () {
            onTap();
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Text(
              text,
              style: AppDecorators.getSubtitle3Style(theme: theme),
            ),
          ),
        ),
      ],
    );
  }
}
