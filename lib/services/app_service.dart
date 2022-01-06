import 'dart:developer';

import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/screen_attributes.dart';
import 'package:pokerapp/services/data/game_templates.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/app_settings.dart';
import 'data/hive_datasource_impl.dart';
import 'data/user_settings.dart';

class AppService {
  GameTemplateStore gameTemplates;
  UserSettingsStore userSettings;
  SharedPreferences sharedPreferences;
  AppSettingsStore appSettings;
  Nats natsClient;

  Future<void> init() async {
    await HiveDatasource.getInstance.init();
    gameTemplates = GameTemplateStore();
    gameTemplates.open();
    userSettings = UserSettingsStore();
    userSettings.open();
    sharedPreferences = await SharedPreferences.getInstance();
    appSettings = AppSettingsStore();
    appSettings.open();
  }

  void initScreenAttribs() {
    try {
      final size = Screen.size;
      ScreenAttributes.buildList();
      final attribs = ScreenAttributes.getScreenAttribs(
          DeviceInfo.model, Screen.diagonalInches, size);
      log('attribs length: ${attribs.length}');
    } catch (err) {
      log('Error: ${err.toString()}');
    }
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

    if (appSettings != null) {
      appSettings.close();
    }
    appSettings = null;
  }
}
