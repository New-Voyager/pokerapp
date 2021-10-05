import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class CardFormTextField extends StatelessWidget {
  const CardFormTextField({
    this.theme,
    this.color = Colors.transparent,
    this.onChanged,
    this.controller,
    @required this.hintText,
    this.obscureText,
    this.keyboardType,
    this.radius,
    this.elevation = 10.0,
    this.validator,
    this.onSaved,
    this.inputFormatters,
    this.hintColor,
    this.maxLines,
  });
  final Color hintColor;
  final AppTheme theme;
  final Function onSaved;
  final List<TextInputFormatter> inputFormatters;
  final Function validator;
  final double elevation;
  final Color color;
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final double radius;
  final Function onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 5.0),
        side: BorderSide(
          color: theme.accentColorWithDark(0.30),
          width: 1.0,
        ),
      ),
      elevation: elevation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.pw, vertical: 5.ph),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          controller: controller,
          maxLines: maxLines ?? 1,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          style: TextStyle(
            color: theme.supportingColor,
            fontSize: 12.dp,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: hintColor ?? theme.supportingColor.withAlpha(100),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
