import 'dart:convert';

import 'package:flutter/foundation.dart';

class GameHistory {
  final String gameCode;
  final DateTime dateEnded;
  final DateTime expireAt;
  final String path;

  String _extractedPath;

  get extractedPath => _extractedPath;

  void updateExtractedPath(String extractedPath) {
    this._extractedPath = extractedPath;
  }

  GameHistory({
    @required this.gameCode,
    @required this.dateEnded,
    @required this.expireAt,
    @required this.path,
  });

  bool isExpired() {
    return DateTime.now().isAfter(expireAt);
  }

  factory GameHistory.fromJson(String json) {
    final data = jsonDecode(json);

    return GameHistory(
      gameCode: data['gameCode'],
      dateEnded: DateTime.parse(data['dateEnded']).toLocal(),
      expireAt: DateTime.parse(data['expireAt']).toLocal(),
      path: data['path'],
    );
  }

  String toJson() {
    return jsonEncode({
      'gameCode': this.gameCode,
      'dateEnded': this.dateEnded.toIso8601String(),
      'expireAt': this.expireAt.toIso8601String(),
      'path': this.path,
    });
  }
}
