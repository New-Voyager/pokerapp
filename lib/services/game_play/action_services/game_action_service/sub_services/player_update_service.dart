import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:provider/provider.dart';

class PlayerUpdateService {
  PlayerUpdateService._();

  static void updatePlayer({
    @required BuildContext context,
    @required var playerUpdate,
  }) async {
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];
    final player = gameState.fromSeat(context, seatNo);

    // fixme: this is until all the player update messages have a newUpdate field
    if (player == null) {
      return handleNewPlayer(
        context: context,
        playerUpdate: playerUpdate,
      );
    }

    player.update(
      stack: playerUpdate['stack'],
      buyIn: playerUpdate['buyIn'],
      showBuyIn: true,
      status: null,
    );
    final seat = gameState.getSeat(context, seatNo);
    seat.notify();

    // wait for "AppConstants.userPopUpMessageHoldDuration" showing the BUY-IN amount
    // after that remove the buyIn amount information
    await Future.delayed(AppConstants.userPopUpMessageHoldDuration);

    player.update(
      stack: playerUpdate['stack'],
      showBuyIn: false,
      status: null,
    );
    seat.notify();
  }

  static void handleNewPlayer({
    @required BuildContext context,
    @required var playerUpdate,
  }) async {
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];
    // fetch new player using GameInfo API and add to the game
    GameInfoModel _gameInfoModel = await GameService.getGameInfo(
      Provider.of<GameContextObject>(
        context,
        listen: false,
      ).gameCode,
    );

    assert(_gameInfoModel != null);

    List<PlayerModel> playerModels = _gameInfoModel.playersInSeats;
    PlayerModel newPlayerModel = playerModels.firstWhere(
      (pm) => pm.seatNo == seatNo,
      orElse: () => null,
    ); // this must return a PLayerModel object

    assert(newPlayerModel != null);

    // put the status of the fetched player
    newPlayerModel?.status = playerUpdate['status'];

    if (newPlayerModel.playerUuid == gameState.currentPlayerUuid) {
      newPlayerModel.isMe = true;
    }
    gameState.newPlayer(context, newPlayerModel);

    if (newPlayerModel.stack == 0) {
      newPlayerModel.showBuyIn = true;
    }

    if (newPlayerModel.isMe) {
      await Future.delayed(Duration(milliseconds: 100));
      final mySeat = gameState.mySeat(context);
      mySeat.player = newPlayerModel;
      mySeat.notify();
    }
    final tableState = gameState.getTableState(context);
    tableState.notifyAll();
    gameState.updatePlayers(context);
  }

  static void handlePlayerLeftGame({
    @required BuildContext context,
    @required var playerUpdate,
  }) {
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];
    gameState.removePlayer(context, seatNo);
    gameState.updatePlayers(context);
  }

  static void handlePlayerNotPlaying({
    @required BuildContext context,
    @required var playerUpdate,
  }) {
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];
    gameState.removePlayer(context, seatNo);
    gameState.updatePlayers(context);
  }

  static void handlePlayerBuyinTimedout({
    @required BuildContext context,
    @required var playerUpdate,
  }) {
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];
    gameState.removePlayer(context, seatNo);
    gameState.updatePlayers(context);
    gameState.markOpenSeat(context, seatNo);
    final tableState = gameState.getTableState(context);
    tableState.notifyAll();
  }

  static void handlePlayerSwitchSeat({
    @required BuildContext context,
    @required var playerUpdate,
  }) async {
    int newSeatNo = playerUpdate['seatNo'] as int;
    int oldSeatNo = playerUpdate['oldSeat'] as int;
    int stack = playerUpdate['stack'] as int;

    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    final player1 = gameState.fromSeat(context, oldSeatNo);
    if (player1 == null) {
      return;
    }

    player1.seatNo = newSeatNo;

    if (gameInfo.status == 'CONFIGURED' &&
        gameInfo.tableStatus == 'WAITING_TO_BE_STARTED') {
      // switch seat for the player
      final oldSeat = gameState.getSeat(context, oldSeatNo);
      oldSeat.player = null;
      gameState.refresh(context);
      // final newSeat = gameState.getSeat(context, oldSeatNo);
      // oldSeat.player = null;

    } else {
      final ValueNotifier<SeatChangeModel> vnSeatChangeModel =
          Provider.of<ValueNotifier<SeatChangeModel>>(
        context,
        listen: false,
      );

      /* animate the stack */
      vnSeatChangeModel.value = SeatChangeModel(
        newSeatNo: newSeatNo,
        oldSeatNo: oldSeatNo,
        stack: stack,
      );

      /* wait for the seat change animation to finish */
      await Future.delayed(AppConstants.seatChangeAnimationDuration);

      /* remove the animating widget */
      vnSeatChangeModel.value = null;
    }
    gameState.updatePlayers(context);
  }

  static void handle({
    BuildContext context,
    var data,
  }) {
    var playerUpdate = data['playerUpdate'];
    String newUpdate = playerUpdate['newUpdate'];

    switch (newUpdate) {
      case AppConstants.NEW_PLAYER:
        return handleNewPlayer(
          context: context,
          playerUpdate: playerUpdate,
        );

      case AppConstants.LEFT_THE_GAME:
        return handlePlayerLeftGame(
          context: context,
          playerUpdate: playerUpdate,
        );

      case AppConstants.SWITCH_SEAT:
        return handlePlayerSwitchSeat(
          context: context,
          playerUpdate: playerUpdate,
        );

      case AppConstants.NOT_PLAYING:
        return handlePlayerNotPlaying(
          context: context,
          playerUpdate: playerUpdate,
        );

      case AppConstants.BUYIN_TIMEDOUT:
        return handlePlayerBuyinTimedout(
          context: context,
          playerUpdate: playerUpdate,
        );

      default:
        return updatePlayer(
          context: context,
          playerUpdate: playerUpdate,
        );
    }
  }
}
