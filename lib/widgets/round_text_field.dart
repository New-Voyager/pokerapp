import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/resources/app_colors.dart';

class RoundTextField extends StatelessWidget {
  final String hintText;
  final IconData iconData;

  RoundTextField({
    @required this.hintText,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData ?? Icons.info,
            size: 30.0,
            color: AppColors.contentColor,
          ),
          border: InputBorder.none,
          hintText: hintText ?? 'Hint Text',
          hintStyle: TextStyle(
            color: AppColors.contentColor,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }
}
