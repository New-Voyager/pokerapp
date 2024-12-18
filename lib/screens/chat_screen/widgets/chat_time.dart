import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../utils.dart';

class ChatTimeWidget extends StatelessWidget {
  final bool isSender;
  final DateTime date;

  const ChatTimeWidget({
    Key key,
    this.isSender,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3, bottom: 3),
        child: Text(
          dateString(date),
          style: AppDecorators.getSubtitle3Style(theme: theme).copyWith(
            fontSize: 6.dp,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
