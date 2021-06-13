import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/datasource_contract.dart';
import 'package:pokerapp/services/data/hive_models/game_settings.dart';

class HiveDatasource implements IDatasource {
  HiveDatasource._();

  static HiveDatasource _instance;

  static HiveDatasource get getInstance => _instance ??= HiveDatasource._();

  Map<BoxType, Box<dynamic>> _boxes = {};

  @override
  Box getBox(BoxType boxType) => _boxes[boxType];

  @override
  Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    Hive.registerAdapter(GameSettingsAdapter());

    /* open boxes */
    /* open every boxes mentioned in the boxtype enum */
    for (BoxType boxType in BoxType.values) {
      log('boxType = $boxType, boxType.value() = ${boxType.value()}');
      _boxes[boxType] = await Hive.openBox(boxType.value());
    }
  }
}
