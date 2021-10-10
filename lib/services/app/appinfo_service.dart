import 'dart:convert';

import 'package:pokerapp/resources/app_config.dart';
import 'package:http/http.dart' as http;

class AppInfo {
  String toc = 'TOC not available';
  String privacyPolicy = 'Privacy policy not available';
  DateTime tocDate = DateTime.now();
  DateTime privacyPolicyDate = DateTime.now();
  String attributions = 'Attributions not available';
  String help = 'Help not available';
}

AppInfo appInfo = AppInfo();

class AppInfoService {
  static Future<AppInfo> getAppInfo() async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.get(
      Uri.parse('$apiServerUrl/app-info'),
      headers: header,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode == 200) {
      appInfo.attributions = respBody['attributions'];
      appInfo.toc = respBody['toc'];
      appInfo.tocDate = DateTime.tryParse(respBody['tocUpdatedDate']);
      appInfo.privacyPolicy = respBody['privacyPolicy'];
      appInfo.privacyPolicyDate =
          DateTime.tryParse(respBody['privacyPolicyUpdatedDate']);
      appInfo.help = respBody['help'];
    }
    return appInfo;
  }
}
