import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/player_info.dart';

class GameReplayService {
  final HandResultData data;
  final int playerID;
  final String gameCode;
  final int handNumber;

  GameReplayService(
    this.data, {
    this.playerID,
    this.gameCode,
    this.handNumber,
  });

  List<PlayerModel> _getPlayers(Map<int, ResultPlayerInfo> players) {
    List<PlayerModel> playerModels = [];

    players.forEach((key, playerInfo) {
      playerModels.add(
        PlayerModel(
          name: playerInfo.name,
          seatNo: key,
          stack: playerInfo.balance.before.toInt(),
          playerId: playerInfo.id,
        ),
      );
    });

    return playerModels;
  }

  /* returns back the mapping of <seat.no-cards> */
  Map<int, List<int>> _getPlayerCards(
    Map<int, ResultPlayerInfo> players,
    int myID,
  ) {
    Map<int, List<int>> _playerCards = {};

    /* IF I played until showdown then only show my cards */
    players.forEach((seatNo, p) {
      if (p.playedUntil == 'SHOW_DOWN' || p.id == myID)
        _playerCards[seatNo] = p.cards;
    });

    return _playerCards;
  }

  List<GameReplayAction> _getActions({
    @required GameActions preflopActions,
    @required GameActions flopActions,
    @required GameActions turnActions,
    @required GameActions riverActions,
    @required List<int> myCards,
    @required int noCards,
    @required List<int> flopCards,
    @required int turnCard,
    @required int riverCard,
    @required Map<int, List<int>> playerCards,
    @required List<int> board1Cards,
    @required List<int> board2Cards,
    @required bool isRunItTwice,
    @required HandResultNew result,
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
        pots: preflopActions.pots,
      ),
    );

    /* add player actions */
    actions.addAll(
      preflopActions.actions
          .map<GameReplayAction>((ActionElement action) => GameReplayAction(
                gameReplayActionType: GameReplayActionType.player_action,
                action: action,
              ))
          .toList(),
    );

    /* flop actions */

    final List<GameReplayAction> flopActionsList = flopActions.actions
        .map<GameReplayAction>((ActionElement action) => GameReplayAction(
              gameReplayActionType: GameReplayActionType.player_action,
              action: action,
            ))
        .toList();

    if (flopActionsList.isNotEmpty) {
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.flop_started,
          // startPot: handLog.flopActions.potStart,
          pots: flopActions.pots,
          boardCards: flopCards,
        ),
      );

      actions.addAll(flopActionsList);
    }

    /* turn actions */
    final List<GameReplayAction> turnActionsList = turnActions.actions
        .map<GameReplayAction>((ActionElement action) => GameReplayAction(
              gameReplayActionType: GameReplayActionType.player_action,
              action: action,
            ))
        .toList();

    if (turnActionsList.isNotEmpty) {
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.turn_started,
          pots: turnActions.pots,
          boardCard: turnCard,
        ),
      );

      actions.addAll(turnActionsList);
    }

    /* river actions */
    final List<GameReplayAction> riverActionsList = riverActions.actions
        .map<GameReplayAction>((ActionElement action) => GameReplayAction(
              gameReplayActionType: GameReplayActionType.player_action,
              action: action,
            ))
        .toList();

    if (riverActionsList.isNotEmpty) {
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.river_started,
          pots: riverActions.pots,
          boardCard: riverCard,
        ),
      );

      /* add player actions */
      actions.addAll(riverActionsList);
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

    if (isRunItTwice)
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.run_it_twice_winner,
          result: result,
          boardCards: board1Cards,
          boardCards2: board2Cards,
        ),
      );
    else
      actions.add(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.pot_winner,
          result: result,
          boardCards: board1Cards,
        ),
      );

    return actions;
  }

  /* we parse the hand log data here, and instantiate the game reply controller */
  Future<GameReplayController> buildController() async {
    final List<PlayerModel> players = _getPlayers(data.result.playerInfo);
    final List<int> seatNos = players.map((p) => p.seatNo).toList();

    final GameInfoModel gameInfoModel = GameInfoModel(
      maxPlayers: data.maxPlayers,
      gameType: data.gameType,
      tableStatus: null,
      status: null,
      smallBlind: data.smallBlind.toInt(),
      bigBlind: data.bigBlind.toInt(),
      playersInSeats: players,
    );

    /* finding the current Player */
    final PlayerModel currPlayer = players.firstWhere(
      (p) => p.playerId == playerID,
    );

    final Map<int, List<int>> playerCards = _getPlayerCards(
      data.result.playerInfo,
      playerID,
    );

    List<int> board1Cards = data.getBoard1();

    final List<GameReplayAction> actions = _getActions(
      myCards: playerCards[currPlayer.seatNo],
      noCards: data.noCards,
      flopCards: board1Cards.sublist(0, 3),
      riverCard: board1Cards[3],
      turnCard: board1Cards[4],
      playerCards: playerCards,
      board1Cards: board1Cards,
      board2Cards: data.getBoard2(),
      isRunItTwice: data.runItTwice,
      result: data.result,
      seatNos: seatNos,
      flopActions: data.flopActions,
      preflopActions: data.preflopActions,
      riverActions: data.riverActions,
      turnActions: data.turnActions,
    );

    final GameState gameState = GameState();
    await gameState.initialize(
      gameCode: gameCode,
      gameInfo: gameInfoModel,
      currentPlayer: PlayerInfo(
        id: currPlayer.playerId,
        // FIXME: I KNOW THIS IS A BAD IDEA, BUT A TEMP FIX
        uuid: '', // THIS IS MADE EMPTY TO KNOW WE ARE IN REPLAY MODE
        name: currPlayer.name,
      ),
      replayMode: true,
    );

    return GameReplayController(
      playerActionTime: data.actionTime ?? 30,
      gameState: gameState,
      actions: actions,
    );
  }
}
