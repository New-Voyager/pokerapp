import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'hive_models/game_settings.dart';

/*
The players earn diamonds and timebank for each game as they play longer in a game.
After a hand ends (result), it will be determined whether next time window is reached
to earn new diamonds or timebank.

This class will track last hand time the player played as well to track the player's
break and leaving/returning scenarios.

If the current hand time is greater than 10 minutes from last updated hand time, then
the player was in a longer break or left/returned to the game.


if (now - lastHandTime) > 10*60 {
  // greater than 5 minutes
  // player went on a break
  // don't add diamonds or time bank

  // update last updated time
  // update last diamond time
  // update last timebank time
} else {
  update lastHandTime

  if (now - lastTimeBankTime > 15*60) {
    // 15 minutes
    if (timebank < max) {
      add time to timebank
    }
    update last timebank time
  }

  if (now - lastDiamondTime > 15*60) {
    // 15 minutes
    if (diamonds < max) {
      add diamons to diamonds
    }
    update last diamond time
  }
}
*/

//int kDefaultDiamonds = 5;
int kDefaultTimebankSecs = 10;

class GameHiveStore {
  Box _gameBox;

  GameHiveStore();

  static const _GAME_SETTINGS_KEY = 'game_settings';

  GameLocalConfig getGameConfiguration() {
    return GameLocalConfig.fromJson(
        jsonDecode(_gameBox.get(_GAME_SETTINGS_KEY)), this);
  }

  bool haveGameSettings() {
    return _gameBox.containsKey(_GAME_SETTINGS_KEY);
  }

  Future<void> putGameSettings(GameLocalConfig gameSettings) {
    return _gameBox.put(_GAME_SETTINGS_KEY, jsonEncode(gameSettings));
  }

  /* HOLE CARD VISIBILITY STATE */
  static const _HOLE_CARDS_VISIBILITY_STATE = 'hole_cards_visibility_state';
  void setHoleCardsVisibilityState(bool visible) {
    _gameBox.put(_HOLE_CARDS_VISIBILITY_STATE, visible);
  }

  bool getHoleCardsVisibilityState() {
    // return false;
    return _gameBox.get(_HOLE_CARDS_VISIBILITY_STATE, defaultValue: false);
  }

  static const _DIAMONDS = 'diamonds';
  static const _DIAMONDS_UPDATE = 'diamonds_update';

  // Future<void> _addDiamonds(int num) {
  //   return _gameBox.put(_DIAMONDS, getDiamonds() + num);
  // }

  // int getDiamonds() => _gameBox.get(_DIAMONDS, defaultValue: 0) as int;

  // Future<void> clearDiamonds() => _gameBox.put(_DIAMONDS, 0);

  // Future<bool> deductDiamonds({int num = 2}) async {
  //   if (getDiamonds() < num) return false;
  //   await _addDiamonds(-num);
  //   return true;
  // }

  static const _TIMEBANK = 'timebank';
  static const _TIMEBANK_UPDATE = 'timebank_update';
  Future<void> _addTimeToTimeBank(int num) async {
    return _gameBox.put(_TIMEBANK, getTimeBankTime() + num);
  }

  int getTimeBankTime() => _gameBox.get(_TIMEBANK, defaultValue: 0) as int;

  Future<void> clearTimebank() => _gameBox.put(_TIMEBANK, 0);

  Future<bool> deductTimebank({int num = 10}) async {
    int availableTime = getTimeBankTime();
    if (availableTime < num) return false;

    await _addTimeToTimeBank(-num);
    if (getTimeBankTime() > AppConstants.maxTimeBankSecs) {
      _gameBox.put(_TIMEBANK, AppConstants.maxTimeBankSecs - num);
    }
    return true;
  }

  void initialize(String gameCode) async {
    // open the box
    final box = await open(gameCode);
    // if this box was not already initialized, add default values
    // final diamonds = box.get(_DIAMONDS, defaultValue: null) as int;
    // if (diamonds == null) {
    //   _gameBox.put(_DIAMONDS, kDefaultDiamonds);
    // }
    final timebank = box.get(_TIMEBANK, defaultValue: null) as int;
    if (timebank == null) {
      _gameBox.put(_TIMEBANK, 20);
    }
  }

  static const _LASTHAND_LONG_BREAK_TIME = 10 * 60 * 1000; // 10 minutes
  static const _LASTHAND_TIME = 'lasthand_time';
  void handEnded() async {
    try {
      // if (getTimeBankTime() < AppConstants.maxTimeBankSecs) {
      //   _addTimeToTimeBank(kDefaultTimebankSecs);
      // }

      // a hand ended
      final String lastHandTimeStr = _gameBox.get(_LASTHAND_TIME);

      final DateTime now = DateTime.now();
      // send back the earliest time possible
      if (lastHandTimeStr == null) {
        // first hand
        // _gameBox.put(_DIAMONDS_UPDATE, now.toIso8601String());
        _gameBox.put(_LASTHAND_TIME, now.toIso8601String());
        _gameBox.put(_TIMEBANK_UPDATE, now.toIso8601String());
        return;
      }
      final DateTime lastHandTime = DateTime.parse(lastHandTimeStr);
      final diffSinceLastHand = now.difference(lastHandTime).inSeconds;
      if (diffSinceLastHand >= _LASTHAND_LONG_BREAK_TIME) {
        // assuming a hand will be end within 10 minutes
        // either the player was in a long break or left/returned to the game
        // _gameBox.put(_DIAMONDS_UPDATE, now.toIso8601String());
        _gameBox.put(_TIMEBANK_UPDATE, now.toIso8601String());
        _gameBox.put(_LASTHAND_TIME, now.toIso8601String());
        return;
      }
      // final String lastDiamondTimeStr = _gameBox.get(_DIAMONDS_UPDATE);
      // final DateTime lastDiamondTime = DateTime.parse(lastDiamondTimeStr);
      final String lastTimebankTimeStr = _gameBox.get(_TIMEBANK_UPDATE);
      final DateTime lastTimebankTime = DateTime.parse(lastTimebankTimeStr);

      // final diffSinceLastDiamond = now.difference(lastDiamondTime).inSeconds;
      // if (diffSinceLastDiamond >=
      //     AppConstants.diamondUpdateDuration.inSeconds) {
      //   // the player earned new diamonds
      //   if (getDiamonds() < AppConstants.maxDiamondNumber) {
      //     _addDiamonds(kDefaultDiamonds);
      //   }
      // _gameBox.put(_DIAMONDS_UPDATE, now.toIso8601String());
      // }

      final diffSinceLastTimebank = now.difference(lastTimebankTime).inSeconds;
      if (diffSinceLastTimebank >=
          AppConstants.timebankUpdateDuration.inSeconds) {
        // the player earned new time for timebank
        if (getTimeBankTime() < AppConstants.maxTimeBankSecs) {
          _addTimeToTimeBank(kDefaultTimebankSecs);
        }
        _gameBox.put(_TIMEBANK_UPDATE, now.toIso8601String());
      }
    } catch (err) {
      log('Failed to update diamonds/timebank. ${err.toString()}');
    }
  }

  Future<Box> open(String gameCode) async {
    _gameBox = await Hive.openBox(gameCode);
    return _gameBox;
  }

  bool isInitialized() {
    return _gameBox.isOpen;
  }

  void close() {
    _gameBox?.close();
  }

  void deleteBox() {
    _gameBox.deleteFromDisk();
  }

  bool isBoxEmpty() {
    return _gameBox.isEmpty;
  }
}
