import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:hive/hive.dart';
import 'package:pokerapp/services/data/datasource_contract.dart';

class HiveDatasource implements IDatasource {
  HiveDatasource._();
  static HiveDatasource _instance;
  static HiveDatasource get getInstance => _instance ??= HiveDatasource._();

  Map<BoxType, Box> boxes = {};

  @override
  Box getBox(BoxType boxType) => boxes[boxType];

  @override
  Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    /* open boxes */
    /* open every boxes mentioned in the boxtype enum */
    for (BoxType boxType in BoxType.values) {
      boxes[boxType] = await Hive.openBox(boxType.value());
    }
  }
}
