import 'package:hive/hive.dart';

part 'game_settings.g.dart';

// typeId should be unique for each model class
@HiveType(typeId: 0)
class GameSettings extends HiveObject {
  @HiveField(0)
  final String gameCode;
  @HiveField(1)
  bool muckLosingHand = false;
  @HiveField(2)
  bool gameSound = true;
  @HiveField(3)
  bool audioConf = true;

  GameSettings(
      this.gameCode, this.muckLosingHand, this.gameSound, this.audioConf);

  @override
  String toString() {
    return "gameCode = ${this.gameCode}, muckLosingHand = ${this.muckLosingHand},"
        " gameSound = ${this.gameSound}, audioConf = ${this.audioConf}";
  }
}
