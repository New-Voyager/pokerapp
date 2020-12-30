import 'package:pokerapp/resources/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHostUrls {
  static Future<void> save({
    String nats,
    String apiServer,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (!apiServer.contains('https://')) {
      apiServer = 'http://$apiServer:9501';
    }

    await sharedPreferences.setString(AppConstants.NATS_URL, nats);
    await sharedPreferences.setString(AppConstants.API_SERVER_URL, apiServer);
  }
}
