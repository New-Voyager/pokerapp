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
    @required double credits,
  }) async {
    final theme = AppTheme.getTheme(context);
    String notes;
    List<bool> isSelected = [];
    isSelected.add(false);
    isSelected.add(false);
    isSelected.add(true);

    final bool ret = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          final theme = AppTheme.getTheme(context);
          TextEditingController creditsController = TextEditingController();
          TextEditingController notesController = TextEditingController();
          creditsController.text = '';

          return StatefulBuilder(builder: (context, setState) {
            String title = 'Set Credits';
            if (isSelected[0]) {
              title = 'Add Credits';
            }
            if (isSelected[1]) {
              title = 'Deduct Credits';
            }
            if (isSelected[2]) {
              title = 'Set Credits';
            }

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
                    ToggleButtons(
                      children: [
                        Icon(Icons.add,
                            size: 32,
                            color: isSelected[0]
                                ? Colors.black
                                : theme.accentColor),
                        Icon(Icons.remove,
                            size: 32,
                            color: isSelected[1]
                                ? Colors.black
                                : theme.accentColor),
                        Icon(Icons.assignment,
                            size: 32,
                            color: isSelected[2]
                                ? Colors.black
                                : theme.accentColor),
                      ],
                      isSelected: isSelected,
                      selectedColor: Colors.black,
                      fillColor: theme.accentColor,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = false;
                          }
                          isSelected[index] = true;
                        });
                      },
                    ),
                    SizedBox(height: 15.ph),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.dp,
                      ),
                    ),
                    SizedBox(height: 15.ph),
                    CardFormTextField(
                      controller: creditsController,
                      theme: theme,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      maxLength: 9,
                      hintText: 'enter value',
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
                              credits = double.parse(
                                  creditsController.text.trim() ?? '0');
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
          });
        });
    if (ret) {
      log('credits: $credits notes: $notes');
      print(credits.toString());
      print(notes);
      if (isSelected[0]) {
        // add
        await ClubInteriorService.addPlayerCredit(
            clubCode, playerUuid, credits.toDouble(), notes);
      } else if (isSelected[1]) {
        // deduct
        await ClubInteriorService.deductPlayerCredit(
            clubCode, playerUuid, credits.toDouble(), notes);
      } else if (isSelected[2]) {
        // set
        // update credits
        await ClubInteriorService.setPlayerCredit(
            clubCode, playerUuid, credits.toDouble(), notes);
      }
    }
    return ret;
  }
}
