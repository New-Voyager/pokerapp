import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/connectivity_check/liveness_sender.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_player_text_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/ion/ion.dart';
import 'package:pokerapp/services/nats/message.dart';

import 'game_state.dart';

class GameContextObject extends ChangeNotifier {
  String _gameCode;
  int _gameId;

  PlayerInfo get currentPlayer => _currentPlayer;
  PlayerInfo _currentPlayer;

  bool _gameEnded = false;
  bool _joiningAudio = false;
  bool _joinedAudio = false;
  GameState gameState;
  HandActionProtoService handActionProtoService;
  GameUpdateService gameUpdateService;
  GameComService gameComService;
  EncryptionService encryptionService;
  LivenessSender livenessSender;
  HandToPlayerTextService handToPlayerTextService;
  IonAudioConferenceService ionAudioConferenceService;

  GameContextObject({
    @required String gameCode,
    @required PlayerInfo player,
    GameState gameState,
    GameUpdateService gameUpdateService,
    HandToPlayerTextService handToPlayerTextService,
    HandActionProtoService handActionProtoService,
    GameComService gameComService,
    EncryptionService encryptionService,
    LivenessSender livenessSender,
  }) {
    this._gameCode = gameCode;
    this._currentPlayer = player;
    this._gameId = 0;
    this.gameComService = gameComService;
    this.encryptionService = encryptionService;
    this.livenessSender = livenessSender;
    this.gameState = gameState;
    this.gameUpdateService = gameUpdateService;
    this.handActionProtoService = handActionProtoService;
    this.handToPlayerTextService = handToPlayerTextService;
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
    this.ionAudioConferenceService?.close();
    handToPlayerTextService?.close();
    gameUpdateService?.close();
    gameComService?.dispose();
    encryptionService?.dispose();
    handActionProtoService?.close();
    livenessSender?.close();
    super.dispose();
  }

  bool get joiningAudio => _joiningAudio || _joinedAudio;

  Future<void> joinAudio(BuildContext context) async {
    if (gameState.gameInfo.audioConfEnabled ?? false) {
      try {
        if (_joiningAudio || _joinedAudio) {
          return;
        }
        _joiningAudio = true;
        this.initializeAudioConf();
        gameState.communicationState.muted =
            this.gameState.playerLocalConfig.muteAudioConf;
        await this.ionAudioConferenceService.join();
        gameState.communicationState.audioConferenceStatus =
            AudioConferenceStatus.CONNECTED;
        this.gameState.playerLocalConfig.inAudioConference = true;
        this.gameState.communicationState.notify();

        gameState.playerLocalConfig.inCall = true;
        _joinedAudio = true;
        _joiningAudio = false;
      } catch (err) {
        _joiningAudio = false;
        gameState.communicationState.audioConferenceStatus =
            AudioConferenceStatus.ERROR;
        this.gameState.gameInfo.audioConfEnabled = false;
        // showErrorDialog(context, 'Error', 'Joining audio conference failed');
      }
    }
  }

  leaveAudio() {
    if (!_joinedAudio) {
      return;
    }
    if (gameState != null) {
      if (this.ionAudioConferenceService != null) {
        this.ionAudioConferenceService.leave();
      }
      gameState.communicationState.audioConferenceStatus =
          AudioConferenceStatus.LEFT;
    }
    _joinedAudio = false;
    _joiningAudio = false;
  }

  void setup(BuildContext context) {
    if (gameUpdateService == null) {
      /* setup the listeners to the channels
            * Any messages received from these channel updates,
            * will be taken care of by the respective class
            * and actions will be taken in the UI
            * as there will be Listeners implemented down this hierarchy level */

      gameUpdateService = GameUpdateService(context, gameState, this);
      gameUpdateService.loop();

      gameComService.gameToPlayerChannelStream?.listen((Message message) {
        if (!gameComService.active) return;

        // log('gameToPlayerChannel(${message.subject}): ${message.string}');

        /* This stream will receive game related messages
                            * e.g.
                            * 1. Player Actions - Sitting on table, getting more chips, leaving game, taking break,
                            * 2. Game Actions - New hand, informing about Next actions, PLayer Acted
                            *  */

        gameUpdateService.handle(message.string);
      });
    }

    if (handActionProtoService == null) {
      handActionProtoService = HandActionProtoService(
        context,
        gameState,
        this,
        gameComService,
        encryptionService,
        livenessSender,
        currentPlayer,
      );

      handActionProtoService.loop();

      gameComService.handToAllChannelStream.listen(
        (Message message) {
          if (!gameComService.active) return;

          if (handActionProtoService == null) return;

          /* This stream receives hand related messages that is common to all players
                            * e.g
                            * New Hand - contains hand status, dealerPos, sbPos, bbPos, nextActionSeat
                            * Next Action - contains the seat No which is to act next
                            *
                            * This stream also contains the output for the query of current hand */
          handActionProtoService.handle(message.data);
        },
      );

      gameComService.handToPlayerChannelStream.listen(
        (Message message) {
          log('messageType: Message in hand to player channel');
          if (!gameComService.active) return;

          if (handActionProtoService == null) return;

          /* This stream receives hand related messages that is specific to THIS player only
                            * e.g
                            * Deal - contains seat No and cards
                            * Your Action - seat No, available actions & amounts */

          handActionProtoService.handle(message.data, encrypted: true);
        },
      );
    }

    // hand to player text channel
    if (handToPlayerTextService == null) {
      handToPlayerTextService = HandToPlayerTextService(context, gameState);
      handToPlayerTextService.loop();

      gameComService.handToPlayerTextChannelStream?.listen((Message message) {
        if (!gameComService.active) return;
        handToPlayerTextService.handle(message.string);
      });
    }
  }
}
