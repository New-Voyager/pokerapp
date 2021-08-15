import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

import '../utils.dart';

class ChatDateTime extends StatelessWidget {
  final DateTime date;

  const ChatDateTime({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      child: Text(
        formatDate(date),
        style: AppDecorators.getSubtitle3Style(theme: theme),
      ),
    );
  }
}
