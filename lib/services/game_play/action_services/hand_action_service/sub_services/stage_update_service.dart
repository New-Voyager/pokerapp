import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class StageUpdateService {
  StageUpdateService._();

  static void handle({
    BuildContext context,
    var data,
    String key,
  }) async {
    assert(key != null);

    // remove the updatedPot and store the pots info
    try {
      List<int> pots =
          data[key]['pots']?.map<int>((e) => int.parse(e.toString()))?.toList();

      Provider.of<TableState>(
        context,
        listen: false,
      ).updatePotChips(
        potChips: pots,
        potUpdatesChips: null,
      );
    } catch (e) {}

    // update the community cards

    if (key == 'flop') {
      var board = data[key]['board'];

      List<CardObject> cards = board
          .map<CardObject>(
            (c) => CardHelper.getCard(
              int.parse(
                c.toString(),
              ),
            ),
          )
          .toList();

      for (int i = 0; i < cards.length; i++) {
        Provider.of<TableState>(
          context,
          listen: false,
        ).addCommunityCard(cards[i]);
        await Future.delayed(AppConstants.communityCardPushDuration);
      }

      // wait for a brief moment, then flip the cards
      await Future.delayed(AppConstants.communityCardPushDuration);
      Provider.of<TableState>(
        context,
        listen: false,
      ).flipCards();
    } else {
      Provider.of<TableState>(
        context,
        listen: false,
      ).addCommunityCard(CardHelper.getCard(data[key]['${key}Card']));

      // wait for a brief moment, then flip the last card
      await Future.delayed(AppConstants.communityCardPushDuration);
      Provider.of<TableState>(
        context,
        listen: false,
      ).flipLastCard();
    }

    // wait for a brief period of time, before removing the last actions of all players
    await Future.delayed(AppConstants.userPopUpMessageHoldDuration);

    // remove all the status (last action) of all the players
    Provider.of<Players>(
      context,
      listen: false,
    ).removeAllPlayersStatus();
  }
}
