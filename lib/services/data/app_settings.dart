import 'package:hive/hive.dart';

import 'box_type.dart';
import 'hive_datasource_impl.dart';

class AppSettingsStore {
  Box _box;

  void open() {
    _box = HiveDatasource.getInstance.getBox(BoxType.APP_SETTINGS_BOX);
  }

  void close() {
    if (_box != null) {
      _box.close();
    }
    _box = null;
  }

  void save(String key, dynamic json) {
    _box.put(key, json);
  }

  dynamic getSetting(String key) {
    return _box.get(key);
  }

  // this flag is used for showing refresh banner one time in the game screen
  bool get showRefreshBanner {
    bool ret = getSetting('gameSettings.refresh');
    if (ret == null) {
      return true;
    }
    return ret;
  }

  set showRefreshBanner(bool v) {
    _box.put('gameSettings.refresh', v);
  }
}
