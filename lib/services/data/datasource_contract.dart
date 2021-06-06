import 'package:hive/hive.dart';
import 'package:pokerapp/services/data/box_type.dart';

abstract class IDatasource {
  Future<void> init();
  Box getBox(BoxType boxType);
}
