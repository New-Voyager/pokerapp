import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import 'package:flutter_rounded_date_picker/src/dialogs/flutter_rounded_date_picker_dialog.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';

class CustomCupertinoDatePicker {
  static showPicker(BuildContext context,
      {@required DateTime minimumDate,
      @required DateTime maximumDate,
      @required DateTime initialDate,
      @required String title,
      @required AppTheme theme}) async {
    log('minimum date: ${minimumDate.toIso8601String()} maximum date: ${maximumDate.toIso8601String()}');
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        var selectedDate = initialDate;
        return Material(
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Brightness.dark,
            ),
            child: Container(
              decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.accentColor, width: 3),
              ),
              padding: EdgeInsets.all(8.pw),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppDecorators.getHeadLine2Style(
                      theme: theme,
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: FlutterRoundedDatePickerDialog(
                      initialDate: initialDate,
                      lastDate: maximumDate,
                      firstDate: minimumDate,
                      // maximumYear: maximumDate.year,

                      // minimumYear: minimumDate.year,

                      borderRadius: 10,
                      era: EraMode.CHRIST_YEAR,
                      initialDatePickerMode: DatePickerMode.day,
                    ),
                  ),
                  RoundRectButton(
                      onTap: () {
                        Navigator.of(context).pop(selectedDate);
                      },
                      text: "OK",
                      theme: theme),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
