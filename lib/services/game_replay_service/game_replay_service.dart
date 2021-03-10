import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
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
          buyIn: null,
          stack: player['balance']['before'],
          status: null,
        ),
      );
    });

    return playerModels;
  }

  static Future<GameReplayController> buildController(dynamic data) async {
    var handLog = data['handLog'];

    /* prepare a game info model */
    GameInfoModel gameInfoModel = GameInfoModel(
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
    );
  }
}
