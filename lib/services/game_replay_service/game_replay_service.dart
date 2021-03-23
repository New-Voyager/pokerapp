import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class GameReplayService {
  GameReplayService._();

  static List<PlayerModel> _getPlayers(dynamic players) {
    List<PlayerModel> playerModels = [];
    players.forEach((String seatNo, var player) {
      playerModels.add(
        PlayerModel(
          name: player['name'],
          seatNo: int.parse(seatNo),
          playerUuid: '',
          // buyIn: null,
          stack: player['balance']['before'],
          status: null,
        ),
      );
    });

    return playerModels;
  }

  static List<GameReplayAction> _getActions(var data) {
    final handLog = data['handLog'];
    final List<GameReplayAction> actions = [];

    /* card distribution */
    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.card_distribution,
      ),
    );

    /* pre flop */

    var preflopActions = handLog['preflopActions'];
    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.pre_flop_started,
        actionData: {
          'pot': preflopActions['pot'],
        },
      ),
    );

    /* add player actions */
    actions.addAll(
      preflopActions['actions']
          .map<GameReplayAction>((var action) => GameReplayAction(
                gameReplayActionType: GameReplayActionType.player_action,
                actionData: action,
              ))
          .toList(),
    );

    /* flop */

    var flopActions = handLog['flopActions'];
    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.flop_started,
        actionData: {
          'pot': flopActions['pot'],
          'cards': data['flopCards'],
        },
      ),
    );

    /* add player actions */
    actions.addAll(
      flopActions['actions']
          .map<GameReplayAction>((var action) => GameReplayAction(
                gameReplayActionType: GameReplayActionType.player_action,
                actionData: action,
              ))
          .toList(),
    );

    /* turn */

    var turnActions = handLog['turnActions'];
    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.turn_started,
        actionData: {
          'pot': turnActions['pot'],
          'cards': data['turnCards'],
        },
      ),
    );

    /* add player actions */
    actions.addAll(
      turnActions['actions']
          .map<GameReplayAction>((var action) => GameReplayAction(
                gameReplayActionType: GameReplayActionType.player_action,
                actionData: action,
              ))
          .toList(),
    );

    /* river */

    var riverActions = handLog['riverActions'];
    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.river_started,
        actionData: {
          'pot': riverActions['pot'],
          'cards': data['riverCards'],
        },
      ),
    );

    /* add player actions */
    actions.addAll(
      riverActions['actions']
          .map<GameReplayAction>((var action) => GameReplayAction(
                gameReplayActionType: GameReplayActionType.player_action,
                actionData: action,
              ))
          .toList(),
    );

    /* showdown -> show the cards of all the players */

    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.showdown,
        actionData: data['players'],
      ),
    );

    /* show winner */

    actions.add(
      GameReplayAction(
        gameReplayActionType: GameReplayActionType.declare_winner,
        actionData: handLog['potWinners'],
      ),
    );

    return actions;
  }

  static Future<GameReplayController> buildController(dynamic data) async {
    var handLog = data['handLog'];

    /* prepare a game info model */
    GameInfoModel gameInfoModel = GameInfoModel(
      maxPlayers: 9, // TODO: WE NEED TO GET THE MAX PLAYERS HERE
      status: null,
      smallBlind: handLog['sbPos'],
      bigBlind: handLog['bbPos'],
      playersInSeats: _getPlayers(data['players']),
      gameType: data['gameType'],
      tableStatus: null,
    );

    return GameReplayController(
      playerUuid: await AuthService.fetchUUID(),
      gameInfoModel: gameInfoModel,
      actions: _getActions(data),
    );
  }
}
