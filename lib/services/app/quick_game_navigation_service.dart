import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/loading_utils.dart';

class QuickGameNavigationService {
  static const String IN_GAME = 'inGame';

  static Future<void> addGame(String gameCode) {
    final Box userSettingsBox =
        HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);

    return userSettingsBox.put(IN_GAME, gameCode);
  }

  static void handle({@required final BuildContext context}) async {
    final Box userSettingsBox =
        HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);
    final String userInGame = userSettingsBox.get(IN_GAME, defaultValue: '');

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
      await userSettingsBox.put(IN_GAME, '');
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
