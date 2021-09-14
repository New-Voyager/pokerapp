import 'dart:developer';

import 'package:flutter/material.dart';
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

import 'hand_action_proto_service.dart';

/** 
 * This class handles the following messages NextAction, YourAction QueryCurrentHand messages.
 * This class is written to breakdown the handler code into managable chunks. 
 */
class PlayerActionHandler {
  BuildContext _context;
  GameState _gameState;
  Function(String) playSoundEffect;

  PlayerActionHandler(this._context, this._gameState, this.playSoundEffect);

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
    final seatToAct = _gameState.getSeat(nextSeatToAct);
    if (seatToAct != null) {
      seatToAct.setActionTimer(_gameState.gameInfo.actionTime,
          remainingTime: remainingActionTime);
    }

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

    if (mySeat != null && nextSeatToAct == mySeat.serverSeatPos) {
      // i am next to act
      proto.HandMessageItem yourAction = proto.HandMessageItem();
      yourAction.seatAction = currentHandState.nextSeatAction;
      handleYourAction(yourAction);
    }
    _gameState.notifyAllSeats();
    _gameState.myState.notify();
  }

  Future<void> handleNextAction(proto.HandMessageItem message) async {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn
    // log('handle next action start');        // reset result in progress flag
    try {
      var actionChange = message.actionChange;
      int seatNo = actionChange.seatNo;
      //log('Hand Message: ::handleNextAction:: START seatNo: $seatNo');

      if (_gameState.uiClosing) return;
      final TableState tableState = _gameState.tableState;

      if (_gameState.uiClosing) return;
      final player = _gameState.fromSeat(seatNo);
      assert(player != null);

      if (!player.isMe) {
        // hide action widget

        if (_gameState.uiClosing) return;
        _gameState.showAction(false);
      }
      // log('next action seat: $seatNo player: ${player.name}');
      // highlight next action player
      player.highlight = true;

      if (_gameState.uiClosing) return;
      final seat = _gameState.getSeat(seatNo);
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

      /* play an sound effect alerting the user */
      playSoundEffect(AppAssets.playerTurnSound);

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
      playSoundEffect(AppAssets.betRaiseSound);
    } else if (action.action == HandActions.FOLD) {
      playSoundEffect(AppAssets.foldSound);
      seat.player.playerFolded = true;
      seat.player.animatingFold = true;
      seat.notify();
      if (seat.isMe) {
        // player folded
        _gameState.myState.notify();
      }
    } else if (action.action == HandActions.CHECK) {
      playSoundEffect(AppAssets.checkSound);
    }
    seat.notify();
    int stack = playerActed.stack?.toInt();
    if (stack != null) {
      seat.player.stack = stack;
    }

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
