import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';

import 'buttons.dart';

showErrorDialog(BuildContext context, String title, String error,
    {Widget child, bool info = false}) async {
  Color titleColor = Colors.red;
  if (info) {
    titleColor = Colors.white;
  }
  // show a popup
  final AppTheme theme = AppTheme.getTheme(context);
  await showGeneralDialog(
    context: context,
    pageBuilder: (_, __, ___) {
      //final theme = AppTheme.getTheme(context);
      return Align(
        alignment: Alignment.center,
        child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(16.pw),
              padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
              decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.accentColor, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child != null
                      ? child
                      : Center(
                          child: Text(
                            title,
                            style: AppDecorators.getHeadLine3Style(theme: theme)
                                .copyWith(color: titleColor),
                          ),
                        ),
                  // sep
                  SizedBox(height: 8.dp),

                  Padding(
                    padding: EdgeInsets.all(10.dp),
                    child: Text(
                      error,
                      style: AppDecorators.getSubtitle2Style(theme: theme)
                          .copyWith(color: Colors.white),
                    ),
                  ),

                  // sep
                  SizedBox(height: 15.dp),

                  Center(
                    child: RoundRectButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      theme: theme,
                      text: "Close",
                    ),
                  ),
                ],
              ),
            )),
      );
    },
  );
}

Future<bool> showPrompt(
  BuildContext context,
  String title,
  String message, {
  String positiveButtonText = "Ok",
  String negativeButtonText = "Cancel",
  Widget child,
}) async {
  Color titleColor = Colors.white;
  // show a popup
  final AppTheme theme = AppTheme.getTheme(context);
  return await showGeneralDialog<bool>(
    context: context,
    pageBuilder: (_, __, ___) {
      //final theme = AppTheme.getTheme(context);
      return SystemPadding(
          child: Align(
        alignment: Alignment.center,
        child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(16.pw),
              padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
              decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.accentColor, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: AppDecorators.getHeadLine3Style(theme: theme)
                          .copyWith(color: titleColor),
                    ),
                  ),
                  // sep
                  SizedBox(height: 8.dp),

                  Padding(
                    padding: EdgeInsets.all(10.dp),
                    child: child == null
                        ? Text(
                            message,
                            style: AppDecorators.getSubtitle2Style(theme: theme)
                                .copyWith(color: Colors.white),
                          )
                        : child,
                  ),

                  // sep
                  SizedBox(height: 15.dp),

                  Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      RoundRectButton(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        theme: theme,
                        text: positiveButtonText,
                        positive: true,
                      ),
                      SizedBox(width: 15.dp),
                      RoundRectButton(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        theme: theme,
                        text: negativeButtonText,
                        negative: true,
                      ),
                    ]),
                  ),
                ],
              ),
            )),
      ));
    },
  );
}
