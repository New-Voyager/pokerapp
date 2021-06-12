import 'dart:developer';

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

  void _onTerminatePress() {
    log('Termininating game $gameCode');
    GameService.endGame(gameCode);
  }

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
    final seatChange = Provider.of<SeatChangeNotifier>(context, listen: true);
    final gameContext = Provider.of<GameContextObject>(context, listen: false);
    if (this.gameStatus == AppConstants.GAME_PAUSED) {
      if (!seatChange.seatChangeInProgress) {
        if (gameContext.isAdmin()) {
          log('is admin: ${gameContext.isAdmin()} isHost: ${gameContext.isHost()}');
          return pauseButtons(context);
        } else {
          return Center(
              child: Text(
            'Game Paused',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ));
        }
      } else {
        return Center(
            child: Text(
          'Seat Change in Progress',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ));
      }
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
    final gameContext = Provider.of<GameContextObject>(context, listen: false);
    log('is admin: ${gameContext.isAdmin()} isHost: ${gameContext.isHost()}');

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
                      adaptive: false,
                      text: 'Resume',
                      onTap: _onResumePress,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: CustomTextButton(
                        adaptive: false,
                        text: 'Terminate',
                        onTap: _onTerminatePress,
                      ),
                    ),
                    CustomTextButton(
                      adaptive: false,
                      split: true,
                      text: 'Rearrange Seats',
                      onTap: () => _onRearrangeSeatsPress(context),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  Widget newGameButtons(BuildContext context) {
    return Consumer<GameContextObject>(builder: (context, gameContext, _) {
      if (!gameContext.isAdmin()) {
        return Container();
      }
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
    });
  }
}
