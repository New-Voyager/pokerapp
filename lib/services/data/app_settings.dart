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

  String get playerInGame {
    return _box.get('playerInGame');
  }

  set playerInGame(String gameCode) {
    _box.put('playerInGame', gameCode);
  }
}
