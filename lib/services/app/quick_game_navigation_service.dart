import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';

class QuickGameNavigationService {
  static const String IN_GAME = 'inGame';

  static Future<void> addGame(String gameCode) {
    return appService.userSettings.setLastGame(gameCode);
  }

  static void handle({@required final BuildContext context}) async {
    final userInGame = appService.userSettings.getLastGame();
    // return if userInGame is empty
    if (userInGame.isEmpty) return;

    ConnectionDialog.show(
      context: context,
      loadingText: "Checking for games...",
    );

    // else fetch game info
    final GameInfoModel gameInfo = await GameService.getGameInfo(userInGame);

    ConnectionDialog.dismiss(context: context);

    if (gameInfo == null || gameInfo.status == AppConstants.GAME_ENDED) {
      // update the IN_GAME value in hive
      appService.userSettings.setLastGame('');
    } else {
      // launch the game
      Navigator.of(context).pushNamed(
        Routes.game_play,
        arguments: {
          'gameCode': userInGame,
          'gameInfo': gameInfo,
        },
      );
    }
  }
}
