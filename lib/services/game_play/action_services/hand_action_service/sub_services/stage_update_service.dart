import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class StageUpdateService {
  StageUpdateService._();

  static void handle({
    BuildContext context,
    var data,
    String key,
  }) {
    assert(key != null);

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

    Provider.of<TableState>(
      context,
      listen: false,
    ).updateCommunityCards(cards);

    // remove all the status (last action) of all the players
    Provider.of<Players>(
      context,
      listen: false,
    ).removeAllPlayersStatus();
  }
}
