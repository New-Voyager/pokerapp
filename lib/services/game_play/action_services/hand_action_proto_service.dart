import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/player_info.dart' as pi;
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/util_screens/dealer_choice_prompt.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/liveness_sender.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/action_handler.dart';
import 'package:pokerapp/services/game_play/action_services/newhand_handler.dart';
import 'package:pokerapp/services/game_play/action_services/result_handler_v2.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/platform.dart';

import '../game_com_service.dart';
import '../message_id.dart';

enum PlayerActedSendState {
  NONE,
  SENT,
  ACK_RECEIVED,
}

enum CardDistributionType {
  randomOrder,
  sequentialOrder,
}

class RetrySendingProtoMsg {
  GameComService _gameComService;
  String _messageType;
  String _messageId;
  DateTime _messageSentTime;
  Uint8List _message;
  int _retryCount = 0;
  int _retrySeconds = 2;
  bool _ackReceived = false;
  bool _cancel = false;

  RetrySendingProtoMsg(
    this._gameComService,
    this._message,
    this._messageType,
    this._messageId,
  );

  run() async {
    DateTime lastSentTime = DateTime.now();
    _messageSentTime = lastSentTime;
    bool firstAttempt = true;
    // runs a loop until we receive acknowledgement or cancel
    while (!_cancel && !_ackReceived) {
      DateTime now = DateTime.now();
      final d = now.difference(lastSentTime);
      if (firstAttempt || d.inSeconds >= _retrySeconds) {
        // log('Sending $_messageType again');
        lastSentTime = now;
        if (_gameComService.active) {
          _gameComService.sendProtoPlayerToHandChannel(_message);
        } else {
          _cancel = true;
          break;
        }
        _retryCount++;
      }
      firstAttempt = false;
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  cancel() {
    _cancel = true;
  }

  /*
   * 1. If the current message is acknowledgement for previously sent message, then
   * this method returns true and stops the retry loop.
   * 2. If the current message is not an acknowledgement, this method will return false.
   * We should send a QUERY_CURRENT_HAND and refresh the screen.
   */
  bool handleMsg(proto.HandMessageItem messageItem) {
    String messageType = messageItem.messageType;
    if (messageType == AppConstants.MSG_ACK) {
      final msgAck = messageItem.msgAck;
      String messageId = msgAck.messageId;
      if (messageId == _messageId) {
        // log('Received acknowledgement');
        _ackReceived = true;
        return true;
      }
      log('Received incorrect acknowledgement $messageId');
      return false;
    }
    // some other messsge
    log('Received some other message type messageType');
    return false;
  }
}

class HandMessageObject {
  final proto.HandMessage message;
  final proto.HandMessageItem item;
  HandMessageObject(this.message, this.item);
}

class HandActionProtoService {
  final GameState _gameState;
  final GameContextObject _gameContextObject;
  final BuildContext _context;
  final List<HandMessageObject> _messages = [];
  PlayerActionHandler _actionHandler;

  bool _close = false;
  bool closed = false;

  GameComService _gameComService;
  EncryptionService _encryptionService;
  LivenessSender _livenessSender;
  RetrySendingProtoMsg _retryMsg;
  pi.PlayerInfo _currentPlayer;

  HandActionProtoService(
    this._context,
    this._gameState,
    this._gameContextObject,
    this._gameComService,
    this._encryptionService,
    this._livenessSender,
    this._currentPlayer,
  ) {
    this._actionHandler =
        PlayerActionHandler(this._context, _gameState, _livenessSender, this);
  }

  void close() {
    _close = true;
    _gameState.uiClosing = true;
    closed = true;
    _messages.clear();
    if (_retryMsg != null) {
      _retryMsg.cancel();
    }

    _livenessSender?.stop();
  }

  void clear() {
    _messages.clear();
  }

  loop() async {
    while (!closed) {
      if (_messages.length > 0) {
        dynamic m = _messages.removeAt(0);
        bool done = false;
        //String messageType = m['messageType'];
        //debugPrint('$messageType start');
        while (!done && !closed) {
          if (m != null) {
            handleMessage(m).whenComplete(() {
              // debugPrint('$messageType end');
              done = true;
            });
          }
          m = null;
          await Future.delayed(Duration(milliseconds: 50));
        }
      }
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  /* this function actually makes the connection with the GameComService
  * and sends the message in the Player to Server channel */
  static void takeAction({
    @required GameState gameState,
    @required GameContextObject gameContextObject,
    String action,
    double amount,
  }) async {
    assert(action != null);
    if (TestService.isTesting) {
      return;
    }

    gameState.me.action.setAction(action);

    final actionState = gameState.actionState;

    gameContextObject.handActionProtoService.playerActed(
      gameState.currentPlayerId,
      gameState.handInfo.handNum,
      actionState.action.seatNo,
      action,
      amount,
      false,
    );
  }

  playerActed(
    int playerID,
    int handNum,
    int seatNo,
    String action,
    double amount,
    bool isTimedout,
  ) {
    if (_retryMsg != null) {
      _retryMsg.cancel();
    }
    _retryMsg = null;

    int msgId = MessageId.incrementAndGet(_gameState.gameCode);
    String messageId = msgId.toString();
    proto.ACTION actionEnum;
    if (action == 'CHECK') {
      actionEnum = proto.ACTION.CHECK;
    } else if (action == 'CALL') {
      actionEnum = proto.ACTION.CALL;
    } else if (action == 'BET') {
      actionEnum = proto.ACTION.BET;
    } else if (action == 'RAISE') {
      actionEnum = proto.ACTION.RAISE;
    } else if (action == 'ALLIN') {
      actionEnum = proto.ACTION.ALLIN;
    } else if (action == 'RUN_IT_TWICE_YES') {
      actionEnum = proto.ACTION.RUN_IT_TWICE_YES;
    } else if (action == 'RUN_IT_TWICE_NO') {
      actionEnum = proto.ACTION.RUN_IT_TWICE_NO;
    } else if (action == 'FOLD') {
      actionEnum = proto.ACTION.FOLD;
    } else if (action == 'STRADDLE') {
      actionEnum = proto.ACTION.STRADDLE;
    }

    final messageItem = proto.HandMessageItem(
      messageType: 'PLAYER_ACTED',
      playerActed: proto.HandAction(
        seatNo: seatNo,
        action: actionEnum,
        timedOut: isTimedout,
        actionId: _gameState.currentActionId,
      ),
    );
    if (amount != null) {
      messageItem.playerActed.amount = amount.toDouble();
    }

    final handMessage = proto.HandMessage(
        gameCode: _gameState.gameCode,
        playerId: $fixnum.Int64(_gameState.currentPlayerId),
        handNum: handNum,
        seatNo: seatNo,
        messageId: messageId,
        messages: [messageItem]);
    final binMessage = handMessage.writeToBuffer();
    _retryMsg = RetrySendingProtoMsg(
        _gameComService, binMessage, 'PLAYER_ACTED', messageId);
    _retryMsg.run();
  }

  extendTime(int playerId, int seatNo, int handNum, int time) {
    final messageItem = proto.HandMessageItem(
      messageType: 'EXTEND_ACTION_TIMER',
      extendTimer: proto.ExtendTimer(
          seatNo: seatNo,
          extendBySec: time,
          actionId: _gameState.currentActionId),
    );
    int msgId = MessageId.incrementAndGet(_gameState.gameCode);
    String messageId = msgId.toString();
    final playerId64 = $fixnum.Int64(playerId);
    final handMessage = proto.HandMessage(
        gameCode: _gameState.gameCode,
        playerId: playerId64,
        handNum: handNum,
        seatNo: seatNo,
        messageId: messageId,
        messages: [messageItem]);
    final binMessage = handMessage.writeToBuffer();
    this._gameComService.sendProtoPlayerToHandChannel(binMessage);

    // extend the time in play action timer
    _actionHandler.extendTime((3 + time) * 1000);
  }

  extendTimerOnReconnect() async {
    log('Requesting to extend action timer on network connectivity');
    if (_gameState?.gameInfo?.tableStatus != AppConstants.GAME_RUNNING) {
      log('extendTimerOnReconnect 1');
      return;
    }

    log('extendTimerOnReconnect 2');
    for (int i = 0; i < 5; i++) {
      try {
        final messageItem = proto.HandMessageItem(
          messageType: 'EXTEND_ACTION_TIMER',
          extendTimer: proto.ExtendTimer(
            seatNo: _gameState.me.seatNo,
            extendBySec: 15,
            actionId: _gameState.currentActionId,
          ),
        );
        int msgId = MessageId.incrementAndGet(_gameState.gameCode);
        String messageId = msgId.toString();
        int playerID = _gameState.currentPlayerId;
        final handMessage = proto.HandMessage(
            gameCode: _gameState.gameCode,
            messageId: messageId,
            playerId: $fixnum.Int64.parseInt(playerID.toString()),
            messages: [messageItem]);
        final binMessage = handMessage.writeToBuffer();
        log('extendTimerOnReconnect 3');
        bool res =
            this._gameComService.sendProtoPlayerToHandChannel(binMessage);
        log('extendTimerOnReconnect 3.1');
        if (!res) {
          log('extendTimerOnReconnect 4');
          await Future.delayed(Duration(seconds: 1));
          continue;
        }
        break;
      } catch (e) {
        log('extendTimerOnReconnect 5.$i $e');
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  queryCurrentHand() {
    int msgId = MessageId.incrementAndGet(_gameState.gameCode);
    String messageId = msgId.toString();
    int playerID = _gameState.currentPlayerId;
    final handMessage = proto.HandMessage(
        gameCode: _gameState.gameCode,
        messageId: messageId,
        playerId: $fixnum.Int64.parseInt(playerID.toString()),
        messages: [proto.HandMessageItem(messageType: "QUERY_CURRENT_HAND")]);
    final binMessage = handMessage.writeToBuffer();
    this._gameComService.sendProtoPlayerToHandChannel(binMessage);
  }

  handle(Uint8List messageData, {bool encrypted = false}) async {
    assert(_gameState != null);
    if (_gameState.uiClosing) {
      return;
    }
    assert(messageData != null && messageData.isNotEmpty);
    Uint8List protoData = messageData;
    //String hex;
    try {
      // is this a text message
      if (messageData[0] == 123 /*{*/) {
        try {
          String textMessage = utf8.decode(messageData);
          // successfully converted
          if (textMessage.indexOf("messages") != -1) {
            // json message
            handleJsonMessage(textMessage);
          }
        } catch (err) {
          // ignore exception
        }
      }

      if (encrypted) {
        List<int> decryptedMessage =
            await this._encryptionService.decrypt(protoData);
        protoData = decryptedMessage;
      }
      // hex = toHexString(protoData);
      // log("\n\n");
      // log(hex);
      final message = proto.HandMessage.fromBuffer(protoData);
      for (final item in message.messages) {
        _messages.add(HandMessageObject(message, item));
        toggleLivenessSender(item);
      }
    } catch (err) {
      log('${err.toString()}');
      throw err;
    }
  }

  Future<void> handleMessage(HandMessageObject messageObject) async {
    // if the service is closed, don't process incoming messages
    if (closed) return;
    if (_close || _gameState.uiClosing) return;

    //log(messageObject.item.writeToJson());
    //debugLog(_gameState.gameCode, messageObject.item.writeToJson());
    //debugLog(_gameState.gameCode, jsonData);

    String messageType = messageObject.item.messageType;
    log('Performance: Message: [${DateTime.now().toIso8601String()}] ${messageType} handNum: ${messageObject.message.handNum}');
    if (messageObject.message.handNum < _gameState.handInfo.handNum) {
      log('Performance: ***** Invalid HandNum: [${DateTime.now().toIso8601String()}] ${messageType} handNum: ${messageObject.message.handNum} expected HandNum: ${_gameState.handInfo.handNum}');
      return;
    }
    if (_retryMsg != null) {
      bool handled = _retryMsg.handleMsg(messageObject.item);
      // cancel retry now
      _retryMsg.cancel();
      _retryMsg = null;
      if (handled) {
        // acknowledgement message
        return;
      } else {
        // something went wrong, we need to refresh the screen
        //this.queryCurrentHand();
      }
    }

    // log('Hand Message: ::handleMessage:: START messageType: $messageType');
    final message = messageObject.item;
    try {
      // delegate further actions to sub services as per messageType
      switch (messageType) {
        case AppConstants.RESULT2:
          await handleResult2(message.handResultClient);
          return;

        case AppConstants.RUN_IT_TWICE:
          await handleRunItTwice(message);
          return;

        case AppConstants.NEW_HAND:
          await handleNewHand(message);
          return;

        // case AppConstants.DEAL_STARTED:
        //   return handleDealStarted();

        case AppConstants.BOMB_POT:
          return handleBombPot();

        case AppConstants.DEAL:
          return handleDeal(message);

        case AppConstants.QUERY_CURRENT_HAND:
          await _actionHandler.handleQueryCurrentHand(message);
          return;

        case AppConstants.NEXT_ACTION:
          if (_gameState.handState == HandState.DEAL) {
            _gameState.handState = HandState.PREFLOP;
          }
          await _actionHandler.handleNextAction(message);
          return;

        case AppConstants.PLAYER_ACTED:
          if (_gameState.handState == HandState.DEAL) {
            _gameState.handState = HandState.PREFLOP;
          }
          await _actionHandler.handlePlayerActed(message);
          return;

        case AppConstants.YOUR_ACTION:
          if (_gameState.handState == HandState.DEAL) {
            _gameState.handState = HandState.PREFLOP;
          }
          await _actionHandler.handleYourAction(message);
          return;

        case AppConstants.EXTEND_ACTION_TIMER:
          await handleExtendTimer(message);
          return;

        case AppConstants.PREFLOP:
          ////log('Hand Message: ::handleStageChange:: FLOP');
          _gameState.handState = HandState.PREFLOP;
          await handleStageChange(message, 'preflop');
          ////log('Hand Message: ::handleStageChange:: FLOP DONE');
          return;
        case AppConstants.FLOP:
          ////log('Hand Message: ::handleStageChange:: FLOP');
          _gameState.handState = HandState.FLOP;
          await handleStageChange(message, 'flop');
          ////log('Hand Message: ::handleStageChange:: FLOP DONE');
          return;

        case AppConstants.TURN:
          _gameState.handState = HandState.TURN;
          ////log('Hand Message: ::handleStageChange:: TURN');
          await handleStageChange(message, 'turn');
          ////log('Hand Message: ::handleStageChange:: TURN DONE');
          return;

        case AppConstants.RIVER:
          _gameState.handState = HandState.RIVER;
          ////log('Hand Message: ::handleStageChange:: RIVER');
          await handleStageChange(message, 'river');
          ////log('Hand Message: ::handleStageChange:: RIVER DONE');
          return;

        case AppConstants.ANNOUNCEMENT:
          return handleAnnouncement(message);
      }
    } catch (err) {
      log('Error: ${err.toString()}, ${err.stackTrace}');
    } finally {
      ////log('Hand Message: ::handleMessage:: END messageType: $messageType');
    }
  }

  void toggleLivenessSender(proto.HandMessageItem item) {
    if (item.messageType == AppConstants.YOUR_ACTION) {
      if (item.seatAction != null &&
          _gameState.me != null &&
          item.seatAction.seatNo == _gameState.me.seatNo) {
        _livenessSender.start();
      }
    } else if (item.messageType == AppConstants.PLAYER_ACTED) {
      _livenessSender.stop();
    }
  }

  static Future<void> handleRunItTwiceStatic({
    @required BuildContext context,
    @required List<int> board1Cards,
    @required List<int> board2Cards,
  }) async {
    final GameState gameState = GameState.getState(context);

    return gameState.communityCardState.addRunItTwiceCards(
      board1: board1Cards,
      board2: board2Cards,
    );
  }

  Future<void> handleRunItTwice(proto.HandMessageItem message) async {
    final runItTwice = message.runItTwice;
    Alerts.showNotification(
        titleText: 'Run it twice', duration: Duration(seconds: 3));
    final List<int> board1Cards = [];
    final List board1 = runItTwice.board1;
    for (int c in board1) {
      board1Cards.add(int.parse(c.toString()));
    }

    final List<int> board2Cards = [];
    final List board2 = runItTwice.board2;
    for (int c in board2) {
      board2Cards.add(int.parse(c.toString()));
    }

    await handleRunItTwiceStatic(
      context: _context,
      board1Cards: board1Cards,
      board2Cards: board2Cards,
    );
  }

  Future<void> handleNewHand(proto.HandMessageItem message) async {
    // reset result in progress flag
    _gameState.tableState.resultInProgress = false;
    log(message.toString());
    NewHandHandler handler = NewHandHandler(
      newHand: message.newHand,
      gameState: _gameState,
      gameContext: _gameContextObject,
    );
    handler.initialize();
    await handler.handle();
  }

  Future<void> handleDeal(proto.HandMessageItem message) async {
    final dealCards = message.dealCards;
    int mySeatNo = dealCards.seatNo;
    String cards = dealCards.cards;
    log("Message : $message");

    List<int> myCards = [];
    if (PlatformUtils.isWeb) {
      myCards = message.dealCards.cardsInt;
      //myCards = CardHelper.getCardNumberFromCardStr(message.dealCards.cardsStr);
    } else {
      myCards = CardHelper.getRawCardNumbers(cards);
    }
    if (_close || _gameState.uiClosing) return;

    if (_gameState.mySeat != null) {
      _gameState.mySeat.player.cards = myCards;
    }
    _gameState.currentCards = myCards;
    log('my cards: ${_gameState.currentCards}');

    List<int> seatNos = _gameState.playersInGame.map((p) => p.seatNo).toList();
    seatNos.sort();
    for (int seatNo in seatNos) {
      int localSeatNo = mySeatNo == null
          ? seatNo
          : ((seatNo - mySeatNo) % _gameState.gameInfo.maxPlayers) + 1;
      if (_close || _gameState.uiClosing) return;
      final seat = _gameState.getSeat(seatNo);
      if (seat.player == null ||
          seat.player.stack == 0 ||
          seat.player.status != AppConstants.PLAYING) {
        continue;
      }

      // start the animation
      if (_close || _gameState.uiClosing) return;
      final playerInSeat = _gameState.getSeat(seatNo);
      if (playerInSeat != null &&
          playerInSeat.player != null &&
          playerInSeat.player.inhand) {
        playerInSeat.player.noOfCardsVisible = myCards.length;
        playerInSeat.notify();
      }
    }

    // if straddle prompt is true, trigger straddle state to show the dialog
    if (_gameState.straddlePrompt && _gameState.playerLocalConfig.straddle) {
      final straddlePromptState = _gameState.straddlePromptState;
      straddlePromptState.notify();
    }

    /* card distribution ends, put the value to NULL */
    if (_close || _gameState.uiClosing) return;
    _gameState.handState = HandState.DEAL;
    _gameState.myState.notify();
    // AudioService.stopSound();
    //log('Hand Message: ::handleDeal:: END');
  }

  /// this method is needed for Replay Hand and Testing Service
  static Future<void> cardDistribution(GameState gameState, [int noCards = 2]) {
    return _handleCardDistribution(noCards, gameState);
  }

  /// distribute cards for this particular `seatNo` `totalCards` no of times
  static Future<void> _handleAnimationForSingleSeat(
    int seatNo,
    int totalCards,
    GameState gameState,
  ) async {
    for (int c = 1; c <= totalCards; c++) {
      gameState.startCardDistributionFor(seatNo);
      await Future.delayed(AppConstants.cardDistributionAnimationDuration);
      gameState.stopCardDistributionFor(seatNo);

      final playerInSeat = gameState.getSeat(seatNo);
      if (playerInSeat != null) {
        playerInSeat.player.noOfCardsVisible = c;
        playerInSeat.notify();
      }
    }
  }

  static Future<void> _handleCardDistribution(
    int noCards,
    GameState gameState, {
    // change the card distribution type from here
    CardDistributionType cardDistributionType =
        CardDistributionType.sequentialOrder,
  }) async {
    final allSeats = gameState.playersInGame.map<int>((p) => p.seatNo).toList();
    allSeats.shuffle();
    AudioService.playDealSound(mute: gameState.playerLocalConfig.mute);

    if (cardDistributionType == CardDistributionType.randomOrder) {
      final List<Future> futures = [];
      for (final seatNo in allSeats) {
        final future = _handleAnimationForSingleSeat(
          seatNo,
          noCards,
          gameState,
        );
        await Future.delayed(
          AppConstants.cardDistributionWaitBetweenPlayersDuration,
        );
        futures.add(future);
      }
      return Future.wait(futures);
    } else {
      for (int c = 0; c < noCards; c++) {
        // distribute cards to all players

        for (final seatNo in allSeats) {
          gameState.startCardDistributionFor(seatNo);
        }

        await Future.delayed(AppConstants.cardDistributionAnimationDuration);

        for (final seatNo in allSeats) {
          gameState.stopCardDistributionFor(seatNo);
          final playerInSeat = gameState.getSeat(seatNo);
          if (playerInSeat != null) {
            playerInSeat.player.noOfCardsVisible = c;
            playerInSeat.notify();
          }
        }
      }
    }
  }

  Future<void> handleDealStarted({
    bool fromGameReplay = false,
    int testNo = 2, // works only if in testing mode
  }) async {
    if (_close) return;
    try {
      final TableState tableState = _gameState.tableState;

      tableState.clear();
      tableState.notifyAll();

      if (_close) return;

      /* show card shuffling*/
      if (_gameState.handInfo.bombPot) {
        tableState.updateCardShufflingAnimation(true);
        //AudioService.playDeal(mute: _gameState.playerLocalConfig.mute);
        await Future.delayed(AppConstants.bombPotTotalWaitDuration); // wait
      } else {
        // play the deal sound effect
        //AudioService.playDeal(mute: _gameState.playerLocalConfig.mute);
        tableState.updateCardShufflingAnimation(true);
        await Future.delayed(
            AppConstants.cardShufflingTotalWaitDuration); // wait
      }

      if (_close) return;

      final handInfo = _gameState.handInfo;

      if (_close) return;

      if (handInfo.noCards == 0) handInfo.update(noCards: testNo);

      await _handleCardDistribution(handInfo.noCards, _gameState);

      /// hide shuffling cards, only after card distribution is done
      tableState.updateCardShufflingAnimation(false);
    } finally {
      //log('Hand Message: ::handleDealStarted:: END');
    }
  }

  Future<void> handleBombPot() async {
    //log('Hand Message: ::handleBombPot:: START');
    if (_close) return;
    try {
      final TableState tableState = _gameState.tableState;
      final handInfo = _gameState.handInfo;
      tableState.clear();
      tableState.notifyAll();
      if (_close) return;

      // play the bet sound effect
      AudioService.playBet(mute: _gameState.playerLocalConfig.mute);

      // place players bets
      for (final player in _gameState.playersInGame) {
        if (player.inhand) {
          // get the seat
          Seat seat = _gameState.getSeatByPlayer(player.playerId);

          // update player bet & player stack
          seat.player.action.setBombPotAction(handInfo.bombPotBet);
          // player.stack = player.stack - handInfo.bombPotBet.toInt();

          // notify seat
          seat.notify();
        }
      }
      if (_close) return;
      tableState.notifyAll();
      _gameState.notifyAllSeats();
    } finally {
      //log('Hand Message: ::handleDealStarted:: END');
    }
  }

  // we update the pot only during
  void updatePot(List<double> potValues, String key, BuildContext context) {
    try {
      List<double> pots = [];
      double totalPot = 0;
      if (potValues != null) {
        pots = potValues;
      }

      for (final v in potValues) {
        totalPot += v;
      }

      if (_close) return;
      final tableState = _gameState.tableState;

      tableState.updatePotChipsSilent(
        potChips: pots,
        potUpdatesChips: totalPot,
      );
      if (_close) return;
      tableState.notifyAll();
    } catch (e) {
      log('exception from StageUpdateService: $e');
    }
  }

  Future<void> handleStageChange(
    proto.HandMessageItem message,
    String stage,
  ) async {
    assert(stage != null);
    // log('stage update start');
    //log('Hand Message: ::handleStageChange:: START');

    if (_close) return;
    final TableState tableState = _gameState.tableState;
    tableState.updatePotChipUpdatesSilent(0);

    if (_close) return;

    // show the move coin to pot animation, after that update the pot
    await _gameState.animateSeatActions();
    await Future.delayed(Duration(milliseconds: 500));
    _gameState.resetSeatActions();
    // update the pot

    if (_close) return;
    List<double> pots;
    if (stage == 'flop') {
      pots = message.flop.pots;
      _gameState.handState = HandState.FLOP;
    } else if (stage == 'turn') {
      pots = message.turn.pots;
      _gameState.handState = HandState.TURN;
    } else if (stage == 'river') {
      pots = message.river.pots;
      _gameState.handState = HandState.RIVER;
    }
    updatePot(pots, stage, _context);

    _gameState.handChangeState.notify();
    _gameState.notifyAllSeats();

    Map<int, String> playerCardRanks;
    // update the community cards
    if (stage == 'flop') {
      tableState.updatePotChipUpdatesSilent(0);
      _gameState.handState = HandState.FLOP;

      final List<int> board1Cards = message.flop.boards[0].cards;
      List<int> board2Cards;
      if (message.flop.boards.length == 2) {
        board2Cards = message.flop.boards[1].cards;
      }

      _gameState.communityCardState.addFlopCards(
        board1: board1Cards,
        board2: board2Cards,
      );

      AudioService.playFlop(mute: _gameState.playerLocalConfig.mute);
      tableState.notifyAll();

      _gameState.actionState.checkFoldSelected = false;
      _gameState.actionState.notify();
      playerCardRanks = message.flop.playerCardRanks;
    } else if (stage == 'turn') {
      tableState.updatePotChipUpdatesSilent(0);
      _gameState.handState = HandState.TURN;

      // for turn pick the 3rd index card
      int board1Card = message.turn.boards[0].cards[3];
      int board2Card;
      if (message.turn.boards.length == 2) {
        board2Card = message.turn.boards[1].cards[3];
      }

      _gameState.communityCardState.addTurnCard(
        board1Card: board1Card,
        board2Card: board2Card,
      );

      AudioService.playFlop(mute: _gameState.playerLocalConfig.mute);
      tableState.notifyAll();

      _gameState.actionState.checkFoldSelected = false;
      _gameState.actionState.notify();
      playerCardRanks = message.turn.playerCardRanks;
    } else if (stage == 'river') {
      tableState.updatePotChipUpdatesSilent(0);
      _gameState.handState = HandState.RIVER;

      // for river pick the 4th index card
      int board1Card = message.river.boards[0].cards[4];
      int board2Card;
      if (message.river.boards.length == 2) {
        board2Card = message.river.boards[1].cards[4];
      }

      _gameState.communityCardState.addRiverCard(
        board1Card: board1Card,
        board2Card: board2Card,
      );

      AudioService.playFlop(mute: _gameState.playerLocalConfig.mute);
      tableState.notifyAll();

      _gameState.actionState.checkFoldSelected = false;
      _gameState.actionState.notify();
      playerCardRanks = message.river.playerCardRanks;
    }

    await Future.delayed(Duration(seconds: 1));
    // AudioService.stopSound();

    if (_close) return;
    updateRank(playerCardRanks);
  }

  void updateRank(Map<int, String> playerCardRanks, {String rankText}) {
    if (_gameState.isPlaying) {
      final me = _gameState.me;
      final myState = _gameState.myState;
      if (rankText != null) {
        me.rankText = rankText;
        myState.notify();
      } else {
        if (playerCardRanks != null) {
          for (final seatNo in playerCardRanks.keys) {
            if (seatNo == me.seatNo) {
              _encryptionService
                  .decodeAndDecrypt(playerCardRanks[seatNo])
                  .then((decryptedBytes) => utf8.decode(decryptedBytes))
                  .then((rankStr) => {me.rankText = rankStr})
                  .then((value) => myState.notify());
              break;
            }
          }
        }
      }
    }
  }

  Future<void> handleExtendTimer(proto.HandMessageItem message) async {
    final extendTimer = message.extendTimer;
    final seat = _gameState.getSeat(extendTimer.seatNo);
    if (seat != null) {
      int total = seat.actionTimer.getTotalTime() + extendTimer.extendBySec;
      //log('ActionTimer: total: ${total} extended time: ${extendTimer.extendBySec} remaining time: ${extendTimer.remainingSec}');
      seat.actionTimer.setTime(total, extendTimer.remainingSec);
      seat.notify();
    }
  }

  Future<void> handleAnnouncement(proto.HandMessageItem message) async {
    //log('Hand Message: ::handleAnnouncement:: START');

    final announcement = message.announcement;
    String type = announcement.type;
    if (type == 'NewGameType') {
      String game = announcement.params[0].toString();
      GameType gameType = gameTypeFromStr(game);
      // String title = gameTypeStr(gameType);
      log("-=-= $gameType");
      Alerts.showNotification(
        titleText: gameTypeStr(gameType),
        duration: Duration(seconds: 5),
        imagePath: GameModel.getGameTypeImageAssetFromEnum(gameType),
      );
    }
    //log('Hand Message: ::handleAnnouncement:: END');
  }

  /* seat-no, list of cards mapping */
  static Map<int, List<int>> _getCards(proto.HandResult handResult, int myID) {
    final players = handResult.players;

    final String kShowDown = 'SHOW_DOWN';

    Map<int, List<int>> seatNoCardsMap = Map<int, List<int>>();

    players.forEach((seatNo, d) {
      /* WE ONLY SHOW CARDS FOR PLAYERS, WHO PLAYED TILL THE SHOWDOWN */
      final int sn = int.parse(seatNo.toString());
      final playerID = d.id.toInt();

      // if it's me do not update my cards
      if (playerID != myID) {
        // if the player has survived till show down
        if (d.playedUntil.name == kShowDown)
          seatNoCardsMap[sn] =
              d.cards?.map<int>((e) => int.parse(e.toString()))?.toList();
      }
    });

    return seatNoCardsMap;
  }

  static void updatePotBeforeResultStatic({
    @required final proto.RunItTwiceResult runItTwiceResult,
    @required final Map<int, proto.PotWinners> potWinners,
    @required final BuildContext context,
    final bool isRunItTwice = false,
  }) {
    List<double> pots = [];

    /* get the pots and update them */
    if (isRunItTwice) {
      // todo: handle this situation
      final board1Winners = runItTwiceResult.board1Winners;
      board1Winners.forEach((key, winner) {
        pots.add(winner.amount);
      });
    } else {
      potWinners.forEach((key, potWinner) {
        pots.add(potWinner.amount);
      });
    }

    /* update the table pots before the result */
    final gameState = GameState.getState(context);
    final tableState = gameState.tableState;
    tableState.updatePotChipsSilent(potChips: pots);
    tableState.notifyAll();
  }

  Future<void> handleResult2(proto.HandResultClient result) async {
    if (_close) return;
    _gameState.actionState.reset();
    _gameState.actionState.notify();

    if (_gameState.isPlaying) {
      _gameState.rabbitState.putResultProto(
        result,
        myCards: _gameState.mySeat.player.cards,
      );
    }

    if (_close) return;
    await _gameState.animateSeatActions();
    await Future.delayed(Duration(milliseconds: 500));
    _gameState.resetSeatActions();
    _gameState.lastHandNum = result.handNum;

    for (final seatNo in result.playerInfo.keys) {
      final playerInfo = result.playerInfo[seatNo];
      if (playerInfo.playedUntil == proto.HandStatus.SHOW_DOWN) {
        final seat = _gameState.getSeat(seatNo);
        seat.player.cards = playerInfo.cards;
      }
    }
    _gameState.showdown = false;
    if (result.wonAt == proto.HandStatus.SHOW_DOWN) {
      _gameState.showdown = true;
    }

    _gameState.handState = HandState.RESULT;
    _gameState.handChangeState.notify();
    try {
      ResultHandlerV2 resultHandler = ResultHandlerV2(
        result: result,
        gameState: _gameState,
        context: _context,
        replay: false,
      );

      await resultHandler.show();
    } catch (err) {
      log('==== CRITICAL ====: Exception thrown at updatePotBeforeResultStatic. Error: ${err.toString()}');
    }
    _gameState.communityCardState.reset();
    _gameState.handState = HandState.ENDED;
    _gameState.handInProgress = false;

    // is the current player in the hand
    final me = _gameState.me;
    if (me != null && !me.inBreak) {
      _gameState.gameHiveStore.handEnded();
    }

    //log('Hand Message: ::handleResult:: END');
  }

  Future<void> handleJsonMessage(String jsonMessage) async {
    try {
      final Map<String, dynamic> message = jsonDecode(jsonMessage);
      final List<dynamic> messages = message["messages"];
      for (final message in messages) {
        // handle each message
        final messageType = message["messageType"].toString();
        if (messageType == AppConstants.DEALER_CHOICE) {
          await handleDealerChoice(message);
        }
      }
    } catch (err) {
      log('Failed to handle message: $jsonMessage');
    }
  }

  // Json messages
  Future<void> handleDealerChoice(var data) async {
    final dealerChoice = data['dealerChoice'];
    if (dealerChoice == null) {
      return;
    }

    if (_close) return;
    final TableState tableState = _gameState.tableState;
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    if (_close) return;
    _gameState.clear();

    if (_close) return;
    // _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    List<GameType> gameChoices = [];
    for (final type in dealerChoice['games']) {
      final gameType =
          GameType.values[type]; //.firstWhere((element) => element == type);
      gameChoices.add(gameType);
    }
    final timeout = int.parse(dealerChoice['timeout'].toString());
    DealerChoiceSelection selection = await DealerChoicePrompt.prompt(
        listOfGameTypes: gameChoices, timeLimit: Duration(seconds: timeout));
    log('selected game type: ${selection.gameType}');
    if (selection.gameType != GameType.UNKNOWN) {
      GameService.dealerChoice(
          _gameState.gameCode, selection.gameType, selection.doubleBoard);
    }
  }
}
