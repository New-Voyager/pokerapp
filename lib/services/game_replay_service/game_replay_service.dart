import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/player_info.dart';

class GameReplayService {
  final dynamic data;
  final int playerID;
  final String gameCode;
  final int handNumber;

  GameReplayService(
    this.data, {
    this.playerID,
    this.gameCode,
    this.handNumber,
  });

  List<PlayerModel> _getPlayers(List<Player> players) => players
      .map<PlayerModel>((p) => PlayerModel(
            name: p.name,
            seatNo: p.seatNo,
            stack: p.balance.before,
            playerId: p.id,
          ))
      .toList();

  /* returns back the mapping of <seat.no-cards> */
  Map<int, List<int>> _getPlayerCards(List<Player> players) {
    Map<int, List<int>> _playerCards = {};

    /* IF I played until showdown then only show my cards */
    for (Player p in players)
      if (p.playedUntil == 'SHOW_DOWN') _playerCards[p.seatNo] = p.cards;

    return _playerCards;
  }

  List<GameReplayAction> _getActions({
    @required HandLog handLog,
    @required List<int> myCards,
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
        myCards: myCards,
        noCards: noCards,
        seatNos: seatNos,
      ),
    );

    /* pre flop */

    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.pre_flop_started,
        pots: handLog.preflopActions.pots,
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
          // startPot: handLog.flopActions.potStart,
          pots: handLog.flopActions.pots,
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
          pots: handLog.turnActions.pots,
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
          pots: handLog.riverActions.pots,
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
          boardCards: board1Cards,
        ),
      );

    return actions;
  }

  /* we parse the hand log data here, and instantiate the game reply controller */
  Future<GameReplayController> buildController() async {
    final HandLogModelNew handLog = HandLogModelNew.fromJson(data);

    final List<PlayerModel> players = _getPlayers(handLog.hand.playersInSeats);
    final List<int> seatNos = players.map((p) => p.seatNo).toList();

    final GameInfoModel gameInfoModel = GameInfoModel(
      maxPlayers: handLog.hand.maxPlayers,
      gameType: handLog.hand.gameType,
      tableStatus: null,
      status: null,
      smallBlind: handLog.hand.smallBlind.toInt(),
      bigBlind: handLog.hand.bigBlind.toInt(),
      playersInSeats: players,
    );

    final Map<int, List<int>> playerCards =
        _getPlayerCards(handLog.hand.playersInSeats);

    /* finding the current Player */
    final PlayerModel currPlayer =
        players.firstWhere((p) => p.playerId == playerID);

    final List<GameReplayAction> actions = _getActions(
      myCards: playerCards[currPlayer.seatNo],
      handLog: handLog.hand.handLog,
      noCards: handLog.hand.noCards,
      flopCards: handLog.hand.flop,
      riverCard: handLog.hand.river,
      turnCard: handLog.hand.turn,
      playerCards: playerCards,
      board1Cards: handLog.hand.boardCards,
      board2Cards: handLog.hand.boardCards2,
      isRunItTwice: handLog.hand.handLog.runItTwice,
      runItTwiceResult: handLog.hand.handLog.runItTwiceResult,
      potWinners: handLog.hand.handLog.potWinners,
      seatNos: seatNos,
    );

    final GameState gameState = GameState();
    gameState.initialize(
      gameCode: gameCode,
      gameInfo: gameInfoModel,
      currentPlayer: PlayerInfo(
        id: currPlayer.playerId,
        // FIXME: I KNOW THIS IS A BAD IDEA, BUT A TEMP FIX
        uuid: '', // THIS IS MADE EMPTY TO KNOW WE ARE IN REPLAY MODE
        name: currPlayer.name,
      ),
    );

    return GameReplayController(
      playerActionTime: handLog.hand.actionTime ?? 30,
      gameState: gameState,
      actions: actions,
    );
  }
}
