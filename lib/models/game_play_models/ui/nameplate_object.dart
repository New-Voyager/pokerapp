import 'dart:convert';

import 'package:flutter/material.dart';

class NamePlateDesignMeta {
  int svgWidth;
  int svgHeight;
  int progressWidth;
  int progressHeight;
  String padding;
  NamePlateDesignMeta(
      {@required this.svgWidth,
      @required this.svgHeight,
      @required this.progressWidth,
      @required this.progressHeight,
      @required this.padding});

  Map<String, dynamic> toMap() {
    return {
      'svgWidth': svgWidth,
      'svgHeight': svgHeight,
      'progressWidth': progressWidth,
      'progressHeight': progressHeight,
      'padding': padding,
    };
  }

  factory NamePlateDesignMeta.fromMap(Map<String, dynamic> map) {
    return NamePlateDesignMeta(
      svgWidth: map['svgWidth'],
      svgHeight: map['svgHeight'],
      progressWidth: map['progressWidth'],
      progressHeight: map['progressHeight'],
      padding: map['padding'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NamePlateDesignMeta.fromJson(String source) =>
      NamePlateDesignMeta.fromMap(json.decode(source));
}

class NamePlateDesign {
  String id;
  String svg;
  String path;
  NamePlateDesignMeta meta;

  NamePlateDesign(
      {@required this.id,
      @required this.svg,
      @required this.path,
      @required this.meta});

  Map<String, dynamic> toMap() {
    return {'id': id, 'svg': svg, 'path': path, 'meta': meta.toMap()};
  }

  factory NamePlateDesign.fromMap(Map<String, dynamic> map) {
    return NamePlateDesign(
      id: map['id'],
      svg: map['svg'],
      path: map['path'],
      meta: NamePlateDesignMeta.fromMap(map['meta']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NamePlateDesign.fromJson(String source) =>
      NamePlateDesign.fromMap(json.decode(source));
}
