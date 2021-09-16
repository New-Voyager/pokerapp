// ignore: must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pokerapp/services/tenor/src/service/gif_fetcher.dart';
import 'package:pokerapp/services/tenor/src/utility/enums.dart';

import 'tenor_result.dart';

class TenorResponse extends Equatable {
  List<TenorResult> results;
  String next;
  final String url;
  ContentFilter contentFilter;
  MediaFilter mediaFilter;
  TenorResponse({
    this.results,
    this.next,
    this.url,
    this.contentFilter = ContentFilter.high,
    this.mediaFilter = MediaFilter.basic,
  });

  Map<String, dynamic> toMap() {
    return {
      'results': results.map((x) => x.toMap()).toList(),
      'next': next,
      'contentFilter': contentFilter.toString(),
      'mediaFilter': mediaFilter.toString(),
    };
  }

  static TenorResponse fromMap(Map<String, dynamic> map, {String urlNew}) {
    if (map == null) return null;
    return TenorResponse(
      results: List<TenorResult>.from(
          map['results']?.map((x) => TenorResult.fromMap(x)) ??
              <TenorResult>[]),
      next: map['next'],
      url: urlNew,
      contentFilter: map['contentFilter'] ?? ContentFilter.high,
      mediaFilter: map['mediaFilter'] ?? MediaFilter.basic,
    );
  }

  Future<TenorResponse> fetchNext({int limit = 1}) {
    return tenorRequestGif(
      url,
      limit: limit,
      contentFilter: null, // this is done on purpose
      size: null, // this is done on purpose
      mediaFilter: null, // this is done on purpose
      pos: next,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'TenorResponse(results: $results, next: $next)';

  static TenorResponse fromJson(String source) =>
      TenorResponse.fromMap(json.decode(source));

  @override
  List<Object> get props => [results];
}
