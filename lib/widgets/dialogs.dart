import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'round_color_button.dart';

showErrorDialog(BuildContext context, String title, String error,
    {bool info = false}) async {
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
                    child: Text(
                      error,
                      style: AppDecorators.getSubtitle2Style(theme: theme)
                          .copyWith(color: Colors.white),
                    ),
                  ),

                  // sep
                  SizedBox(height: 15.dp),

                  Center(
                    child: RoundedColorButton(
                      onTapFunction: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: theme.accentColor,
                      textColor: theme.primaryColorWithDark(),
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

Future<bool> showPrompt(BuildContext context, String title, String message,
    {String positiveButtonText = "Ok",
    String negativeButtonText = "Cancel"}) async {
  Color titleColor = Colors.white;
  // show a popup
  final AppTheme theme = AppTheme.getTheme(context);
  return await showGeneralDialog<bool>(
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
                    child: Text(
                      message,
                      style: AppDecorators.getSubtitle2Style(theme: theme)
                          .copyWith(color: Colors.white),
                    ),
                  ),

                  // sep
                  SizedBox(height: 15.dp),

                  Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      RoundedColorButton(
                        onTapFunction: () {
                          Navigator.pop(context, true);
                        },
                        backgroundColor: theme.accentColor,
                        textColor: theme.primaryColorWithDark(),
                        text: positiveButtonText,
                      ),
                      SizedBox(width: 15.dp),
                      RoundedColorButton(
                        onTapFunction: () {
                          Navigator.pop(context, false);
                        },
                        backgroundColor: theme.accentColor,
                        textColor: theme.primaryColorWithDark(),
                        text: negativeButtonText,
                      ),
                    ]),
                  ),
                ],
              ),
            )),
      );
    },
  );
}
