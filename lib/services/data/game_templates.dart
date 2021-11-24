import 'package:hive/hive.dart';

import 'box_type.dart';
import 'hive_datasource_impl.dart';

class GameTemplateStore {
  Box _box;

  void open() {
    _box = HiveDatasource.getInstance.getBox(BoxType.GAME_TEMPLATE_BOX);
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

  List<String> getSettings() {
    List<String> ret = [];
    for (final key in _box.keys) {
      ret.add(key.toString());
    }
    return ret;
  }

  Map<String, dynamic> getSetting(String key) {
    return _box.get(key).cast<String, dynamic>();
  }
}