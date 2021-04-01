import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'animating_widgets/stack_switch_seat_animating_widget.dart';

class DisplayCardsWidget extends StatelessWidget {
  final Seat seat;

  DisplayCardsWidget(this.seat);

  @override
  Widget build(BuildContext context) {
    /* The status message is not shown, if
    * 1. The seat is empty - nothing to show
    * 2. The current user is to act - the current user is highlighted */
    if (seat.isOpen || seat.player.highlight) return shrinkedSizedBox;

    String status;

    if (seat.player?.status != null && seat.player.status.isNotEmpty)
      status = seat.player.status;

    if (seat.player?.status == AppConstants.WAIT_FOR_BUYIN)
      // SOMA: disabled showing status
      //status = 'Waiting for Buy In';
      status = null;

    //if (seat.player.buyIn != null) status = 'Buy In ${seat.player.buyIn} amount';

    if (seat.player?.status == AppConstants.PLAYING) status = null;

    // decide color from the status message
    // raise, bet -> red
    // check, call -> green

    return AnimatedSwitcher(
      duration: AppConstants.popUpAnimationDuration,
      reverseDuration: AppConstants.popUpAnimationDuration,
      switchInCurve: Curves.bounceInOut,
      switchOutCurve: Curves.bounceInOut,
      transitionBuilder: (widget, animation) => ScaleTransition(
        alignment: Alignment.topCenter,
        scale: animation,
        child: widget,
      ),
      child: status == null
          ? shrinkedSizedBox
          : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Text(
                status,
                style: getStatusTextStyle(status),
              ),
            ),
    );     
  }


  static TextStyle getStatusTextStyle(String status) {
    Color statusColor = Colors.black; // default color be black
    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }

    Color fgColor = Colors.white;
    return AppStyles.userPopUpMessageTextStyle
        .copyWith(fontSize: 10, color: fgColor, backgroundColor: statusColor);
  }  
}
