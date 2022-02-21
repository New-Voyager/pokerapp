import 'dart:developer';

import 'package:hive/hive.dart';

import 'box_type.dart';
import 'hive_datasource_impl.dart';

class UserSettingsStore {
  Box _box;
  static const String KEY_SELECTED_ASSETS = "selected-assets";
  static const String KEY_SELECTED_TABLE = "selected-table";
  static const String KEY_SELECTED_BACKDROP = "selected-backdrop";
  static const String KEY_SELECTED_NAMEPLATE = "selected-nameplate";
  static const String KEY_SELECTED_BETDIAL = "selected-betdial";
  static const String KEY_SELECTED_CARDFACE = "selected-cardface";
  static const String KEY_SELECTED_CARDBACK = "selected-cardback";

  static const String VALUE_DEFAULT_TABLE = "default-table";
  static const String VALUE_DEFAULT_BACKDROP = "default-backdrop";
  static const String VALUE_DEFAULT_NAMEPLATE = "0";
  static const String VALUE_DEFAULT_BETDIAL = "default-betdial";
  static const String VALUE_DEFAULT_CARDFACE = "default-cardface";
  static const String VALUE_DEFAULT_CARDBACK = "default-cardback";

  static const String KEY_LAST_GAME = "last-game";
  static const String KEY_COLOR_CARDS = "color-cards";
  static const String KEY_BETTING_OPTIONS = "betting-options";

  UserSettingsStore();

  void open() async {
    _box = HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);
    final assets = _box.get(KEY_SELECTED_ASSETS);
    if (assets == null) {
      await loadDefault();
    }
  }

  void close() {
    if (_box != null) {
      _box.close();
    }
    _box = null;
  }

  Map<String, String> defaultAssets() {
    return {
      KEY_SELECTED_BACKDROP: VALUE_DEFAULT_BACKDROP,
      KEY_SELECTED_TABLE: VALUE_DEFAULT_TABLE,
      KEY_SELECTED_BETDIAL: VALUE_DEFAULT_BETDIAL,
      KEY_SELECTED_NAMEPLATE: VALUE_DEFAULT_NAMEPLATE,
      KEY_SELECTED_CARDFACE: VALUE_DEFAULT_CARDFACE,
      KEY_SELECTED_CARDBACK: VALUE_DEFAULT_CARDBACK,
    };
  }

  Future<void> loadDefault() async {
    await _box.put(
      KEY_SELECTED_ASSETS,
      defaultAssets(),
    );
  }

  void delete() {
    if (_box != null) {
      _box.deleteFromDisk();
    }
  }

  Map<String, String> getSelectedAssets() {
    dynamic assets = _box.get(KEY_SELECTED_ASSETS);
    if (assets == null) {
      assets = defaultAssets();
    }
    Map<String, String> ret = Map<String, String>();
    for (final key in assets.keys) {
      final keyStr = key.toString();
      final value = assets[keyStr].toString();
      ret[keyStr] = value;
    }
    return ret;
  }

  String getSelectedTableId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_TABLE] ?? VALUE_DEFAULT_TABLE;
  }

  String getSelectedBackdropId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_BACKDROP] ?? VALUE_DEFAULT_BACKDROP;
  }

  String getSelectedNameplateId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_NAMEPLATE] ?? VALUE_DEFAULT_TABLE;
  }

  String getSelectedCardFaceId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_CARDFACE] ?? VALUE_DEFAULT_CARDFACE;
  }

  String getSelectedCardBackId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_CARDBACK] ?? VALUE_DEFAULT_CARDBACK;
  }

  String getSelectedBetDial() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_BETDIAL] ?? VALUE_DEFAULT_BETDIAL;
  }

  void setSelectedTableId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_TABLE] = id;
    setSelectedAssets(values);
  }

  void setSelectedBackdropId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_BACKDROP] = id;
    setSelectedAssets(values);
  }

  void setSelectedNameplateId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_NAMEPLATE] = id;
    setSelectedAssets(values);
  }

  void setSelectedCardFaceId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_CARDFACE] = id;
    setSelectedAssets(values);
  }

  void setSelectedCardBackId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_CARDBACK] = id;
    setSelectedAssets(values);
  }

  void setSelectedAssets(Map<String, String> values) {
    _box.put(KEY_SELECTED_ASSETS, values);
  }

  Future<void> setColorCards(bool colorCards) async {
    try {
      await _box.put(KEY_COLOR_CARDS, colorCards);
    } catch (e) {
      // ignore the error
    }
  }

  bool getColorCards() {
    try {
      bool colorCards = _box.get(KEY_COLOR_CARDS) as bool;
      return colorCards;
    } catch (e) {
      // ignore the error
    }
    return false;
  }

  Future<void> setBettingOptions(String bettingOptions) async {
    try {
      await _box.put(KEY_BETTING_OPTIONS, bettingOptions);
    } catch (e) {
      // ignore the error
    }
  }

  String getBettingOptions() {
    try {
      String bettingOptions = _box.get(KEY_BETTING_OPTIONS);
      return bettingOptions;
    } catch (e) {
      // ignore the error
    }
    return "";
  }

  Future<void> setLastGame(String gameCode) async {
    try {
      await _box.put(KEY_LAST_GAME, gameCode);
    } catch (e) {
      // ignore the error
    }
  }

  String getLastGame() {
    try {
      String gameCode = _box.get(KEY_LAST_GAME) as String;
      if (gameCode == null) {
        gameCode = '';
      }
      return gameCode;
    } catch (e) {
      // ignore the error
    }
    return '';
  }
}
