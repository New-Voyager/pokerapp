import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RoundRectButton extends StatelessWidget {
  RoundRectButton({
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
      onTap: this.onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.pw,
          vertical: 10.pw,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: theme.roundedButtonBackgroundColor,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              split ? text?.replaceFirst(" ", "\n") ?? 'Text' : text ?? 'Text',
              textAlign: TextAlign.center,
              style: theme.roundedButtonTextStyle,
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
      onTap: this.onTap,
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
              style: theme.roundedButton2TextStyle,
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
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String svgAsset;
  final String asset;
  final IconData icon;
  final AppTheme theme;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    Widget image = Container();
    if (asset != null) {
      image = Image.asset(asset);
    } else if (svgAsset != null) {
      image = SvgPicture.asset(
        svgAsset,
        color: theme.circleImageButtonImageColor,
      );
    } else if (icon != null) {
      image = Icon(
        icon,
        size: 24,
        color: theme.circleImageButtonImageColor,
      );
    }

    return InkWell(
      onTap: this.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40.0,
        height: 40.0,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.circleImageButtonBackgroundColor,
          border:
              Border.all(color: theme.circleImageButtonBorderColor, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(child: image),
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
      onTap: this.onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 24.0,
        height: 24.0,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: theme.confirmYesButtonBackgroundColor,
        ),
        child: Center(
            child: Icon(
          Icons.check,
          color: theme.confirmYesButtonIconColor,
          size: 20,
        )),
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
      onTap: this.onTap,
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
        )),
      ),
    );
  }
}
