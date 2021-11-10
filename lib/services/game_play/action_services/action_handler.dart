import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/liveness_sender.dart';
import 'package:provider/provider.dart';

import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/proto/hand.pb.dart';
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/run_it_twice_dialog.dart';
import 'package:vibration/vibration.dart';

import 'hand_action_proto_service.dart';

/** 
 * This class handles the following messages NextAction, YourAction QueryCurrentHand messages.
 * This class is written to breakdown the handler code into managable chunks. 
 */
class PlayerActionHandler {
  BuildContext _context;
  GameState _gameState;
  LivenessSender _livenessSender;
  HandActionProtoService _handActionProtoService;
  PlayActionTimer _actionTimer;

  PlayerActionHandler(this._context, this._gameState, this._livenessSender,
      this._handActionProtoService);

  void close() {
    if (_actionTimer != null) {
      _actionTimer.stop();
    }
  }

  Future<void> handleQueryCurrentHand(proto.HandMessageItem message) async {
    final currentHandState = message.currentHandState;
    log('Current hand state: $currentHandState');
    if (_gameState.uiClosing) return;

    // current players cards
    String playerCards = currentHandState.playerCards;
    final tableState = _gameState.tableState;

    // if game is paused, we don't update cards
    if (_gameState.gameInfo.status == AppConstants.GAME_PAUSED) {
      return;
    }

    if (_gameState.uiClosing) return;
    final handInfo = _gameState.handInfo;

    // am I playing this game?
    final mySeat = _gameState.mySeat;
    if (mySeat != null) {
      // update my cards
      mySeat.player.cards = CardHelper.getRawCardNumbers(playerCards);
    }

    int handNum = currentHandState.handNum;
    double smallBlind = currentHandState.smallBlind;
    double bigBlind = currentHandState.bigBlind;
    final protoGameType = currentHandState.gameType;
    final gameType = GameType.values
        .firstWhere((element) => (element.index == protoGameType.value));

    handInfo.update(
      handNum: handNum,
      smallBlind: smallBlind,
      bigBlind: bigBlind,
      gameType: gameType,
    );

    // update button
    final buttonSeat = _gameState.getSeat(currentHandState.buttonPos);
    if (buttonSeat != null) {
      buttonSeat.dealer = true;
    }

    /* set the noOfVisible cards for other players */
    int noOfCards = currentHandState.noCards;
    handInfo.update(noCards: noOfCards);
    _gameState.setPlayerNoCards(noOfCards);

    // boardCards update if available
    //String currentRound = currentHandState.currentRound.name;
    final round = currentHandState.currentRound;

    try {
      List<int> boardCardsNum = currentHandState.boardCards;
      if (round == HandStatus.FLOP) {
        if (boardCardsNum.length >= 3) {
          boardCardsNum = boardCardsNum.sublist(0, 3);
        }
      } else if (round == HandStatus.TURN) {
        if (boardCardsNum.length >= 4) {
          boardCardsNum = boardCardsNum.sublist(0, 4);
        }
      } else if (round == HandStatus.RIVER || round == HandStatus.SHOW_DOWN) {
        if (boardCardsNum.length >= 5) {
          boardCardsNum = boardCardsNum;
        }
      } else if (round == HandStatus.PREFLOP) {
        boardCardsNum = [];
      }

      if (boardCardsNum != null) {
        tableState.setBoardCards(
          1,
          boardCardsNum.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
        );
      }

      // set second board if found
      List<int> secondBoard = currentHandState.boardCards2;
      if (secondBoard != null && secondBoard.length > 0) {
        if (round == HandStatus.FLOP) {
          if (secondBoard.length >= 3) {
            secondBoard = secondBoard.sublist(0, 3);
          }
        } else if (round == HandStatus.TURN) {
          if (secondBoard.length >= 4) {
            secondBoard = secondBoard.sublist(0, 4);
          }
        } else if (round == HandStatus.RIVER || round == HandStatus.SHOW_DOWN) {
          if (secondBoard.length >= 5) {
            secondBoard = secondBoard;
          }
        } else if (round == HandStatus.PREFLOP) {
          secondBoard = [];
        }

        if (secondBoard != null) {
          tableState.setBoardCards(
            2,
            secondBoard.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
          );
        }
      }
    } catch (e) {}

    // update the pot values
    List<int> pots = [];
    for (final pot in currentHandState.pots) {
      int potValue = 0;
      potValue = pot.toInt();
      pots.add(potValue);
    }
    int potUpdates = 0;
    if (currentHandState.potUpdates != null) {
      potUpdates = currentHandState.potUpdates.toInt();
    }

    tableState.updatePotChipsSilent(
      potChips: pots,
      potUpdatesChips: potUpdates,
    );

    tableState.resultInProgress = false;
    if (round == HandStatus.RESULT) {
      tableState.resultInProgress = true;
    }
    switch (round) {
      case HandStatus.DEAL:
        _gameState.handState = HandState.DEAL;
        break;
      case HandStatus.FLOP:
        _gameState.handState = HandState.FLOP;
        break;
      case HandStatus.PREFLOP:
        _gameState.handState = HandState.PREFLOP;
        break;
      case HandStatus.TURN:
        _gameState.handState = HandState.TURN;
        break;
      case HandStatus.RIVER:
        _gameState.handState = HandState.RIVER;
        break;
      case HandStatus.SHOW_DOWN:
        _gameState.handState = HandState.SHOWDOWN;
        break;
      case HandStatus.RESULT:
        _gameState.handState = HandState.RESULT;
        break;
    }
    tableState.notifyAll();

    // remainingActionTime
    int remainingActionTime = currentHandState.remainingActionTime != null
        ? int.parse(
            currentHandState.remainingActionTime.toString(),
          )
        : 0;

    if (_gameState.uiClosing) return;

    _gameState.updatePlayersStack(currentHandState.playersStack);

    int nextSeatToAct = int.parse(
      currentHandState.nextSeatToAct?.toString() ?? '-1',
    );

    if (nextSeatToAct == -1) return;

    // setup player bet amount
    for (final seatNo in currentHandState.playersActed.keys) {
      final seatAct = currentHandState.playersActed[seatNo];
      final seat = _gameState.getSeat(seatNo);
      if (seat != null) {
        PlayerActedState acted = PlayerActedState();
        seat.player.inhand = true;
        if (seatAct.action == ACTION.FOLD) {
          seat.player.playerFolded = true;
        } else {
          acted.setActionProto(seatAct.action, seatAct.amount);
          seat.player.action = acted;
        }
      }
    }

    proto.HandMessageItem actionChange = proto.HandMessageItem();
    actionChange.actionChange = proto.ActionChange(seatNo: nextSeatToAct);
    handleNextAction(actionChange);

    // don't move action time update from here.
    final seatToAct = _gameState.getSeat(nextSeatToAct);
    if (seatToAct != null) {
      log('QueryCurrentHand: seat no: ${seatToAct.serverSeatPos} action timer: ${_gameState.gameInfo.actionTime} remainingTime: $remainingActionTime');
      seatToAct.actionTimer
          .setTime(_gameState.gameInfo.actionTime, remainingActionTime);
    }
    log('QueryCurrentHand: 1 seat no: ${seatToAct.serverSeatPos} action timer: ${seatToAct.actionTimer.getTotalTime()} remainingTime: ${seatToAct.actionTimer.getRemainingTime()}');

    if (mySeat != null && nextSeatToAct == mySeat.serverSeatPos) {
      // i am next to act
      proto.HandMessageItem yourAction = proto.HandMessageItem();
      yourAction.seatAction = currentHandState.nextSeatAction;
      handleYourAction(yourAction);
    }
    _gameState.notifyAllSeats();
    _gameState.myState.notify();
    log('QueryCurrentHand: 3 seat no: ${seatToAct.serverSeatPos} action timer: ${seatToAct.actionTimer.getTotalTime()} remainingTime: ${seatToAct.actionTimer.getRemainingTime()}');
  }

