import 'dart:developer';

import 'package:hive/hive.dart';

class UserSettingsStore {
  static Box _settingsBox;
  static const String KEY_SELECTED_ASSETS = "selected-assets";
  static const String KEY_SELECTED_TABLE = "selected-table";
  static const String KEY_SELECTED_BACKDROP = "selected-backdrop";
  static const String KEY_SELECTED_BETDIAL = "selected-betdial";
  static const String KEY_SELECTED_CARDFACE = "selected-cardface";
  static const String KEY_SELECTED_CARDBACK = "selected-cardback";

  static const String VALUE_DEFAULT_TABLE = "default-table";
  static const String VALUE_DEFAULT_BACKDROP = "default-backdrop";
  static const String VALUE_DEFAULT_BETDIAL = "default-betdial";
  static const String VALUE_DEFAULT_CARDFACE = "default-cardface";
  static const String VALUE_DEFAULT_CARDBACK = "default-cardback";

  UserSettingsStore._();

  static Future<void> openSettingsStore() async {
    if (_settingsBox == null) {
      _settingsBox = await Hive.openBox("user_settings");
      if (_settingsBox.isEmpty) {
        log("0-0-0-User Settings box is empty: Loading default values");
        await loadDefaultSettings();
      }
    }
  }

  static Future<void> loadDefaultSettings() async {
    await _settingsBox.clear();
    await _settingsBox.put(
      KEY_SELECTED_ASSETS,
      {
        KEY_SELECTED_BACKDROP: VALUE_DEFAULT_BACKDROP,
        KEY_SELECTED_TABLE: VALUE_DEFAULT_TABLE,
        KEY_SELECTED_BETDIAL: VALUE_DEFAULT_BETDIAL,
        KEY_SELECTED_CARDFACE: VALUE_DEFAULT_CARDFACE,
        KEY_SELECTED_CARDBACK: VALUE_DEFAULT_CARDBACK,
      },
    );
  }

  static void close() {
    if (_settingsBox != null) {
      _settingsBox.close();
    }
  }

  static void delete() {
    if (_settingsBox != null) {
      _settingsBox.deleteFromDisk();
    }
  }

  static Map<String, String> getSelectedAssets() {
    final assets = _settingsBox.get(KEY_SELECTED_ASSETS);
    Map<String, String> ret = Map<String, String>();
    for (final key in assets.keys) {
      final keyStr = key.toString();
      final value = assets[keyStr].toString();
      ret[keyStr] = value;
    }
    return ret;
  }

  static String getSelectedTableId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_TABLE] ?? VALUE_DEFAULT_TABLE;
  }

  static String getSelectedBackdropId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_BACKDROP] ?? VALUE_DEFAULT_BACKDROP;
  }

  static String getSelectedCardFaceId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_CARDFACE] ?? VALUE_DEFAULT_CARDFACE;
  }

  static String getSelectedCardBackId() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_CARDBACK] ?? VALUE_DEFAULT_CARDBACK;
  }

  static String getSelectedBetDial() {
    final Map<String, String> values = getSelectedAssets();
    return values[KEY_SELECTED_BETDIAL] ?? VALUE_DEFAULT_BETDIAL;
  }

  static void setSelectedTableId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_TABLE] = id;
    setSelectedAssets(values);
  }

  static void setSelectedBackdropId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_BACKDROP] = id;
    setSelectedAssets(values);
  }

  static void setSelectedCardFaceId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_CARDFACE] = id;
    setSelectedAssets(values);
  }

  static void setSelectedCardBackId(String id) {
    final Map<String, String> values = getSelectedAssets();
    values[KEY_SELECTED_CARDBACK] = id;
    setSelectedAssets(values);
  }

  static void setSelectedAssets(Map<String, String> values) {
    _settingsBox.put(KEY_SELECTED_ASSETS, values);
  }
}
