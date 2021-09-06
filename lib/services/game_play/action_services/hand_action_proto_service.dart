import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/player_info.dart' as pi;
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/newhand_handler.dart';
import 'package:pokerapp/services/game_play/action_services/result_handler.dart';
import 'package:pokerapp/services/game_play/action_services/result_handler_v2.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/run_it_twice_dialog.dart';
import 'package:provider/provider.dart';

import '../game_com_service.dart';
import '../message_id.dart';

enum PlayerActedSendState {
  NONE,
  SENT,
  ACK_RECEIVED,
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
  final BuildContext _context;
  final List<HandMessageObject> _messages = [];

  bool _close = false;
  bool closed = false;

  GameComService _gameComService;
  EncryptionService _encryptionService;
  RetrySendingProtoMsg _retryMsg;
  pi.PlayerInfo _currentPlayer;
  AudioPlayer audioPlayer;

  HandActionProtoService(
    this._context,
    this._gameState,
    this._gameComService,
    this._encryptionService,
    this._currentPlayer, {
    this.audioPlayer,
  });

  void close() {
    _close = true;
    _gameState.uiClosing = true;
    closed = true;
    _messages.clear();
    if (_retryMsg != null) {
      _retryMsg.cancel();
    }
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
    BuildContext context,
    String action,
    int amount,
  }) async {
    assert(context != null);
    assert(action != null);

    final gameState = Provider.of<GameState>(context, listen: false);
    final actionState = gameState.getActionState(context);
    final handInfo = gameState.getHandInfo(context);
    final gameContextObject = Provider.of<GameContextObject>(
      context,
      listen: false,
    );

    gameContextObject.handActionProtoService.playerActed(
      gameContextObject.playerId,
      gameState.handInfo.handNum,
      actionState.action.seatNo,
      action,
      amount,
    );
  }

  playerActed(
    int playerID,
    int handNum,
    int seatNo,
    String action,
    int amount,
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
    }

    final messageItem = proto.HandMessageItem(
      messageType: 'PLAYER_ACTED',
      playerActed: proto.HandAction(
        seatNo: seatNo,
        action: actionEnum,
      ),
    );
    if (amount != null) {
      messageItem.playerActed.amount = amount.toDouble();
    }

    final handMessage = proto.HandMessage(
        gameCode: _gameState.gameCode,
        handNum: handNum,
        seatNo: seatNo,
        messageId: messageId,
        messages: [messageItem]);
    final binMessage = handMessage.writeToBuffer();
    _retryMsg = RetrySendingProtoMsg(
        _gameComService, binMessage, 'PLAYER_ACTED', messageId);
    _retryMsg.run();
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
    assert(_context != null);
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
      }
    } catch (err) {
      log('${err.toString()}');
      throw err;
    }
  }

  Future<void> handleMessage(HandMessageObject messageObject) async {
    // if the service is closed, don't process incoming messages
    if (closed) return;

    log(messageObject.item.writeToJson());

    debugLog(_gameState.gameCode, messageObject.item.writeToJson());
    //debugLog(_gameState.gameCode, jsonData);

    String messageType = messageObject.item.messageType;

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

    ////log('Hand Message: ::handleMessage:: START messageType: $messageType');
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

        case AppConstants.DEAL_STARTED:
          return handleDealStarted();

        case AppConstants.BOMB_POT:
          return handleBombPot();

        case AppConstants.DEAL:
          return handleDeal(message);

        case AppConstants.QUERY_CURRENT_HAND:
          await handleQueryCurrentHand(message);
          return;

        case AppConstants.NEXT_ACTION:
          await handleNextAction(message);
          return;

        case AppConstants.PLAYER_ACTED:
          return handlePlayerActed(message);

        case AppConstants.YOUR_ACTION:
          await handleYourAction(message);
          return;

        case AppConstants.FLOP:
          ////log('Hand Message: ::handleStageChange:: FLOP');
          await handleStageChange(message, 'flop');
          ////log('Hand Message: ::handleStageChange:: FLOP DONE');
          return;

        case AppConstants.TURN:
          ////log('Hand Message: ::handleStageChange:: TURN');
          await handleStageChange(message, 'turn');
          ////log('Hand Message: ::handleStageChange:: TURN DONE');
          return;

        case AppConstants.RIVER:
          ////log('Hand Message: ::handleStageChange:: RIVER');
          await handleStageChange(message, 'river');
          ////log('Hand Message: ::handleStageChange:: RIVER DONE');
          return;

        case AppConstants.ANNOUNCEMENT:
          return handleAnnouncement(message);
      }
    } catch (err) {
      log('Error: ${err.toString()}');
    } finally {
      ////log('Hand Message: ::handleMessage:: END messageType: $messageType');
    }
  }

  static Future<void> handleRunItTwiceStatic({
    @required BuildContext context,
    @required List<int> board1Cards,
    @required List<int> board2Cards,
  }) async {
    final GameState gameState = GameState.getState(context);
    final TableState tableState = gameState.tableState;

    final List<CardObject> b1 = [];
    for (final c in board1Cards) {
      b1.add(CardHelper.getCard(c));
    }

    final List<CardObject> b2 = [];
    for (final c in board2Cards) {
      b2.add(CardHelper.getCard(c));
    }

    tableState.updateTwoBoardsNeeded(true);

    /* show the board 1 cards */
    await tableState.addAllCommunityCardsForRunItTwiceScenario(1, b1);

    /* pause for a bit todo: get duration */
    // await Future.delayed(const Duration(milliseconds: 200));

    /* show the board 2 cards */
    await tableState.addAllCommunityCardsForRunItTwiceScenario(2, b2);

    /* pause for a bit todo: get duration */
    // await Future.delayed(const Duration(milliseconds: 2000));
  }

  Future<void> handleRunItTwice(proto.HandMessageItem message) async {
    final runItTwice = message.runItTwice;

    final List<int> board1Cards = [];
    final List board1 = runItTwice.board1;
    for (int c in board1) {
      board1Cards.add(int.parse(c.toString()));
    }

    final List<int> board2Cards = [];
    final List board2 = runItTwice.board2;
    for (int c in board2) {
      board1Cards.add(int.parse(c.toString()));
    }

    return handleRunItTwiceStatic(
      context: _context,
      board1Cards: board1Cards,
      board2Cards: board2Cards,
    );
  }

  Future<void> handleNewHand(proto.HandMessageItem message) async {
    NewHandHandler handler = NewHandHandler(
        newHand: message.newHand,
        context: _context,
        gameState: _gameState,
        playSoundEffect: playSoundEffect);
    handler.initialize();
    await handler.handle();
  }

  Future<void> handleNewHand2(proto.HandMessageItem message) async {
    _gameState.handState = HandState.STARTED;
    _gameState.highHand = null;
    _gameState.handInProgress = true;
    ////log('Hand Message: ::handleNewHand:: START');
    playSoundEffect(AppAssets.newHandSound);

    /* data contains the dealer, small blind and big blind seat Positions
    * Update the Players object with these information */
    final newHand = message.newHand;

    // there are seat nos
    int dealerPos = newHand.buttonPos;
    int sbPos = newHand.sbPos;
    int bbPos = newHand.bbPos;
    int noCards = newHand.noCards;
    double bigBlind = newHand.bigBlind;
    double smallBlind = newHand.smallBlind;
    int handNum = newHand.handNum;

    GameType gameType = GameType.values
        .firstWhere((element) => element.index == newHand.gameType.value);
    _gameState.resetSeatActions(newHand: true);

    // clear marked cards here
    if (_close) return;
    _context.read<MarkedCards>().clear();

    if (_close) return;
    final handInfo = _gameState.getHandInfo(_context);
    handInfo.update(
      handNum: handNum,
      noCards: noCards,
      gameType: gameType,
      smallBlind: smallBlind,
      bigBlind: bigBlind,
      bombPot: newHand.bombPot,
      bombPotBet: newHand.bombPotBet,
      doubleBoard: newHand.doubleBoardBombPot,
    );

    // set small blind and big blind
    if (_close) return;
    final noOfPlayers = newHand.playersInSeats.length;
    if (_gameState.gameInfo.playersInSeats.length != noOfPlayers) {
      log('gameState seats does not match with new hand. * Refreshing *');
      await _gameState.refresh(_context);
      log('gameState seats does not match with new hand. * Refreshing Done *');
    }

    if (_close) return;
    final Players players = _gameState.getPlayers(_context);

    // update player's state and stack
    final playersInSeats = newHand.playersInSeats;
    int retryCount = 0;
    while (retryCount < 2) {
      retryCount++;
      // show buyin button/timer if the player is in middle of buyin
      for (final seatNo in playersInSeats.keys) {
        if (seatNo == 0) {
          continue;
        }
        final playerInSeat = playersInSeats[seatNo];

        if (playerInSeat.playerId == 0) {
          // open seat
          final seat = _gameState.getSeat(_context, seatNo);
          seat.player = null;
          continue;
        }

        PlayerModel playerFound;
        bool newPlayer = true;
        for (final player in players.players) {
          if (player.playerId == playerInSeat.playerId.toInt()) {
            playerFound = player;
            break;
          }
        }
        PlayerModel playerObj;
        if (playerFound != null) {
          newPlayer = false;
          playerObj = playerFound;
        } else {
          playerObj = new PlayerModel();
        }
        playerObj.seatNo = seatNo;
        playerObj.stack = playerInSeat.stack.toInt();
        // if (newHand.bombPot) {
        //   playerObj.stack = playerObj.stack + newHand.bombPotBet.toInt();
        // }
        playerObj.status = playerInSeat.status.name;
        playerObj.inhand = playerInSeat.inhand;
        if (playerInSeat.buyInExpTime != null &&
            playerInSeat.breakExpTime.length > 0 &&
            playerInSeat.stack == 0) {
          playerObj.showBuyIn = true;
          final buyInTimeExpAt = DateTime.tryParse(playerInSeat.buyInExpTime);
          playerObj.buyInTimeExpAt = buyInTimeExpAt.toLocal();
        }
        if (playerInSeat.breakExpTime != null &&
            playerInSeat.breakExpTime.length > 0) {
          playerObj.inBreak = true;
          final time = DateTime.tryParse(playerInSeat.breakExpTime);
          playerObj.breakTimeExpAt = time.toLocal();
        }

        if (newPlayer) {
          //playerObj.playerUuid = playerInSeat.playerId;
          players.addNewPlayerSilent(playerObj);
        }
        if (playerObj.playerUuid == this._currentPlayer.uuid) {
          playerObj.isMe = true;
        }
        final seat = _gameState.getSeat(_context, seatNo);
        seat.player = playerObj;
      }

      // make sure no two users in the same seat
      Map<int, int> seatNos = Map<int, int>();
      for (final player in players.players) {
        if (!seatNos.containsKey(player.seatNo)) {
          seatNos[player.seatNo] = 1;
        } else {
          seatNos[player.seatNo] = seatNos[player.seatNo] + 1;
        }
      }
      bool refresh = false;
      for (final seatNo in seatNos.keys) {
        if (seatNos[seatNo] > 1) {
          refresh = true;
          break;
        }
      }
      if (refresh) {
        // the game state does not have all the players, refresh
        if (_close) return;
        log('gameState seats does not match with new hand. * Refreshing *');
        await _gameState.refresh(_context);
        log('gameState seats does not match with new hand. * Refreshing Done *');
      } else {
        break;
      }
    }

    if (!newHand.bombPot) {
      final sbSeat = _gameState.getSeat(_context, sbPos);
      sbSeat.player.action.sb = true;
      sbSeat.player.action.amount = _gameState.gameInfo.smallBlind.toDouble();

      if (_close) return;
      final bbSeat = _gameState.getSeat(_context, bbPos);
      bbSeat.player.action.bb = true;
      bbSeat.player.action.amount = _gameState.gameInfo.bigBlind.toDouble();
    }

    if (_close) return;
    final TableState tableState = _gameState.tableState;
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    if (_close) return;
    _gameState.resetPlayers(_context, notify: false);

    if (_close) return;
    _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    // next action seat is me
    if (!newHand.bombPot) {
      final nextActionSeat =
          _gameState.getSeat(_context, newHand.nextActionSeat);
      if (nextActionSeat != null && nextActionSeat.isMe) {
        // if straddle is allowed, my stack size > straddle value, and I haven't turned off straddle option
        if (_gameState.gameInfo.utgStraddleAllowed &&
            nextActionSeat.player.stack >= 2 * _gameState.gameInfo.bigBlind) {
          // set straddlePrompt true
          if (_gameState.settings.straddleOption) {
            // we show the straddle dialog only when the auto straddle is off
            if (_gameState.settings.autoStraddle == true) {
              // set straddle bet
              _gameState.straddleBetThisHand = true;
            } else {
              // prompt for the straddle dialog
              _gameState.straddlePrompt = true;
            }
          }
        }
      }

      /* marking the small blind */
      int smallBlindIdx = players.players.indexWhere((p) => p.seatNo == sbPos);
      assert(smallBlindIdx != -1);

      players.updatePlayerTypeSilent(
        smallBlindIdx,
        TablePosition.SmallBlind,
        coinAmount: smallBlind.toInt(),
      );

      /* marking the big blind */
      int bigBlindIdx = players.players.indexWhere((p) => p.seatNo == bbPos);
      assert(bigBlindIdx != -1);
      players.updatePlayerTypeSilent(
        bigBlindIdx,
        TablePosition.BigBlind,
        coinAmount: bigBlind.toInt(),
      );
    }

    // set player actions
    for (final seatNo in newHand.playersActed.keys) {
      final action = newHand.playersActed[seatNo];
      if (action.action != proto.ACTION.NOT_ACTED) {
        final seat = _gameState.getSeat(_context, seatNo);
        seat.player.action.setActionProto(action.action, action.amount);
      }
    }

    /* marking the dealer */
    int dealerIdx = players.players.indexWhere((p) => p.seatNo == dealerPos);

    if (dealerIdx == -1) {
      /* we have a open seat, set the dealer */
      if (_close) return;
      final Seat seat = _gameState.getSeat(_context, dealerPos);
      seat.isDealer = true;
    } else {
      players.updatePlayerTypeSilent(
        dealerIdx,
        TablePosition.Dealer,
      );
      handInfo.notify();
      players.notifyAll();
    }

    /* get a new card back asset to be shown */
    if (_close) return;

    final myState = _gameState.getMyState(_context);
    myState.notify();

    tableState.notifyAll();
    //log('Hand Message: ::handleNewHand:: END');
    _gameState.handState = HandState.NEW_HAND;
  }

  Future<void> handleDeal(proto.HandMessageItem message) async {
    //log('Hand Message: ::handleDeal:: START');

    // play the deal sound effect
    playSoundEffect(AppAssets.dealSound);

    final dealCards = message.dealCards;
    int mySeatNo = dealCards.seatNo;
    String cards = dealCards.cards;

    List<int> myCards = CardHelper.getRawCardNumbers(cards);
    if (_close) return;
    final players = _gameState.getPlayers(_context);

    List<int> seatNos = players.players.map((p) => p.seatNo).toList();
    seatNos.sort();
    players.updateCardSilent(mySeatNo, myCards);
    _gameState.currentCards = myCards;
    log('my cards: ${_gameState.currentCards}');

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    //for (int i = 0; i < myCards.length; i++) {
    /* for distributing the ith card, go through all the players, and give them */
    for (int seatNo in seatNos) {
      int localSeatNo = mySeatNo == null
          ? seatNo
          : ((seatNo - mySeatNo) % _gameState.gameInfo.maxPlayers) + 1;
      if (_close) return;
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat.player == null ||
          seat.player.stack == 0 ||
          seat.player.status != AppConstants.PLAYING) {
        continue;
      }

      // start the animation
      if (_close) return;
      _context.read<CardDistributionModel>().seatNo = localSeatNo;
      // wait for the animation to finish
      await Future.delayed(AppConstants.cardDistributionAnimationDuration);

      //debugPrint('Setting cards for $seatNo');
      players.updateVisibleCardNumberSilent(seatNo, myCards.length);
      players.notifyAll();
    }
    // if straddle prompt is true, trigger straddle state to show the dialog
    if (_gameState.straddlePrompt && _gameState.settings.straddleOption) {
      final straddlePromptState = _gameState.straddlePromptState;
      straddlePromptState.notify();
    }

    /* card distribution ends, put the value to NULL */
    if (_close) return;
    audioPlayer.stop();
    _context.read<CardDistributionModel>().seatNo = null;
    _gameState.handState = HandState.DEAL;

    //log('Hand Message: ::handleDeal:: END');
  }

  Future<void> handleYourAction(proto.HandMessageItem message) async {
    //log('Hand Message: ::handleYourAction:: START');

    if (_close) return;
    try {
      final me = _gameState.me(_context);
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
        if (_close) return;
        HandActionProtoService.takeAction(
          context: _context,
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
        if (_close) return;
        int secondsTillTimeout = seatAction.secondsTillTimesout;

        return RunItTwiceDialog.promptRunItTwice(
          context: _context,
          expTime: secondsTillTimeout,
        );
      } else {
        if (availableActions?.contains(AppConstants.STRADDLE) ?? false) {
          if (_close) return;
        }
      }

      if (_close) return;
      _gameState.setActionProto(_context, seatAction.seatNo, seatAction);

      if (_close) return;
      if (_gameState.straddlePrompt) {
        // we are showing the straddle prompt
      } else {
        // don't show
        _gameState.showAction(_context, true);
      }
    } finally {
      //log('Hand Message: ::handleYourAction:: END');
    }
  }

  playSoundEffect(String soundFile) {
    return;

    if (_gameState != null &&
        _gameState.settings != null &&
        _gameState.settings.gameSound) {
      _gameState
          .getAudioBytes(soundFile)
          .then((value) => audioPlayer.playBytes(value));
      // log('In playSoundEffect(), gameSounds = ${_gameState.settings.gameSound}');
    }
  }

  Future<void> handleNextAction(proto.HandMessageItem message) async {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn
    // log('handle next action start');

    try {
      var actionChange = message.actionChange;
      int seatNo = actionChange.seatNo;
      //log('Hand Message: ::handleNextAction:: START seatNo: $seatNo');

      if (_close) return;
      final TableState tableState = Provider.of<TableState>(
        _context,
        listen: false,
      );

      if (_close) return;
      final player = _gameState.fromSeat(_context, seatNo);
      assert(player != null);

      if (!player.isMe) {
        // hide action widget

        if (_close) return;
        _gameState.showAction(_context, false);
      }
      // log('next action seat: $seatNo player: ${player.name}');
      // highlight next action player
      player.highlight = true;

      if (_close) return;
      final seat = _gameState.getSeat(_context, seatNo);
      seat.setActionTimer(_gameState.gameInfo.actionTime);
      seat.notify();

      /* check if pot is available, if true, update the pot value in the table state object */
      try {
        List<int> pots = actionChange.pots
            ?.map<int>((e) => int.parse(e.toString()))
            ?.toList();
        double potUpdates = actionChange.potUpdates;

        tableState.updatePotChipsSilent(
          potChips: pots,
          potUpdatesChips: potUpdates.toInt(),
        );
      } catch (e) {}

      // tableState.updateTableStatusSilent(null);
      // tableState.notifyAll();
    } finally {
      //log('Hand Message: ::handleNextAction:: END');
    }
    // log('handle next action end');
  }

  Future<void> handleDealStarted({
    bool fromGameReplay = false,
    int testNo = 2, // works only if in testing mode
  }) async {
    //log('Hand Message: ::handleDealStarted:: START');
    // final me = _gameState.me(_context);

    /* if I am present in this game,
     Deal Start message is unnecessary */
    // if (fromGameReplay == false && me == null) return;

    if (_close) return;
    try {
      final TableState tableState = _gameState.tableState;

      tableState.clear();
      tableState.notifyAll();

      if (_close) return;

      // play the deal sound effect
      playSoundEffect(AppAssets.dealSound);

      /* show card shuffling*/
      tableState.updateCardShufflingAnimation(true);
      await Future.delayed(AppConstants.cardShufflingTotalWaitDuration); // wait
      tableState.updateCardShufflingAnimation(false);
      /* end card shuffling animation */

      if (_close) return;

      final players = _gameState.getPlayers(_context);
      List<int> seatNos = players.players.map((p) => p.seatNo).toList();
      seatNos.sort();

      if (_close) return;

      final handInfo = _gameState.getHandInfo(_context);

      if (_close) return;

      CardDistributionModel cardDistributionModel =
          _context.read<CardDistributionModel>();

      if (handInfo.noCards == 0) handInfo.update(noCards: testNo);

      /* distribute cards to the players */
      /* this for loop will distribute cards one by one to all the players */
      //for (int i = 0; i < handInfo.noCards; i++) {
      /* for distributing the ith card, go through all the players, and give them */
      for (int seatNo in seatNos) {
        if (_close) return;
        final seat = _gameState.getSeat(_context, seatNo);
        if (seat.player == null ||
            seat.player.stack == 0 ||
            seat.player.status != AppConstants.PLAYING) {
          continue;
        }

        // start the animation
        cardDistributionModel.seatNo = seatNo;
        if (_close) return;

        // wait for the animation to finish
        await Future.delayed(AppConstants.cardDistributionAnimationDuration);
        if (_close) return;

        players.updateVisibleCardNumberSilent(seatNo, handInfo.noCards);
        players.notifyAll();
      }
      //}

      /* card distribution ends, put the value to NULL */
      cardDistributionModel.seatNo = null;
      // tableState.updateTableStatusSilent(null);
      if (_close) return;
      // tableState.notifyAll();
      // no of cards in this game
      players.visibleCardNumbersForAllSilent(handInfo.noCards);
      if (_close) return;
      players.notifyAll();
    } finally {
      //log('Hand Message: ::handleDealStarted:: END');
    }
  }

  Future<void> handleBombPot() async {
    //log('Hand Message: ::handleBombPot:: START');
    if (_close) return;
    try {
      final TableState tableState = _gameState.tableState;
      final handInfo = _gameState.getHandInfo(_context);
      tableState.clear();
      tableState.notifyAll();
      if (_close) return;

      // play the bet sound effect
      playSoundEffect(AppAssets.betRaiseSound);

      // place players bets
      final players = _gameState.getPlayers(_context);
      for (final player in players.players) {
        if (player.inhand) {
          // get the seat
          Seat seat = _gameState.getSeatByPlayer(player.playerId);

          // update player bet & player stack
          seat.player.action.setBombPotAction(handInfo.bombPotBet);
          player.stack = player.stack - handInfo.bombPotBet.toInt();

          // notify seat
          seat.notify();
        }
      }
      if (_close) return;
      players.notifyAll();
      tableState.notifyAll();
    } finally {
      //log('Hand Message: ::handleDealStarted:: END');
    }
  }

  // we update the pot only during
  void updatePot(List<double> potValues, String key, BuildContext context) {
    try {
      List<int> pots = [];
      if (potValues != null) {
        pots = potValues.map((e) => e.toInt()).toList();
      }

      if (_close) return;
      final tableState = _gameState.tableState;

      tableState.updatePotChipsSilent(
        potChips: pots,
        potUpdatesChips: null,
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

    if (_close) return;
    final players = _gameState.getPlayers(_context);

    // show the move coin to pot animation, after that update the pot
    await _gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    _gameState.resetSeatActions();
    // update the pot

    if (_close) return;
    List<double> pots;
    if (stage == 'flop') {
      pots = message.flop.pots;
    } else if (stage == 'turn') {
      pots = message.turn.pots;
    } else if (stage == 'river') {
      pots = message.river.pots;
    }
    updatePot(pots, stage, _context);

    players.notifyAll();

    Map<int, String> playerCardRanks;
    // update the community cards
    if (stage == 'flop') {
      _gameState.handState = HandState.FLOP;
      playSoundEffect(AppAssets.flopSound);
      var board = message.flop.boards[0];
      List<CardObject> cards = [];
      for (int i = 0; i < 3; i++) {
        final c = CardHelper.getCard(
          int.parse(
            board.cards[i].toString(),
          ),
        );
        cards.add(c);
      }

      tableState.addFlopCards(1, cards);
      tableState.notifyAll();
      await Future.delayed(Duration(seconds: 1));
      audioPlayer.stop();

      if (message.flop.boards.length >= 2) {
        cards = [];
        board = message.flop.boards[1];
        for (int i = 0; i < 3; i++) {
          final c = CardHelper.getCard(
            int.parse(
              board.cards[i].toString(),
            ),
          );
          cards.add(c);
        }
        playSoundEffect(AppAssets.flopSound);
        tableState.addFlopCards(2, cards);
        tableState.updateTwoBoardsNeeded(true);
        tableState.notifyAll();
        await Future.delayed(Duration(seconds: 1));
        audioPlayer.stop();
      } else {
        tableState.updateTwoBoardsNeeded(false);
      }
      playerCardRanks = message.flop.playerCardRanks;
    } else if (stage == 'turn') {
      _gameState.handState = HandState.TURN;
      playSoundEffect(AppAssets.flopSound);
      var board = message.turn.boards[0];
      var turnCard = board.cards[3];
      playerCardRanks = message.turn.playerCardRanks;
      tableState.addTurnOrRiverCard(1, CardHelper.getCard(turnCard));
      tableState.notifyAll();
      await Future.delayed(Duration(seconds: 1));
      audioPlayer.stop();
      if (message.turn.boards.length == 2) {
        board = message.turn.boards[1];
        if (!tableState.twoBoardsNeeded) {
          tableState.updateTwoBoardsNeeded(true);
        }
        turnCard = board.cards[3];
        tableState.addTurnOrRiverCard(2, CardHelper.getCard(turnCard));
        playSoundEffect(AppAssets.flopSound);
        tableState.notifyAll();
        await Future.delayed(Duration(seconds: 1));
        audioPlayer.stop();
      }
    } else if (stage == 'river') {
      _gameState.handState = HandState.RIVER;
      playSoundEffect(AppAssets.flopSound);
      var board = message.river.boards[0];
      var riverCard = board.cards[4];
      playerCardRanks = message.river.playerCardRanks;
      tableState.addTurnOrRiverCard(1, CardHelper.getCard(riverCard));
      playSoundEffect(AppAssets.flopSound);
      tableState.notifyAll();
      await Future.delayed(Duration(seconds: 1));
      audioPlayer.stop();
      if (message.river.boards.length == 2) {
        board = message.river.boards[1];
        if (!tableState.twoBoardsNeeded) {
          tableState.updateTwoBoardsNeeded(true);
          // flop the cards here (run it twice)
        }
        audioPlayer.stop();
        riverCard = board.cards[4];
        tableState.addTurnOrRiverCard(2, CardHelper.getCard(riverCard));
        playSoundEffect(AppAssets.flopSound);
        tableState.notifyAll();
        await Future.delayed(Duration(seconds: 1));
        audioPlayer.stop();
      }
    }
    if (_close) return;
    updateRank(playerCardRanks);

    audioPlayer.stop();
    // log('stage update end');
  }

  void updateRank(Map<int, String> playerCardRanks, {String rankText}) {
    if (_gameState.isPlaying) {
      final me = _gameState.me(_context);
      final myState = _gameState.getMyState(_context);
      if (rankText != null) {
        me.rankText = rankText;
        myState.notify();
      } else {
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

  Future<void> handleQueryCurrentHand(proto.HandMessageItem message) async {
    final currentHandState = message.currentHandState;
    // log('Current hand state: $currentHandState');

    // current players cards
    String playerCards = currentHandState.playerCards;

    if (_close) return;
    final Players players = _context.read<Players>();

    if (_close) return;
    final tableState = _gameState.tableState;

    // if game is paused, we don't update cards
    if (_gameState.gameInfo.status == AppConstants.GAME_PAUSED) {
      return;
    }

    if (_close) return;
    final handInfo = _gameState.getHandInfo(_context);

    /* store the cards of the current player */
    int idxOfMe = players.players.indexWhere((p) => p.isMe);
    if (idxOfMe != -1)
      players.updateCardSilent(
        players.players[idxOfMe].seatNo,
        CardHelper.getRawCardNumbers(playerCards),
      );

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

    /* set the noOfVisible cards for other players */
    int noOfCards = currentHandState.noCards;
    handInfo.update(noCards: noOfCards);
    players.visibleCardNumbersForAllSilent(noOfCards);

    // boardCards update if available
    String currentRound = currentHandState.currentRound.name;

    try {
      List<int> boardCardsNum = currentHandState.boardCards;
      if (currentRound == "FLOP") {
        if (boardCardsNum.length >= 3) {
          boardCardsNum = boardCardsNum.sublist(0, 3);
        }
      } else if (currentRound == "TURN") {
        if (boardCardsNum.length >= 4) {
          boardCardsNum = boardCardsNum.sublist(0, 4);
        }
      } else if (currentRound == "RIVER" || currentRound == "SHOWDOWN") {
        if (boardCardsNum.length >= 5) {
          boardCardsNum = boardCardsNum;
        }
      } else if (currentRound == 'PREFLOP') {
        boardCardsNum = [];
      }

      if (boardCardsNum != null)
        tableState.setBoardCards(
          1,
          boardCardsNum.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
        );
    } catch (e) {}

    // update the pot values
    List<int> pots = currentHandState.pots
        ?.map<int>((e) => int.parse(e.toString()))
        ?.toList();
    final potUpdates = currentHandState.potUpdates?.toInt();

    tableState.updatePotChipsSilent(
      potChips: pots,
      potUpdatesChips: potUpdates,
    );

    tableState.notifyAll();

    // remainingActionTime
    int remainingActionTime = currentHandState.remainingActionTime != null
        ? int.parse(
            currentHandState.remainingActionTime.toString(),
          )
        : 0;

    if (_close) return;
    // put the remaining time in the provider
    _context.read<RemainingTime>().time = remainingActionTime;

    players.updateStackBulkSilent(
      currentHandState.playersStack,
    );

    players.notifyAll();
    handInfo.notify();

    // next seat to ACT - handle using Next_Action service
    // debugPrint('$currentHandState');
    int nextSeatToAct = int.parse(
      currentHandState.nextSeatToAct?.toString() ?? '-1',
    );

    if (nextSeatToAct == -1) return;

    int idx = players.players.indexWhere((p) => p.seatNo == nextSeatToAct);

    proto.HandMessageItem actionChange = proto.HandMessageItem();
    actionChange.actionChange = proto.ActionChange(seatNo: nextSeatToAct);
    if (players.players[idx].isMe) {
      handleNextAction(message);

      proto.HandMessageItem nextSeatAction = proto.HandMessageItem();
      nextSeatAction.seatAction = currentHandState.nextSeatAction;
      handleYourAction(nextSeatAction);
    } else {
      handleNextAction(message);
    }
    //log('Hand Message: ::handleStageChange:: END');

    // log('stage update done');
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
        imagePath: GameModelNew.getGameTypeImageAssetFromEnum(gameType),
      );
    }
    //log('Hand Message: ::handleAnnouncement:: END');
  }

  Future<void> handlePlayerActed(proto.HandMessageItem message) async {
    final playerActed = message.playerActed;
    int seatNo = playerActed.seatNo;
    //log('Hand Message: ::handlePlayerActed:: START seatNo: $seatNo');

    if (_gameState.uiClosing || _close) return;
    // show a prompt regarding last player action

    final seat = _gameState.getSeat(_context, seatNo);
    // hide straddle dialog
    if (_gameState.straddlePrompt) {
      _gameState.straddlePrompt = false;
      _context.read<StraddlePromptState>().notify();
    }
    if (_gameState.uiClosing || _close) return;
    if (seat?.player?.action == null) {
      ////log('Hand Message: ::handlePlayerActed:: player acted: $seatNo, player: ${seat.player.name}');
      return;
    }
    final action = seat.player.action;
    action.setActionProto(playerActed.action, playerActed.amount);
    //log('Hand Message: ::handlePlayerActed:: player acted: $seatNo, player: ${seat.player.name} action: ${action.action.toString()}');

    if (seat.player.isMe) {
      final Players players = _gameState.getPlayers(_context);
      final player = players.players.firstWhere(
        (p) => p.seatNo == seatNo,
        orElse: null,
      );
      if (player != null) {
        player.action = action;
        // notify of the last action
        players.notifyAll();
      }
    }

    // play the bet-raise sound effect
    if (action.action == HandActions.BET ||
        action.action == HandActions.RAISE ||
        action.action == HandActions.CALL) {
      playSoundEffect(AppAssets.betRaiseSound);
    } else if (action.action == HandActions.FOLD) {
      playSoundEffect(AppAssets.foldSound);
      seat.player.playerFolded = true;
      seat.player.animatingFold = true;
    } else if (action.action == HandActions.CHECK) {
      playSoundEffect(AppAssets.checkSound);
    }
    seat.notify();
    int stack = playerActed.stack?.toInt();
    if (stack != null) {
      seat.player.stack = stack;
    }

    if (_close) return;
    // before showing the prompt --> turn off the highlight on other players
    _gameState.resetActionHighlight(_context, -1);
    //log('Hand Message: ::handlePlayerActed:: END');
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
    List<int> pots = [];

    /* get the pots and update them */
    if (isRunItTwice) {
      // todo: handle this situation
      final board1Winners = runItTwiceResult.board1Winners;
      board1Winners.forEach((key, winner) {
        final amount = winner.amount.toInt();
        pots.add(amount);
      });
    } else {
      potWinners.forEach((key, potWinner) {
        final amount = potWinner.amount.toInt();
        pots.add(amount);
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

    // if (_gameState.isPlaying) {
    //   _context.read<RabbitState>().putResultProto(
    //         result,
    //         myCards: _gameState.getPlayers(_context).me.cards,
    //       );
    // }

    //_gameState.handState = HandState.RESULT;
    final json = result.toProto3Json();
    final jsonMsg = result.writeToJson();
    final out = jsonEncode(json);
    log("$out");
    log("\n\n$jsonMsg\n\n");
    if (_close) return;
    final Players players = _gameState.getPlayers(_context);
    _gameState.resetSeatActions();
    _gameState.lastHandNum = result.handNum;
    players.clearForShowdown();
    //log('Hand Message: ::handleResult:: START');

    int myID = players?.me?.playerId ?? 0;
    for (final seatNo in result.playerInfo.keys) {
      final playerInfo = result.playerInfo[seatNo];
      if (playerInfo.playedUntil == proto.HandStatus.SHOW_DOWN) {
        final seat = _gameState.getSeat(_context, seatNo);
        seat.player.cards = playerInfo.cards;
      }
    }
    _gameState.handState = HandState.RESULT;
    try {
      ResultHandlerV2 resultHandler = ResultHandlerV2(
        result: result,
        gameState: _gameState,
        context: _context,
        audioPlayer: audioPlayer,
        replay: false,
      );
      await resultHandler.show();
    } catch (err) {}
    _gameState.handState = HandState.ENDED;
    _gameState.handInProgress = false;
    //log('Hand Message: ::handleResult:: END');
  }

  Future<void> handleResult(proto.HandMessageItem message) async {
    /* invoke rabbit state */
    if (_close) return;

    if (_gameState.isPlaying) {
      _context.read<RabbitState>().putResultProto(
            message.handResult,
            myCards: _gameState.getPlayers(_context).me.cards,
          );
    }

    _gameState.handState = HandState.RESULT;

    if (_close) return;
    final Players players = _gameState.getPlayers(_context);
    _gameState.resetSeatActions();
    players.clearForShowdown();
    //log('Hand Message: ::handleResult:: START');

    // get hand winners data and update results
    final handResult = message.handResult;

    log('MY CARDS ${players.me.cards}');
    log('MY CARDS ${players.me.cardObjects}');

    /* showdown time, show other players cards */
    players.updateUserCardsSilent(
      _getCards(handResult, players?.me?.playerId ?? 0),
    );

    /* check if the result is a run it twice result */
    final bool isRunItTwice = handResult.runItTwice;

    List<int> boardCards = [];
    List<int> boardCards2 = [];
    if (handResult.boardCards != null) {
      for (final c in handResult.boardCards) {
        boardCards.add(int.parse(c.toString()));
      }
    }
    if (handResult.boardCards2 != null) {
      for (final c in handResult.boardCards2) {
        boardCards2.add(int.parse(c.toString()));
      }
    }

    final runItTwiceResult = handResult.handLog.runItTwiceResult;
    final potWinners = handResult.handLog.potWinners;
    final wonAt = handResult.handLog.wonAt;

    if (wonAt.name == 'FLOP') {
      boardCards = boardCards.sublist(0, 3);
    } else if (wonAt.name == 'TURN') {
      boardCards = boardCards.sublist(0, 4);
    } else if (wonAt.name == 'PREFLOP') {
      boardCards = [];
    }

    if (_close) return;
    updatePotBeforeResultStatic(
      potWinners: potWinners,
      runItTwiceResult: runItTwiceResult,
      isRunItTwice: isRunItTwice,
      context: _context,
    );

    if (_close) return;

    ResultHandler resultHandler = ResultHandler(
      isRunItTwice: isRunItTwice,
      runItTwiceResult: runItTwiceResult,
      potWinners: potWinners,
      boardCards: boardCards,
      boardCards2: boardCards2,
      gameState: _gameState,
      context: _context,
      audioPlayer: audioPlayer,
      replay: false,
    );
    await resultHandler.show();

    if (_gameState.isPlaying) {
      final me = _gameState.me(_context);
      final myState = _gameState.getMyState(_context);
      me.rankText = '';
      myState.notify();
    }

    // clear rabbit state
    if (_close) return;
    _context.read<RabbitState>().resultDone();

    if (_close) return;
    if (_gameState.highHand != null) {
      // animate high hand
      log('highhand');
      await showHighHands(_gameState.highHand);
      _gameState.highHand = null;
    }

    _gameState.handState = HandState.ENDED;
    _gameState.handInProgress = false;
    //log('Hand Message: ::handleResult:: END');
  }

  Future<void> showHighHands(final highHand) async {
    final int handNum = int.parse(highHand['handNum'].toString());

    // board Cards
    List<CardObject> boardCards = [];
    for (int c in highHand['boardCards']) boardCards.add(CardHelper.getCard(c));
    final tableState = _context.read<TableState>();

    List<Seat> playerSeats = [];

    // process the winners - also mark cards for highlighting
    final winners = highHand['winners'];
    for (final winner in winners) {
      final String name = winner['playerName'].toString();
      final int playerID = int.parse(winner['playerId'].toString());

      // get the player cards
      final List<int> playerCards = [];
      for (final v in winner['playerCards'])
        playerCards.add(int.parse(v.toString()));

      // get the board cards
      final List<int> rawHighHandCards = [];
      final List<CardObject> highHandCards = [];
      for (final v in winner['hhCards']) {
        final int value = int.parse(v.toString());
        rawHighHandCards.add(value);
        highHandCards.add(CardHelper.getCard(value));
      }

      // mark the board cards, that are part of high hands
      for (CardObject co in boardCards)
        if (rawHighHandCards.contains(co.cardNum)) co.highlight = true;

      // prepare the player for animations and cards
      final Seat seat = _gameState.getSeatByPlayer(playerID);
      seat.player.showFirework = true;
      seat.player.cards = playerCards;
      seat.player.highlightCards =
          rawHighHandCards; // this will highlight all the player cards that matches elements from this list
      playerSeats.add(seat);

      // show notification for winner
      Alerts.showHighHandWinner(
        playerCards: playerCards,
        boardCards: boardCards,
        highHandCards: rawHighHandCards,
        name: name,
        handNo: handNum,
      );
    }

    // notify to build the table (community cards)
    tableState.setBoardCards(1, boardCards);
    tableState.notifyAll();
    playSoundEffect(AppAssets.fireworksSound);

    // notify to build the players
    for (final s in playerSeats) s.notify();

    /* wait for the animation to finish */
    await Future.delayed(AppConstants.highHandFireworkAnimationDuration);

    // finally clear players values and board values

    // clear players
    for (final s in playerSeats) {
      s.player.showFirework = false;
      s.player.cards = [];
      s.player.highlightCards = [];
      s.notify();
    }

    // clear the board
    tableState.clear();
    tableState.notifyAll();
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
    _gameState.resetPlayers(_context, notify: true);

    if (_close) return;
    _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    List<GameType> gameChoices = [];
    for (final type in dealerChoice['games']) {
      final gameType =
          GameType.values[type]; //.firstWhere((element) => element == type);
      gameChoices.add(gameType);
    }
    final timeout = int.parse(dealerChoice['timeout'].toString());
    GameType type = await showGameSelectorDialog(
      listOfGameTypes: gameChoices,
      timeLimit: Duration(seconds: timeout),
    );
    log('selected game type: $type');
    if (type != GameType.UNKNOWN) {
      GameService.dealerChoice(_gameState.gameCode, type);
    }
  }
}
