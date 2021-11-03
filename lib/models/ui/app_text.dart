import 'dart:convert';

import 'package:flutter/services.dart';

class AppText {
  Map<String, Map<String, String>> languageTexts =
      Map<String, Map<String, String>>();
  AppText();

  getText(String screenName, String textId) {
    if (languageTexts.containsKey(screenName)) {
      if (languageTexts[screenName].containsKey(textId)) {
        return languageTexts[screenName][textId];
      }
    }
    return "No Text";
  }

  AppTextScreen getScreen(String screenName) {
    if (languageTexts.containsKey(screenName)) {
      return AppTextScreen(languageTexts[screenName]);
    }
    return AppTextScreen(Map<String, String>());
  }

  void change(String lang) async {
    String json;
    try {
      json = await rootBundle.loadString('assets/language/$lang.json');
    } catch (err) {
      json = await rootBundle.loadString('assets/language/en.json');
    }
    if (json != null) {
      languageTexts = Map<String, Map<String, String>>();
      Map<String, dynamic> screens = jsonDecode(json);
      for (String key in screens.keys) {
        dynamic screenTexts = screens[key];
        languageTexts[key] = Map<String, String>();
        for (String textId in screenTexts.keys) {
          languageTexts[key][textId] = screenTexts[textId].toString();
        }
      }
    }
  }

  static Future<AppText> init(String lang) async {
    final text = AppText();
    text.change(lang);
    return text;
  }
}

class AppTextScreen {
  Map<String, String> texts;
  AppTextScreen(this.texts);
  String getText(String textId, {Map<String, dynamic> values}) {
    String text;
    if (texts.containsKey(textId)) {
      text = texts[textId];
    }

    if (text == null) {
      final global = appText.getScreen('global');
      if (global != null) {
        if (global.texts.containsKey(textId)) {
          text = global[textId];
        }
      }
    }
    if (text != null) {
      if (values != null) {
        for (final key in values.keys) {
          final value = values[key];
          text = text.replaceAll('{$key}', value);
        }
        return text;
      }
    }
    if (text == null) {
      return "No Text";
    }
    return text;
  }

  String operator [](String textId) {
    return getText(textId);
  }
}

AppText appText;

initAppText(String lang) async {
  appText = await AppText.init(lang);
}

AppText getAppText() {
  return appText;
}

AppTextScreen getAppTextScreen(String screenName) {
  return appText.getScreen(screenName);
}
