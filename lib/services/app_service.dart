import 'package:pokerapp/services/data/game_templates.dart';

import 'data/app_settings.dart';
import 'data/hive_datasource_impl.dart';

class AppService {
  GameTemplateStore gameTemplates;
  AppSettingsStore appSettings;

  void init() async {
    await HiveDatasource.getInstance.init();
    gameTemplates = GameTemplateStore();
    appSettings = AppSettingsStore();
    gameTemplates.open();
    appSettings.open();
  }

  void close() {
    if (gameTemplates != null) {
      gameTemplates.close();
    }
    if (appSettings != null) {
      appSettings.close();
    }
  }
}