  Future<void> handleNextAction(proto.HandMessageItem message) async {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn
    log('NextAction: handle next action handState: ${_gameState.handState.toString()}'); // reset result in progress flag
    try {
      // stop game audio
      // AudioService.stopSound();
      var actionChange = message.actionChange;
      int seatNo = actionChange.seatNo;
      //log('Hand Message: ::handleNextAction:: START seatNo: $seatNo');

      if (_gameState.uiClosing) return;
      final TableState tableState = _gameState.tableState;

      if (_gameState.uiClosing) return;
      final seat = _gameState.getSeat(seatNo);
      if (seat == null) {
        return;
      }
      final player = seat.player;
      assert(player != null);

      if (!player.isMe) {
        // hide action widget
        if (_gameState.uiClosing) return;
        _gameState.showAction(false);

        // can I show check/fold button?
        final me = _gameState.me;
        if (me != null) {
          if (me.isActive) {
            _gameState.showCheckFold();
          }
        }
      }
      // log('next action seat: $seatNo player: ${player.name}');
      // highlight next action player
      player.highlight = true;

      if (_gameState.uiClosing) return;
      log('SeatView: Next action ${seat.serverSeatPos}:L${seat.localSeatPos} pos: ${seat.seatPos.toString()} player: ${seat.player?.name} highlight: ${seat.player.highlight}');
      seat.setActionTimer(_gameState.gameInfo.actionTime);
      seat.notify();

      /* check if pot is available, if true, update the pot value in the table state object */
      if (actionChange.pots != null && actionChange.pots.length > 0) {
        try {
          List<int> pots = actionChange.pots
              ?.map<int>((e) => int.parse(e.toString()))
              ?.toList();
          double potUpdates = actionChange.potUpdates;

          tableState.updatePotChipsSilent(
            potChips: pots,
            potUpdatesChips: potUpdates.toInt(),
          );
          tableState.notifyAll();
        } catch (e) {}
      }

      seat.setActionTimer(_gameState.gameInfo.actionTime);
      seat.notify();
      //_gameState.actionTimerState.notify();
    } finally {
      //log('Hand Message: ::handleNextAction:: END');
    }
  }

