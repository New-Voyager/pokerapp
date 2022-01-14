import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

class IconWidgetTile extends StatelessWidget {
  final String svgIconPath;
  final String title;
  const IconWidgetTile(
      {Key key, @required this.svgIconPath, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.getTheme(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(
        svgIconPath,
        width: 24,
        height: 24,
      ),
      title: Text(
        title,
        style: AppDecorators.getHeadLine5Style(theme: theme),
      ),
    );
  }
}
