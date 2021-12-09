import 'package:pokerapp/main.dart';

enum OnboardingType {
  HOST_BUTTON,
  JOIN_BUTTON,
}

class OnboardingService {
  OnboardingService._();
  static bool get showHostButton {
    bool ret = appService.sharedPreferences.getBool('livegames.hostbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showHostButton(bool v) {
    appService.sharedPreferences.setBool('livegames.hostbutton', v);
  }

  static bool get showJoinButton {
    bool ret = appService.sharedPreferences.getBool('livegames.joinbutton');
    if (ret == null) {
      ret = true;
    }
    return ret;
  }

  static set showJoinButton(bool v) {
    appService.sharedPreferences.setBool('livegames.joinbutton', v);
  }
}
