import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */
class BombPotDialog {
  /* method available to the outside */
  static Future<bool> prompt({
    @required BuildContext context,
    @required String gameCode,
  }) async {
    final theme = AppTheme.getTheme(context);
    String notes;
    List<bool> isSelected = [];
    isSelected.add(true);
    isSelected.add(false);
    isSelected.add(false);

    final bool ret = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          final theme = AppTheme.getTheme(context);
          TextEditingController creditsController = TextEditingController();
          TextEditingController notesController = TextEditingController();
          creditsController.text = '';

          return StatefulBuilder(builder: (context, setState) {
            String dialogTitle = 'Run Bomb Pot';

            String title = '';
            if (isSelected[0]) {
              title = 'Next Hand';
            }
            if (isSelected[1]) {
              title = 'Every Hand';
            }
            if (isSelected[2]) {
              title = 'Stop';
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
                    Center(
                        child: Text(
                      dialogTitle,
                    )),
                    // sep
                    SizedBox(height: 15.ph),
                    ToggleButtons(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('Off',
                                style: TextStyle(
                                    color: isSelected[0]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('Next Hand',
                                style: TextStyle(
                                    color: isSelected[1]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('Every Hand',
                                style: TextStyle(
                                    color: isSelected[2]
                                        ? Colors.black
                                        : theme.accentColor))),
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
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            text: "Apply",
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
    return ret;
  }
}
