import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/ui/nameplate_object.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/user_settings.dart';

class UserSettingsService {
  UserSettingsService._();

  static bool isDefaultTable() {
    if (getSelectedTableId() == UserSettingsStore.VALUE_DEFAULT_TABLE) {
      return true;
    }
    return false;
  }

  static bool isDefaultBackdrop() {
    if (getSelectedBackdropId() == UserSettingsStore.VALUE_DEFAULT_BACKDROP) {
      return true;
    }
    return false;
  }

  static String getSelectedTableId() {
    return appService.userSettings.getSelectedTableId();
  }

  static String getSelectedBackdropId() {
    return appService.userSettings.getSelectedBackdropId();
  }

  static String getSelectedNameplateId() {
    return appService.userSettings.getSelectedNameplateId();
  }

  static String getSelectedBetdialId() {
    return appService.userSettings.getSelectedBetDial();
  }

  static String getSelectedCardFaceId() {
    return appService.userSettings.getSelectedCardFaceId();
  }

  static String getSelectedCardBackId() {
    return appService.userSettings.getSelectedCardBackId();
  }

  static setSelectedTableId(Asset tableAsset) {
    appService.userSettings.setSelectedTableId(tableAsset.id);
  }

  static setSelectedNameplateId(NamePlateDesign nameplate) {
    appService.userSettings.setSelectedNameplateId(nameplate.id);
  }

  static setSelectedBackdropId(Asset backDropAsset) {
    appService.userSettings.setSelectedBackdropId(backDropAsset.id);
  }
}
