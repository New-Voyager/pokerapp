import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/widgets/drawer/wudgets.dart';

class Actions4Widget extends StatelessWidget {
  final AppTextScreen text;
  const Actions4Widget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidgetTile(
          svgIconPath: AppAssetsNew.statisticsImagePath,
          title: text["queue"],
        ),
        IconWidgetTile(
          svgIconPath: AppAssetsNew.statisticsImagePath,
          title: text['seatChange'],
        ),
      ],
    );
  }
}
