import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokerapp/utils/platform.dart';

Future<FirebaseOptions> getFirebaseSettings(String apiUrl) async {
  try {
    http.Response response =
        await http.get(Uri.parse('$apiUrl/firebase-settings'));

    String resBody = response.body;

    if (response.statusCode != 200)
      throw new Exception('Failed to get firebase settings');

    Map settings = jsonDecode(resBody);

    if (PlatformUtils.isAndroid) {
      settings['apiKey'] = settings['androidApiKey'];
      settings['appId'] = settings['androidAppId'];
    } else if (PlatformUtils.isIOS) {
      settings['apiKey'] = settings['iosApiKey'];
      settings['appId'] = settings['iosAppId'];
    }
    final fbOptions = FirebaseOptions.fromMap(settings);
    return fbOptions;
  } catch (err) {
    log('Error: ${err.toString()}, ${err.stackTrace}');
    return null;
  }
}
