import 'dart:developer';
import 'package:tenor/tenor.dart';

class TenorService {
  static final String _token = "Poker Club App	64Q3AL13ME20";

  static Tenor tenor = Tenor(apiKey: _token);

  static Future<List<TenorResult>> getTrendingGifs() async {
    TenorResponse res = await tenor.requestTrendingGIF(limit: 24);
    final List<TenorResult> list = [];
    res?.results?.forEach((TenorResult tenorResult) {
      list.add(tenorResult);
      /*  var title = tenorResult.title;
      var media = tenorResult.media;
      print('$title: gif : ${media?.gif?.previewUrl?.toString()}'); */
    });
    log("Fetching GIFs from Tenor");
    return list;
  }

  static Future<List<TenorResult>> getGifsWithSearch(String query) async {
    TenorResponse res = await tenor.searchGIF(query, limit: 20);
    final List<TenorResult> list = [];

    res?.results?.forEach((TenorResult tenorResult) {
      list.add(tenorResult);
      var title = tenorResult.title;
      var media = tenorResult.media;
      // print('******* : ${media?.nanogif?.url?.toString()}');
    });
    return list;
  }
}
