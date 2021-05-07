import 'package:flutter/material.dart';
import 'package:pokerapp/services/app/util_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:timer_count_down/timer_count_down.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */

class RunItTwiceDialog extends StatelessWidget {
  /* method available to the outside */
  static Future<void> promptRunItTwice(BuildContext context) async {
    /* show the dialog */
    final bool runItTwice = await showDialog<bool>(
      context: context,
      builder: (_) => RunItTwiceDialog(),
    );

    final String playerAction =
        runItTwice ? 'RUN_IT_TWICE_YES' : 'RUN_IT_TWICE_NO';

    if (playerAction == null) return;

    /* if we are in testing mode just return from this function */
    if (TestService.isTesting)
      return print('run it twice prompt response: $playerAction');

    /* send the player action, as PLAYER_ACTED message: RUN_IT_TWICE_YES or RUN_IT_TWICE_NO */
    HandActionService.takeAction(
      context: context,
      action: playerAction,
    );
  }

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* show count down timer */
              Countdown(
                seconds: 30,
                onFinished: () => Navigator.pop(context),
                build: (_, timeLeft) {
                  return Text(
                    DataFormatter.timeFormatMMSS(timeLeft),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                    ),
                  );
                },
              ),

              /* divider */
              const SizedBox(height: 20.0),

              /* main body */
              Text(
                'Run it twice?',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),

              /* divider */
              const SizedBox(height: 20.0),

              /* yes / no button */
              Row(
                children: [
                  /* no button */
                  Expanded(
                    child: ElevatedButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(
                        context,
                        false,
                      ),
                    ),
                  ),

                  /* divider */
                  const SizedBox(width: 10.0),

                  /* true button */
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Yes'),
                      onPressed: () => Navigator.pop(
                        context,
                        true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
