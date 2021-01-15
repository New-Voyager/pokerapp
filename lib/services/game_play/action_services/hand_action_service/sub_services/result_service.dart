import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:provider/provider.dart';

class ResultService {
  ResultService._();

  /* seat-no, value mapping */
  static Map<int, int> _getUpdatedStack(var data) {
    Map<int, int> stacks = Map<int, int>();

    var players = data['handResult']['players'];
    players.forEach(
        (key, p) => stacks[int.parse(key.toString())] = p['balance']['after']);

    return stacks;
  }

  /* seat-no, list of cards mapping */
  static Map<int, List<int>> _getCards(var data) {
    var players = data['handResult']['players'];

    Map<int, List<int>> seatNoCardsMap = Map<int, List<int>>();
    players.forEach((seatNo, d) =>
        seatNoCardsMap[int.parse(seatNo.toString())] =
            d['cards']?.map<int>((e) => int.parse(e.toString()))?.toList());

    return seatNoCardsMap;
  }

  /* get back the board cards that needs to be highlighted */
  static List<int> _getBoardCards(var data) {
    var boardCards = data['handResult']['handLog']['potWinners']['0']
        ['hiWinners'][0]['boardCards'];

    return boardCards.map<int>((c) => int.parse(c.toString())).toList();
  }

  /* get back the player cards that needs to be highlighted */
  static Map<String, dynamic> _getPlayerData(var data) {
    var hiWinner =
        data['handResult']['handLog']['potWinners']['0']['hiWinners'][0];

    int seatNo = hiWinner['seatNo'];
    var playerCards = hiWinner['playerCards'];

    return {
      'seatNo': seatNo,
      'playerCards':
          playerCards.map<int>((c) => int.parse(c.toString())).toList(),
    };
  }

  static void handle({
    BuildContext context,
    var data,
  }) {
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    /* remove all highlight - silently */
    players.removeAllHighlights();

    /* footer status -> showing the result */
    /* set the footer result data */
    List<HiWinnersModel> winners = Provider.of<FooterResult>(
      context,
      listen: false,
    ).updateWinners(
      data['handResult']['handLog']['potWinners'],
    );

    // get the winner seat No and highlight the winner
    winners.forEach((winner) {
      // highlight the winner seat No
      players.highlightWinner(winner.seatNo);
    });

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    /* players remove last status and markers */
    players.removeAllPlayersStatus();

    players.removeMarkersFromAllPlayer();

    /* showdown time, show other players cards */
    players.updateUserCards(_getCards(data));

    /* highlight cards of players and community cards for winner */
    Provider.of<TableState>(
      context,
      listen: false,
    ).highlightCards(_getBoardCards(data));

    Map<String, dynamic> playerData = _getPlayerData(data);

    players.highlightCards(
      seatNo: playerData['seatNo'],
      cards: playerData['playerCards'],
    );

    /* update stack of every player after showing the reverse pot chip animation */
    for (HiWinnersModel winner in winners) {
      int idx = players.players.indexWhere(
        (player) => player.seatNo == winner.seatNo,
      );

      if (idx != -1) {
        players.updateCoinAmount(idx, winner.amount);
        players.moveCoinsFromPot(idx, winner.amount);
      }
    }

    // wait for the animation to finish, then update the stack
    Future.delayed(AppConstants.animationDuration).then(
      (_) => players.updateStackBulk(_getUpdatedStack(data)),
    );
  }
}
