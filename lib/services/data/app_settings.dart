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
    print(_box.get("AppSettings"));
  }

  List<String> getSettings() {
    List<String> ret = [];
    for (final key in _box.keys) {
      ret.add(key.toString());
    }
    return ret;
  }

  Map<String, dynamic> getSetting(String key) {
    if (_box.get(key) != null) {
      return _box.get(key).cast<String, dynamic>();
    }
    return null;
  }
}
