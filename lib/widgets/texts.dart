import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

class WrapText extends StatelessWidget {
  final AppTheme theme;
  final String text;
  final bool wrap;
  final TextStyle style;

  WrapText(this.text, this.theme, {
      this.wrap = true,
      this.style,
    });
  @override
  Widget build(BuildContext context) {
    TextStyle style = this.style;
    if (style == null) {
      style = AppDecorators.getHeadLine3Style(theme: this.theme);
    }
    String text = this.text.replaceAll(' ', '\n');
    return Text(text, style: style,);
  }

}