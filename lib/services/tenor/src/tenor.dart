import 'package:pokerapp/services/tenor/src/service/gif_fetcher.dart';
import 'package:pokerapp/services/tenor/src/utility/enums.dart';

import 'model/category.dart';
import 'model/tenor_response.dart';
import 'service/category_fetcher.dart';
import 'service/search_suggestions.dart';

class Tenor {
  final String apiKey;
  final String language;
  final String secret;

  Tenor(
      {this.apiKey = '', this.language = 'en', this.secret = 'Poker Club App'});

  /// Returns response containing a list of the current global trending GIFs. The trending stream is updated regularly throughout the day.
  ///
  /// Defaults: `contentFilter`: `ContentFilter.off`
  ///
  /// Defaults: `size` : `GifSize.all`
  ///
  /// Defaults: `mediaFilter` : `MediaFilter.minimal`
  ///
  ///```dart
  /// var api = Tenor(apiKey: 'Tenor Api');
  ///
  /// TenorResponse res = await api.requestTrendingGIF(limit: 5);
  ///```
  Future<TenorResponse> requestTrendingGIF({
    int limit = 20,
    ContentFilter contentFilter = ContentFilter.off,
    GifSize size = GifSize.all,
    MediaFilter mediaFilter = MediaFilter.minimal,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/trending_terms?key=$apiKey&client_key=$secret&limit=$limit';
    return await tenorRequestGif(
      url,
      limit: limit,
      contentFilter: contentFilter,
      mediaFilter: mediaFilter,
      pos: null,
    );
  }

  /// Requests Gif from tenor
  ///
  ///```dart
  /// var api = Tenor(apiKey: 'Tenor Api');
  ///
  /// TenorResponse res = await api.searchGIF('universe', limit: 5);
  ///```
  Future<TenorResponse> searchGIF(
    String search, {
    int limit = 20,
    ContentFilter contentFilter = ContentFilter.off,
    GifSize size = GifSize.all,
    MediaFilter mediaFilter = MediaFilter.minimal,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/search?q=$search&key=$apiKey&client_key=$secret&limit=$limit';

    // var url =
    //     'https://g.tenor.com/v1/search?key=$apiKey&locale=$language&q=$search';
    return await tenorRequestGif(
      url,
      limit: limit,
      contentFilter: contentFilter,
      size: size,
      mediaFilter: mediaFilter,
      pos: null,
    );
  }

  /// Get a randomized list of GIFs for a given search term. This differs from the search endpoint which returns a rank ordered list of GIFs for a given search term.
  ///```dart
  ///
  /// var api = Tenor(apiKey: 'Tenor Api');
  /// TenorResponse res = await api.searchGIF('universe', limit: 5);
  ///```
  Future<TenorResponse> randomGIF(
    String search, {
    int limit = 20,
    ContentFilter contentFilter = ContentFilter.off,
    GifSize size = GifSize.all,
    MediaFilter mediaFilter = MediaFilter.minimal,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/search?q=$search&key=$apiKey&client_key=$secret&limit=$limit';

    // var url =
    //     'https://g.tenor.com/v1/random?key=$apiKey&locale=$language&q=$search';
    return await tenorRequestGif(
      url,
      limit: limit,
      contentFilter: contentFilter,
      size: size,
      mediaFilter: mediaFilter,
      pos: null,
    );
  }

  /// Search suggestions helps a user narrow their search or discover related search terms to find a more precise GIF. Results are returned in order of what is most likely to drive a share for a given term, based on historic user search and share behavior.
  ///```dart
  ///
  /// var api = Tenor(apiKey: 'Tenor Api');
  /// List<String> suggestions = await api.searchSuggestions('un', limit: 5);
  ///```
  Future<List<String>> searchSuggestions(
    String search, {
    int limit = 20,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/search_suggestions?q=$search&key=$apiKey&client_key=$secret&limit=$limit';

    return await tenorSearchSuggestions(
      url,
      limit: limit,
    );
  }

  /// Returns response containing a list of the current trending search terms. The list is updated Hourly by Tenor’s AI.
  /// ```dart
  ///
  /// var api = Tenor(apiKey: 'Tenor Api');
  /// List<String> trendingSearch = await api.trendingSearch(limit: 5);
  ///```
  Future<List<String>> trendingSearch({
    int limit = 20,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/trending_terms?key=$apiKey&client_key=$secret&limit=$limit';

    return await tenorSearchSuggestions(
      url,
      limit: limit,
    );
  }

  /// Returns response containing a list of completed search terms given a partial search term. The list is sorted by `Tenor’s AI` and the number of results will decrease as `Tenor’s AI` becomes more certain.
  ///```dart
  /// var api = Tenor(apiKey: 'Tenor Api');
  ///
  /// List<String> autoCompletedItems = await api.autoComplete('un', limit: 5);
  ///```
  Future<List<String>> autoComplete(
    String search, {
    int limit = 20,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/autocomplete?key=$apiKey&client_key=$secret&limit=$limit';

    return await tenorSearchSuggestions(
      url,
      limit: limit,
    );
  }

  /// Requests `Categories` from tenor
  ///
  ///```dart
  /// var api = Tenor(apiKey: 'Tenor Api');
  ///
  /// TenorCategories res = await api.requestCategories();
  ///```
  Future<List<TenorCategories>> requestCategories({
    ContentFilter contentFilter = ContentFilter.off,
    CategoryType categoryType = CategoryType.featured,
  }) async {
    var url =
        'https://tenor.googleapis.com/v2/categories?key=$apiKey&client_key=$secret';

    return await tenorTenorCategories(
      url,
      contentFilter: contentFilter,
      categoryType: categoryType,
    );
  }
}
