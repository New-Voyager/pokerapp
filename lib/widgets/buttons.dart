import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/styles.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/color_generator.dart';
import 'package:pokerapp/utils/formatter.dart';

import 'blinking_widget.dart';

class RoundRectButton extends StatelessWidget {
  RoundRectButton(
      {this.text,
      @required this.onTap,
      @required this.theme,
      this.focusNode,
      this.fontSize,
      this.split = false,
      this.adaptive = true,
      this.icon,
      this.positive = null,
      this.negative = null});

  final bool adaptive;
  final String text;
  final AppTheme theme;
  final Function onTap;
  final bool split;
  final double fontSize;
  final Icon icon;
  final FocusNode focusNode;
  final bool positive;
  final bool negative;

  Widget build(BuildContext context) {
    var gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.accentColorWithDark(0.1),
          theme.accentColorWithLight(0.2),
          theme.accentColor,
          theme.accentColorWithDark(0.1),
          theme.accentColorWithDark(0.2),
          theme.accentColor,
        ],
        stops: [
          0,
          0.3,
          0.5,
          0.7,
          0.9,
          1.0
          //0.3
        ]);
    // if (positive != null && positive) {
    //   gradient = LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [
    //         Colors.green[500],
    //         Colors.green[300],
    //         Colors.green[200],
    //         Colors.green[500],
    //         Colors.green[700],
    //         Colors.green[800],
    //       ],
    //       stops: [
    //         0,
    //         0.3,
    //         0.5,
    //         0.7,
    //         0.9,
    //         1.0
    //         //0.3
    //       ]);
    // }
    // if (negative != null && negative) {
    //   gradient = LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [
    //         Colors.red[500],
    //         Colors.red[300],
    //         Colors.red[200],
    //         Colors.red[500],
    //         Colors.red[700],
    //         Colors.red[800],
    //       ],
    //       stops: [
    //         0,
    //         0.3,
    //         0.5,
    //         0.7,
    //         0.9,
    //         1.0
    //         //0.3
    //       ]);
    // }
    return InkWell(
      focusNode: focusNode,
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
          // color: theme.roundedButtonBackgroundColor,
          gradient: gradient,
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
            text == null
                ? const SizedBox.shrink()
                : Text(
                    split
                        ? text?.replaceFirst(" ", "\n") ?? 'Text'
                        : text ?? 'Text',
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

class ThemedButton extends StatelessWidget {
  ThemedButton({
    this.text,
    @required this.onTap,
    @required this.style,
    this.focusNode,
    this.split = false,
    this.icon,
  });

  final String text;
  final ThemedButtonStyle style;
  final Function onTap;
  final bool split;
  final Icon icon;
  final FocusNode focusNode;

  Widget build(BuildContext context) {
    return InkWell(
      focusNode: focusNode,
      onTap: () {
        this.onTap();
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.pw),
            // border: Border.all(
            //     color: theme.roundedButtonBorderColor ??
            //         theme.roundedButtonBackgroundColor,
            //     width: 1.pw),
            // color: theme.roundedButtonBackgroundColor,
            gradient: style.borderGradient),
        padding: EdgeInsets.all(2),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.pw,
            vertical: 3.ph,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.pw),
            gradient: style.gradient,
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
              text == null
                  ? const SizedBox.shrink()
                  : Text(
                      split
                          ? text?.replaceFirst(" ", "\n") ?? 'Text'
                          : text ?? 'Text',
                      textAlign: TextAlign.center,
                      style: style.textStyle,
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  CircleImageButton({
    @required this.onTap,
    @required this.theme,
    this.focusNode,
    this.height,
    this.width,
    this.imageHeight,
    this.imageWidth,
    this.asset,
    this.svgAsset,
    this.icon,
    this.caption,
    this.captionTextStyle,
    this.disabled = false,
    this.split = false,
    this.adaptive = true,
  });
  final FocusNode focusNode;
  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final String caption;
  final TextStyle captionTextStyle;
  final AppTheme theme;
  final Function onTap;
  final bool disabled;
  final bool split;
  final double height;
  final double width;
  final double imageHeight;
  final double imageWidth;

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
        width: imageWidth ?? 18,
        height: imageHeight ?? 18,
        color: buttonColor,
      );
    } else if (icon != null) {
      image = Icon(
        icon,
        size: imageWidth ?? 18,
        color: buttonColor,
      );
    }
    TextStyle textStyle = TextStyle(
      fontSize: 12.dp,
      color: Colors.white, //theme.circleImageButtonBorderColor,
    );
    if (captionTextStyle != null) {
      textStyle = captionTextStyle;
    } else if (theme.circleImageButtonTextStyle != null) {
      textStyle = textStyle.merge(theme.circleImageButtonTextStyle);
    }

    return OutlineGradientButton(
        child: SizedBox(width: 32, height: 32, child: Center(child: image)),
        gradient: LinearGradient(
          colors: [
            theme.accentColorWithLight(0.2),
            theme.accentColorWithLight(0.1),
            theme.accentColor,
            theme.accentColor,
            //           theme.accentColorWithDark(0.1),
            theme.accentColorWithDark(0.1),
            theme.accentColorWithDark(0.2),
            //theme.accentColor,
          ],
          stops: [
            0,
            0.2,
            0.5,
            0.8,
            0.9,
            1.0,
            //0.3
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // begin: Alignment(-1, -1),
          // end: Alignment(2, 2),
        ),
        strokeWidth: 3,
        backgroundColor: Colors.black,
        padding: EdgeInsets.zero,
        radius: Radius.circular(24),
        onTap: () {
          this.onTap();
        });
  }
}

class ThemedCircleImageButton extends StatelessWidget {
  ThemedCircleImageButton({
    @required this.onTap,
    @required this.style,
    this.focusNode,
    this.height,
    this.width,
    this.imageHeight,
    this.imageWidth,
    this.asset,
    this.svgAsset,
    this.icon,
    this.caption,
    this.captionTextStyle,
    this.disabled = false,
    this.split = false,
    this.adaptive = true,
  });
  final FocusNode focusNode;
  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final String caption;
  final TextStyle captionTextStyle;
  final ThemedButtonStyle style;
  final Function onTap;
  final bool disabled;
  final bool split;
  final double height;
  final double width;
  final double imageHeight;
  final double imageWidth;

  Widget build(BuildContext context) {
    Color buttonColor = style.iconColor;

    Widget image = Container();
    if (asset != null) {
      image = ColorFiltered(
        child: Image.asset(asset),
        colorFilter: ColorFilter.mode(buttonColor, BlendMode.srcATop),
      );
    } else if (svgAsset != null) {
      image = SvgPicture.asset(
        svgAsset,
        width: imageWidth ?? 18,
        height: imageHeight ?? 18,
        color: buttonColor,
      );
    } else if (icon != null) {
      image = DecoratedIcon(
        icon,
        size: imageWidth ?? 18,
        color: buttonColor,
        shadows: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.black38,
          ),
        ],
      );
    }

    return OutlineGradientButton(
        child: SizedBox(width: 32, height: 32, child: Center(child: image)),
        gradient: style.borderGradient,
        backgroundGradient: style.gradient,
        strokeWidth: 3,
        backgroundColor: Colors.black,
        padding: EdgeInsets.zero,
        radius: Radius.circular(24),
        onTap: () {
          this.onTap();
        });
  }
}

