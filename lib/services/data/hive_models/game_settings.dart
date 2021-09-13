import 'package:pokerapp/services/data/game_hive_store.dart';

class GameConfiguration {
  GameHiveStore _gameHiveStore;

  // this function is invoked everytime something in game settings changes
  // this function saves the game settings to the local storage
  Future<void> _save() {
    return _gameHiveStore.putGameSettings(this);
  }

  String get gameCode => _gameCode;
  String _gameCode;

  bool get muckLosingHand => _muckLosingHand;
  bool _muckLosingHand = false;
  set muckLosingHand(bool value) {
    _muckLosingHand = value;
    _save();
  }

  bool get gameSound => _gameSound;
  bool _gameSound = true;
  set gameSound(bool value) {
    _gameSound = value;
    _save();
  }

  bool get audioConf => _audioConf;
  bool _audioConf = true;
  set audioConf(bool value) {
    _audioConf = value;
    _save();
  }

  bool get straddleOption => _straddleOption;
  bool _straddleOption = true;
  set straddleOption(bool value) {
    _straddleOption = value;
    _save();
  }

  bool get autoStraddle => _autoStraddle;
  bool _autoStraddle = false;
  set autoStraddle(bool value) {
    _autoStraddle = value;
    _save();
  }

  bool get animations => _animations;
  bool _animations = true;
  set animations(bool value) {
    _animations = value;
    _save();
  }

  bool get showChat => _showChat;
  bool _showChat = true;
  set showChat(bool value) {
    _showChat = value;
    _save();
  }

  GameConfiguration(this._gameCode, this._gameHiveStore);

  // this method only to be called for the first time
  Future<void> init() async {
    await _save();
  }

  Map<String, dynamic> toJson() => {
        'gameCode': this._gameCode,
        'muckLosingHand': this._muckLosingHand,
        'gameSound': this._gameSound,
        'audioConf': this._audioConf,
        'straddleOption': this._straddleOption,
        'autoStraddle': this._autoStraddle,
        'animations': this._animations,
        'showChat': this._showChat,
      };

  GameConfiguration.fromJson(Map<String, dynamic> json, this._gameHiveStore) {
    this._gameCode = json['gameCode'];
    this._muckLosingHand = json['muckLosingHand'];
    this._gameSound = json['gameSound'];
    this._audioConf = json['audioConf'];
    this._autoStraddle = json['autoStraddle'];
    this._straddleOption = json['straddleOption'];
    this._animations = json['animations'];
    this._showChat = json['showChat'];
  }
}
