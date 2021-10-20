import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/general_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'buttons.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */
class RunItTwiceDialog {
  /* method available to the outside */
  static Future<void> promptRunItTwice({
    @required BuildContext context,
    int expTime = 30,
  }) async {
    final bool runItTwice = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
                // width: MediaQuery.of(context).size.width * 0.70,
                // height: 200.ph,
                decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.accentColor, width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /* show count down timer */
                    Countdown(
                      seconds: expTime,
                      onFinished: () {
                        Navigator.pop(context);
                      },
                      build: (_, timeLeft) {
                        return Text(
                          DataFormatter.timeFormatMMSS(timeLeft),
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.dp,
                          ),
                        );
                      },
                    ),

                    // sep
                    SizedBox(height: 15.ph),
                    Text(
                      'Do you want to run it twice?',
                      style: TextStyle(
                        fontSize: 16.dp,
                      ),
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
                            },
                            text: "No",
                            theme: theme,
                            icon: Icon(
                              Icons.cancel,
                              color: theme.accentColor,
                            ),
                          ),

                          /* divider */
                          const SizedBox(width: 10.0),

                          /* true button */
                          RoundRectButton(
                            onTap: () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            text: "Yes",
                            theme: theme,
                            icon: Icon(
                              Icons.check,
                              color: theme.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );

    String playerAction = AppConstants.RUN_IT_TWICE_NO;
    if (runItTwice != null && runItTwice) {
      playerAction = AppConstants.RUN_IT_TWICE_YES;
    }

    /* if we are in testing mode just return from this function */
    if (TestService.isTesting) {
      return;
    }

    final gameContextObj = context.read<GameContextObject>();
    final gameState = context.read<GameState>();
    /* send the player action, as PLAYER_ACTED message: RUN_IT_TWICE_YES or RUN_IT_TWICE_NO */
    HandActionProtoService.takeAction(
      gameState: gameState,
      gameContextObject: gameContextObj,
      action: playerAction,
    );
  }
}
