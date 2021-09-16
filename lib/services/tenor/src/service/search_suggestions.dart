import 'server_request.dart';

/// Request Gif with `Search` parameter
Future<List<String>> tenorSearchSuggestions(
  String url, {
  int limit = 1,
}) async {
  url += '&limit=${limit.clamp(1, 50)}';

  var data = await tenorServerRequest(url);
  if (data != null && data.isNotEmpty) {
    return (data['results'] as List).map((e) => '$e').toList();
  }
  return <String>[];
}
