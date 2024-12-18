// ignore: must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  String previewUrl;
  Size size;

  TenorResult(
      {this.hasCaption = false,
      this.hasaudio = false,
      this.shares = 0,
      this.id,
      this.title,
      this.created,
      this.url,
      this.itemurl,
      this.media,
      this.cache,
      this.previewUrl,
      this.size});

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
      'previewUrl': previewUrl,
      'size': {'width': size.width, 'height': size.height},
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
    String previewUrl = '';
    if (map['media_formats'] != null &&
        map['media_formats']["tinygif"] != null) {
      previewUrl = map['media_formats']["tinygif"]["url"];
    }
    Size size;
    if (map['media_formats'] != null &&
        map['media_formats']["tinygif"] != null) {
      int width = map['media_formats']["tinygif"]["dims"][0];
      int height = map['media_formats']["tinygif"]["dims"][0];
      size = Size(width.toDouble(), height.toDouble());
    }
    if (map['media'] != null && map['media']["tinygif"] != null) {
      previewUrl = map['media']["tinygif"]["url"];
    }

    if (map['size'] != null) {
      size = Size(map['size']['width'], map['size']['height']);
    }

    if (map['previewUrl'] != null) {
      previewUrl = map['previewUrl'];
    }

    return TenorResult(
      hasCaption: map['hascaption'] ?? false,
      hasaudio: map['hasaudio'] ?? false,
      shares: map['shares'] ?? 0,
      id: map['id'],
      title: map['title'],
      created: '${map['created']}',
      url: map['url'],
      previewUrl: previewUrl,
      itemurl: map['itemurl'],
      media: TenorGif.fromMap(media),
      cache: map['cache'],
      size: size,
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
