import 'dart:core';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';

class ReloadDialog {
  static Future<List> prompt({
    @required BuildContext context,
    double reloadMax,
    double reloadMin,
    bool decimalAllowed,
  }) async {
    List ret = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          AppTheme theme = AppTheme.getTheme(context);
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: ReloadDialogWidget(
                theme,
                reloadMax,
                reloadMin,
                decimalAllowed,
              ),
            );
          });
        });

    return ret;
  }
}

class ReloadDialogWidget extends StatefulWidget {
  final AppTheme theme;
  final double reloadMax, reloadMin;
  final bool decimalAllowed;
  ReloadDialogWidget(
    this.theme,
    this.reloadMax,
    this.reloadMin,
    this.decimalAllowed,
  );

  @override
  _ReloadDialogWidgetState createState() => _ReloadDialogWidgetState();
}

class _ReloadDialogWidgetState extends State<ReloadDialogWidget> {
  double amount = 0.0;
  bool autoReload = false;
  double belowAmt, reloadToAmt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
      decoration: AppDecorators.bgRadialGradient(widget.theme).copyWith(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.theme.accentColor, width: 3),
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Reload"),
            SizedBox(height: 10.ph),
            Row(children: [
              Text("Amount"),
              SizedBox(width: 20.pw),
              Expanded(
                child: TextInputWidget(
                  maxValue: widget.reloadMax,
                  minValue: widget.reloadMin,
                  value: amount,
                  decimalAllowed: widget.decimalAllowed,
                  onChange: (double value) {
                    amount = value;
                  },
                ),
              ),
            ]),
            SizedBox(height: 10.ph),
            SwitchWidget2(
              label: "Auto Reload",
              value: autoReload,
              onChange: (bool v) {
                setState(() {
                  autoReload = v;
                });
              },
            ),
            SizedBox(height: 10.ph),
            autoReload
                ? Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("If stack goes below"),
                            SizedBox(
                              width: 100,
                              child: TextInputWidget(
                                maxValue: widget.reloadMax,
                                minValue: widget.reloadMin,
                                value: widget.reloadMin,
                                decimalAllowed: widget.decimalAllowed,
                                onChange: (double value) {
                                  belowAmt = value;
                                },
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("Reload to"),
                            SizedBox(
                              width: 100,
                              child: TextInputWidget(
                                maxValue: widget.reloadMax,
                                minValue: widget.reloadMin,
                                value: widget.reloadMin,
                                decimalAllowed: widget.decimalAllowed,
                                onChange: (double value) {
                                  reloadToAmt = value;
                                },
                              ),
                            ),
                          ]),
                    ],
                  )
                : Container(),
            SizedBox(height: 20.ph),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* ok button */
                  RoundRectButton(
                    onTap: () async {
                      if (!autoReload && amount == 0.0) {
                        await showErrorDialog(
                            context, 'Error', 'Enter a valid amount');
                      } else {
                        Navigator.pop(context,
                            [amount, autoReload, belowAmt, reloadToAmt]);
                      }
                    },
                    text: "OK",
                    theme: widget.theme,
                  ),

                  /* divider */
                  SizedBox(width: 5.ph),

                  /* cancel button */
                  RoundRectButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                    theme: widget.theme,
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