  Future<void> handleYourAction(proto.HandMessageItem message) async {
    if (_gameState.uiClosing) return;
    try {
      final me = _gameState.me;
      if (me == null) {
        return;
      }

      final seatAction = message.seatAction;
      if (me.seatNo != seatAction.seatNo) {
        return;
      }

      log('YourAction: raiseAmount: ${seatAction.raiseAmount} seatInSoFar: ${seatAction.seatInSoFar}');
      /* play an sound effect alerting the user */
      AudioService.playYourAction(mute: _gameState.playerLocalConfig.mute);

      // start timer
      if (_actionTimer == null) {
        _actionTimer = PlayActionTimer(_livenessSender.sendAliveMsg);
      }
      _actionTimer.start(_gameState.gameInfo.actionTime);

      try {
        if (_gameState.playerLocalConfig.vibration ?? true) {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate();
          }
        }
      } catch (err) {
        // ignore
      }

      if (_gameState.straddleBetThisHand == true) {
        // we have the straddleBet set to true, do a bet
        if (_gameState.uiClosing) return;
        final gameContextObject = _context.read<GameContextObject>();

        HandActionProtoService.takeAction(
          gameContextObject: gameContextObject,
          gameState: _gameState,
          action: AppConstants.STRADDLE,
          amount: 2 * _gameState.gameInfo.bigBlind,
        );

        // once, the first bet is done, set straddleBet to false, and wait for next hand
        return _gameState.straddleBetThisHand = false;
      }

      if (_gameState.actionState.checkFoldSelected) {
        // the player has chosen check/fold option
        // do we have that option in the list
        bool checkAvailable = false;
        bool foldAvailable = false;
        for (final action in seatAction.availableActions) {
          if (action == ACTION.CHECK) {
            checkAvailable = true;
          }
          if (action == ACTION.FOLD) {
            foldAvailable = true;
          }
        }

        if (checkAvailable) {
          _handActionProtoService.playerActed(
              me.playerId,
              _gameState.handInfo.handNum,
              me.seatNo,
              ACTION.CHECK.toString(),
              0);
          return;
        }

        if (foldAvailable) {
          _handActionProtoService.playerActed(
              me.playerId,
              _gameState.handInfo.handNum,
              me.seatNo,
              ACTION.FOLD.toString(),
              0);
          return;
        }
      }

      /* this part handles if we receive a prompt for run it twice */
      List<String> availableActions =
          seatAction.availableActions.map<String>((e) => e.toString()).toList();
      if (availableActions?.contains(AppConstants.RUN_IT_TWICE_PROMPT) ??
          false) {
        if (_gameState.uiClosing) return;
        int secondsTillTimeout = seatAction.secondsTillTimesout;

        return RunItTwiceDialog.promptRunItTwice(
          context: _context,
          expTime: secondsTillTimeout,
        );
      } else {
        if (availableActions?.contains(AppConstants.STRADDLE) ?? false) {
          if (_gameState.uiClosing) return;
        }
      }

      if (_gameState.uiClosing) return;
      _gameState.setActionProto(seatAction.seatNo, seatAction);

      if (_gameState.uiClosing) return;
      if (_gameState.straddlePrompt) {
        // we are showing the straddle prompt
      } else {
        // don't show
        _gameState.showAction(true);
      }
    } finally {
      //log('Hand Message: ::handleYourAction:: END');
    }
  }

  Future<void> handlePlayerActed(proto.HandMessageItem message) async {
    final playerActed = message.playerActed;
    int seatNo = playerActed.seatNo;
    log('HandMessage: ${message.playerActed.seatNo} action: ${message.playerActed.action.name}');

    // stop the timer if running
    if (_actionTimer != null) {
      _actionTimer.stop();
    }

    //log('Hand Message: ::handlePlayerActed:: START seatNo: $seatNo');

    if (_gameState.uiClosing) return;
    // show a prompt regarding last player action

    final seat = _gameState.getSeat(seatNo);
    if (seat.isMe) {
      _gameState.showAction(false);
      _gameState.myState.notify();
    }
    // hide straddle dialog
    if (_gameState.straddlePrompt) {
      _gameState.straddlePrompt = false;
      _gameState.straddlePromptState.notify();
    }
    if (_gameState.uiClosing) return;
    if (seat?.player?.action == null) {
      ////log('Hand Message: ::handlePlayerActed:: player acted: $seatNo, player: ${seat.player.name}');
      return;
    }
    final action = seat.player.action;
    action.setActionProto(playerActed.action, playerActed.amount);

    // play the bet-raise sound effect
    if (action.action == HandActions.BET ||
        action.action == HandActions.RAISE ||
        action.action == HandActions.CALL) {
      AudioService.playBet(mute: _gameState.playerLocalConfig.mute);
    } else if (action.action == HandActions.FOLD) {
      AudioService.playFold(mute: _gameState.playerLocalConfig.mute);
      seat.player.playerFolded = true;
      seat.player.animatingFold = true;
      seat.notify();
      if (seat.isMe) {
        // player folded
        _gameState.myState.notify();
      }
    } else if (action.action == HandActions.CHECK) {
      AudioService.playCheck(mute: _gameState.playerLocalConfig.mute);
    }
    seat.notify();

    int stack = playerActed.stack?.toInt();
    if (stack != null) {
      seat.player.stack = stack;
    }
    log('NEW_HAND: handlePlayerActed player: ${seat.player.name} stack ${seat.player.stack}');

    if (_gameState.uiClosing) return;
    // before showing the prompt --> turn off the highlight on other players
    _gameState.resetActionHighlight(-1);

    // update pot chip updates
    _gameState.tableState
        .updatePotChipUpdatesSilent(playerActed.potUpdates.toInt());
    _gameState.tableState.notifyAll();
    //log('Hand Message: ::handlePlayerActed:: END');
  }
}

class PlayActionTimer {
  int actionTimeout;
  Timer timer;
  Function onTick;

  PlayActionTimer(this.onTick);

  void close() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  void start(int timeout) {
    actionTimeout = timeout;
    log('ActionTimer: Start action timer');
    // start a timer
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      this.tick();
    });
  }

  void stop() {
    log('ActionTimer: Stopped action timer');
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  void tick() {
    log('ActionTimer: Waiting for action...');
    onTick();
  }
}
