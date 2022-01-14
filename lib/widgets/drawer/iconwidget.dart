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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            svgIconPath,
            width: 30,
            height: 30,
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
        ],
      ),
    );
  }
}
