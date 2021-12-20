import 'package:pokerapp/services/data/game_templates.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/hive_datasource_impl.dart';
import 'data/user_settings.dart';

class AppService {
  GameTemplateStore gameTemplates;
  UserSettingsStore userSettings;
  SharedPreferences sharedPreferences;

  Future<void> init() async {
    await HiveDatasource.getInstance.init();
    gameTemplates = GameTemplateStore();
    gameTemplates.open();
    userSettings = UserSettingsStore();
    userSettings.open();
    sharedPreferences = await SharedPreferences.getInstance();
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
