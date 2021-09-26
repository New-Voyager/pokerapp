import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
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
    if (action == HandActions.SB ||
        action == HandActions.BB ||
        action == HandActions.POST_BLIND ||
        action == HandActions.BET ||
        action == HandActions.CALL ||
        action == HandActions.CHECK ||
        action == HandActions.RAISE ||
        action == HandActions.FOLD ||
        action == HandActions.ALLIN ||
        action == HandActions.STRADDLE ||
        action == HandActions.BOMB_POT_BET) {
      actionStr = action.toString().replaceAll('HandActions.', '');
    }

    if (seat.player.inBreak) {
      actionStr = "In Break";
    }

    if (action == HandActions.POST_BLIND) {
      actionStr = 'Blind';
    }

    if (action == HandActions.BOMB_POT_BET) {
      actionStr = 'Bomb Pot';
    }

    // decide color from the status message
    // raise, bet -> red
    // check, call -> green
    return actionStr == ''
        ? shrinkedSizedBox
        : ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '  ' + actionStr + '  ',
                  style: getStatusTextStyle(actionStr),
                ),
                Visibility(
                  visible: seat.player.action.action == HandActions.ALLIN,
                  child: Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/images/game/flame.png',
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
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
    return AppStylesNew.userPopUpMessageTextStyle.copyWith(
        fontSize: 10.dp, color: fgColor, backgroundColor: statusColor);
  }
}
