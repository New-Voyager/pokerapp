import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/club_member_detailed_view.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class CenterButtonView extends StatelessWidget {
  final bool isHost;
  final Function onStartGame;
  AppTextScreen _appScreenText;

  CenterButtonView({this.isHost, this.onStartGame});

  void _onResumePress(BuildContext context, gameCode) {
    GameService.resumeGame(gameCode);

    // redraw the top section
    final gameState = GameState.getState(context);
    gameState.redrawBoard();
  }

  Future<void> _onTerminatePress(BuildContext context) async {
    final response = await showPrompt(
        context, 'End Game', "Do you want to end the game?",
        positiveButtonText: 'Yes', negativeButtonText: 'No');
    if (response != null && response == true) {
      final gameState = GameState.getState(context);
      log('Termininating game ${gameState.gameCode}');
      await GameService.endGame(gameState.gameCode);
      if (gameState.uiClosing) {
        return;
      }
      if (appState != null) {
        appState.setGameEnded(true);
      }
      if (!gameState.isGameRunning) {
        gameState.refresh();
      }
    }
  }

  void _onRearrangeSeatsPress(context) async {
    GameContextObject gameContextObject = Provider.of<GameContextObject>(
      context,
      listen: false,
    );
    final gameState = GameState.getState(context);

    Alerts.showNotification(
        titleText: _appScreenText['game'],
        svgPath: AppAssetsNew.seatChangeImagePath,
        subTitleText: _appScreenText['movePlayerDescription'],
        duration: Duration(seconds: 30));

    Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    )
      ..updateSeatChangeHost(gameContextObject.playerId)
      ..updateSeatChangeInProgress(true);
    await SeatChangeService.hostSeatChangeBegin(gameState.gameCode);
    gameState.hostSeatChangeInProgress = true;

    await gameState.refresh();
    gameState.redrawFooter();
    log('status: ${gameState.gameInfo.status} table status: ${gameState.gameInfo.tableStatus}');
  }

  @override
  Widget build(BuildContext context) {
    // log('Center: Center buttons build');
    _appScreenText = getAppTextScreen("centerButtonView");

    final seatChange = Provider.of<SeatChangeNotifier>(context, listen: false);
    final gameContext = Provider.of<GameContextObject>(context, listen: false);
    final gameState = GameState.getState(context);
    final tableState = gameState.tableState;
    log('Seat Change: seat change in progress: ${gameState.playerSeatChangeInProgress} gameRunning: ${gameState.isGameRunning}');
    if (gameState.playerSeatChangeInProgress ||
        gameState.gameInfo.tableStatus ==
            AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      return Center(
          child: Text(
        '${_appScreenText['seatChangeInProgress']}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.dp,
          fontWeight: FontWeight.w600,
        ),
      ));
    }

    if (tableState.gameStatus == AppConstants.GAME_PAUSED) {
      if (!seatChange.seatChangeInProgress) {
        if (gameContext.isHost()) {
          log('is admin: ${gameContext.isAdmin()} isHost: ${gameContext.isHost()}');
          // return pauseButtons(context);
          return Container();
        } else {
          return Center(
              child: Text(
            _appScreenText['gamePaused'],
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
          _appScreenText['seatChangeInProgress'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ));
      }
    } else if (tableState.gameStatus == AppConstants.GAME_CONFIGURED ||
        tableState.tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
      if (this.isHost) {
        if (!gameState.isGameRunning) {
          debugLog(gameState.gameCode, 'Showing start/terminate buttons');
          return newGameButtons(context);
        } else {
          return const SizedBox.shrink();
        }
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
          child: Text(_appScreenText['waitingToBeStarted']),
        );
      }
    } else {
      debugLog(gameState.gameCode, "No center buttons");
      return Container();
    }
  }

  Widget pauseButtons(BuildContext context) {
    final gameContext = Provider.of<GameContextObject>(context, listen: false);
    final gameState = GameState.getState(context);
    log('is admin: ${gameContext.isAdmin()} isHost: ${gameContext.isHost()}');
    final providerContext = context;
    return Consumer<GameContextObject>(
      builder: (context, gameContext, _) => gameContext.isAdmin()
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: AppStylesNew.resumeBgDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      _appScreenText['gamePaused'],
                      style: AppStylesNew.cardHeaderTextStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Resume Button
                      IconAndTitleWidget(
                        child: SvgPicture.asset(
                          AppAssetsNew.resumeImagePath,
                          height: 48.ph,
                          width: 48.pw,
                        ),
                        onTap: () {
                          _onResumePress(context, gameState.gameCode);
                        },
                        text: _appScreenText['resume'],
                      ),

                      // Rearrange Button
                      IconAndTitleWidget(
                        child: SvgPicture.asset(
                          AppAssetsNew.seatChangeImagePath,
                          height: 48.ph,
                          width: 48.pw,
                        ),
                        onTap: () {
                          _onRearrangeSeatsPress(providerContext);
                        },
                        text: _appScreenText['rearrange'],
                      ),

                      // Terminate Button
                      IconAndTitleWidget(
                        child: SvgPicture.asset(
                          AppAssetsNew.terminateImagePath,
                          height: 48.ph,
                          width: 48.pw,
                        ),
                        onTap: () {
                          _onTerminatePress(context);
                        },
                        text: _appScreenText['terminate'],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  Widget newGameButtons(BuildContext context) {
    return Consumer<GameContextObject>(builder: (context, gameContext, _) {
      if (!gameContext.isHost()) {
        return SizedBox.shrink();
      }

      return Center(
        child: DebugBorderWidget(
          color: Colors.blue,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            decoration: AppStylesNew.resumeBgDecoration,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                IconAndTitleWidget(
                  child: SvgPicture.asset(
                    AppAssetsNew.resumeImagePath,
                    height: 48.ph,
                    width: 48.pw,
                  ),
                  onTap: () {
                    // log('Center: Starting the game ${gameState.gameCode}');
                    this.onStartGame();
                  },
                  text: _appScreenText['start'],
                ),
                IconAndTitleWidget(
                  child: SvgPicture.asset(
                    AppAssetsNew.terminateImagePath,
                    height: 48.ph,
                    width: 48.pw,
                  ),
                  onTap: () => _onTerminatePress(context),
                  text: _appScreenText['terminate'],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
