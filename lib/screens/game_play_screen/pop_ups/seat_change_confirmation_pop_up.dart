import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class SeatChangeConfirmationPopUp {
  static void dialog(
          {BuildContext context,
          String gameCode,
          int promptSecs,
          int openedSeat}) =>
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
              height: 150,
              margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Scaffold(
                  body: _SeatChangeConfirmationPopUpWidget(
                      gameCode, promptSecs, openedSeat, () {
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
  _SeatChangeConfirmationPopUpWidget(
      this.gameCode, this.promptSecs, this.openedSeat, this.onTimerExpired);

  void _confirm(BuildContext context) async {
    /* call confirmSeatChange mutation */
    log('Player confirmed to make seat change');
    await GameService.confirmSeatChange(gameCode, openedSeat);
    Navigator.pop(context);
  }

  void _decline(BuildContext context) async {
    log('Player declined to make seat change');
    await GameService.declineSeatChange(gameCode);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'A seat is open. Do you want to change?',
            textAlign: TextAlign.center,
            style: AppStyles.titleTextStyle.copyWith(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: CountDownTextButton(
                  text: 'Confirm',
                  onTap: () => _confirm(context),
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
