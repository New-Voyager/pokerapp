import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/club_action_screens/club_member_detailed_view/club_member_detailed_view.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:provider/provider.dart';

class CenterButtonView extends StatelessWidget {
  final bool isHost;
  final Function onStartGame;
  AppTextScreen _appScreenText;

  CenterButtonView({this.isHost, this.onStartGame});

  void _onResumePress(gameCode) {
    GameService.resumeGame(gameCode);
  }

  Future<void> _onTerminatePress(BuildContext context) async {
    final gameState = GameState.getState(context);
    log('Termininating game ${gameState.gameCode}');
    await GameService.endGame(gameState.gameCode);
    if (!gameState.isGameRunning) {
      gameState.refresh(context);
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
    await gameState.refresh(context);
    log('status: ${gameState.gameInfo.status} table status: ${gameState.gameInfo.tableStatus}');
  }

  @override
  Widget build(BuildContext context) {
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
        if (gameContext.isAdmin()) {
          log('is admin: ${gameContext.isAdmin()} isHost: ${gameContext.isHost()}');
          return pauseButtons(context);
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
          return Container();
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
          ? Center(
              child: Container(
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
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        // CustomTextButton(
                        //   adaptive: false,
                        //   text: 'Resume',
                        //   onTap: _onResumePress,
                        // ),
                        IconAndTitleWidget(
                          child: SvgPicture.asset(
                            AppAssetsNew.resumeImagePath,
                            height: 48.ph,
                            width: 48.pw,
                          ),
                          onTap: () {
                            return _onResumePress(gameState.gameCode);
                          },
                          text: _appScreenText['resume'],
                        ),

                        SizedBox(width: 15.pw),
                        IconAndTitleWidget(
                          child: SvgPicture.asset(
                            AppAssetsNew.seatChangeImagePath,
                            height: 48.ph,
                            width: 48.pw,
                          ),
                          onTap: () => _onRearrangeSeatsPress(providerContext),
                          text: _appScreenText['rearrange'],
                        ),
                        SizedBox(width: 15.pw),
                        IconAndTitleWidget(
                          child: SvgPicture.asset(
                            AppAssetsNew.terminateImagePath,
                            height: 48.ph,
                            width: 48.pw,
                          ),
                          onTap: () => _onTerminatePress(context),
                          text: _appScreenText['terminate'],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 10.0,
                        //   ),
                        //   child: CustomTextButton(
                        //     adaptive: false,
                        //     text: 'Terminate',
                        //     onTap: _onTerminatePress,
                        //   ),
                        // ),
                        // CustomTextButton(
                        //   adaptive: false,
                        //   split: true,
                        //   text: 'Rearrange Seats',
                        //   onTap: () => _onRearrangeSeatsPress(context),
                        // ),
                      ],
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
        return SizedBox.shrink();
      }

      // if this is not bot game and the player count is less than 2
      // don't allow the player to start the game
      final gameState = GameState.getState(context);
      if (!gameState.botGame && gameState.playersInSeatsCount <= 1) {
        return SizedBox.shrink();
      }

      return Center(
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
                onTap: this.onStartGame,
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
      );
    });
  }
}
