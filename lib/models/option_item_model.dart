import 'package:flutter/material.dart';

class OptionItemModel {
  String name;
  String image;
  IconData iconData;
  String title;
  Function onTap;
  Color backGroundColor;
  OptionItemModel(
      {this.image,
      this.name,
      this.iconData,
      this.title,
      this.onTap,
      this.backGroundColor});
}
