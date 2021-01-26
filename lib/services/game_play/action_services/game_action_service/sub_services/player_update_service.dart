import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:provider/provider.dart';

class PlayerUpdateService {
  PlayerUpdateService._();

  static void updatePlayer({
    @required BuildContext context,
    @required var playerUpdate,
  }) async {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];

    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);

    // fixme: this is until all the player update messages have a newUpdate field
    if (idx == -1)
      return handleNewPlayer(
        context: context,
        playerUpdate: playerUpdate,
      );

    PlayerModel updatedPlayer = players.players[idx];

    updatedPlayer.update(
      stack: playerUpdate['stack'],
      buyIn: playerUpdate['buyIn'],
      showBuyIn: true,
      status: null,
    );

    players.updateExistingPlayerSilent(
      idx,
      updatedPlayer,
    );
    players.notifyAll();

    // wait for "AppConstants.userPopUpMessageHoldDuration" showing the BUY-IN amount
    // after that remove the buyIn amount information
    await Future.delayed(AppConstants.userPopUpMessageHoldDuration);

    updatedPlayer.update(
      stack: playerUpdate['stack'],
      showBuyIn: false,
      status: null,
    );

    players.updateExistingPlayerSilent(
      idx,
      updatedPlayer,
    );
    players.notifyAll();
  }

  static void handleNewPlayer({
    @required BuildContext context,
    @required var playerUpdate,
  }) async {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int seatNo = playerUpdate['seatNo'];

    // fetch new player using GameInfo API and add to the game
    GameInfoModel _gameInfoModel = await GameService.getGameInfo(
      Provider.of<HeaderObject>(
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

    players.addNewPlayerSilent(newPlayerModel);

    // if the newPlayer has 0 stack and is me then prompt for buy-in
    if (newPlayerModel.stack == 0)
      Provider.of<ValueNotifier<FooterStatus>>(
        context,
        listen: false,
      ).value = FooterStatus.Prompt;

    players.notifyAll();
  }

  static void handlePlayerLeftGame({
    @required BuildContext context,
    @required var playerUpdate,
  }) {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    // fixme: remove 6
    int seatNo = playerUpdate['seatNo'] ?? 6;

    players.removePlayerSilent(seatNo);
    players.notifyAll();
  }

  static void handlePlayerSwitchSeat({
    @required BuildContext context,
    @required var playerUpdate,
  }) {}

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

      default:
        return updatePlayer(
          context: context,
          playerUpdate: playerUpdate,
        );
    }
  }
}
