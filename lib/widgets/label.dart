import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

class Label extends StatelessWidget {
  final String label;
  final AppTheme theme;
  Label(this.label, this.theme);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: EdgeInsets.all(2.0),
      decoration: ShapeDecoration(
        color: theme.accentColorWithDark(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
      ),
      child: Center(
          child: Text(label,
              style: AppDecorators.getHeadLine6Style(theme: theme))),
    );
  }
}
