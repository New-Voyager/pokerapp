import 'package:flutter/widgets.dart';
import 'package:intl/locale.dart';

import 'english.dart';

// identifier every widget in the app
class ResourceId {
  static const MAIN_TAB_GAMES = 1;
  static const MAIN_TAB_CLUBS = 2;
  static const MAIN_MYPROFILE = 3;
}

class Localization {
  final Locale locale;
  Map<int, String> _localizedValues;
  Localization(this.locale) {
    if (this.locale.languageCode == 'en') {
      var localization = new EnglishLocalization();
      _localizedValues = localization.getValues();
    } else {
      // default english
      var localization = new EnglishLocalization();
      _localizedValues = localization.getValues();
    }
  }

  String get(int resourceId) {
    if (_localizedValues.containsKey(resourceId)) {
      return _localizedValues[resourceId];
    } else {
      return 'NOTAVAILABLE';
    }
  }

  static Localization _default;
  static Localization of() {
    if (_default == null) {
      _default = new Localization(Locale.fromSubtags(languageCode: 'en'));
    }
    return _default;
  }
}
