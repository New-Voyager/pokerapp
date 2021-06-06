import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class HandlogCacheService {
  HandlogCacheService._();

  static String getSharedPrefKey(String gameCode, int handNum) {
    return "Handlog:$gameCode:$handNum";
  }

  /* if key exists do not fetch again, if not, fetch */
  static bool needToFetch(
    String gameCode,
    int handNum,
    SharedPreferences preferences,
  )  {
   
    return !preferences.containsKey(getSharedPrefKey(gameCode, handNum));
  }

  static void saveToCache(
    String gameCode,
    int handNum,
    String data,    SharedPreferences preferences,

  ) async {
    log("Save to Cache: GAMECODE: $gameCode : $handNum");

    preferences.setString(
      getSharedPrefKey(gameCode, handNum),
      data,
    );
  }

  static String getFromCache(
    String gameCode,
    int handNum,
    SharedPreferences sharedPreferences,
  ) {
    log("Reading from Cache: GAMECODE: $gameCode : $handNum");
    
    String cachedResponse = sharedPreferences.getString(
      getSharedPrefKey(gameCode, handNum),
    );

    return cachedResponse;
  }
}
