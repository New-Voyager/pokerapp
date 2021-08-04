import 'package:flutter/material.dart';

class AppDecorators {
  AppDecorators._();

  static getBorderStyle({
    Color color = Colors.black,
    double radius = 10.0,
  }) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: color,
        ),
      );
}
