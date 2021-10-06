import 'package:pokerapp/services/data/game_hive_store.dart';

class GameLocalConfig {
  GameHiveStore _gameHiveStore;

  // this function is invoked everytime something in game settings changes
  // this function saves the game settings to the local storage
  Future<void> _save() {
    return _gameHiveStore.putGameSettings(this);
  }

  String get gameCode => _gameCode;
  String _gameCode;

  bool get gameSound => _gameSound;
  bool _gameSound = true;

  // Show check and fold
  bool _showCheckFold = true;
  get showCheckFold => _showCheckFold;
  set showCheckFold(bool value) {
    _showCheckFold = value;
    _save();
  }

// Show rearrange button
  bool _showRearrange = true;
  get showRearrange => _showRearrange;
  set showRearrange(bool value) {
    _showRearrange = value;
    _save();
  }

  set gameSound(bool value) {
    _gameSound = value;
    _save();
  }

  get mute {
    return !_gameSound;
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

  bool get straddle => _straddle;
  bool _straddle = true;
  set straddle(bool value) {
    _straddle = value;
    _save();
  }

  bool _inAudioConference = true;
  bool get inAudioConference => _inAudioConference;
  set inAudioConference(bool value) {
    _inAudioConference = value;
    _save();
  }

  bool get tapOrSwipeBetAction {
    if (_tapOrSwipeBetAction == null) {
      return true;
    }
    return _tapOrSwipeBetAction;
  }

  bool _tapOrSwipeBetAction = false;
  set tapOrSwipeBetAction(bool value) {
    _tapOrSwipeBetAction = value;
    _save();
  }

  GameLocalConfig(this._gameCode, this._gameHiveStore);

  // this method only to be called for the first time
  Future<void> init() async {
    await _save();
  }

  Map<String, dynamic> toJson() => {
        'gameCode': this._gameCode,
        'gameSound': this._gameSound,
        'animations': this._animations,
        'showChat': this._showChat,
        'straddle': this._straddle,
        'inAudioConference': this._inAudioConference,
        'tapOrSwipeBetAction': this._tapOrSwipeBetAction,
        'showCheckFold': this._showCheckFold,
        'showRearrange': this._showRearrange
      };

  GameLocalConfig.fromJson(Map<String, dynamic> json, this._gameHiveStore) {
    this._gameCode = json['gameCode'];
    this._gameSound = json['gameSound'];
    this._animations = json['animations'];
    this._showChat = json['showChat'];
    this._straddle = json['straddle'];
    this._inAudioConference = json['inAudioConference'];
    this._tapOrSwipeBetAction = json['tapOrSwipeBetAction'];
    this._showCheckFold = json['showCheckFold'];
    this._showRearrange = json['showRearrange'];
  }
}
