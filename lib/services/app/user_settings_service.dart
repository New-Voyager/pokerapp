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

  static String getSelectedBetdialId() {
    return UserSettingsStore.getSelectedBetDial();
  }

  static String getSelectedCardFaceId() {
    return UserSettingsStore.getSelectedCardFaceId();
  }

  static String getSelectedCardBackId() {
    return UserSettingsStore.getSelectedCardBackId();
  }
}
