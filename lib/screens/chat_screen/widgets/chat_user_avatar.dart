import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

import '../../../utils/color_generator.dart';

class ChatUserAvatar extends StatelessWidget {
  final String avatarLink;
  final String name;
  final String userId;

  const ChatUserAvatar({
    Key key,
    this.avatarLink,
    this.name,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: generateColorFor(userId),
        child: Text(
          name[0].toUpperCase(),
          style: AppDecorators.getHeadLine3Style(theme: theme),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
