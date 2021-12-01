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

  UserSettingsStore();

  void open() async {
    _box = HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);
    if (_box.isEmpty) {
      await loadDefault();
    }    
  }

  void close() {
    if (_box != null) {
      _box.close();
    }
    _box = null;
  }


  Future<void> loadDefault() async {
    await _box.clear();
    await _box.put(
      KEY_SELECTED_ASSETS,
      {
        KEY_SELECTED_BACKDROP: VALUE_DEFAULT_BACKDROP,
        KEY_SELECTED_TABLE: VALUE_DEFAULT_TABLE,
        KEY_SELECTED_BETDIAL: VALUE_DEFAULT_BETDIAL,
        KEY_SELECTED_NAMEPLATE: VALUE_DEFAULT_NAMEPLATE,
        KEY_SELECTED_CARDFACE: VALUE_DEFAULT_CARDFACE,
        KEY_SELECTED_CARDBACK: VALUE_DEFAULT_CARDBACK,
      },
    );
  }

  void delete() {
    if (_box != null) {
      _box.deleteFromDisk();
    }
  }

  Map<String, String> getSelectedAssets() {
    final assets = _box.get(KEY_SELECTED_ASSETS);
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
}
