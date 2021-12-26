import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */
class CreditsSettings {
  bool addCredit;
  bool deductCredit;
  bool setCredit;
  double credits;
  bool cancelled;
  String notes = '';
  CreditsSettings() {
    addCredit = false;
    deductCredit = false;
    setCredit = false;
    credits = 0;
    cancelled = false;
  }
}

class SetCreditsDialog {
  /* method available to the outside */
  static Future<bool> prompt({
    @required BuildContext context,
    @required String clubCode,
    @required String playerUuid,
    @required double credits,
    @required String name,
  }) async {
    CreditsSettings settings = CreditsSettings();
    final bool ret = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          AppTheme theme = AppTheme.getTheme(context);
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: CreditDialogsWidget(
                theme,
                clubCode,
                playerUuid,
                credits,
                name,
                settings,
              ),
            );
          });
        });
    if (!settings.cancelled) {
      log('credits: ${settings.credits} notes: ${settings.notes}');
      print(credits.toString());
      if (settings.addCredit) {
        // add
        await ClubInteriorService.addPlayerCredit(
            clubCode, playerUuid, settings.credits.toDouble(), settings.notes);
      } else if (settings.deductCredit) {
        // deduct
        await ClubInteriorService.deductPlayerCredit(
            clubCode, playerUuid, settings.credits.toDouble(), settings.notes);
      } else if (settings.setCredit) {
        // set
        // update credits
        await ClubInteriorService.setPlayerCredit(
            clubCode, playerUuid, settings.credits.toDouble(), settings.notes);
      }
    }
    return ret;
  }
}

class CreditDialogsWidget extends StatefulWidget {
  final AppTheme theme;
  final String clubCode;
  final String playerUuid;
  final double credits;
  final String name;
  final CreditsSettings settings;

  CreditDialogsWidget(
    this.theme,
    this.clubCode,
    this.playerUuid,
    this.credits,
    this.name,
    this.settings,
  );

  @override
  State<CreditDialogsWidget> createState() => _CreditDialogsWidgetState();
}

class _CreditDialogsWidgetState extends State<CreditDialogsWidget> {
  TextEditingController creditsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String notes;
  List<bool> isSelected = [];
  double credits = 0;
  bool loadingCredits = false;
  bool closed = false;
  @override
  void initState() {
    super.initState();
    creditsController.text = '';
    isSelected.add(false);
    isSelected.add(false);
    isSelected.add(true);
    if (widget.credits == null) {
      loadingCredits = true;
      setState(() {});
      loadCredits();
    }
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  Future<void> loadCredits() async {
    await Future.delayed(Duration(seconds: 3));
    credits = await ClubsService.getAvailableCredit(
        widget.clubCode, widget.playerUuid);
    loadingCredits = false;
    if (!closed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
    Widget creditsWidget = Container();
    if (loadingCredits) {
      creditsWidget = Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: widget.theme.accentColorWithDark(),
        ),
      );
    } else {
      Color color = Colors.green;
      if (credits < 0) {
        color = Colors.red;
      }
      creditsWidget = Text(DataFormatter.chipsFormat(credits),
          style: AppDecorators.getHeadLine3Style(theme: widget.theme)
              .copyWith(color: color));
    }
    return Container(
      // height: MediaQuery.of(context).size.height * 0.5,
      // margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
      decoration: AppDecorators.bgRadialGradient(widget.theme).copyWith(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.theme.accentColor, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // sep
          SizedBox(height: 15.ph),
          Text(widget.name,
              style: AppDecorators.getHeadLine2Style(theme: widget.theme)),
          SizedBox(height: 15.ph),
          Row(children: [
            Text('Available Credits',
                style: AppDecorators.getHeadLine3Style(theme: widget.theme)),
            SizedBox(width: 10),
            creditsWidget,
          ]),
          SizedBox(height: 15.ph),
          ToggleButtons(
            children: [
              Icon(Icons.add,
                  size: 32,
                  color:
                      isSelected[0] ? Colors.black : widget.theme.accentColor),
              Icon(Icons.remove,
                  size: 32,
                  color:
                      isSelected[1] ? Colors.black : widget.theme.accentColor),
              Icon(Icons.assignment,
                  size: 32,
                  color:
                      isSelected[2] ? Colors.black : widget.theme.accentColor),
            ],
            isSelected: isSelected,
            selectedColor: Colors.black,
            fillColor: widget.theme.accentColor,
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
            theme: widget.theme,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLength: 9,
            hintText: 'enter value',
            onChanged: (val) {},
          ),

          // sep
          SizedBox(height: 15.ph),

          CardFormTextField(
            controller: notesController,
            theme: widget.theme,
            keyboardType: TextInputType.text,
            hintText: 'Enter Notes',
            maxLines: 2,
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
                    widget.settings.cancelled = true;
                  },
                  text: "Close",
                  theme: widget.theme,
                ),

                /* divider */
                SizedBox(width: 10.ph),

                /* true button */
                RoundRectButton(
                  onTap: () {
                    credits =
                        double.parse(creditsController.text.trim() ?? '0');
                    notes = notesController.text;
                    widget.settings.cancelled = false;
                    widget.settings.notes = notesController.text;

                    widget.settings.credits = credits;
                    if (isSelected[0]) {
                      // add
                      widget.settings.addCredit = true;
                      widget.settings.credits = credits;
                    } else if (isSelected[1]) {
                      // deduct
                      widget.settings.deductCredit = true;
                    } else if (isSelected[2]) {
                      // set
                      // update credits
                      widget.settings.setCredit = true;
                    }
                    Navigator.pop(
                      context,
                      true,
                    );
                  },
                  text: "Save",
                  theme: widget.theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
