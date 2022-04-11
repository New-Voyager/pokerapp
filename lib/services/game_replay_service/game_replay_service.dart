import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
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
          stack: playerInfo.balance.before,
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
          boardCards: board1Cards?.sublist(0, 3),
          boardCards2: board2Cards != null && board2Cards.length >= 3
              ? board2Cards.sublist(0, 3)
              : null,
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
          boardCard: board1Cards != null && board1Cards.length >= 3
              ? board1Cards[3]
              : null,
          boardCard2: board2Cards != null && board2Cards.length >= 3
              ? board2Cards[3]
              : null,
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
          boardCard: board1Cards != null && board1Cards.length >= 4
              ? board1Cards[4]
              : null,
          boardCard2: board2Cards != null && board2Cards.length >= 4
              ? board2Cards[4]
              : null,
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
    for (final p in players) {
      // this is done to mark which players perspective in replay hand
      if (p.playerId == playerID) p.playerUuid = '';
    }
    final List<int> seatNos = players.map((p) => p.seatNo).toList();

    final GameInfoModel gameInfoModel = GameInfoModel(
      maxPlayers: data.maxPlayers,
      gameType: data.gameType,
      tableStatus: null,
      status: null,
      smallBlind: data.smallBlind / 100,
      bigBlind: data.bigBlind / 100,
      playersInSeats: players,
    );

    /* finding the current Player */
    PlayerModel currPlayer = null;
    for (final player in players) {
      if (player.playerId == playerID) {
        currPlayer = player;
        break;
      }
    }

    final Map<int, List<int>> playerCards = _getPlayerCards(
      data.result.playerInfo,
      playerID,
    );
    List<int> currPlayerCards = [];
    if (currPlayer != null) {
      currPlayerCards = playerCards[currPlayer.seatNo];
    }

    List<int> board1Cards = data.getBoard1();

    final List<GameReplayAction> actions = _getActions(
      myCards: currPlayerCards,
      noCards: data.noCards,
      flopCards: board1Cards.sublist(0, 3),
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
        id: playerID,
        uuid: '', // to mark which players perspective in replay hand
        name: currPlayer == null ? '' : currPlayer.name,
      ),
      replayMode: true,
    );

    final player = gameState.getPlayerById(playerID);
    if (player != null && currPlayerCards.isNotEmpty) {
      player.cards = currPlayerCards;
    }

    return GameReplayController(
      playerActionTime: data.actionTime ?? 30,
      gameState: gameState,
      actions: actions,
    );
  }
}
