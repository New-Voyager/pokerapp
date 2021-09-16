
import 'package:pokerapp/services/tenor/src/model/tenor_response.dart';
import 'package:pokerapp/services/tenor/src/utility/enums.dart';

import 'server_request.dart';

/// Request Gif with `Search` parameter
Future<TenorResponse> tenorRequestGif(
  String url, {
  int limit = 1,
  ContentFilter contentFilter = ContentFilter.off,
  GifSize size = GifSize.all,
  MediaFilter mediaFilter = MediaFilter.minimal,
  String pos,
}) async {
  // storing the temp url for fetching the next counts.
  var tempUrl = url;

  url += '&limit=${limit.clamp(1, 50)}';

  if (contentFilter != null) {
    url += '&contentfilter=' + contentFilter.toString().split('.').last;
  }
  if (mediaFilter != null) {
    url += '&media_filter=' + mediaFilter.toString().split('.').last;
  }
  if (size != null) {
    url += '&ar_range=' + size.toString().split('.').last;
  }
  if (pos != null) {
    url += '&pos=$pos';
  }

  var data = await tenorServerRequest(url);
  TenorResponse res;
  if (data != null && data.length > 0) {
    res = TenorResponse.fromMap(data, urlNew: tempUrl);
  }
  return res;
}
