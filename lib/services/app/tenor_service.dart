
import 'package:pokerapp/services/app/gif_cache_service.dart';
import 'package:tenor/tenor.dart';

class TenorService {
  static final String _token = "Poker Club App	64Q3AL13ME20";

  static Tenor tenor = Tenor(apiKey: _token);

  static Future<List<TenorResult>> getTrendingGifs() async {
    TenorResponse res = await tenor.requestTrendingGIF();

    final List<TenorResult> list = [];

    res?.results?.forEach((TenorResult tenorResult) {
      list.add(tenorResult);
      /*  var title = tenorResult.title;
      var media = tenorResult.media;
      print('$title: gif : ${media?.gif?.previewUrl?.toString()}'); */
    });
    return list;
  }

  static Future<List<TenorResult>> getGifsWithSearch(
    String query, {
    int limit = 20,
  }) async {
    /* check in cache first */
    final List<TenorResult> cacheResults = await GifCacheService.getFromCache(
      query,
    );

    /* return from cache if not NULL */
    if (cacheResults != null) return cacheResults;

    TenorResponse res = await tenor.searchGIF(
      query,
      limit: limit,
    );
    final List<TenorResult> list = [];

    res?.results?.forEach((TenorResult tenorResult) {
      list.add(tenorResult);
    });

    return list;
  }
}
