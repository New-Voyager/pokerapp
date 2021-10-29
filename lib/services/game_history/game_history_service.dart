import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_history/model/game_history.dart';
import 'package:pokerapp/utils/formatter.dart';

class GameHistoryServiceImpl {
  GameHistoryServiceImpl();
  GameHistoryStore _store;
  Map<String, List<Map<String, dynamic>>> _cachedHands;

  init({String dataDir}) async {
    _store = GameHistoryStore();
    if (dataDir == null) {
      dataDir = (await getApplicationDocumentsDirectory()).path;
    }
    String historyDir = '$dataDir/history';
    Directory(historyDir).createSync(recursive: true);
    _store.init(historyDir);
    _cachedHands = Map<String, List<Map<String, dynamic>>>();
  }

  Future<HandResultData> getHandLog(String gameCode, int handNum) async {
    final list = await this.getHandHistoryList(gameCode);
    // find the hand number
    for (final handJson in list) {
      int num = handJson['handNum'] as int;
      if (handNum == num) {
        HandResultData data = HandResultData.fromJson(handJson['data']);
        return data;
      }
    }
    return null;
  }

  Future<HandHistoryListModel> getHandHistory(
      String gameCode, int playerId) async {
    HandHistoryListModel ret = HandHistoryListModel(gameCode, true);
    final list = await this.getHandHistoryList(gameCode);
    List<HandHistoryItem> allHands = [];
    List<HandHistoryItem> winningHands = [];
    for (final handJson in list) {
      /*
       class HandHistoryItem {
          List<Winner> winners;
          List<Winner> lowWinners;
          List<int> community;
          List<int> community1;
        }
      */
      HandHistoryItem item = HandHistoryItem();
      item.handNum = handJson['handNum'] as int;
      dynamic summary = handJson['summary'] as Map<String, dynamic>;
      item.noCards = summary['noCards'];
      DateTime started = DateTime.tryParse(handJson['timeStarted']);
      DateTime ended = DateTime.tryParse(handJson['timeEnded']);
      int handTime = 0;
      if (ended != null && started != null) {
        handTime = ended.difference(started).inSeconds;
      }
      if (handTime == 0) {
        handTime = 1;
      }
      item.handTime = DataFormatter.minuteFormat(handTime);
      item.authorized = true;

      dynamic boardCards = summary['boardCards'];
      if (boardCards != null) {
        if (boardCards.length > 1) {
          item.community1 = List<int>.from(boardCards[1]);
        }

        if (boardCards.length >= 1) {
          item.community = List<int>.from(boardCards[0]);
        }
      }
      bool showCards = false;

      /*
        PREFLOP,
        FLOP,
        TURN,
        RIVER,
        SHOW_DOWN,
      */
      int wonAt = handJson['wonAt'] as int;
      if (wonAt == 4) {
        showCards = true;
      }

      if (wonAt == 1) {
        item.community = item.community.sublist(0, 3);
      } else if (wonAt == 2) {
        item.community = item.community.sublist(0, 4);
      } else if (wonAt == 3) {
        item.community = item.community.sublist(0, 5);
      }

      List hiWinners = summary['hiWinners'] as List;
      item.winners = [];
      bool playerWon = false;
      for (final winnnerData in hiWinners) {
        final winner = Winner.fromJson(null, item.noCards, winnnerData,
            showCards: showCards);
        item.winners.add(winner);
        if (winner.id == playerId) {
          playerWon = true;
        }
      }
      allHands.add(item);
      if (playerWon) {
        winningHands.add(item);
      }
    }
    ret.allHands = allHands;
    ret.winningHands = winningHands;
    ret.jsonData = list;
    return ret;
  }

  Future<List<Map<String, dynamic>>> getHandHistoryList(
      final String gameCode) async {
    if (_cachedHands[gameCode] != null) {
      return _cachedHands[gameCode];
    }
    // check if available locally
    GameHistory gameHistory = _store.get(gameCode);
    if (gameHistory == null) {
      // history is not available
      // get the completed game data
      GameHistoryDetailModel history = GameHistoryDetailModel(gameCode, false);
      history = await GameService.getGameHistoryDetail(history);
      if (history == null) {
        throw new Exception('Game $gameCode is not found in the server');
      }
      String gameDataDir = '${_store.dataDir}/$gameCode';
      await Directory(gameDataDir)
        ..create(recursive: true);
      if (history.handDataLink != null) {
        String handDataFile = '${gameDataDir}/hand.dat';
        // perform the download operation and return the file
        final File downloadedHandData = await _downloadGameHistory(
          history.handDataLink,
          handDataFile,
        );

        if (downloadedHandData == null) {
          log("game_history_service : COULD NOT download compressed game history data");
          return null;
        }
      }

      // create GameHistory object
      final expireTime = DateTime.now().add(const Duration(days: 30));
      gameHistory = GameHistory(
        gameCode: gameCode,
        dateEnded: expireTime,
        expireAt: expireTime,
        path: gameDataDir,
      );
      // save gameHistory to Hive
      await _store.put(history, gameHistory);
    }

    // decompress json file
    String handDataFile = '${gameHistory.path}/hand.dat';
    final bytes = File(handDataFile).readAsBytesSync();
    final json = jsonDecode(String.fromCharCodes(zlib.decode(bytes)));
    // print(json);
    // HandHistoryListModel model = HandHistoryListModel(gameCode, true);
    // model.jsonData = jsonDecode(json);
    // model.load();

    // remove some data if the cache has more than 10 values
    if (_cachedHands.keys.length > 10) {
      List<String> keys = _cachedHands.keys.map((e) => e);
      for (int i = 0; i < 5; i++) {
        _cachedHands.remove(keys[i]);
      }
    }

    final handList1 = json as List<dynamic>;
    final handList = handList1.map((e) => e as Map<String, dynamic>).toList();
    _cachedHands[gameCode] = handList;
    return handList;

    // TODO: EXTRACTED IF NOT ALREADY
    // TODO: THEN READ THE .json FILE (STORE INTO MEMORY as Map or Object)
    // TODO: THEN RETURN that Map or Object
  }

  Future<File> _downloadGameHistory(String downloadUrl, String path) async {
    final response = await http.get(Uri.parse(downloadUrl));

    if (response.statusCode == HttpStatus.ok) {
      final file = File(path);
      file.create(recursive: true);
      return file.writeAsBytes(response.bodyBytes);
    }
    return null;
  }

  // method to clean up all expired caches
  Future<void> cleanupExpired() async {
    for (final history in _store.all()) {
      if (history.isExpired()) {
        _store.remove(history);
      }
    }
  }
}

GameHistoryServiceImpl GameHistoryService = GameHistoryServiceImpl();
