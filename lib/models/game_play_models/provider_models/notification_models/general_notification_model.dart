import 'package:flutter/material.dart';

class GeneralNotificationModel {
  String titleText;
  String subTitleText;
  Widget leadingWidget;
  Widget trailingWidget;

  GeneralNotificationModel({
    @required this.titleText,
    @required this.subTitleText,
    this.leadingWidget,
    this.trailingWidget,
  });
}
