import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

class HeaderGameCodeText extends StatelessWidget {
  final String text1;
  final String text2;

  HeaderGameCodeText(this.text1, this.text2);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();

    return RichText(
      text: TextSpan(
        text: text1,
        style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 10.dp,
        ),
        children: [
          TextSpan(
            text: text2,
            style: AppDecorators.getAccentTextStyle(theme: theme).copyWith(
              fontSize: 10.dp,
            ),
          )
        ],
      ),
    );
  }
}
