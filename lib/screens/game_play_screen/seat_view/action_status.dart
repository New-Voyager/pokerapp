import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/app_styles.dart';

import 'animating_widgets/stack_switch_seat_animating_widget.dart';

class ActionStatusWidget extends StatelessWidget {
  final Seat seat;
  final Alignment alignment;

  ActionStatusWidget(this.seat, this.alignment);

  @override
  Widget build(BuildContext context) {
    /* The status message is not shown, if
    * 1. The seat is empty - nothing to show
    * 2. The current user is to act - the current user is highlighted */
    if (seat.isOpen || seat.player.highlight) return shrinkedSizedBox;

    //String action;
    //seat.player.status = "CHECK";
    final action = seat.player.action.action;
    String actionStr = '';
    if (action == HandActions.BET ||
        action == HandActions.CALL ||
        action == HandActions.CHECK ||
        action == HandActions.RAISE ||
        action == HandActions.FOLD ||
        action == HandActions.ALLIN ||
        action == HandActions.STRADDLE) {
      actionStr = action.toString().replaceAll('HandActions.', '');
    }
    // decide color from the status message
    // raise, bet -> red
    // check, call -> green
    return actionStr == ''
        ? shrinkedSizedBox
        : ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Text(
              '  ' + actionStr + '  ',
              style: getStatusTextStyle(actionStr),
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
