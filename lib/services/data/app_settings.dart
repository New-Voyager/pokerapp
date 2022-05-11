import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'box_type.dart';
import 'hive_datasource_impl.dart';

class AppSettingsStore {
  Box _box;
  Uint8List holeCardBackBytes;

  void open() {
    _box = HiveDatasource.getInstance.getBox(BoxType.APP_SETTINGS_BOX);
  }

  void loadCardBack() async {
    String cardBackAsset = this.cardBackAsset;
    final cardData = await rootBundle.load(cardBackAsset);
    holeCardBackBytes = cardData.buffer.asUint8List();
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

  bool get showHoleRearrangeTip {
    bool ret = getSetting('gameSettings.showHoleRearrangeTip');
    if (ret == null) {
      return true;
    }
    return ret;
  }

  set showHoleRearrangeTip(bool v) {
    _box.put('gameSettings.showHoleRearrangeTip', v);
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

  String get backdropAsset {
    String ret = getSetting('gameSettings.backdropAsset');
    if (ret == null) {
      return 'assets/images/backgrounds/night sky.png';
    }
    return ret.toString();
  }

  set backdropAsset(String v) {
    _box.put('gameSettings.backdropAsset', v);
  }

  String get tableAsset {
    String ret = getSetting('gameSettings.tableAsset');
    if (ret == null) {
      return 'assets/images/table/vertical.png';
    }
    return ret.toString();
  }

  set tableAsset(String v) {
    _box.put('gameSettings.tableAsset', v);
  }

  String get cardBackAsset {
    String ret = getSetting('gameSettings.cardbackAsset');
    if (ret == null) {
      return 'assets/images/card_back/set2/Asset 1.png';
    }
    return ret.toString();
  }

  set cardBackAsset(String v) {
    _box.put('gameSettings.cardbackAsset', v);
  }
}
