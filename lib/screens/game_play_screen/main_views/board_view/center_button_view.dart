import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class CenterButtonView extends StatelessWidget {
  final String tableStatus;
  final String gameStatus;
  final String gameCode;
  final bool isHost;
  final Function onStartGame;

  CenterButtonView(
      {this.gameCode,
      this.isHost,
      this.gameStatus,
      this.tableStatus,
      this.onStartGame});

  void _onResumePress() {
    GameService.resumeGame(gameCode);
  }

  void _onTerminatePress() {}

  void _onRearrangeSeatsPress(context) {
    GameContextObject gameContextObject = Provider.of<GameContextObject>(
      context,
      listen: false,
    );
    Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    )
      ..updateSeatChangeHost(gameContextObject.playerId)
      ..updateSeatChangeInProgress(true);

    SeatChangeService.hostSeatChangeBegin(gameCode);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Viren, please fix this correctly
    final seatChange = Provider.of<SeatChangeNotifier>(context, listen: true);
    if (this.gameStatus == AppConstants.GAME_PAUSED &&
        !seatChange.seatChangeInProgress) {
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
    return Consumer<GameContextObject>(
      builder: (context, gameContext, _) => gameContext.isAdmin()
          ? Center(
              child: Container(
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
                      onTap: () => _onRearrangeSeatsPress(context),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 50,
              width: 50,
              color: Colors.red,
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
  }
}
