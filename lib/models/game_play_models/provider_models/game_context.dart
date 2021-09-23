import 'package:flutter/material.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/ion/ion.dart';
import 'package:pokerapp/widgets/dialogs.dart';

import 'game_state.dart';

class GameContextObject extends ChangeNotifier {
  String _gameCode;
  int _gameId;

  PlayerInfo get currentPlayer => _currentPlayer;
  PlayerInfo _currentPlayer;

  bool _gameEnded = false;
  GameState gameState;
  HandActionProtoService handActionProtoService;
  GameUpdateService gameUpdateService;
  GameComService gameComService;
  EncryptionService encryptionService;
  IonAudioConferenceService ionAudioConferenceService;

  GameContextObject({
    @required String gameCode,
    @required PlayerInfo player,
    GameState gameState,
    GameUpdateService gameUpdateService,
    //HandActionService handActionService,
    HandActionProtoService handActionProtoService,
    GameComService gameComService,
    EncryptionService encryptionService,
  }) {
    this._gameCode = gameCode;
    this._currentPlayer = player;
    this._gameId = 0;
    this.gameComService = gameComService;
    this.encryptionService = encryptionService;
    this.gameState = gameState;
    this.gameUpdateService = gameUpdateService;
    this.handActionProtoService = handActionProtoService;
  }

  void initializeAudioConf() {
    if (this.ionAudioConferenceService != null) {
      return;
    }
    this.ionAudioConferenceService = IonAudioConferenceService(
        gameState,
        gameComService.chat,
        gameState.gameInfo.sfuUrl,
        gameState.gameInfo.gameCode,
        this._currentPlayer);
  }

  set gameEnded(bool ended) {
    if (ended == _gameEnded) return;
    this._gameEnded = ended;
    notifyListeners();
  }

  int get gameId => _gameId;
  String get gameCode => _gameCode;
  bool get gameEnded => _gameEnded;
  String get playerUuid => _currentPlayer.uuid;
  int get playerId => _currentPlayer.id;

  bool isAdmin() {
    if (_currentPlayer?.role?.isHost == true ||
        _currentPlayer?.role?.isManager == true ||
        _currentPlayer?.role?.isOwner == true) return true;

    return false;
  }

  bool isHost() {
    if (_currentPlayer?.role?.isHost == true) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    //handActionService?.close();
    this.ionAudioConferenceService.close();
    gameUpdateService?.close();
    gameComService?.dispose();
    encryptionService?.dispose();
    handActionProtoService?.close();
    super.dispose();
  }

  void joinAudio(BuildContext context) async {
    if (gameState.audioConfEnabled) {
      try {
        this.initializeAudioConf();
        await this.ionAudioConferenceService.join();
        gameState.communicationState.audioConferenceStatus =
            AudioConferenceStatus.CONNECTED;
        this.gameState.playerLocalConfig.inAudioConference = true;
        this.gameState.communicationState.notify();
      } catch (err) {
        gameState.communicationState.audioConferenceStatus =
            AudioConferenceStatus.ERROR;
        this.gameState.gameInfo.audioConfEnabled = false;
        showErrorDialog(context, 'Error', 'Joining audio conference failed');
      }
    }
  }

  leaveAudio() {
    if (gameState != null) {
      if (this.ionAudioConferenceService != null) {
        this.ionAudioConferenceService.leave();
      }
      gameState.communicationState.audioConferenceStatus =
          AudioConferenceStatus.LEFT;
    }
  }
}
