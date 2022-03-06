import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

class NamePlateNameText extends StatelessWidget {
  final String text;

  const NamePlateNameText(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();

    final textWidget = Text(
      text,
      style: AppDecorators.getNameplateStyle(theme: theme).copyWith(
        fontSize: 11.dp,
      ),
    );

    if (text.length > 5) {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: textWidget,
      );
    }

    return textWidget;
  }
}
