import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

class CardFormTextField extends StatelessWidget {
  const CardFormTextField({
    this.onChanged,
    this.controller,
    @required this.hintText,
    this.obscureText,
    this.keyboardType,
    this.radius,
  });

  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final double radius;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 5.0),
        side: BorderSide(
          color: Color(0xff878787),
          width: 1.0,
        ),
      ),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          maxLines: 1,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: AppAssets.fontFamilyLato,
            color: Colors.white,
            fontSize: 20.0,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.21),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
