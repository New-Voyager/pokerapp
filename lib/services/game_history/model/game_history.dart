import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';

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

class GameHistoryStore {
  Box _box;
  String _dataDir;

  String get dataDir => _dataDir;

  void init(String dataDir) {
    _box = HiveDatasource.getInstance.getBox(BoxType.GAME_HISTORY_BOX);
    _dataDir = dataDir;
  }

  GameHistory get(String gameCode) {
    if (_box.containsKey(gameCode)) {
      return GameHistory.fromJson(_box.get(gameCode));
    }
    return null;
  }

  void put(GameHistoryDetailModel model, GameHistory history) {
    _box.put(history.gameCode, history.toJson());
  }

  List<GameHistory> all() {
    List<GameHistory> list = [];
    for (final String gameCode in _box.keys) {
      final gameHistory = GameHistory.fromJson(_box.get(gameCode));
      list.add(gameHistory);
    }
    return list;
  }

  void remove(GameHistory history) {
    try {
      _box.delete(history.gameCode);
      Directory(history.path).deleteSync(recursive: true);
    } catch (e) {
      // ignore this exception
    }
  }
}
