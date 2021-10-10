import 'package:pokerapp/models/game_play_models/ui/nameplate_object.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/user_settings_store.dart';

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
    return UserSettingsStore.getSelectedTableId();
  }

  static String getSelectedBackdropId() {
    return UserSettingsStore.getSelectedBackdropId();
  }

  static String getSelectedNameplateId() {
    return UserSettingsStore.getSelectedNameplateId();
  }

  static String getSelectedBetdialId() {
    return UserSettingsStore.getSelectedBetDial();
  }

  static String getSelectedCardFaceId() {
    return UserSettingsStore.getSelectedCardFaceId();
  }

  static String getSelectedCardBackId() {
    return UserSettingsStore.getSelectedCardBackId();
  }

  static setSelectedTableId(Asset tableAsset) {
    UserSettingsStore.setSelectedTableId(tableAsset.id);
  }

  static setSelectedNameplateId(NamePlateDesign nameplate) {
    UserSettingsStore.setSelectedNameplateId(nameplate.id);
  }

  static setSelectedBackdropId(Asset backDropAsset) {
    UserSettingsStore.setSelectedBackdropId(backDropAsset.id);
  }
}
