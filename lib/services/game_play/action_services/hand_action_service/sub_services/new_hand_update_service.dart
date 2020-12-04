import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:provider/provider.dart';

class NewHandUpdateService {
  NewHandUpdateService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    /* data contains the dealer, small blind and big blind seat Positions
    * Update the Players object with these information */

    var newHand = data['newHand'];

    // there are seat nos
    int dealerPos = newHand['buttonPos'];
    int sbPos = newHand['sbPos'];
    int bbPos = newHand['bbPos'];

    // get the players list
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    /* marking the small blind */
    int smallBlindIdx = players.players.indexWhere((p) => p.seatNo == sbPos);
    assert(smallBlindIdx != -1);
    Provider.of<Players>(
      context,
      listen: false,
    ).updatePlayerTypeInSilent(
      smallBlindIdx,
      PlayerType.SmallBlind,
    );

    /* marking the dealer */
    int bigBlindIdx = players.players.indexWhere((p) => p.seatNo == bbPos);
    assert(bigBlindIdx != -1);
    Provider.of<Players>(
      context,
      listen: false,
    ).updatePlayerType(
      bigBlindIdx,
      PlayerType.BigBlind,
    );

    /* marking the dealer */
    int dealerIdx = players.players.indexWhere((p) => p.seatNo == dealerPos);
    assert(dealerIdx != -1);
    Provider.of<Players>(
      context,
      listen: false,
    ).updatePlayerType(
      dealerIdx,
      PlayerType.Dealer,
    );
  }
}
