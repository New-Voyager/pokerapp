import 'package:flutter/foundation.dart';
import 'package:pokerapp/models/handlog_model.dart';

enum GameReplayActionType {
  card_distribution,
  pre_flop_started,
  player_to_act,
  player_action,
  flop_started,
  river_started,
  turn_started,
  showdown,
  run_it_twice_board,
  pot_winner,
  run_it_twice_winner,
}

class GameReplayAction {
  /* this contains the action type */
  final GameReplayActionType gameReplayActionType;

  /* game related info */
  final List<int> myCards; // current players cards ; used in distribution
  final int noCards;
  final List<int> seatNos;

  /* the start pot holds the value of pot before the round begins */
  final int startPot;
  final List<int> pots;

  /* action contains the acted player's action */
  final ActionElement action;

  /* community cards - flop cards, turn card or river card */
  final List<int> boardCards;
  final List<int> boardCards2;
  final int boardCard;

  /* for show down & run it twice result / pot winners */
  final Map<int, List<int>> playerCards;

  /* result data */
  final HandResultNew result;

  GameReplayAction({
    @required this.gameReplayActionType,
    this.myCards,
    this.noCards,
    this.startPot,
    this.pots,
    this.action,
    this.boardCards,
    this.boardCards2,
    this.boardCard,
    this.playerCards,
    this.result,
    this.seatNos,
  }) : assert(gameReplayActionType != null);
}
