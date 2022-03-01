import 'dart:convert';

import 'package:hive/hive.dart';

/*
PlayerState
    1 default betting config
        {
            "preflop": [ 2, 5, 10],       // BB
            "postflop": [ 30, 50, 100]    // % pot
            "raise": [2, 5, 10]           // x Raise
        }
    2 last system announcement read id
    3 TOC date
    4 playerId
    5 playerUuid
    6 name
*/

class PlayerState {
  Box _box;

  DateTime _tocAcceptDate;
  DateTime _lastReadSysAnnounceDate;
  int _playerId;
  String _playerUuid;
  String _playerName;
  int unreadAnnouncements;
  int _diamonds;

  static const TOC_ACCEPT_DATE = 'toc_accept_date';
  static const PLAYER_ID = 'player_id';
  static const PLAYER_UUID = 'player_uuid';
  static const PLAYER_NAME = 'player_name';
  static const SYS_ANNOUNCEMENT_READ_DATE = 'sys_announcement_read_date';
  static const DIAMONDS = 'diamonds';

  PlayerState();

  Future<Box> open() async {
    if (_box != null) {
      return _box;
    }
    _box = await Hive.openBox('player_state');

    bool newData = false;
    // set default values
    String tocAcceptDate = _box.get(TOC_ACCEPT_DATE);
    if (tocAcceptDate == null) {
      _tocAcceptDate = DateTime.now();
      newData = true;
    } else {
      try {
        _tocAcceptDate = DateTime.parse(tocAcceptDate);
      } catch (err) {
        _tocAcceptDate = DateTime.now();
      }
    }

    _playerId = _box.get(PLAYER_ID) as int;
    _playerUuid = _box.get(PLAYER_UUID) as String;
    _playerName = _box.get(PLAYER_NAME) as String;
    String lastReadSysAnnounceDate = _box.get(SYS_ANNOUNCEMENT_READ_DATE);
    if (lastReadSysAnnounceDate == null) {
      _lastReadSysAnnounceDate = DateTime.now();
    } else {
      try {
        _lastReadSysAnnounceDate = DateTime.parse(lastReadSysAnnounceDate);
      } catch (err) {
        _lastReadSysAnnounceDate = DateTime.now();
      }
    }
    _diamonds = _box.get(DIAMONDS) as int;
    if (_diamonds == null) {
      _diamonds = 50;
    }

    if (newData) {
      _save();
    }
    return _box;
  }

  void _save() {
    open();

    _box.put(PLAYER_ID, _playerId);
    _box.put(PLAYER_UUID, _playerUuid);
    _box.put(PLAYER_NAME, _playerName);
    _box.put(TOC_ACCEPT_DATE, _tocAcceptDate.toIso8601String());
    _box.put(
        SYS_ANNOUNCEMENT_READ_DATE, _lastReadSysAnnounceDate.toIso8601String());
    _box.put(DIAMONDS, _diamonds);
  }

  bool isInitialized() {
    return _box.isOpen;
  }

  void close() {
    if (_box?.isOpen ?? false) {
      _box?.close();
    }
    _box = null;
  }

  // add get/set properties
  void updatePlayerInfo({String playerUuid, int playerId, String playerName}) {
    open();
    _playerUuid = playerUuid;
    _playerId = playerId;
    _playerName = playerName;
    _box.put(PLAYER_ID, _playerId);
    _box.put(PLAYER_UUID, _playerUuid);
    _box.put(PLAYER_NAME, _playerName);
  }

  int get playerId => _playerId;
  String get playerUuid => _playerUuid;
  String get playerName => _playerName;

  void updateTocAcceptDate() {
    _tocAcceptDate = DateTime.now();
    _box.put(TOC_ACCEPT_DATE, _tocAcceptDate.toIso8601String());
  }

  DateTime get tocAcceptDate => this._tocAcceptDate;

  bool isTocUpdated(DateTime serverTocDate) {
    if (serverTocDate.isAfter(_tocAcceptDate)) {
      return true;
    }
    return false;
  }

  void updateSysAnnounceReadDate() {
    _lastReadSysAnnounceDate = DateTime.now();
    _box.put(
        SYS_ANNOUNCEMENT_READ_DATE, _lastReadSysAnnounceDate.toIso8601String());
  }

  int get diamonds => this._diamonds;
  void addDiamonds(int diamonds) {
    _diamonds += diamonds;
    _box.put(DIAMONDS, _diamonds);
  }

  bool deductDiamonds(int diamonds) {
    if (_diamonds < diamonds) {
      return false;
    }
    _diamonds -= diamonds;
    if (_diamonds < 0) {
      _diamonds = 0;
    }
    _box.put(DIAMONDS, _diamonds);
    return true;
  }

  List<String> getFriendsGameCodes() {
    List<String> gameCodes = [];
    String json = _box.get('friends_game_codes');
    if (json != null) {
      final codes = jsonDecode(json);
      for (var code in codes) {
        gameCodes.add(code);
      }
    } else {
      _box.put('friends_game_codes', jsonEncode(gameCodes));
    }
    return gameCodes;
  }

  List<String> removeFriendsGameCodes(String gameCode) {
    List<String> gameCodes = [];
    String json = _box.get('friends_game_codes');
    if (json != null) {
      final codes = jsonDecode(json);
      for (var code in codes) {
        gameCodes.add(code);
      }
      gameCodes.remove(gameCode);
      _box.put('friends_game_codes', jsonEncode(gameCodes));
    }
    return gameCodes;
  }

  List<String> addFriendsGameCodes(String gameCode) {
    List<String> gameCodes = [];
    String json = _box.get('friends_game_codes');
    if (json != null) {
      final codes = jsonDecode(json);
      for (var code in codes) {
        gameCodes.add(code);
      }
      gameCodes.add(gameCode);
      _box.put('friends_game_codes', jsonEncode(gameCodes));
    }
    return gameCodes;
  }

  DateTime get lastReadSysAnnounceDate => this._lastReadSysAnnounceDate;
}

PlayerState playerState = PlayerState();
