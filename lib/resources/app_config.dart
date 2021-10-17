import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';

class AppConfig {
  static String jwt = '';
  static int _availableCoins = 0;
  static String _apiUrl;
  static String _deviceId;
  static String _deviceSecret;
  static String _screenName;
  static int noOfDiamondsForAnimation = 5;
  static int noOfDiamondsForReveal = 5;
  static int noOfDiamondsForShare = 5;


  static SharedPreferences sharedPreferences;

  static Future<void> init(String defaultUrl) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String apiServer = sharedPreferences.getString(AppConstants.API_SERVER_URL);
    if (apiServer == null) {
      apiServer = defaultUrl;
    }

    if (!apiServer.contains('https://') && !apiServer.contains('http://')) {
      apiServer = 'http://$apiServer:9501';
    }
    _apiUrl = apiServer;

    String deviceId = sharedPreferences.getString(AppConstants.DEVICE_ID);
    String deviceSecret =
        sharedPreferences.getString(AppConstants.DEVICE_SECRET);
    await AppConfig.saveApiUrl(apiServer: _apiUrl);
    _deviceId = deviceId;
    _deviceSecret = deviceSecret;
  }

  static Future<void> saveApiUrl({
    String apiServer,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (!apiServer.contains('https://') && !apiServer.contains('http://')) {
      apiServer = 'http://$apiServer:9501';
    }

    await sharedPreferences.setString(AppConstants.API_SERVER_URL, apiServer);
    _apiUrl = apiServer;
  }

  static Future<void> saveDeviceIdAndSecret(
      String deviceId, String deviceSecret) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(AppConstants.DEVICE_ID, deviceId);
    await sharedPreferences.setString(AppConstants.DEVICE_ID, deviceSecret);
    _deviceId = deviceId;
    _deviceSecret = deviceSecret;
  }

  static Future<void> saveScreenName(String screenName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(AppConstants.SCREEN_NAME, screenName);
    _screenName = screenName;
  }

  static String get apiUrl {
    if (_apiUrl == null) {
      String apiServer =
          sharedPreferences.getString(AppConstants.API_SERVER_URL);

      if (!apiServer.contains('https://') && !apiServer.contains('http://')) {
        apiServer = 'http://$apiServer:9501';
      }
      _apiUrl = apiServer;
    }
    return _apiUrl;
  }

  static String get deviceId {
    return _deviceId;
  }

  static String get deviceSecret {
    return _deviceSecret;
  }

  static String get screeName {
    return _screenName;
  }

  static int get availableCoins {
    return _availableCoins;
  }

  static void setAvailableCoins(int coins) {
    _availableCoins = coins;
  }
}
