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

  dynamic getSetting(String key) {
    return _box.get(key);
  }

  dynamic putSetting(String key, dynamic value) {
    return _box.put(key, value);
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

  bool get showHoleCardTip {
    bool ret = getSetting('gameSettings.showHoleCardTip');
    if (ret == null) {
      return true;
    }
    return ret;
  }

  set showHoleCardTip(bool v) {
    _box.put('gameSettings.showHoleCardTip', v);
  }

  bool get showBetTip {
    bool ret = getSetting('gameSettings.showBetTip');
    if (ret == null) {
      return true;
    }
    return ret;
  }

  set showBetTip(bool v) {
    _box.put('gameSettings.showBetTip', v);
  }

  // this flag is used for showing report info dialog one time in the game screen
  bool get showReportInfoDialog {
    bool ret = getSetting('gameSettings.reportInfo');
    if (ret == null) {
      return true;
    }
    return ret;
  }

  set showReportInfoDialog(bool v) {
    _box.put('gameSettings.reportInfo', v);
  }
}
