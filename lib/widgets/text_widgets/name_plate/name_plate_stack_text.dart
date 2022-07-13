import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';

class NamePlateStackText extends StatelessWidget {
  final double stack;

  const NamePlateStackText(this.stack);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();

    return Text(
      DataFormatter.chipsFormat(stack),
      style: AppDecorators.getNameplateStyle(theme: theme).copyWith(
        fontSize: 10.dp,
        color: theme.accentColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
