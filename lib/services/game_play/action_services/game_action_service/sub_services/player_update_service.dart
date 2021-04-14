import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
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
    final status = playerUpdate['status'];
    final newUpdate = playerUpdate['newUpdate'];

    // fixme: this is until all the player update messages have a newUpdate field
    if (player == null) {
      return ;
    }
    //   return handleNewPlayer(
    //     context: context,
    //     playerUpdate: playerUpdate,
    //   );
    // }
    
    bool showBuyIn = false;
    if (status == AppConstants.PLAYING) {
      showBuyIn = false;
    }

    if (newUpdate == AppConstants.NEW_BUYIN) {
      log('Player ${player.name} new buy in');
      showBuyIn = false;
    }

    if (status == AppConstants.WAIT_FOR_BUYIN ||
        status == AppConstants.NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL) {
      showBuyIn = true;
    }

    player.update(
      stack: playerUpdate['stack'],
      buyIn: playerUpdate['buyIn'],
      showBuyIn: showBuyIn,
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

    // update my state to remove buyin button 
    if (player.isMe) {
      final myState = gameState.getMyState(context);
      myState.notify();
    }
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

      gameState.myState.status = PlayerStatus.WAIT_FOR_BUYIN_APPROVAL;
      gameState.myState.notify();
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
    final seat = gameState.getSeat(context, seatNo);
    if (seat != null && seat.player != null) {
      // update my state to update widgets around my seat
      if (seat.player.isMe) {
        final myState = gameState.getMyState(context);
        myState.notify();
      }
    }

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
    final seat = gameState.getSeat(context, seatNo);
    if(seat != null && seat.player != null && seat.player.isMe) {
      gameState.myState.status = PlayerStatus.NOT_PLAYING;
      gameState.myState.notify();
    }

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


  static void handlePlayerWaitForBuyinApproval({
    @required BuildContext context,
    @required var playerUpdate,
  }) {
    final GameState gameState = GameState.getState(context);
    int seatNo = playerUpdate['seatNo'];
    final seat = gameState.getSeat(context, seatNo);

    if(seat.player.isMe) {
      gameState.myState.status = PlayerStatus.WAIT_FOR_BUYIN_APPROVAL;
      gameState.myState.notify();
    }

    seat.player.waitForBuyInApproval = true;
    seat.notify();
    log('Player ${seat.player.name} is waiting for approval');
    final tableState = gameState.getTableState(context);
    tableState.notifyAll();
  }

  static void handlePlayerBuyinDenied({
    @required BuildContext context,
    @required var playerUpdate,
  }) {
    final GameState gameState = GameState.getState(context);
    int seatNo = playerUpdate['seatNo'];
    final seat = gameState.getSeat(context, seatNo);
    log('Buyin is denied');
    final players = gameState.getPlayers(context);
    players.removePlayerSilent(seatNo);
    bool isMe = false;
    if(seat.player.isMe) {
      isMe = true;
    }
    seat.player = null;
    seat.notify();

    if (isMe) {
      final myState = gameState.getMyState(context);
      myState.notify();

      showAlertDialog(context, "BuyIn Request", "The host denied the buyin request");      
    }
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

      case AppConstants.NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL:
      case AppConstants.WAIT_FOR_BUYIN_APPROVAL:
        return handlePlayerWaitForBuyinApproval(
          context: context,
          playerUpdate: playerUpdate,
        );
      case AppConstants.BUYIN_DENIED:
        return handlePlayerBuyinDenied(
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
