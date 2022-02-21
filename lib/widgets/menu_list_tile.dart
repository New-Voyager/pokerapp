import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/texts.dart';

class MenuListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String svgIconPath;
  final TextStyle textStyle;
  final bool navIcon;
  final String suffixText;
  final bool switchable;
  final bool switchValue;
  final Function onSwitchChanged;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final int badgeCount;

  const MenuListTile({
    Key key,
    @required this.title,
    this.onPressed,
    this.padding,
    this.textStyle,
    this.icon,
    this.svgIconPath,
    this.navIcon = false,
    this.suffixText = "",
    this.switchable = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.badgeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.getTheme(context);
    Widget iconWidget = SizedBox.shrink();
    if (this.svgIconPath != null) {
      iconWidget = SvgPicture.asset(
        svgIconPath,
        width: 18,
        height: 18,
        color: theme.accentColor,
      );
    } else if (this.icon != null) {
      iconWidget = Icon(this.icon, size: 18, color: theme.accentColor);
    }

    iconWidget = Container(
        width: 24,
        height: 24,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.accentColor,
            width: 1.5,
          ),
        ),
        child: iconWidget);

    if (this.badgeCount != null && this.badgeCount != 0) {
      iconWidget = IconWithBadge(
        child: iconWidget,
        count: this.badgeCount,
      );
    }

    Widget prefixWidget = Row(
      children: [
        (icon != null || svgIconPath != null)
            ? Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: iconWidget,
              )
            : SizedBox.shrink(),
        TileText(
          text: title,
          theme: theme,
          style: textStyle,
        ),
      ],
    );

    Widget suffixWidget = Row(children: [
      (suffixText != null)
          ? TileText(
              text: suffixText,
              theme: theme,
            )
          : SizedBox.shrink(),
      switchable
          ? SwitchWidget2(
              label: '',
              value: switchValue,
              onChange: onSwitchChanged,
            )
          : SizedBox.shrink(),
      navIcon
          ? Icon(Icons.navigate_next, color: theme.accentColor)
          : SizedBox.shrink(),
    ]);

    return InkWell(
      onTap: () {
        if (this.onPressed != null) {
          AudioService.playClickSound();
          this.onPressed();
        }
      },
      child: Padding(
        padding: padding ?? EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [prefixWidget, suffixWidget],
        ),
      ),
    );
  }
}
