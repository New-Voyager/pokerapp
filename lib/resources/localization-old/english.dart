import 'dart:core';

//import 'package:pokerapp/resources/localization/localization.dart';

class EnglishLocalization {
  Map<int, String> _localizedValues;

  Map<int, String> getValues() {
    if (_localizedValues == null) {
      _localizedValues = Map<int, String>();
      this.build();
    }
    return _localizedValues;
  }

  void build() {
    tabNames();
  }

  tabNames() {
    /*   _localizedValues[ResourceId.MAIN_MYPROFILE] = 'My Profile';
    _localizedValues[ResourceId.MAIN_TAB_CLUBS] = 'Clubs';
    _localizedValues[ResourceId.MAIN_TAB_GAMES] = 'Games';
  */
  }
}
