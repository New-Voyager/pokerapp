import 'dart:core';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';

class ReloadOptions {
  bool autoReload = false;
  double stackBelowAmount = null;
  double stackReloadTo = null;
}

class ReloadDialog {
  static Future<ReloadOptions> prompt({
    @required BuildContext context,
    bool autoReload,
    double reloadThreshold,
    double reloadTo,
    double reloadMax,
    double reloadMin,
    bool decimalAllowed,
  }) async {
    final ret = await showDialog<ReloadOptions>(
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
                autoReload,
                reloadThreshold,
                reloadTo,
                reloadMax,
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
  final double reloadMax;
  final bool decimalAllowed;
  final bool autoReload;
  final double reloadThreshold;
  final double reloadTo;
  ReloadDialogWidget(
    this.theme,
    this.autoReload,
    this.reloadThreshold,
    this.reloadTo,
    this.reloadMax,
    this.decimalAllowed,
  );

  @override
  _ReloadDialogWidgetState createState() => _ReloadDialogWidgetState();
}

class _ReloadDialogWidgetState extends State<ReloadDialogWidget> {
  bool autoReload = false;
  double belowAmt, reloadToAmt;

  @override
  void initState() {
    belowAmt = widget.reloadThreshold;
    reloadToAmt = widget.reloadTo;
    autoReload = widget.autoReload;
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
                                minValue: 1,
                                value: belowAmt,
                                decimalAllowed: widget.decimalAllowed,
                                onChange: (double value) {
                                  belowAmt = value;
                                  setState(() {});
                                },
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(width: 30),
                            Text("reload to"),
                            SizedBox(
                              width: 100,
                              child: TextInputWidget(
                                maxValue: widget.reloadMax,
                                minValue: belowAmt,
                                value: reloadToAmt,
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
                      ReloadOptions options = ReloadOptions();
                      options.autoReload = autoReload;
                      options.stackBelowAmount = belowAmt;
                      options.stackReloadTo = reloadToAmt;
                      Navigator.pop(context, options);
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
