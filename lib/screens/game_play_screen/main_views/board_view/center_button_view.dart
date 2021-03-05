import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class CenterButtonView extends StatelessWidget {
  final String tableStatus;
  final String gameCode;
  final bool isHost;
  final Function onStartGame;

  CenterButtonView(
      {this.gameCode, this.isHost, this.tableStatus, this.onStartGame});

  void _onResumePress() {}

  void _onTerminatePress() {}

  void _onRearrangeSeatsPress() {}

  @override
  Widget build(BuildContext context) {
    if (this.tableStatus == AppConstants.GAME_PAUSED) {
      return pauseButtons(context);
    } else if (this.tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
      if (this.isHost) {
        return newGameButtons(context);
      } else {
        // other players are waiting for the game to be started
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.black.withOpacity(0.50),
          ),
          child: Text('Waiting to be started'),
        );
      }
    } else {
      return Container();
    }
  }

  Widget pauseButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withOpacity(0.50),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CustomTextButton(
            text: 'Resume',
            onTap: _onResumePress,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: CustomTextButton(
              text: 'Terminate',
              onTap: _onTerminatePress,
            ),
          ),
          CustomTextButton(
            split: true,
            text: 'Rearrange Seats',
            onTap: _onRearrangeSeatsPress,
          ),
        ],
      ),
    );
  }

  Widget newGameButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black.withOpacity(0.50),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CustomTextButton(
                  text: 'Start',
                  onTap: this.onStartGame,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black.withOpacity(0.50),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CustomTextButton(
                  text: 'Terminate',
                  onTap: _onTerminatePress,
                ),
              ],
            ),
          ),
        ],
      );

      Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withOpacity(0.50),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CustomTextButton(
            text: 'Start',
            onTap: this.onStartGame,
          ),
          SizedBox(
            width: 10,
          ),
          CustomTextButton(
            text: 'Terminate',
            onTap: _onTerminatePress,
          ),
        ],
      ),
    );
  }
}
