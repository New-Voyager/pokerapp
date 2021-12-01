import 'package:pokerapp/services/data/game_templates.dart';

import 'data/hive_datasource_impl.dart';
import 'data/user_settings.dart';

class AppService {
  GameTemplateStore gameTemplates;
  UserSettingsStore userSettings;

  void init() async {
    await HiveDatasource.getInstance.init();
    gameTemplates = GameTemplateStore();
    gameTemplates.open();
    userSettings = UserSettingsStore();
    userSettings.open();
  }

  void close() {
    if (gameTemplates != null) {
      gameTemplates.close();
    }
    gameTemplates = null;
    if (userSettings != null) {
      userSettings.close();
    }
    userSettings = null;
  } 
}
