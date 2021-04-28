import 'dart:convert';
import 'dart:developer';

import 'package:pokerapp/models/gif_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:http/http.dart' as http;

class GiphyService {
  /* static const String trendingEndpoint =
      'https://api.giphy.com/v1/gifs/trending';

  static const String searchEndpoint = 'https://api.giphy.com/v1/gifs/search';

  static String _attachApi(String url) =>
      '$url?api_key=${AppConstants.giphyApiKey}';

  static String _attachQuery(String query) =>
      '${_attachApi(searchEndpoint)}&q=$query';

  static Future<List<GifModel>> _get(String url) async {
    http.Response res = await http.get(url);

    var data = jsonDecode(res.body);

    return data['data'].map<GifModel>((d) => GifModel.fromJson(d)).toList();
  }

  static Future<List<GifModel>> fetchTrending() async {
    String url = _attachApi(trendingEndpoint);

    return _get(url);
  }

  static Future<List<GifModel>> fetchQuery(String query) {
    if (query.isEmpty) return fetchTrending();

    String url = _attachQuery(query);

    return _get(url);
  } */
}
