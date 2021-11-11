import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */
class SetCreditsDialog {
  /* method available to the outside */
  static Future<bool> prompt({
    @required BuildContext context,
    @required String clubCode,
    @required String playerUuid,
    @required int credits,
  }) async {
    final theme = AppTheme.getTheme(context);
    String notes;
    final bool ret = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        TextEditingController creditsController = TextEditingController();
        TextEditingController notesController = TextEditingController();
        creditsController.text = '$credits';
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
                  'Set Credits',
                  style: TextStyle(
                    fontSize: 16.dp,
                  ),
                ),
                SizedBox(height: 15.ph),
                CardFormTextField(
                  controller: creditsController,
                  theme: theme,
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  hintText: 'Set credits',
                  onChanged: (val) {},
                ),

                // sep
                SizedBox(height: 15.ph),

                CardFormTextField(
                  controller: notesController,
                  theme: theme,
                  keyboardType: TextInputType.text,
                  hintText: 'Enter Notes',
                  maxLines: 3,
                  maxLength: 200,
                  showCharacterCounter: true,
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
                          credits = int.parse(creditsController.text ?? '0');
                          notes = notesController.text;
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
    if (ret) {
      log('credits: $credits notes: $notes');
      print(credits.toString());
      print(notes);
      // update credits
      await ClubInteriorService.setPlayerCredit(
          clubCode, playerUuid, credits.toDouble(), notes);
    }
    return ret;
  }
}
