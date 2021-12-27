import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_result.dart';

class GifCacheService {
  GifCacheService._();

  static String _getKey(String category) => 'GIF CACHE: $category';

  /* fetch if key exists do not fetch again, if not, fetch */
  static bool _needToFetch(
    String category,
    Box cacheBox,
  ) =>
      !cacheBox.containsKey(_getKey(category));

  static Future<void> _refreshPathForFavGifs() async {
    Directory downloadsDirectory = await getApplicationDocumentsDirectory();

    final fgBox = HiveDatasource.getInstance.getBox(BoxType.FAV_GIF_BOX);

    List<TenorResult> trs = [];

    fgBox.values.forEach((data) => trs.add(TenorResult.fromJson(data)));

    if (trs.length > 0) {
      final oldCachePath = trs.first.cache;
      final oldDirPath =
          oldCachePath.substring(0, oldCachePath.lastIndexOf("/"));
      final newDirPath = downloadsDirectory.path;
      print('oldDirPath: $oldDirPath');
      print('newPath: $newDirPath');

      final Map<String, String> updatedGifs = Map();

      if (oldDirPath != newDirPath) {
        for (final gif in trs) {
          gif.cache = gif.cache.replaceFirst(oldDirPath, newDirPath);
          print('NEW UPDATED PATH: ${gif.cache}');

          updatedGifs[gif.id] = gif.toJson();
        }

        // finally save
        await fgBox.putAll(updatedGifs);
      }
    }
  }

  /* use this method to keep a cache of the all the gifs from the categories array */
  static Future<void> cacheGifCategories(
    List<String> categories, {
    int cacheAmount = 20,
  }) async {
    final cacheBox = HiveDatasource.getInstance.getBox(BoxType.CACHE_GIF_BOX);
    Directory downloadsDirectory = await getApplicationDocumentsDirectory();

    for (String category in categories) {
      if (_needToFetch(category, cacheBox)) {
        List<TenorResult> gifs = await TenorService.getGifsWithSearch(
          category,
          limit: cacheAmount,
        );
        await _save(
          category,
          gifs,
          cacheBox,
          downloadsDirectory,
        );
      } else {
        // we probably need to update the path
        final rawGifs = cacheBox.get(_getKey(category));
        final List<TenorResult> gifs =
            rawGifs.map<TenorResult>((g) => TenorResult.fromJson(g)).toList();
        final oldCachePath = gifs.first.cache;
        if (oldCachePath == null) continue;
        final oldDirPath =
            oldCachePath.substring(0, oldCachePath.lastIndexOf("/"));
        final newDirPath = downloadsDirectory.path;
        print('oldDirPath: $oldDirPath');
        print('newPath: $newDirPath');
        if (oldDirPath != newDirPath) {
          // update path
          for (final gif in gifs) {
            gif.cache = gif.cache.replaceFirst(oldDirPath, newDirPath);
            print('NEW UPDATED PATH: ${gif.cache}');
          }

          // finally save
          await cacheBox.put(
            _getKey(category),
            gifs.map<String>((result) => result.toJson()).toList(),
          );
        }
      }
    }

    await _refreshPathForFavGifs();
  }

  /* check in the storage, if exists, return else return null */
  static Future<List<TenorResult>> getFromCache(String category) async {
    final cacheBox = HiveDatasource.getInstance.getBox(BoxType.CACHE_GIF_BOX);

    List<String> cachedResponse = cacheBox.get(_getKey(category));

    return cachedResponse
        ?.map<TenorResult>(
            (cachedTenorResult) => TenorResult.fromJson(cachedTenorResult))
        ?.toList();
  }

  static Future<void> _save(
    String query,
    List<TenorResult> gifs,
    Box cacheBox,
    Directory dir,
  ) async {
    /* download the preview gifs & store them in local storage */
    for (int i = 0; i < gifs.length; i++) {
      print('downloading $i cache gif for $query');
      TenorResult gif = gifs[i];

      final String previewUrl = gif.media.tinygif.url;
      final String downloadToFile =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.gif';

      /* download the file */
      Response response = await get(Uri.parse(previewUrl));
      await File(downloadToFile).writeAsBytes(response.bodyBytes);

      // we dont care about the GOOD quality GIFs, thus we just save the preview ones
      gif.media.gif.url = previewUrl;

      /* replace the URL with the local file path */
      gif.cache = downloadToFile;
    }

    /* finally put the list of gif into the shared preference */
    await cacheBox.put(
      _getKey(query),
      gifs.map<String>((result) => result.toJson()).toList(),
    );
  }
}
