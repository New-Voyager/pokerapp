import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_result.dart';
import 'package:uuid/uuid.dart';

class GifCacheService {
  GifCacheService._();

  static Future<Directory> get _gifDirectory {
    return getApplicationDocumentsDirectory();
  }

  static String _getKey(String category) => 'gif-cache-$category';

  /* fetch if key exists do not fetch again, if not, fetch */
  static bool _needToFetch(String category, Box cacheBox) {
    return !cacheBox.containsKey(_getKey(category));
  }

  /* use this method to keep a cache of the all the gifs from the categories array */
  static Future<void> cacheGifCategories(
    List<String> categories, {
    int cacheAmount = 20,
  }) async {
    final Directory dir = await _gifDirectory;

    final cacheBox = HiveDatasource.getInstance.getBox(BoxType.CACHE_GIF_BOX);
    bool needToFetch = false;
    for (String category in categories) {
      if (_needToFetch(category, cacheBox) || needToFetch) {
        List<TenorResult> gifs = await TenorService.getGifsWithSearch(
          category,
          limit: cacheAmount,
        );

        await _save(category, gifs, cacheBox, dir);
      }
    }
    log('All gifs cached');
  }

  static Future<void> _save(
    String query,
    List<TenorResult> gifs,
    Box cacheBox,
    Directory dir,
  ) async {
    /* download the preview gifs & store them in local storage */
    for (int i = 0; i < gifs.length; i++) {
      TenorResult gif = gifs[i];

      String previewUrl = gif.previewUrl; // gif.media.tinygif.url;
      if (previewUrl == null) {
        previewUrl = gif.itemurl;
      }
      final String fileName = '${Uuid().v1()}.gif';

      final String downloadPath = '${dir.path}/$fileName';

      /* download the file */
      Response response = await get(Uri.parse(previewUrl));
      await File(downloadPath).writeAsBytes(response.bodyBytes);
      log('Download ${previewUrl} cache gif for size: ${response.contentLength}');

      // we dont care about the GOOD quality GIFs, thus we just save the preview ones
      //gif.media.gif.url = previewUrl;

      gif.cache = fileName;
    }

    /* finally put the list of gif to hive box */
    await cacheBox.put(
      _getKey(query),
      gifs.map<String>((result) => result.toJson()).toList(),
    );
  }

  /* check in the storage, if exists, return else return null */
  static Future<List<TenorResult>> getFromCache(String category) async {
    final gifParentPath = (await _gifDirectory).path;
    final cacheBox = HiveDatasource.getInstance.getBox(BoxType.CACHE_GIF_BOX);

    List<String> cachedResponse = cacheBox.get(_getKey(category));

    if (cachedResponse == null) return null;

    List<TenorResult> gifs = [];

    for (final resp in cachedResponse) {
      final gif = TenorResult.fromJson(resp);
      gif.cache = '$gifParentPath/${gif.cache}';
      gifs.add(gif);
    }

    return gifs;
  }
}
