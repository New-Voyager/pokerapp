import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/result_handler.dart';
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

class RetrySendingMsg {
  GameComService _gameComService;
  String _messageType;
  String _messageId;
  DateTime _messageSentTime;
  String _message;
  int _retryCount = 0;
  int _retrySeconds = 2;
  bool _ackReceived = false;
  bool _cancel = false;

  RetrySendingMsg(
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
          _gameComService.sendPlayerToHandChannel(_message);
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
  bool handleMsg(var data) {
    String messageType = data['messageType'].toString();
    if (messageType == AppConstants.MSG_ACK) {
      var msgAck = data['msgAck'];
      String messageId = msgAck['messageId'].toString();
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

class HandActionServiceDecprecated {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];

  bool _close = false;
  bool closed = false;

  GameComService _gameComService;
  EncryptionService _encryptionService;
  RetrySendingMsg _retryMsg;
  PlayerInfo _currentPlayer;
  AudioPlayer audioPlayer;

  HandActionServiceDecprecated(
    this._context,
    this._gameState,
    this._gameComService,
    this._encryptionService,
    this._currentPlayer, {
    this.audioPlayer,
  });

  void close() {
    _close = true;
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

    // gameContextObject.handActionService.playerActed(
    //   gameContextObject.playerId,
    //   handInfo.handNum,
    //   actionState.action.seatNo,
    //   action,
    //   amount,
    // );
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
    String message = """{
      "gameCode": "${_gameState.gameCode}",
      "playerId": "$playerID",
      "handNum": $handNum,
      "seatNo": $seatNo, 
      "messageId": "$messageId",
      "messages": [{
        "messageType": "PLAYER_ACTED",
        "playerActed": {
          "seatNo": $seatNo,
          "action": "$action",
          "amount": $amount
        }
      }]
    }""";
    _retryMsg =
        RetrySendingMsg(_gameComService, message, 'PLAYER_ACTED', messageId);
    _retryMsg.run();
  }

  queryCurrentHand() {
    int msgId = MessageId.incrementAndGet(_gameState.gameCode);
    String messageId = msgId.toString();
    int playerID = _gameState.currentPlayerId;
    String message = """{
      "gameCode": "${_gameState.gameCode}",
      "playerId": "$playerID",
      "messageId": "$messageId",
      "messages": [{
        "messageType": "QUERY_CURRENT_HAND"
      }]
    }""";
    // log(message);
    this._gameComService.sendPlayerToHandChannel(message);
  }

  handle(String message) async {
    //log('\n\n$message\n\n');
    assert(_gameState != null);
    assert(_context != null);
    assert(message != null && message.isNotEmpty);

    // debugPrint(message);
    var data = jsonDecode(message);
    List<dynamic> messages = data['messages'];
    _messages.addAll(messages);
  }

  Future<void> handleMessage(dynamic data) async {
    // if the service is closed, don't process incoming messages
    if (closed) return;

    final jsonData = jsonEncode(data);
    debugPrint(jsonData);
    debugLog(_gameState.gameCode, jsonData);

    String messageType = data['messageType'];

    if (_retryMsg != null) {
      bool handled = _retryMsg.handleMsg(data);
      // cancel retry now
      _retryMsg.cancel();
      _retryMsg = null;
      if (handled) {
        // acknowledgement message
        return;
      } else {
        // something went wrong, we need to refresh the screen
        this.queryCurrentHand();
      }
    }

    log('Hand Message: ::handleMessage:: START messageType: $messageType');

    try {
      // delegate further actions to sub services as per messageType
      switch (messageType) {
        case AppConstants.RESULT:
          await handleResult(data);
          return;

        case AppConstants.RUN_IT_TWICE:
          await handleRunItTwice(data);
          return;

        case AppConstants.NEW_HAND:
          await handleNewHand(data);
          return;

        case AppConstants.DEAL_STARTED:
          return handleDealStarted();

        case AppConstants.DEAL:
          return handleDeal(data);

        case AppConstants.QUERY_CURRENT_HAND:
          await handleQueryCurrentHand(data);
          return;

        case AppConstants.NEXT_ACTION:
          await handleNextAction(data);
          return;

        case AppConstants.PLAYER_ACTED:
          return handlePlayerActed(data);

        case AppConstants.YOUR_ACTION:
          await handleYourAction(data);
          return;

        case AppConstants.FLOP:
          await handleStageChange(data, 'flop');
          return;

        case AppConstants.TURN:
          return handleStageChange(data, 'turn');

        case AppConstants.RIVER:
          return handleStageChange(data, 'river');

        case AppConstants.ANNOUNCEMENT:
          return handleAnnouncement(data);

        case AppConstants.DEALER_CHOICE:
          return handleDealerChoice(data);
      }
    } catch (err) {
      log('Error: ${err.toString()}');
    } finally {
      log('Hand Message: ::handleMessage:: END messageType: $messageType');
    }
  }

  static Future<void> handleRunItTwiceStatic({
    @required BuildContext context,
    @required List<int> board1Cards,
    @required List<int> board2Cards,
  }) async {
    final GameState gameState = GameState.getState(context);
    final TableState tableState = gameState.getTableState(context);

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

  Future<void> handleRunItTwice(var data) async {
    final runItTwice = data['runItTwice'];

    final List<int> board1Cards = [];
    final List board1 = runItTwice['board1'];
    for (int c in board1) {
      board1Cards.add(int.parse(c.toString()));
    }

    final List<int> board2Cards = [];
    final List board2 = runItTwice['board2'];
    for (int c in board2) {
      board1Cards.add(int.parse(c.toString()));
    }

    return handleRunItTwiceStatic(
      context: _context,
      board1Cards: board1Cards,
      board2Cards: board2Cards,
    );
  }

  Future<void> handleDealerChoice(var data) async {
    final dealerChoice = data['dealerChoice'];
    if (dealerChoice == null) {
      return;
    }

    if (_close) return;
    final TableState tableState = _gameState.getTableState(_context);
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

  Future<void> handleNewHand(var data) async {
    _gameState.handState = HandState.STARTED;
    _gameState.highHand = null;
    log('Hand Message: ::handleNewHand:: START');
    playSoundEffect(AppAssets.newHandSound);

    log(jsonEncode(data));
    /* data contains the dealer, small blind and big blind seat Positions
    * Update the Players object with these information */
    var newHand = data['newHand'];

    // there are seat nos
    int dealerPos = newHand['buttonPos'];
    int sbPos = newHand['sbPos'];
    int bbPos = newHand['bbPos'];
    int noCards = newHand['noCards'];
    double bigBlind = double.parse(newHand['bigBlind'].toString());
    double smallBlind = double.parse(newHand['smallBlind'].toString());
    int handNum = int.parse(newHand["handNum"].toString());
    String gameTypeStr = newHand['gameType'].toString();
    final gameType = GameType.values.firstWhere(
        (element) => (element.toString() == 'GameType.' + gameTypeStr));
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
    );

    // set small blind and big blind
    if (_close) return;
    final noOfPlayers = newHand['playersInSeats'].length;
    if (_gameState.gameInfo.playersInSeats.length != noOfPlayers) {
      log('gameState seats does not match with new hand. * Refreshing *');
      await _gameState.refresh(_context);
      log('gameState seats does not match with new hand. * Refreshing Done *');
    }

    if (_close) return;
    final Players players = _gameState.getPlayers(_context);

    // update player's state and stack
    final dynamic playersInSeats = newHand['playersInSeats'];
    bool refresh = false;
    for (final seatNoStr in playersInSeats.keys) {
      final seatNo = int.parse(seatNoStr);
      if (_close) return;
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat == null && seat.player == null) {
        refresh = true;
        break;
      }

      final player = players.fromSeat(seatNo);
      if (player == null) {
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
    }

    final sbSeat = _gameState.getSeat(_context, sbPos);
    sbSeat.player.action.sb = true;
    sbSeat.player.action.amount = _gameState.gameInfo.smallBlind.toDouble();

    if (_close) return;
    final bbSeat = _gameState.getSeat(_context, bbPos);
    bbSeat.player.action.bb = true;
    bbSeat.player.action.amount = _gameState.gameInfo.bigBlind.toDouble();

    if (_close) return;
    final TableState tableState = _gameState.getTableState(_context);
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    if (_close) return;
    _gameState.resetPlayers(_context, notify: false);

    if (_close) return;
    _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    for (final seatNoStr in playersInSeats.keys) {
      final seatNo = int.parse(seatNoStr);
      if (_close) return;
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat != null && seat.player != null) {
        final dynamic playerUpdate = playersInSeats[seatNoStr];
        final double stack = double.parse(playerUpdate['stack'].toString());
        seat.player.stack = stack.toInt();
        seat.player.startingStack = stack.toInt();

        final String statusStr = playerUpdate['status'].toString();
        final status = PlayerStatus.values.firstWhere(
            (element) => (element.toString() == 'PlayerStatus.' + statusStr));
        seat.player.status = playerUpdate['status'].toString();
        if (status == PlayerStatus.WAIT_FOR_BUYIN ||
            status == PlayerStatus.WAIT_FOR_BUYIN_APPROVAL) {
          // show buyin timer
          seat.player.showBuyIn = true;
          seat.player.buyInTimeExpAt =
              DateTime.parse(playerUpdate['buyInExpTime'].toString());

          // show buyin button
          if (seat.player.isMe) {
            if (_close) return;
            _gameState.getMyState(_context).notify();
          }
        } else {
          seat.player.showBuyIn = false;
          seat.player.buyInTimeExpAt = null;
        }
      }
    }

    // next action seat is me
    final nextActionSeat =
        _gameState.getSeat(_context, newHand['nextActionSeat']);
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
    _context.read<ValueNotifier<String>>().value = CardBackAssets.getRandom();
    // // wait for the fastAnimationDuration completion
    // // this is done to wait until the footerResult section is removed

    // /* put new hand message */
    // tableState.updateTableStatusSilent(AppConstants.NEW_HAND);
    // tableState.notifyAll();

    // log('Hand Message: ::handleNewHand:: Delaying');
    // await Future.delayed(Duration(milliseconds: 10000));
    // tableState.updateTableStatusSilent(AppConstants.CLEAR);
    tableState.notifyAll();
    log('Hand Message: ::handleNewHand:: END');
    _gameState.handState = HandState.NEW_HAND;
  }

  Future<void> handleDeal(var data) async {
    log('Hand Message: ::handleDeal:: START');

    // play the deal sound effect
    playSoundEffect(AppAssets.dealSound);

    int mySeatNo = data['dealCards']['seatNo'];
    String cards = data['dealCards']['cards'];

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
      final straddlePromptState = _gameState.straddlePromptState(_context);
      straddlePromptState.notify();
    }

    /* card distribution ends, put the value to NULL */
    if (_close) return;
    audioPlayer.stop();
    _context.read<CardDistributionModel>().seatNo = null;
    _gameState.handState = HandState.DEAL;

    log('Hand Message: ::handleDeal:: END');
  }

  Future<void> handleYourAction(var data) async {
    log('Hand Message: ::handleYourAction:: START');

    if (_close) return;
    try {
      final me = _gameState.me(_context);
      if (me == null) {
        return;
      }

      var seatAction = data['seatAction'];
      int seatNo = int.parse(seatAction['seatNo'].toString());
      if (me.seatNo != seatNo) {
        return;
      }

      /* play an sound effect alerting the user */
      playSoundEffect(AppAssets.playerTurnSound);

      if (_gameState.straddleBetThisHand == true) {
        // we have the straddleBet set to true, do a bet
        if (_close) return;
        HandActionServiceDecprecated.takeAction(
          context: _context,
          action: AppConstants.STRADDLE,
          amount: 2 * _gameState.gameInfo.bigBlind,
        );

        // once, the first bet is done, set straddleBet to false, and wait for next hand
        return _gameState.straddleBetThisHand = false;
      }

      /* this part handles if we receive a prompt for run it twice */
      List<String> availableActions = seatAction['availableActions']
          .map<String>((e) => e.toString())
          .toList();
      if (availableActions?.contains(AppConstants.RUN_IT_TWICE_PROMPT) ??
          false) {
        if (_close) return;
        int secondsTillTimeout = seatAction['secondsTillTimesout'];

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
      _gameState.setAction(_context, seatNo, seatAction);

      if (_close) return;
      if (_gameState.straddlePrompt) {
        // we are showing the straddle prompt
      } else {
        // don't show
        _gameState.showAction(_context, true);
      }
    } finally {
      log('Hand Message: ::handleYourAction:: END');
    }
  }

  playSoundEffect(String soundFile) {
    if (_gameState.settings.gameSound) {
      _gameState
          .getAudioBytes(soundFile)
          .then((value) => audioPlayer.playBytes(value));
      // log('In playSoundEffect(), gameSounds = ${_gameState.settings.gameSound}');
    }
  }

  Future<void> handleNextAction(var data) async {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn
    // log('handle next action start');

    try {
      var actionChange = data['actionChange'];
      int seatNo = actionChange['seatNo'];
      log('Hand Message: ::handleNextAction:: START seatNo: $seatNo');

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
        List<int> pots = actionChange['pots']
            ?.map<int>((e) => int.parse(e.toString()))
            ?.toList();
        var potUpdates = actionChange['potUpdates'];

        tableState.updatePotChipsSilent(
          potChips: pots,
          potUpdatesChips: potUpdates,
        );
      } catch (e) {}

      // tableState.updateTableStatusSilent(null);
      // tableState.notifyAll();
    } finally {
      log('Hand Message: ::handleNextAction:: END');
    }
    // log('handle next action end');
  }

  Future<void> handleDealStarted({
    bool fromGameReplay = false,
    int testNo = 2, // works only if in testing mode
  }) async {
    log('Hand Message: ::handleDealStarted:: START');
    // final me = _gameState.me(_context);

    /* if I am present in this game,
     Deal Start message is unnecessary */
    // if (fromGameReplay == false && me == null) return;

    if (_close) return;
    try {
      final TableState tableState = _gameState.getTableState(_context);

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
      log('Hand Message: ::handleDealStarted:: END');
    }
  }

  // we update the pot only during
  void updatePot(var data, String key, BuildContext context) {
    try {
      List<int> pots =
          data[key]['pots']?.map<int>((e) => int.parse(e.toString()))?.toList();

      if (_close) return;
      final tableState = _gameState.getTableState(_context);

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
    var data,
    String stage,
  ) async {
    assert(stage != null);
    // log('stage update start');
    log('Hand Message: ::handleStageChange:: START');
    log(jsonEncode(data));

    if (_close) return;
    final TableState tableState = _gameState.getTableState(_context);

    if (_close) return;
    final players = _gameState.getPlayers(_context);

    // show the move coin to pot animation, after that update the pot
    await _gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    _gameState.resetSeatActions();
    // update the pot

    if (_close) return;
    updatePot(data, stage, _context);

    players.notifyAll();

    // update the community cards
    if (stage == 'flop') {
      _gameState.handState = HandState.FLOP;
      playSoundEffect(AppAssets.flopSound);

      var board = data[stage]['board'];
      List<CardObject> cards = [];
      for (int i = 0; i < 3; i++) {
        final c = CardHelper.getCard(
          int.parse(
            board[i].toString(),
          ),
        );
        cards.add(c);
      }

      tableState.addFlopCards(1, cards);
    } else if (stage == 'turn') {
      _gameState.handState = HandState.TURN;
      playSoundEffect(AppAssets.flopSound);

      tableState.addTurnOrRiverCard(
          1, CardHelper.getCard(data[stage]['${stage}Card']));
    } else if (stage == 'river') {
      _gameState.handState = HandState.RIVER;
      playSoundEffect(AppAssets.flopSound);

      tableState.addTurnOrRiverCard(
          1, CardHelper.getCard(data[stage]['${stage}Card']));
    }
    if (_close) return;
    updateRank(data[stage]);

    tableState.notifyAll();
    await Future.delayed(Duration(seconds: 1));
    audioPlayer.stop();
    // log('stage update end');
  }

  void updateRank(var data, {String rankText}) {
    if (_gameState.isPlaying) {
      final me = _gameState.me(_context);
      final playerCardRanks = data['playerCardRanks'];
      final myState = _gameState.getMyState(_context);
      if (rankText != null) {
        me.rankText = rankText;
        myState.notify();
      } else {
        for (final seatNoStr in playerCardRanks.keys) {
          final seatNo = int.parse(seatNoStr);
          if (seatNo == me.seatNo) {
            _encryptionService
                .decodeAndDecrypt(playerCardRanks[seatNoStr])
                .then((decryptedBytes) => utf8.decode(decryptedBytes))
                .then((rankStr) => {me.rankText = rankStr})
                .then((value) => myState.notify());
            break;
          }
        }
      }
    }
  }

  Future<void> handleQueryCurrentHand(var data) async {
    var currentHandState = data['currentHandState'];
    // log('Current hand state: $currentHandState');

    // current players cards
    String playerCards = currentHandState['playerCards'];

    if (_close) return;
    final Players players = _context.read<Players>();

    if (_close) return;
    final tableState = _gameState.getTableState(_context);

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

    int handNum = int.parse(currentHandState["handNum"].toString());
    double smallBlind = double.parse(currentHandState["smallBlind"].toString());
    double bigBlind = double.parse(currentHandState["bigBlind"].toString());
    String gameTypeStr = currentHandState['gameType'].toString();
    final gameType = GameType.values.firstWhere(
        (element) => (element.toString() == 'GameType.' + gameTypeStr));

    handInfo.update(
      handNum: handNum,
      smallBlind: smallBlind,
      bigBlind: bigBlind,
      gameType: gameType,
    );

    /* set the noOfVisible cards for other players */
    int noOfCards = int.parse(currentHandState["noCards"].toString());
    handInfo.update(noCards: noOfCards);
    players.visibleCardNumbersForAllSilent(noOfCards);

    // boardCards update if available
    String currentRound = currentHandState["currentRound"];

    try {
      List<int> boardCardsNum = currentHandState['boardCards']
          .map<int>((e) => int.parse(e.toString()))
          .toList();
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
    List<int> pots = currentHandState['pots']
        ?.map<int>((e) => int.parse(e.toString()))
        ?.toList();
    var potUpdates = currentHandState['potUpdates'];

    tableState.updatePotChipsSilent(
      potChips: pots,
      potUpdatesChips: potUpdates,
    );

    tableState.notifyAll();

    // remainingActionTime
    int remainingActionTime = currentHandState['remainingActionTime'] != null
        ? int.parse(
            currentHandState['remainingActionTime'].toString(),
          )
        : 0;

    if (_close) return;
    // put the remaining time in the provider
    _context.read<RemainingTime>().time = remainingActionTime;

    players.updateStackBulkSilent(
      currentHandState['playersStack'],
    );

    players.notifyAll();
    handInfo.notify();

    // next seat to ACT - handle using Next_Action service
    // debugPrint('$currentHandState');
    int nextSeatToAct = int.parse(
      currentHandState['nextSeatToAct']?.toString() ?? '-1',
    );

    if (nextSeatToAct == -1) return;

    int idx = players.players.indexWhere((p) => p.seatNo == nextSeatToAct);

    if (players.players[idx].isMe) {
      handleNextAction(
        {
          'actionChange': {
            'seatNo': nextSeatToAct,
            'pots': [{}],
          },
        },
      );

      handleYourAction(
        jsonDecode("""{
           "clubId":${data['clubId']},
           "gameId":"${data['gameId']}",
           "gameCode":"${data['gameCode']}",
           "handNum":${data['handNum']},
           "playerId":"${data['playerId']}",
           "seatAction":${jsonEncode(data['currentHandState']['nextSeatAction'])}
        }"""),
      );
    } else {
      handleNextAction(
        {
          'actionChange': {
            'seatNo': nextSeatToAct,
            'pots': [{}],
          },
        },
      );
    }
    log('Hand Message: ::handleStageChange:: END');

    // log('stage update done');
  }

  Future<void> handleAnnouncement(var data) async {
    log('Hand Message: ::handleAnnouncement:: START');

    var announcement = data['announcement'];
    String type = announcement['type'].toString();
    if (type == 'NewGameType') {
      String game = announcement['params'][0].toString();
      GameType gameType = gameTypeFromStr(game);
      // String title = gameTypeStr(gameType);
      log("-=-= $gameType");
      Alerts.showNotification(
        titleText: gameTypeStr(gameType),
        duration: Duration(seconds: 5),
        imagePath: GameModelNew.getGameTypeImageAssetFromEnum(gameType),
      );
      // showOverlayNotification(
      //   (context) => OverlayNotificationWidget(
      //     title: title,
      //     subTitle: '',
      //   ),
      //   duration: Duration(seconds: 5),
      // );
    }
    log('Hand Message: ::handleAnnouncement:: END');
  }

  Future<void> handlePlayerActed(var data) async {
    var playerActed = data['playerActed'];
    int seatNo = playerActed['seatNo'];
    log('Hand Message: ::handlePlayerActed:: START seatNo: $seatNo');
    log(jsonEncode(data));

    if (_close) return;
    // show a prompt regarding last player action
    final gameState = _context.read<GameState>();

    if (_close) return;
    final seat = gameState.getSeat(_context, seatNo);
    // hide straddle dialog
    if (gameState.straddlePrompt) {
      gameState.straddlePrompt = false;
      _context.read<StraddlePromptState>().notify();
    }
    if (seat.player.action == null) {
      log('Hand Message: ::handlePlayerActed:: player acted: $seatNo, player: ${seat.player.name}');
    }
    final action = seat.player.action;
    action.setAction(playerActed);
    log('Hand Message: ::handlePlayerActed:: player acted: $seatNo, player: ${seat.player.name} action: ${action.action.toString()}');

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
    int stack = playerActed['stack'];
    if (stack != null) {
      seat.player.stack = stack;
    }

    if (_close) return;
    // before showing the prompt --> turn off the highlight on other players
    gameState.resetActionHighlight(_context, -1);
    log('Hand Message: ::handlePlayerActed:: END');
  }

  /* seat-no, list of cards mapping */
  static Map<int, List<int>> _getCards(final data, int myID) {
    final Map players = data['handResult']['players'];

    final String kShowDown = 'SHOW_DOWN';

    Map<int, List<int>> seatNoCardsMap = Map<int, List<int>>();

    players.forEach((seatNo, d) {
      /* WE ONLY SHOW CARDS FOR PLAYERS, WHO PLAYED TILL THE SHOWDOWN */
      final int sn = int.parse(seatNo.toString());
      final String playerID = d['id'] as String;

      // if it's me do not update my cards
      if (playerID != '$myID') {
        // if the player has survived till show down
        if (d['playedUntil'] == kShowDown)
          seatNoCardsMap[sn] =
              d['cards']?.map<int>((e) => int.parse(e.toString()))?.toList();
      }
    });

    return seatNoCardsMap;
  }

  static void updatePotBeforeResultStatic({
    @required final runItTwiceResult,
    @required final potWinners,
    @required final BuildContext context,
    final bool isRunItTwice = false,
  }) {
    List<int> pots = [];

    /* get the pots and update them */
    if (isRunItTwice) {
      // todo: handle this situation
      final Map board1Winners = runItTwiceResult['board1Winners'];
      board1Winners.forEach((key, winner) {
        final amount = winner['amount'] as int;
        pots.add(amount);
      });
    } else {
      potWinners.forEach((key, potWinner) {
        final amount = potWinner['amount'] as int;
        pots.add(amount);
      });
    }

    /* update the table pots before the result */
    final gameState = GameState.getState(context);
    final tableState = gameState.getTableState(context);
    tableState.updatePotChipsSilent(potChips: pots);
    tableState.notifyAll();
  }

  Future<void> handleResult(var data) async {
    /* invoke rabbit state */
    if (_close) return;

    if (_gameState.isPlaying) {
      _context.read<RabbitState>().putResult(
            data,
            myCards: _gameState.getPlayers(_context).me.cards,
          );
    }

    _gameState.handState = HandState.RESULT;

    if (_close) return;
    final Players players = _gameState.getPlayers(_context);
    _gameState.resetSeatActions();
    players.clearForShowdown();
    log('Hand Message: ::handleResult:: START');

    // get hand winners data and update results
    final handResult = data['handResult'];

    Map<String, dynamic> result = {
      "hand": {"data": handResult},
      "myInfo": {
        "id": _currentPlayer.id,
        "name": _currentPlayer.name,
        "uuid": _currentPlayer.uuid
      }
    };
    final jsonData = jsonEncode(result);
    log('\nResult: \n');
    log('Result: ' + jsonData);
    log('\n\n');
    final handNum = handResult['handNum'];
    _gameState.lastHand = jsonData;
    _gameState.setHandLog(handNum, jsonData, _gameState.currentCards);

    log('MY CARDS ${players.me.cards}');
    log('MY CARDS ${players.me.cardObjects}');

    /* showdown time, show other players cards */
    players.updateUserCardsSilent(
      _getCards(data, players?.me?.playerId ?? 0),
    );

    /* check if the result is a run it twice result */
    final bool isRunItTwice = handResult['runItTwice'] as bool;

    List<int> boardCards = [];
    List<int> boardCards2 = [];
    if (handResult['boardCards'] != null) {
      for (final c in handResult['boardCards']) {
        boardCards.add(int.parse(c.toString()));
      }
    }
    if (handResult['boardCards2'] != null) {
      for (final c in handResult['boardCards2']) {
        boardCards2.add(int.parse(c.toString()));
      }
    }

    final runItTwiceResult = handResult['handLog']['runItTwiceResult'];
    final potWinners = handResult['handLog']['potWinners'];
    final wonAt = handResult['handLog']['wonAt'];

    if (wonAt == 'FLOP') {
      boardCards = boardCards.sublist(0, 3);
    } else if (wonAt == 'TURN') {
      boardCards = boardCards.sublist(0, 4);
    } else if (wonAt == 'PREFLOP') {
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
    }

    _gameState.handState = HandState.ENDED;
    log('Hand Message: ::handleResult:: END');
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
}