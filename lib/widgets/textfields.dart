import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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

class CardFormTextField extends StatelessWidget {
  const CardFormTextField(
      {this.theme,
      this.color = Colors.white12,
      this.onChanged,
      this.controller,
      @required this.hintText,
      this.obscureText,
      this.keyboardType,
      this.radius,
      this.elevation = 0.0,
      this.validator,
      this.onSaved,
      this.inputFormatters,
      this.hintColor,
      this.maxLines,
      this.maxLength,
      this.showCharacterCounter = false,
      this.onTap});
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
  final Function onTap;
  final int maxLines;
  final int maxLength;
  final bool showCharacterCounter;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 5.0),
        side: BorderSide(
          color: theme.accentColor,
          width: 1.0,
        ),
      ),
      elevation: elevation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.pw, vertical: 1.ph),
        child: TextFormField(
          onTap: onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          controller: controller,
          maxLines: maxLines ?? 1,
          maxLength: maxLength ?? null,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          style: TextStyle(
            color: theme.supportingColor,
            fontSize: 10.dp,
          ),
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintColor ?? theme.supportingColor.withAlpha(100),
              ),
              border: InputBorder.none,
              counterText: showCharacterCounter ? null : ""),
        ),
      ),
    );
  }
}
