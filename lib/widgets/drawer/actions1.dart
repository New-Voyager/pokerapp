import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/widgets/drawer/wudgets.dart';

class Actions1Widget extends StatelessWidget {
  final AppTextScreen text;
  Actions1Widget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidgetTile(
          svgIconPath: AppAssetsNew.statisticsImagePath,
          title: text['standup'],
        ),
        IconWidgetTile(
          svgIconPath: AppAssetsNew.statisticsImagePath,
          title: text['break'],
        ),
        IconWidgetTile(
          svgIconPath: AppAssetsNew.statisticsImagePath,
          title: text['reload'],
        ),
      ],
    );
  }
}