class DummyCircleImageButton extends StatelessWidget {
  DummyCircleImageButton({
    @required this.theme,
    this.focusNode,
    this.height,
    this.width,
    this.imageHeight,
    this.imageWidth,
    this.asset,
    this.svgAsset,
    this.icon,
    this.caption,
    this.disabled = false,
    this.split = false,
    this.adaptive = true,
  });
  final FocusNode focusNode;
  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final String caption;
  final AppTheme theme;
  final bool disabled;
  final bool split;
  final double height;
  final double width;
  final double imageHeight;
  final double imageWidth;

  Widget build(BuildContext context) {
    Color buttonColor = theme.accentColor;
    Widget image = Container();
    if (asset != null) {
      image = ColorFiltered(
        child: Image.asset(asset),
        colorFilter: ColorFilter.mode(buttonColor, BlendMode.srcATop),
      );
    } else if (svgAsset != null) {
      image = SvgPicture.asset(
        svgAsset,
        width: imageWidth ?? 18,
        height: imageHeight ?? 18,
        color: buttonColor,
      );
    } else if (icon != null) {
      image = Icon(
        icon,
        size: imageWidth ?? 18,
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

    return OutlineGradientButton(
      child: SizedBox(width: 32, height: 32, child: Center(child: image)),
      gradient: LinearGradient(
        colors: [theme.accentColor, theme.accentColorWithDark(0.25)],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        // begin: Alignment(-1, -1),
        // end: Alignment(2, 2),
      ),
      strokeWidth: 3,
      backgroundColor: Colors.black,
      padding: EdgeInsets.zero,
      radius: Radius.circular(24),
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
    Color buttonColor = theme.accentColor;
    Color buttonBackGround = Colors.black;
    Color buttonBorder = theme.accentColor;

    List<Widget> svgWidget = [];

    svgImages.forEach((element) {
      svgWidget.add(
          SvgPicture.asset(element, width: 24, height: 24, color: buttonColor));
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
            padding: EdgeInsets.all(2.pw),
            decoration: BoxDecoration(
              color: buttonBackGround,
              border: Border.all(color: buttonBorder, width: 2.0),
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

class OutlineGradientButton extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Radius radius;
  final Corners corners;
  final Gradient gradient;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Gradient backgroundGradient;
  final double elevation;
  final bool inkWell;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;
  final GestureTapDownCallback onTapDown;
  final GestureTapCancelCallback onTapCancel;
  final ValueChanged<bool> onHighlightChanged;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onFocusChange;

  OutlineGradientButton({
    Key key,
    @required this.child,
    @required this.strokeWidth,
    @required this.gradient,
    this.corners,
    this.radius,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor = Colors.transparent,
    this.backgroundGradient,
    this.elevation = 0,
    this.inkWell = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.onFocusChange,
  })  : assert(strokeWidth > 0),
        assert(padding.isNonNegative),
        assert(elevation >= 0),
        assert(radius == null || corners == null,
            'Cannot provide both a radius and corners.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = corners != null
        ? _fromCorners(corners, strokeWidth)
        : _fromRadius(radius ?? Radius.zero, strokeWidth);
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: br,
      child: InkWell(
        borderRadius: br,
        highlightColor:
            inkWell ? Theme.of(context).highlightColor : Colors.transparent,
        splashColor:
            inkWell ? Theme.of(context).splashColor : Colors.transparent,
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        onHighlightChanged: onHighlightChanged,
        onHover: onHover,
        onFocusChange: onFocusChange,
        child: CustomPaint(
          foregroundPainter: _Painter(gradient, radius, strokeWidth, corners),
          child: Padding(
              padding: padding,
              child: Container(
                  decoration: BoxDecoration(
                    gradient: backgroundGradient,
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(radius),
                  ),
                  child: child)),
        ),
      ),
    );
  }

  static BorderRadius _fromCorners(Corners corners, double strokeWidth) {
    return BorderRadius.only(
      topLeft: Radius.elliptical(
          corners.topLeft.x + strokeWidth, corners.topLeft.y + strokeWidth),
      topRight: Radius.elliptical(
          corners.topRight.x + strokeWidth, corners.topRight.y + strokeWidth),
      bottomLeft: Radius.elliptical(corners.bottomLeft.x + strokeWidth,
          corners.bottomLeft.y + strokeWidth),
      bottomRight: Radius.elliptical(corners.bottomRight.x + strokeWidth,
          corners.bottomRight.y + strokeWidth),
    );
  }

  static BorderRadius _fromRadius(Radius radius, double strokeWidth) {
    return BorderRadius.all(
        Radius.elliptical(radius.x + strokeWidth, radius.y + strokeWidth));
  }
}

class _Painter extends CustomPainter {
  final Gradient gradient;
  final Radius radius;
  final double strokeWidth;
  final Corners corners;

  _Painter(this.gradient, this.radius, this.strokeWidth, this.corners);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
        size.width - strokeWidth, size.height - strokeWidth);
    final RRect rRect = corners != null
        ? RRect.fromRectAndCorners(
            rect,
            topLeft: corners.topLeft,
            topRight: corners.topRight,
            bottomLeft: corners.bottomLeft,
            bottomRight: corners.bottomRight,
          )
        : RRect.fromRectAndRadius(rect, radius ?? Radius.zero);
    final Paint _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(rRect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

class Corners {
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;

  const Corners({
    this.topLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.bottomRight = Radius.zero,
  });
}

class BetAmountButton extends StatelessWidget {
  final AppTheme theme;
  final String text;
  final Function onTap;
  final bool isKeyboard;
  final double amount;
  const BetAmountButton(
      {Key key,
      @required this.theme,
      this.text = '',
      this.isKeyboard = false,
      this.amount = null,
      @required this.onTap})
      : super(key: key);

  Widget build(BuildContext context) {
    TextStyle btnTextStyle = AppDecorators.getHeadLine4Style(theme: theme)
        .copyWith(color: theme.supportingColor);
    // Color btnColor = theme.primaryColorWithLight(0.25);
    Color btnColor = Color.fromARGB(255, 73, 77, 97);
    Widget amountWidget;
    if (amount != null) {
      amountWidget = Column(
        children: [
          Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: btnTextStyle.copyWith(
              fontSize: 9.dp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          //SizedBox(height: 2),
          Text(
            DataFormatter.chipsFormat(amount),
            textAlign: TextAlign.center,
            style: btnTextStyle.copyWith(
              fontSize: 7.dp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      amountWidget = Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: btnTextStyle.copyWith(
          fontSize: 10.dp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }
    final button = Container(
      // duration: AppConstants.fastAnimationDuration,
      // curve: Curves.bounceInOut,
      height: 26.ph,
      width: 50.pw,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        //color: btnColor,
        shape: BoxShape.rectangle,
        // border: Border.all(
        //   color: darken(btnColor, 0.1),
        //   width: 2.0,
        // ),
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [
            btnColor,
            lighten(btnColor, 0.1),
            btnColor
            // lighten(btnColor, 0.1),
          ],
          begin: Alignment.centerLeft,
          stops: [0.0, 0.5, 1],
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: isKeyboard
              ? Icon(
                  Icons.keyboard,
                  color: Colors.white,
                )
              : amountWidget,
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      child: button,
    );
  }
}

class BetButton extends StatelessWidget {
  final AppTheme theme;
  final String text;
  final Function onTap;
  final Function onTapDown;
  final Function onTapUp;
  final bool isKeyboard;
  final String svgAsset;
  final IconData iconData;

  const BetButton(
      {Key key,
      @required this.theme,
      this.svgAsset,
      this.iconData,
      this.text = '',
      this.isKeyboard = false,
      @required this.onTap,
      this.onTapDown,
      this.onTapUp})
      : super(key: key);

  Widget build(BuildContext context) {
    TextStyle btnTextStyle = AppDecorators.getHeadLine4Style(theme: theme)
        .copyWith(color: theme.supportingColor);
    // Color btnColor = theme.primaryColorWithLight(0.25);
    Color btnColor = Color(0xFF134848);
    Widget icon;
    if (this.svgAsset != null) {
      icon = SvgPicture.asset(
        svgAsset,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      icon = Icon(iconData);
    }
    final button = Container(
      // duration: AppConstants.fastAnimationDuration,
      // curve: Curves.bounceInOut,
      height: 28.ph,
      width: 28.ph,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/buttons/bet-button.png',
              ),
              fit: BoxFit.fill)),
      child: icon,
    );

    return GestureDetector(
      onTap: onTap,
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: button,
    );
  }
}

class GameActionButton extends StatelessWidget {
  final AppTheme theme;
  final Function onTap;
  final String text;
  final Color btnColor;
  final IconData icon;
  GameActionButton(
      {this.theme, this.onTap, this.text, this.btnColor, this.icon});

  @override
  Widget build(BuildContext context) {
    TextStyle btnTextStyle = AppDecorators.getHeadLine4Style(theme: theme)
        .copyWith(color: theme.primaryColorWithDark());
    Color btnColor = this.btnColor ?? theme.accentColor;
    List<Widget> widgets = [];
    if (icon != null) {
      widgets.add(Icon(icon));
    }
    widgets.add(Text(text,
        textAlign: TextAlign.center,
        style: btnTextStyle.copyWith(
          fontSize: 10.dp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        )));
    final button = Container(
      height: 32.ph,
      width: 80.pw,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: btnColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [
            btnColor,
            lighten(btnColor, 0.13),
            btnColor,
          ],
          begin: Alignment.centerLeft,
          stops: [0.0, 0.5, 1],
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Row(
            children: widgets,
          ),
        ),
      ),
    );
    return InkWell(
      onTap: onTap,
      child: button,
    );
  }
}

class TipButton extends StatelessWidget {
  final AppTheme theme;
  final String text;
  final tooltipController = JustTheController();
  TipButton({@required this.theme, @required this.text});

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      width: 18.ph,
      height: 18.ph,
      //padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
        color: Colors.black,
      ),
      child: Icon(Icons.question_mark, size: 15.ph, color: Colors.grey),
    );

    return JustTheTooltip(
        controller: tooltipController,
        isModal: true,
        child: button,
        backgroundColor: Color.fromARGB(255, 41, 40, 40),
        content: Padding(
            padding: EdgeInsets.all(8.0),
            child: MarkdownBody(
              data: text,
              styleSheet: MarkdownStyleSheet(
                h3: TextStyle(
                    color: theme.accentColor,
                    fontSize: 9.dp,
                    fontWeight: FontWeight.bold),
              ),
            )));
  }
}
