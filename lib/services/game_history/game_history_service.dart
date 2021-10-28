import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/game_history/model/game_history.dart';

class GameHistoryService {
  GameHistoryService._();

  static GameHistoryService _instance;

  static GameHistoryService get getInstance =>
      _instance ??= GameHistoryService._();

  Box _gameHistoryBox =
      HiveDatasource.getInstance.getBox(BoxType.GAME_HISTORY_BOX);

  Future<HandHistoryListModel> getHandLog(final String gameCode) async {
    // check if available locally
    if (_gameHistoryBox.containsKey(gameCode)) {
      final gameHistory = GameHistory.fromJson(_gameHistoryBox.get(gameCode));

      // TODO: EXTRACTED IF NOT ALREADY
      // TODO: THEN READ THE .json FILE (STORE INTO MEMORY as Map or Object)
      // TODO: THEN RETURN that Map or Object
      return null;
    } else {
      // TODO: GET THE DATA DOWNLOAD URL -> the url will comes from the GraphQL API
      final String downloadUrl =
          "https://hands-pokerclub.nyc3.digitaloceanspaces.com/game/cggrbojg/hand.dat";

      // perform the download operation and return the file
      final File compressedData = await _downloadGameHistory(
        downloadUrl,
        gameCode,
      );

      if (compressedData == null) {
        log("game_history_service : COULD NOT download compressed game history data");
        return null;
      }

      // create GameHistory object
      final expireTime = DateTime.now().add(const Duration(days: 30));
      final gameHistory = GameHistory(
        gameCode: gameCode,
        dateEnded: expireTime,
        expireAt: expireTime,
        path: compressedData.path,
      );

      // save gameHistory to Hive
      await _gameHistoryBox.put(gameCode, gameHistory.toJson());

      // finally extract the data, read the json and return the object
      // next time we call this same function, we will have the data downloaded
      return GameHistoryService.getInstance.getHandLog(gameCode);
    }
  }

  Future<File> _downloadGameHistory(String downloadUrl, String gameCode) async {
    final response = await http.get(Uri.parse(downloadUrl));

    if (response.statusCode == HttpStatus.ok) {
      final dir = await getApplicationDocumentsDirectory();

      final file = File("${dir.path}/history/$gameCode/compressed.zip");
      file.create(recursive: true);

      return file.writeAsBytes(response.bodyBytes);
    }

    return null;
  }

  // method to clean up all expired caches
  Future<void> cleanupExpired() async {
    List<String> gameCodesExpired = [];

    for (final String gameCode in _gameHistoryBox.keys) {
      final gameHistory = GameHistory.fromJson(_gameHistoryBox.get(gameCode));
      // check if the game history cache is expired
      if (gameHistory.isExpired()) {
        // remove all the relevant files
        await _cleanupDirs(gameHistory);

        // finally collect for removing from hive
        gameCodesExpired.add(gameCode);
      }
    }

    // remove all game keys from hive
    await _gameHistoryBox.deleteAll(gameCodesExpired);
  }

  Future<void> _cleanupDirs(final GameHistory gameHistory) async {
    // delete the parent directory

    // /history/gamecode/handlog.json -> extracted (un-compressed)
    //                  /handlog.dat -> compressed

    // thus, delete /history/gamecode -> gamecode directory
    final file = File(gameHistory.path);
    await file.parent.delete(recursive: true);
  }
}
