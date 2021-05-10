import 'package:flutter/material.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:timer_count_down/timer_count_down.dart';

class GeneralDialogWidget extends StatelessWidget {
  final int expTimeInSecs;
  final Widget body;
  final String acceptButtonText;
  final String declineButtonText;
  final Function onAccept;
  final Function onDecline;
  final Function onTimerFinished;

  GeneralDialogWidget({
    this.expTimeInSecs,
    this.body,
    this.acceptButtonText,
    this.declineButtonText,
    void this.onAccept(),
    void this.onDecline(),
    void this.onTimerFinished(BuildContext _),
  });

  static Future<T> show<T>({
    @required BuildContext context,
    bool dismissible = true,
    int expTimeInSecs = 30,
    Widget body = const SizedBox.shrink(),
    String acceptButtonText = 'Yes',
    String declineButtonText = 'No',
    void Function() onAccept,
    void Function() onDecline,
    void Function(BuildContext) onTimerFinished,
  }) =>
      showDialog<T>(
        context: context,
        barrierDismissible: dismissible,
        builder: (_) => GeneralDialogWidget(
          expTimeInSecs: expTimeInSecs,
          body: body,
          acceptButtonText: acceptButtonText,
          declineButtonText: declineButtonText,
          onAccept: onAccept,
          onDecline: onDecline,
          onTimerFinished: onTimerFinished,
        ),
      );

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* show count down timer */
              Countdown(
                seconds: this.expTimeInSecs,
                onFinished: () => onTimerFinished?.call(context),
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
              body,

              /* divider */
              const SizedBox(height: 20.0),

              /* yes / no button */
              Row(
                children: [
                  /* no button */
                  Expanded(
                    child: ElevatedButton(
                      child: Text(declineButtonText),
                      onPressed: onDecline,
                    ),
                  ),

                  /* divider */
                  const SizedBox(width: 10.0),

                  /* true button */
                  Expanded(
                    child: ElevatedButton(
                      child: Text(acceptButtonText),
                      onPressed: onAccept,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
