import 'dart:developer';

import 'package:pokerapp/services/app/gif_cache_service.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_response.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_result.dart';
import 'package:pokerapp/services/tenor/src/tenor.dart';

class TenorService {
  static final String _token = "AIzaSyDJuyVzy0Q-pN3LAyvfUnzAvEtDvoKlYU4";
  static final String secret = "Poker Club App";

  static Tenor tenor = Tenor(apiKey: _token);

  static Future<List<TenorResult>> getTrendingGifs() async {
    TenorResponse res = await tenor.requestTrendingGIF();

    final List<TenorResult> list = [];

    res?.results?.forEach((TenorResult tenorResult) {
      list.add(tenorResult);
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
    // if (cacheResults != null && cacheResults.length > 0) return cacheResults;

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
