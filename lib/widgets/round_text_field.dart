import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class RoundTextField extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final Function onChanged;

  RoundTextField({
    @required this.hintText,
    @required this.iconData,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsNew.cardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            100.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData ?? Icons.info,
            size: 30.0,
            color: AppColorsNew.contentColor,
          ),
          border: InputBorder.none,
          hintText: hintText ?? 'Hint Text',
          hintStyle: TextStyle(
            color: AppColorsNew.contentColor,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }
}
