import 'package:pokerapp/resources/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHostUrls {
  static String _apiUrl;
  static SharedPreferences sharedPreferences;

  static void init(String defaultUrl) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String apiServer = sharedPreferences.getString(AppConstants.API_SERVER_URL);
    if (apiServer == null) {
      apiServer = defaultUrl;
    }

    if (!apiServer.contains('https://')) {
      apiServer = 'http://$apiServer:9501';
    }
    AppHostUrls._apiUrl = apiServer;
  }

  static Future<void> save({
    String apiServer,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (!apiServer.contains('https://')) {
      apiServer = 'http://$apiServer:9501';
    }

    await sharedPreferences.setString(AppConstants.API_SERVER_URL, apiServer);
    AppHostUrls._apiUrl = apiServer;
  }

  static String get apiUrl {
    if (apiUrl == null) {
      String apiServer =
          sharedPreferences.getString(AppConstants.API_SERVER_URL);

      if (!apiServer.contains('https://')) {
        apiServer = 'http://$apiServer:9501';
      }
      _apiUrl = apiServer;
    }
    return _apiUrl;
  }
}
