import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/widgets/texts.dart';

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
        width: 20,
        height: 20,
        color: theme.accentColor,
      );
    } else if (this.icon != null) {
      icon = Icon(this.icon, size: 20, color: theme.accentColor);
    }

    Widget child = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
              width: 30,
              height: 30,
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
