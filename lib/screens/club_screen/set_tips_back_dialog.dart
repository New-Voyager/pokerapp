import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/textfields.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */
class SetTipsBackDialog {
  /* method available to the outside */
  static Future<int> prompt({
    @required BuildContext context,
    @required String clubCode,
    @required String playerUuid,
    @required int tipsBack,
    String title,
  }) async {
    final theme = AppTheme.getTheme(context);
    String notes;
    final bool ret = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        TextEditingController tipsBackController = TextEditingController();
        tipsBackController.text = '$tipsBack';
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            // height: MediaQuery.of(context).size.height * 0.5,
            // margin: EdgeInsets.all(16),
            padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
            decoration: AppDecorators.bgRadialGradient(theme).copyWith(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.accentColor, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // sep
                SizedBox(height: 15.ph),
                Text(
                  title != null ? title : 'Set Fee Credits',
                  style: TextStyle(
                    fontSize: 16.dp,
                  ),
                ),
                SizedBox(height: 15.ph),
                CardFormTextField(
                  controller: tipsBackController,
                  theme: theme,
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  hintText: title != null ? title : 'Set Fee Credits',
                  onChanged: (val) {},
                ),

                // sep
                SizedBox(height: 15.ph),

                /* yes / no button */
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* no button */
                      RoundRectButton(
                        onTap: () {
                          Navigator.pop(
                            context,
                            false,
                          );
                        },
                        text: "Close",
                        theme: theme,
                      ),

                      /* divider */
                      SizedBox(width: 10.ph),

                      /* true button */
                      RoundRectButton(
                        onTap: () {
                          tipsBack = int.parse(tipsBackController.text ?? '0');
                          Navigator.pop(
                            context,
                            true,
                          );
                        },
                        text: "Save",
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return tipsBack;
  }
}
