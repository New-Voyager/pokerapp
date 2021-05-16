import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/player_info.dart';

class GameReplayService {
  GameReplayService._();

  static List<PlayerModel> _getPlayers(List<Player> players) => players
      .map<PlayerModel>((p) => PlayerModel(
            name: p.name,
            seatNo: p.seatNo,
            stack: p.balance.before,
          ))
      .toList();

  /* returns back the mapping of <seat.no-cards> */
  static Map<int, List<int>> _getPlayerCards(List<Player> players) {
    Map<int, List<int>> _playerCards = {};
    for (Player p in players) _playerCards[p.seatNo] = p.cards;
    return _playerCards;
  }

  static List<GameReplayAction> _getActions({
    @required HandLog handLog,
    @required int noCards,
    @required List<int> flopCards,
    @required int turnCard,
    @required int riverCard,
    @required Map<int, List<int>> playerCards,
    @required List<int> board1Cards,
    @required List<int> board2Cards,
    @required bool isRunItTwice,
    @required dynamic runItTwiceResult,
    @required Map<String, PotWinner> potWinners,
    @required List<int> seatNos,
  }) {
    final List<GameReplayAction> actions = [];

    /* card distribution */
    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.card_distribution,
        noCards: noCards,
        seatNos: seatNos,
      ),
    );

    /* pre flop */

    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.pre_flop_started,
        startPot: handLog.preflopActions.potStart,
      ),
    );

    /* add player actions */
    actions.addAll(
      handLog.preflopActions.actions
          .map<GameReplayAction>((ActionElement action) => GameReplayAction(
                gameReplayActionType: GameReplayActionType.player_action,
                action: action,
              ))
          .toList(),
    );

    /* flop actions */

    final List<GameReplayAction> flopActions = handLog.flopActions.actions
        .map<GameReplayAction>((ActionElement action) => GameReplayAction(
              gameReplayActionType: GameReplayActionType.player_action,
              action: action,
            ))
        .toList();

    if (flopActions.isNotEmpty) {
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.flop_started,
          startPot: handLog.flopActions.potStart,
          boardCards: flopCards,
        ),
      );

      actions.addAll(flopActions);
    }

    /* turn actions */
    final List<GameReplayAction> turnActions = handLog.turnActions.actions
        .map<GameReplayAction>((ActionElement action) => GameReplayAction(
              gameReplayActionType: GameReplayActionType.player_action,
              action: action,
            ))
        .toList();

    if (turnActions.isNotEmpty) {
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.turn_started,
          startPot: handLog.turnActions.potStart,
          boardCard: turnCard,
        ),
      );

      actions.addAll(turnActions);
    }

    /* river actions */
    final List<GameReplayAction> riverActions = handLog.riverActions.actions
        .map<GameReplayAction>((ActionElement action) => GameReplayAction(
              gameReplayActionType: GameReplayActionType.player_action,
              action: action,
            ))
        .toList();

    if (riverActions.isNotEmpty) {
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.river_started,
          startPot: handLog.riverActions.potStart,
          boardCard: riverCard,
        ),
      );

      /* add player actions */
      actions.addAll(riverActions);
    }

    /* showdown -> show the cards of all the players */

    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.showdown,
        playerCards: playerCards,
      ),
    );

    /* if run it twice case, we need to show the animation for the board cards */
    if (isRunItTwice)
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.run_it_twice_board,
          boardCards: board1Cards,
          boardCards2: board2Cards,
        ),
      );

    /* declare winner */
    /* if run it twice is true -> show run it twice result */
    /* else show the regular pot winner result */

    if (isRunItTwice)
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.run_it_twice_winner,
          runItTwiceResult: runItTwiceResult,
          boardCards: board1Cards,
          boardCards2: board2Cards,
        ),
      );
    else
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.pot_winner,
          potWinners: potWinners,
        ),
      );

    return actions;
  }

  /* we parse the hand log data here, and instantiate the game reply controller */
  static Future<GameReplayController> buildController(dynamic data) async {
    final HandLogModelNew handLog = HandLogModelNew.fromJson(data);

    final List<PlayerModel> players = _getPlayers(handLog.hand.playersInSeats);
    final List<int> seatNos = players.map((p) => p.seatNo).toList();

    final GameInfoModel gameInfoModel = GameInfoModel(
      // FIXME: WE WOULD NEED THE MAX PLAYER INFORMATION IN HANDLOG
      maxPlayers: handLog.hand.maxPlayers,
      gameType: handLog.hand.gameType,
      tableStatus: null,
      status: null,
      smallBlind: handLog.hand.smallBlind.toInt(), // fixme: we need this data
      bigBlind: handLog.hand.bigBlind.toInt(), // fixme: we need this data
      playersInSeats: players,
    );

    final List<GameReplayAction> actions = _getActions(
      handLog: handLog.hand.handLog,
      noCards: handLog.hand.noCards,
      flopCards: handLog.hand.flop,
      riverCard: handLog.hand.river,
      turnCard: handLog.hand.turn,
      playerCards: _getPlayerCards(handLog.hand.playersInSeats),
      board1Cards: handLog.hand.boardCards,
      board2Cards: handLog.hand.boardCards2,
      isRunItTwice: handLog.hand.handLog.runItTwice,
      runItTwiceResult: handLog.hand.handLog.runItTwiceResult,
      potWinners: handLog.hand.handLog.potWinners,
      seatNos: seatNos,
    );

    final GameState gameState = GameState();
    gameState.initialize(
      // todo: take care of game code
      gameCode: 'gameCode',
      gameInfo: gameInfoModel,
      currentPlayer: PlayerInfo(
        id: handLog.myInfo.id,
        uuid: handLog.myInfo.uuid,
        name: handLog.myInfo.name,
      ),
    );

    return GameReplayController(
      gameState: gameState,
      actions: actions,
    );
  }
}
