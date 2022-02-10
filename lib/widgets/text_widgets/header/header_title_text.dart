import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

class HeaderTitleText extends StatelessWidget {
  final String text;

  HeaderTitleText(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();

    return Text(
      text,
      style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
        fontSize: 10.dp,
      ),
    );
  }
}
