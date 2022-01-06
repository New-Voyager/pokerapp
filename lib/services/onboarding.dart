import 'package:pokerapp/main.dart';

enum OnboardingType {
  HOST_BUTTON,
  JOIN_BUTTON,
  SEARCH_CLUB_BUTTON,
  CREATE_CLUB_BUTTON,
  REPORT_BUTTON
}

class OnboardingService {
  OnboardingService._();
  static bool get showHostButton {
    bool ret = appService.appSettings.getSetting('livegames.hostbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showHostButton(bool v) {
    appService.appSettings.putSetting('livegames.hostbutton', v);
  }

  static bool get showJoinButton {
    bool ret = appService.appSettings.getSetting('livegames.joinbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showJoinButton(bool v) {
    appService.appSettings.putSetting('livegames.joinbutton', v);
  }

  static bool get showSearchClubButton {
    bool ret = appService.appSettings.getSetting('clubs.searchbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showSearchClubButton(bool v) {
    appService.appSettings.putSetting('clubs.searchbutton', v);
  }

  static bool get showCreateClubButton {
    bool ret = appService.appSettings.getSetting('clubs.createbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showCreateClubButton(bool v) {
    appService.appSettings.putSetting('clubs.createbutton', v);
  }

  static bool get showReportButton {
    bool ret = appService.appSettings.getSetting('app.reportbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showReportButton(bool v) {
    appService.appSettings.putSetting('app.reportbutton', v);
  }
}
