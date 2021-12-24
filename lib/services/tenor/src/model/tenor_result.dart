// ignore: must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_gif.dart';

class TenorResult extends Equatable {
  bool hasCaption = false;
  bool hasaudio = false;
  int shares;
  String id;
  String title;
  String created;
  String url;
  String itemurl;
  String cache;
  TenorGif media;
  TenorResult({
    this.hasCaption = false,
    this.hasaudio = false,
    this.shares = 0,
    this.id,
    this.title,
    this.created,
    this.url,
    this.itemurl,
    this.media,
    this.cache,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasCaption': hasCaption,
      'hasaudio': hasaudio,
      'shares': shares,
      'id': id,
      'title': title,
      'created': created,
      'url': url,
      'itemurl': itemurl,
      'media': media?.toMap(),
      'cache': cache,
    };
  }

  static TenorResult fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Map<String, dynamic> media;

    dynamic rawMedia = map['media'];

    if (rawMedia == null) {
      media = <String, dynamic>{};
    } else if (rawMedia is List && rawMedia.isNotEmpty) {
      media = rawMedia[0];
    } else {
      media = rawMedia;
    }

    return TenorResult(
      hasCaption: map['hascaption'] ?? false,
      hasaudio: map['hasaudio'] ?? false,
      shares: map['shares'] ?? 0,
      id: map['id'],
      title: map['title'],
      created: '${map['created']}',
      url: map['url'],
      itemurl: map['itemurl'],
      media: TenorGif.fromMap(media),
      cache: map['cache'],
    );
  }

  String toJson() => json.encode(toMap());

  static TenorResult fromJson(String source) =>
      TenorResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TenorResult(hasCaption: $hasCaption, hasaudio: $hasaudio, shares: $shares, id: $id, title: $title, created: $created, url: $url, itemurl: $itemurl, media: $media, cache: $cache)';
  }

  @override
  List<Object> get props => [
        hasCaption,
        hasaudio,
        shares,
        id,
        title,
        created,
        url,
        itemurl,
        media,
        cache
      ];
}
