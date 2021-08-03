import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/widgets/general_dialog_widget.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */

class RunItTwiceDialog {
  /* method available to the outside */
  static Future<void> promptRunItTwice({
    @required BuildContext context,
    int expTime = 30,
  }) async {
    /* show the dialog */
    final bool runItTwice = await GeneralDialogWidget.show<bool>(
      context: context,
      dismissible: false,
      expTimeInSecs: expTime,
      body: Text(
        'Do you want to run it twice?',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
      acceptButtonText: 'Yes',
      declineButtonText: 'No',
      onAccept: () => Navigator.pop(
        context,
        true,
      ),
      onDecline: () => Navigator.pop(
        context,
        false,
      ),
      onTimerFinished: (BuildContext context) => Navigator.pop(context),
    );

    if (runItTwice == null) return;

    final String playerAction = runItTwice
        ? AppConstants.RUN_IT_TWICE_YES
        : AppConstants.RUN_IT_TWICE_NO;

    /* if we are in testing mode just return from this function */
    if (TestService.isTesting)
      return print('run it twice prompt response: $playerAction');

    /* send the player action, as PLAYER_ACTED message: RUN_IT_TWICE_YES or RUN_IT_TWICE_NO */
    HandActionProtoService.takeAction(
      context: context,
      action: playerAction,
    );
  }
}
