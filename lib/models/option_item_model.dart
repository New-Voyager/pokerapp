import 'package:flutter/material.dart';

class OptionItemModel {
  String name;
  String image;
  IconData iconData;
  String title;
  Function ontap;
  Color backGroundColor;
  OptionItemModel(
      {this.image,
      this.name,
      this.iconData,
      this.title,
      this.ontap,
      this.backGroundColor});
}
