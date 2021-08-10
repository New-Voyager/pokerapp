import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

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
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Text(
          dateString(date),
          style: AppDecorators.getSubtitle3Style(theme: theme),
        ),
      ),
    );
  }
}
