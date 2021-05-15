import 'package:flutter/foundation.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';

enum GameReplayActionType {
  card_distribution,
  pre_flop_started,
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

  /* the start pot holds the value of pot before the round begins */
  final int startPot;

  /* action contains the acted player's action */
  final ActionElement action;

  /* community cards - flop cards, turn card or river card */
  final List<int> boardCards;
  final List<int> board2Cards;
  final int boardCard;

  /* for show down & run it twice result / pot winners */
  final Map<int, List<int>> playerCards;

  /* result data */
  final Map<String, PotWinner> potWinners;
  final dynamic runItTwiceWinners;

  GameReplayAction({
    @required this.gameReplayActionType,
    this.startPot,
    this.action,
    this.boardCards,
    this.board2Cards,
    this.boardCard,
    this.playerCards,
    this.potWinners,
    this.runItTwiceWinners,
  }) : assert(gameReplayActionType != null);
}
