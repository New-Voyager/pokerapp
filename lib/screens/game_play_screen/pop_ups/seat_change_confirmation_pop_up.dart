import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class SeatChangeConfirmationPopUp {
  static void dialog(
          {BuildContext context,
          String gameCode,
          int promptSecs,
          int openedSeat,
          List<int> openSeats}) =>
      showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200.ph,
              width: 350.pw,
              margin: EdgeInsets.only(bottom: 50.ph, left: 12.pw, right: 12.pw),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40.pw),
                border: Border.all(color: AppColorsNew.dialogBorderColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.pw),
                child: Scaffold(
                  body: _SeatChangeConfirmationPopUpWidget(
                      gameCode, promptSecs, openedSeat, openSeats, () {
                    Navigator.pop(context);
                  }),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
}

class _SeatChangeConfirmationPopUpWidget extends StatelessWidget {
  final String gameCode;
  final int promptSecs;
  final Function onTimerExpired;
  final int openedSeat;
  final List<int> openSeats;
  _SeatChangeConfirmationPopUpWidget(this.gameCode, this.promptSecs,
      this.openedSeat, this.openSeats, this.onTimerExpired);

  void _confirm(BuildContext context, int selectedSeat) async {
    /* call confirmSeatChange mutation */
    log('Player confirmed to make seat change');
    await GameService.confirmSeatChange(gameCode, selectedSeat);
    Navigator.pop(context);
  }

  void _decline(BuildContext context) async {
    log('Player declined to make seat change');
    await GameService.declineSeatChange(gameCode);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    log('Seat Change: open seats: $openSeats');
    String title = 'A seat is open. Select a seat to switch.';
    if (this.openSeats.length > 1) {
      title =
          '${this.openSeats.length} seats are open. Select a seat to switch.';
    }
    int selectedSeat = this.openSeats[0];
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10.dp,
      fontWeight: FontWeight.normal,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle, //AppStylesNew.dialogTextStyle,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Center(
              child: RadioListWidget(
            defaultValue: selectedSeat,
            values: this.openSeats,
            onSelect: (int value) {
              selectedSeat = value;
            },
          )),
          Row(
            children: [
              Expanded(
                child: CountDownTextButton(
                  text: 'Confirm',
                  onTap: () {
                    log('Seat change: Selected seat: $selectedSeat');
                    _confirm(context, selectedSeat);
                  },
                  time: promptSecs,
                  onTimerExpired: onTimerExpired,
                ),
              ),
              Expanded(
                child: CustomTextButton(
                  text: 'Decline',
                  onTap: () => _decline(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
