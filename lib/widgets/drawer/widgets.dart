import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:provider/provider.dart';

class IconWidgetTile extends StatelessWidget {
  final String svgIconPath;
  final String title;
  final IconData icon;
  final int badgeCount;
  final Function onPressed;
  const IconWidgetTile({
    Key key,
    @required this.title,
    this.svgIconPath,
    this.icon,
    this.onPressed,
    this.badgeCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.getTheme(context);
    Widget icon = Container();
    if (this.svgIconPath != null) {
      icon = SvgPicture.asset(
        svgIconPath,
        width: 24,
        height: 24,
        color: theme.accentColor,
      );
    } else if (this.icon != null) {
      icon = Icon(this.icon, size: 24, color: theme.accentColor);
    }

    Widget child = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.accentColor),
              ),
              child: icon),
          SizedBox(width: 12),
          TileText(text: title, theme: theme),
        ],
      ),
    );
    if (this.badgeCount != null && this.badgeCount != 0) {
      child = IconWithBadge(
        child: child,
        count: this.badgeCount,
      );
    }
    return InkWell(
      onTap: () {
        if (this.onPressed != null) {
          AudioService.playClickSound();
          this.onPressed();
        }
      },
      child: child,
    );
  }
}

class TileText extends StatelessWidget {
  final String text;
  final AppTheme theme;
  const TileText({Key key, @required this.text, @required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppDecorators.getHeadLine5Style(theme: theme),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String text;
  final AppTheme theme;
  const SubTitleText({Key key, @required this.text, @required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppDecorators.getHeadLine5Style(theme: theme),
    );
  }
}

class SwitchWidget2 extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool b) onChange;
  final bool disabled;
  final String activeText;
  final String inactiveText;
  final IconData icon;
  /* ui variables */
  // final bool useSpacer;

  SwitchWidget2({
    Key key,
    @required this.label,
    @required this.onChange,
    this.icon = null,
    this.value = false,
    // this.useSpacer = true,
    this.disabled = false,
    this.activeText = 'On',
    this.inactiveText = 'Off',
  }) : super(key: key == null ? UniqueKey() : key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    List<Widget> iconChildren = [];
    if (this.icon != null) {
      iconChildren.add(Icon(icon, color: theme.accentColor));
      iconChildren.add(SizedBox(width: 20));
    }
    return ListenableProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...iconChildren,
            /* label */
            Expanded(
              child: Text(
                label,
                style: AppDecorators.getHeadLine5Style(theme: theme),
              ),
            ),

            /* spacer */
            // useSpacer ? const Spacer() : const SizedBox(width: 20.0),
            const SizedBox(width: 10.0),

            /* switch */
            Consumer<ValueNotifier<bool>>(
              builder: (_, vnValue, __) => FlutterSwitch(
                //width: activeText != 'On' ? 100 : 70.0,
                width: 50,
                height: 25,
                disabled: disabled,
                activeTextColor: theme.supportingColor,
                inactiveTextColor: theme.supportingColor.withAlpha(100),
                activeSwitchBorder: Border.all(
                  color: theme.accentColor,
                  width: 2.0,
                ),
                inactiveSwitchBorder: Border.all(
                  color: theme.supportingColor.withAlpha(100),
                  width: 2.0,
                ),
                activeColor: theme.fillInColor,
                activeToggleColor: theme.accentColor,
                inactiveColor: theme.fillInColor,
                inactiveToggleColor: theme.supportingColor.withAlpha(100),
                //showOnOff: true,
                activeText: activeText,
                inactiveText: inactiveText,
                value: vnValue.value ?? false,
                onToggle: (bool newValue) {
                  vnValue.value = newValue;
                  onChange(newValue);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
