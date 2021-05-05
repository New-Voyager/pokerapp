import 'dart:developer';
import 'dart:io';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenor/tenor.dart';

class GifCacheService {
  GifCacheService._();

  static String _getSharedPrefKey(String category) => 'GIF CACHE: $category';

  static String _getSharedPrefKeyTime(String category) =>
      'GIF CACHE TIME: $category';

  /* TODO: A EXPIRY FUNCTIONALITY TO INVALIDATE CACHES AFTER A WHILE */
  /* TODO: ALSO NEED TO SCHEDULE FOR DELETION, IN CASE A CACHE IS IN VALIDATED */
  static bool _needToFetch(
    String category,
    SharedPreferences sharedPreferences,
  ) {
    // int expTime = sharedPreferences.getInt(_getSharedPrefKeyTime(category));

    /* FIXME: FOW NOW: fetch if key exists do not fetch again, if not, fetch */
    return !sharedPreferences.containsKey(_getSharedPrefKey(category));
  }

  /* use this method to keep a cache of the all the gifs from the categories array */
  static void cacheGifCategories(
    List<String> categories, {
    int cacheAmount = 20,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    Directory downloadsDirectory = await getApplicationDocumentsDirectory();

    for (String category in categories) {
      if (_needToFetch(category, sp)) {
        List<TenorResult> gifs = await TenorService.getGifsWithSearch(
          category,
          limit: cacheAmount,
        );
        await _save(
          category,
          gifs,
          sp,
          downloadsDirectory,
        );
      }
    }
  }

  /* check in the storage, if exists, return else return null */
  static Future<List<TenorResult>> getFromCache(String category) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    List<String> cachedResponse = sharedPreferences.getStringList(
      _getSharedPrefKey(category),
    );

    return cachedResponse
        ?.map<TenorResult>(
            (cachedTenorResult) => TenorResult.fromJson(cachedTenorResult))
        ?.toList();
  }

  static Future<void> _save(
    String query,
    List<TenorResult> gifs,
    SharedPreferences sharedPreferences,
    Directory dir,
  ) async {
    /* download the preview gifs & store them in local storage */
    for (int i = 0; i < gifs.length; i++) {
      TenorResult gif = gifs[i];

      final String previewUrl = gif.media.tinygif.url;
      final String downloadToFile =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.gif';

      /* download the file */
      Response response = await get(previewUrl);
      await File(downloadToFile).writeAsBytes(response.bodyBytes);

      print('downloaded :$query GIF to: $downloadToFile');

      /* replace the URL with the local file path */
      gif.media.tinygif.url = downloadToFile;
    }

    /* finally put the list of gif into the shared preference */
    sharedPreferences.setStringList(
      _getSharedPrefKey(query),
      gifs.map<String>((result) => result.toJson()).toList(),
    );
  }
}
