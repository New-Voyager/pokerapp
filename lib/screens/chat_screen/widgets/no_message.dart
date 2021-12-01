import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class NoMessageWidget extends StatelessWidget {
  final bool isHandOnly;

  NoMessageWidget({
    this.isHandOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    AppTextScreen appScreenText = getAppTextScreen("global");

    final theme = AppTheme.getTheme(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.message_rounded,
          size: 56.dp,
          color: theme.fillInColor,
        ),
        Text(
          isHandOnly
              ? appScreenText['noSharedHands']
              : appScreenText['noMessages'],
          textAlign: TextAlign.center,
          style: AppDecorators.getSubtitle3Style(theme: theme),
        )
      ],
    );
  }
}

class CircularProgressWidget extends StatelessWidget {
  CircularProgressWidget({
    this.text,
    this.showText,
    this.height,
  });
  final String text;
  final bool showText;
  final double height;
  @override
  Widget build(BuildContext context) {
    AppTextScreen appScreenText = getAppTextScreen("global");

    final theme = AppTheme.getTheme(context);
    return showText ?? true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text ?? appScreenText['loading'],
                textAlign: TextAlign.center,
                style: AppDecorators.getHeadLine4Style(theme: theme),
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  height: height ?? 32,
                  width: height ?? 32,
                  child: CircularProgressIndicator(
                    backgroundColor: theme.accentColorWithDark(),
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      theme.accentColorWithLight(),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Container(
              height: height ?? 32,
              width: height ?? 32,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                backgroundColor: theme.accentColorWithDark(),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    theme.accentColorWithLight()),
              ),
            ),
          );
  }
}
