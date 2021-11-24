import 'package:pokerapp/services/data/game_templates.dart';

import 'data/hive_datasource_impl.dart';

class AppService {
  GameTemplateStore gameTemplates;

  void init() async {
    await HiveDatasource.getInstance.init();
    gameTemplates = GameTemplateStore();
    gameTemplates.open();
  }

  void close() {
    if (gameTemplates != null) {
      gameTemplates.close();
    }
  }
}