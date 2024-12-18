import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/datasource_contract.dart';
import 'package:pokerapp/utils/platform.dart';

class HiveDatasource implements IDatasource {
  HiveDatasource._();

  static HiveDatasource _instance;

  static HiveDatasource get getInstance => _instance ??= HiveDatasource._();

  Map<BoxType, Box<dynamic>> _boxes = {};

  @override
  Box getBox(BoxType boxType) => _boxes[boxType];

  @override
  Future<void> init() async {
    if (PlatformUtils.isWeb) {
      await Hive.initFlutter();
    } else {
      Directory dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
    }

    /* open boxes */
    /* open every boxes mentioned in the boxtype enum */
    for (BoxType boxType in BoxType.values) {
      log('boxType = $boxType, boxType.value() = ${boxType.value()}');
      _boxes[boxType] = await Hive.openBox(boxType.value());
    }
  }
}
