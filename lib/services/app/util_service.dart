import 'dart:convert';
import 'dart:math';

import 'package:pokerapp/resources/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UtilService {
  static Future<String> getNatsURL() async {
    String apiServerUrl = (await SharedPreferences.getInstance())
        .getString(AppConstants.API_SERVER_URL);

    // if API server URL is not https://, then we are running in dev/docker environment
    // use API server hostname for NATS host
    if (apiServerUrl.contains('http://')) {
      String natsUrl = apiServerUrl
          .replaceFirst('http://', 'nats://')
          .replaceFirst(':9501', '');
      return natsUrl;
    }

    http.Response response =
        await http.get(Uri.parse('$apiServerUrl/nats-urls'));

    String resBody = response.body;

    if (response.statusCode != 200)
      throw new Exception('Failed to get NATS urls');

    // take one of the urls
    List<String> urls = jsonDecode(resBody)['urls'].toString().split(',');
    int i = (new Random()).nextInt(urls.length);
    return urls[i];
  }
}
