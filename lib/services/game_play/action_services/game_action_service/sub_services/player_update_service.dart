import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:provider/provider.dart';

class PlayerUpdateService {
  PlayerUpdateService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    var playerUpdate = data['playerUpdate'];

    int seatNo = playerUpdate['seatNo'];
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    // if seatNo if not to be found in the existing players array, then get the new PLayer using the GameInfo Api
    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);
    if (idx == -1) {
      // fetch new player using GameInfo API and add to the game
      GameInfoModel _gameInfoModel = await GameService.getGameInfo(
        data['gameCode'],
      );

      List<PlayerModel> playerModels = _gameInfoModel.playersInSeats;
      PlayerModel newPlayerModel = playerModels.firstWhere(
        (pm) => pm.seatNo == seatNo,
        orElse: () => null,
      ); // this must return a PLayerModel object

      // put the status of the fetched player
      newPlayerModel?.status = playerUpdate['status'];

      assert(newPlayerModel != null);

      Provider.of<Players>(
        context,
        listen: false,
      ).addNewPlayer(newPlayerModel);

      // if the newPlayer has 0 stack then prompt for buyin
      if (newPlayerModel.stack == 0)
        Provider.of<ValueNotifier<FooterStatus>>(
          context,
          listen: false,
        ).value = FooterStatus.Prompt;
    } else {
      // the player at "idx" th index is updated
      /* new stack value / buyIn amount / change in status*/

      PlayerModel updatedPlayer = players.players[idx];
      updatedPlayer.update(
        stack: playerUpdate['stack'],
        buyIn: playerUpdate['buyIn'],
        showBuyIn: true,
        status: null,
      );

      Provider.of<Players>(
        context,
        listen: false,
      ).updateExistingPlayer(
        idx,
        updatedPlayer,
      );

      // wait for "AppConstants.userPopUpMessageHoldDuration" showing the BUYIN amount
      // after that remove the buyIn amount information
      await Future.delayed(AppConstants.userPopUpMessageHoldDuration);

      updatedPlayer.update(
        stack: playerUpdate['stack'],
        showBuyIn: false,
        status: null,
      );

      Provider.of<Players>(
        context,
        listen: false,
      ).updateExistingPlayer(
        idx,
        updatedPlayer,
      );
    }
  }
}
