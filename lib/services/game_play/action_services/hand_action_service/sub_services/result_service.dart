import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
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

  static void handle({
    BuildContext context,
    var data,
  }) {
    /* update stack of every player - silently (i.e. without notifying the listeners) */
    Provider.of<Players>(
      context,
      listen: false,
    ).updateStackSilent(_getUpdatedStack(data));

    /* footer status -> showing the result */
    /* set the footer result data */
    Provider.of<FooterResult>(
      context,
      listen: false,
    ).updateWinners(
      data['handResult']['handLog']['potWinners'],
    );

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    /* players remove last status and markers */
    Provider.of<Players>(
      context,
      listen: false,
    ).removeAllPlayersStatus();
    Provider.of<Players>(
      context,
      listen: false,
    ).removeMarkersFromAllPlayer();

    /* showdown time, show other players cards */
    Provider.of<Players>(
      context,
      listen: false,
    ).updateUserCards(_getCards(data));

    /* highlight cards of players and community cards for winner */
  }
}
