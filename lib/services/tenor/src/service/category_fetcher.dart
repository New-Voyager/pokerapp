
import 'package:pokerapp/services/tenor/src/model/category.dart';
import 'package:pokerapp/services/tenor/src/utility/enums.dart';

import 'server_request.dart';

/// Request `Category`
Future<List<TenorCategories>> tenorTenorCategories(
  String url, {
  CategoryType categoryType = CategoryType.featured,
  ContentFilter contentFilter = ContentFilter.high,
}) async {
  url += '&contentfilter=' + contentFilter.toString().split('.').last;

  url += '&type=' + categoryType.toString().split('.').last;

  var data = await tenorServerRequest(url);
  var res = <TenorCategories>[];
  if (data != null && data['tags'] != null) {
    data['tags'].forEach((tag) {
      res.add(TenorCategories.fromMap(tag));
    });
  }
  return res;
}
