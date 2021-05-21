import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/high_hand_service.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:pokerapp/services/test/test_service.dart';
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
        log('Sending $_messageType again');
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

  /**
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
        log('Received acknowledgement');
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

class HandActionService {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];
  bool closed = false;
  GameComService _gameComService;
  RetrySendingMsg _retryMsg;
  HandActionService(this._context, this._gameState, this._gameComService);

  void close() {
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

    gameContextObject.handActionService.playerActed(
      gameContextObject.playerId,
      handInfo.handNum,
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
    log(message);
    this._gameComService.sendPlayerToHandChannel(message);
  }

  handle(String message) async {
    assert(_gameState != null);
    assert(_context != null);
    assert(message != null && message.isNotEmpty);

    debugPrint(message);
    var data = jsonDecode(message);
    List<dynamic> messages = data['messages'];
    _messages.addAll(messages);
  }

  Future<void> handleMessage(dynamic data) async {
    // if the service is closed, don't process incoming messages
    if (closed) {
      return;
    }

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
          // await handleDealStarted(
          //   context: context,
          // );
          return null;

        case AppConstants.DEAL:
          await handleDeal(data);
          return null;

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
    }
  }

  static Future<void> handleRunItTwiceStatic({
    @required BuildContext context,
    @required List<int> board1Cards,
    @required List<int> board2Cards,
  }) async {
    final GameState gameState = GameState.getState(context);
    final TableState tableState = gameState.getTableState(context);

    final List<CardObject> b1 =
        board1Cards.map<CardObject>((c) => CardHelper.getCard(c)).toList();

    final List<CardObject> b2 =
        board2Cards.map<CardObject>((c) => CardHelper.getCard(c)).toList();

    tableState.updateTwoBoardsNeeded(true);

    /* show the board 1 cards */
    await tableState.addAllCommunityCardsForRunItTwiceScenario(1, b1);

    /* pause for a bit todo: get duration */
    await Future.delayed(const Duration(milliseconds: 500));

    /* show the board 2 cards */
    await tableState.addAllCommunityCardsForRunItTwiceScenario(2, b2);

    /* pause for a bit todo: get duration */
    await Future.delayed(const Duration(milliseconds: 2000));
  }

  Future<void> handleRunItTwice(var data) async {
    final runItTwice = data['runItTwice'];

    final List<int> board1Cards = runItTwice['board1']
        .map<CardObject>((c) => int.parse(c.toString()))
        .toList();

    final List<int> board2Cards = runItTwice['board2']
        .map<CardObject>((c) => int.parse(c.toString()))
        .toList();

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

    final TableState tableState = _gameState.getTableState(_context);
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    _gameState.resetPlayers(_context, notify: true);

    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.None;

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
    /* play the new hand sound effect */
    Audio.play(
      context: _context,
      assetFile: AppAssets.newHandSound,
    );

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
    _gameState.resetSeatActions();

    final handInfo = _gameState.getHandInfo(_context);
    handInfo.update(
      handNum: handNum,
      noCards: noCards,
      gameType: gameType,
      smallBlind: smallBlind,
      bigBlind: bigBlind,
    );

    // set small blind and big blind
    final sbSeat = _gameState.getSeat(_context, sbPos);
    sbSeat.player.action.sb = true;
    sbSeat.player.action.amount = _gameState.gameInfo.smallBlind.toDouble();

    final bbSeat = _gameState.getSeat(_context, bbPos);
    bbSeat.player.action.bb = true;
    bbSeat.player.action.amount = _gameState.gameInfo.bigBlind.toDouble();

    final Players players = _gameState.getPlayers(_context);

    final TableState tableState = _gameState.getTableState(_context);
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    _gameState.resetPlayers(_context, notify: false);

    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.None;

    // update player's state and stack
    final dynamic playersInSeats = newHand['playersInSeats'];
    bool refresh = false;
    for (final seatNoStr in playersInSeats.keys) {
      final seatNo = int.parse(seatNoStr);
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
      _gameState.refresh(_context);
    }

    for (final seatNoStr in playersInSeats.keys) {
      final seatNo = int.parse(seatNoStr);
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat != null && seat.player != null) {
        final dynamic playerUpdate = playersInSeats[seatNoStr];
        final double stack = double.parse(playerUpdate['stack'].toString());
        seat.player.stack = stack.toInt();

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
            _gameState.getMyState(_context).notify();
          }
        } else {
          seat.player.showBuyIn = false;
          seat.player.buyInTimeExpAt = null;
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
    //print('dealer index: $dealerIdx');
    assert(dealerIdx != -1);
    players.updatePlayerTypeSilent(
      dealerIdx,
      TablePosition.Dealer,
    );
    handInfo.notify();
    players.notifyAll();

    /* get a new card back asset to be shown */
    Provider.of<ValueNotifier<String>>(
      _context,
      listen: false,
    ).value = CardBackAssets.getRandom();

    // wait for the fastAnimationDuration completion
    // this is done to wait until the footerResult section is removed

    /* put new hand message */
    // log('display shuffling animation');
    tableState.updateTableStatusSilent(AppConstants.NEW_HAND);
    tableState.notifyAll();
    await Future.delayed(Duration(milliseconds: 1000));
    tableState.updateTableStatusSilent(AppConstants.CLEAR);
    tableState.notifyAll();
  }

  Future<void> handleDeal(var data) async {
    // play the deal sound effect
    Audio.play(
      context: _context,
      assetFile: AppAssets.dealSound,
    );

    int mySeatNo = data['dealCards']['seatNo'];
    String cards = data['dealCards']['cards'];

    List<int> myCards = CardHelper.getRawCardNumbers(cards);
    final players = _gameState.getPlayers(_context);

    List<int> seatNos = players.players.map((p) => p.seatNo).toList();
    seatNos.sort();

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    //for (int i = 0; i < myCards.length; i++) {
    /* for distributing the ith card, go through all the players, and give them */
    for (int seatNo in seatNos) {
      int localSeatNo =
          mySeatNo == null ? seatNo : ((seatNo - mySeatNo) % 9) + 1;
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat.player == null ||
          seat.player.stack == 0 ||
          seat.player.status != AppConstants.PLAYING) {
        continue;
      }

      // start the animation
      Provider.of<CardDistributionModel>(
        _context,
        listen: false,
      ).seatNo = localSeatNo;
      // wait for the animation to finish
      await Future.delayed(AppConstants.cardDistributionAnimationDuration);

      if (seatNo == mySeatNo) {
        // this is me - give me my cards one by one
        players.updateCardSilent(mySeatNo, myCards);
      }
      //debugPrint('Setting cards for $seatNo');
      players.updateVisibleCardNumberSilent(seatNo, myCards.length);
      players.notifyAll();
    }
    //}

    /* card distribution ends, put the value to NULL */
    Provider.of<CardDistributionModel>(
      _context,
      listen: false,
    ).seatNo = null;
  }

  Future<void> handleYourAction(var data) async {
    /* play an sound effect alerting the user */
    Audio.play(
      context: _context,
      assetFile: AppAssets.playerTurnSound,
    );

    final me = _gameState.me(_context);
    if (me == null) {
      return;
    }
    var seatAction = data['seatAction'];
    int seatNo = int.parse(seatAction['seatNo'].toString());
    if (me.seatNo != seatNo) {
      return;
    }

    /* this part handles if we receive a prompt for run it twice */
    List<String> availableActions = seatAction['availableActions']
        .map<String>((e) => e.toString())
        .toList();
    if (availableActions?.contains(AppConstants.RUN_IT_TWICE_PROMPT) ?? false) {
      return RunItTwiceDialog.promptRunItTwice(
        context: _context,
        expTime: 30, // TODO: WE GET THIS TIME FROM THE SERVER
      );
    }

    _gameState.setAction(_context, seatNo, seatAction);
    _gameState.showAction(_context, true);
  }

  Future<void> handleNextAction(var data) async {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn
    // log('handle next action start');
    var actionChange = data['actionChange'];
    int seatNo = actionChange['seatNo'];

    final TableState tableState = Provider.of<TableState>(
      _context,
      listen: false,
    );

    final player = _gameState.fromSeat(_context, seatNo);
    // log('next action seat no: $seatNo');
    assert(player != null);

    if (!player.isMe) {
      // hide action widget
      _gameState.showAction(_context, false);
    }
    // log('next action seat: $seatNo player: ${player.name}');
    // highlight next action player
    player.highlight = true;
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

    tableState.updateTableStatusSilent(null);
    tableState.notifyAll();
    // log('handle next action end');
  }

  Future<void> handleDealStarted({
    bool fromGameReplay = false,
    // works only if in testing mode
    int testNo = 2,
  }) async {
    // final me = _gameState.me(_context);

    /* if I am present in this game,
     Deal Start message is unnecessary */
    // if (fromGameReplay == false && me == null) return;

    /* show card shuffling */
    final TableState tableState = _gameState.getTableState(_context);
    /* stop showing card shuffling */
    tableState.clear();
    tableState.notifyAll();

    // play the deal sound effect
    Audio.play(
      context: _context,
      assetFile: AppAssets.dealSound,
    );
    final players = _gameState.getPlayers(_context);
    List<int> seatNos = players.players.map((p) => p.seatNo).toList();
    seatNos.sort();

    final handInfo = _gameState.getHandInfo(_context);

    CardDistributionModel cardDistributionModel =
        Provider.of<CardDistributionModel>(
      _context,
      listen: false,
    );

    if (handInfo.noCards == 0) handInfo.update(noCards: testNo);

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    //for (int i = 0; i < handInfo.noCards; i++) {
    /* for distributing the ith card, go through all the players, and give them */
    for (int seatNo in seatNos) {
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat.player == null ||
          seat.player.stack == 0 ||
          seat.player.status != AppConstants.PLAYING) {
        continue;
      }

      // start the animation
      cardDistributionModel.seatNo = seatNo;

      // wait for the animation to finish
      await Future.delayed(AppConstants.cardDistributionAnimationDuration);

      players.updateVisibleCardNumberSilent(seatNo, handInfo.noCards);
      players.notifyAll();
    }
    //}

    /* card distribution ends, put the value to NULL */
    cardDistributionModel.seatNo = null;

    tableState.updateTableStatusSilent(null);
    tableState.notifyAll();
    // no of cards in this game
    players.visibleCardNumbersForAllSilent(handInfo.noCards);
    players.notifyAll();
  }

  void updatePot(var data, String key, BuildContext context) {
    try {
      List<int> pots =
          data[key]['pots']?.map<int>((e) => int.parse(e.toString()))?.toList();

      final tableState = _gameState.getTableState(_context);

      tableState.updatePotChipsSilent(
        potChips: pots,
        potUpdatesChips: null,
      );
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
    final TableState tableState = _gameState.getTableState(_context);
    final players = _gameState.getPlayers(_context);

    // show the move coin to pot animation, after that update the pot
    await _gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    _gameState.resetSeatActions();
    // update the pot
    updatePot(data, stage, _context);

    players.notifyAll();

    // update the community cards
    if (stage == 'flop') {
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
      tableState.addTurnOrRiverCard(
          1, CardHelper.getCard(data[stage]['${stage}Card']));
    } else if (stage == 'river') {
      tableState.addTurnOrRiverCard(
          1, CardHelper.getCard(data[stage]['${stage}Card']));
    }

    tableState.notifyAll();
    await Future.delayed(Duration(seconds: 1));
    // log('stage update end');
  }

  Future<void> handleQueryCurrentHand(var data) async {
    var currentHandState = data['currentHandState'];
    // log('Current hand state: $currentHandState');

    // current players cards
    String playerCards = currentHandState['playerCards'];

    final Players players = Provider.of<Players>(
      _context,
      listen: false,
    );

    final tableState = _gameState.getTableState(_context);
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
        gameType: gameType);

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

    // put the remaining time in the provider
    Provider.of<RemainingTime>(
      _context,
      listen: false,
    ).time = remainingActionTime;

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
    } else
      handleNextAction(
        {
          'actionChange': {
            'seatNo': nextSeatToAct,
            'pots': [{}],
          },
        },
      );
    // log('stage update done');
  }

  Future<void> handleAnnouncement(var data) async {
    var announcement = data['announcement'];
    String type = announcement['type'].toString();
    if (type == 'NewGameType') {
      String game = announcement['params'][0].toString();
      GameType gameType = gameTypeFromStr(game);
      String title = gameTypeStr(gameType);
      showOverlayNotification(
        (context) => OverlayNotificationWidget(
          title: title,
          subTitle: '',
        ),
        duration: Duration(seconds: 5),
      );
    }
  }

  Future<void> handlePlayerActed(var data) async {
    var playerActed = data['playerActed'];
    int seatNo = playerActed['seatNo'];
    // show a prompt regarding last player action
    final gameState = Provider.of<GameState>(
      _context,
      listen: false,
    );
    final seat = gameState.getSeat(_context, seatNo);
    //log('player acted: $seatNo, player: ${seat.player.name}');
    final action = seat.player.action;
    action.setAction(playerActed);
    // play the bet-raise sound effect
    if (action.action == HandActions.BET ||
        action.action == HandActions.RAISE ||
        action.action == HandActions.CALL) {
      Audio.play(
        context: _context,
        assetFile: AppAssets.betRaiseSound,
      );
    } else if (action.action == HandActions.FOLD) {
      Audio.play(
        context: _context,
        assetFile: AppAssets.foldSound,
      );
      seat.player.playerFolded = true;
      seat.player.animatingFold = true;
      seat.notify();
    } else if (action.action == HandActions.CHECK) {
      Audio.play(
        context: _context,
        assetFile: AppAssets.checkSound,
      );
    }
    int stack = playerActed['stack'];
    if (stack != null) {
      seat.player.stack = stack;
    }
    // before showing the prompt --> turn off the highlight on other players
    gameState.resetActionHighlight(_context, -1);
  }

  /* seat-no, list of cards mapping */
  static Map<int, List<int>> _getCards(final data) {
    var players = data['handResult']['players'];

    Map<int, List<int>> seatNoCardsMap = Map<int, List<int>>();
    players.forEach((seatNo, d) =>
        seatNoCardsMap[int.parse(seatNo.toString())] =
            d['cards']?.map<int>((e) => int.parse(e.toString()))?.toList());

    return seatNoCardsMap;
  }

  static Future<void> processWinner({
    final HiWinnersModel winner,
    final Players players,
    final TableState tableState,
    final boardIndex = 1,
    final GameState gameState,
    final bool setState = false,
  }) async {
    /* highlight the hi winners */
    players.highlightWinnerSilent(winner.seatNo);

    /* highlight the winning cards for players */
    players.highlightCardsSilent(
      seatNo: winner.seatNo,
      cards: winner.playerCards,
    );

    /* highlight the winning cards for board 1 */
    tableState.highlightCardsSilent(
      boardIndex,
      winner.boardCards,
    );

    /* update the rank str */
    tableState.updateRankStrSilent(winner.rankStr);

    /* update the stack amount for the winners */
    final PlayerModel player = players.getPlayerBySeat(winner.seatNo);
    if (player != null) {
      player.action.amount = winner.amount.toDouble();
      player.action.winner = true;
    }

    /** set state */
    if (setState) {
      /* update state */
      players.notifyAll();
      tableState.notifyAll();

      /* finally animate the moving stack */
      gameState.animateSeatActions();

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.animationDuration);

      /* update the actual stack */
      players.updateStackWithValueSilent(
        winner.seatNo,
        winner.amount,
      );

      players.notifyAll();
    }
  }

  /* this method processes multiple winners */
  static Future<void> processWinners({
    List highWinners,
    final Players players,
    final TableState tableState,
    final boardIndex = 1,
    final GameState gameState,
  }) async {
    /** process the high pot winners */
    for (int i = 0; i < highWinners.length; i++) {
      final HiWinnersModel winner = HiWinnersModel.fromJson(highWinners[i]);

      await processWinner(
        winner: winner,
        players: players,
        tableState: tableState,
        boardIndex: boardIndex,
        gameState: gameState,
        // for the last element only we set the state
        setState: i == highWinners.length - 1,
      );
    }
  }

  /* only resets the highlights, and winners */
  static void resetResult({
    TableState tableState,
    Players players,
    GameState gameState,
    int boardIndex = 1,
  }) {
    tableState.unHighlightCardsSilent(boardIndex);
    players.removeAllHighlightsSilent();
    players.removeWinnerHighlightSilent();
    players.unHighlightCardsSilentForAll();

    tableState.updateRankStrSilent(null);

    gameState.resetSeatActions();

    players.notifyAll();
    tableState.notifyAll();
  }

  static Future<void> processForHighWinnersDelayProcessForLowWinners({
    final List highWinners,
    final List lowWinners,
    final gameState,
    final tableState,
    final players,
    int boardIndex = 1,
  }) async {
    /** process the high pot winners */
    await processWinners(
      highWinners: highWinners,
      players: players,
      tableState: tableState,
      boardIndex: boardIndex,
      gameState: gameState,
    );

    /** delay for a bit */
    await Future.delayed(AppConstants.animationDuration);

    /* need to clear the board */
    resetResult(
      tableState: tableState,
      players: players,
      gameState: gameState,
    );

    /** process the low pot winners */
    await processWinners(
      highWinners: lowWinners,
      players: players,
      tableState: tableState,
      boardIndex: boardIndex,
      gameState: gameState,
    );
  }

  static Future<void> handleResultStatic({
    @required final bool isRunItTwice,
    @required final dynamic runItTwiceResult,
    @required final Map<String, dynamic> potWinners,
    @required final List<int> boardCards,
    @required final List<int> boardCards2,
    @required final BuildContext context,
    final bool fromReplay = false,
  }) async {
    assert(context != null);

    final GameState gameState = GameState.getState(context);
    final TableState tableState = gameState.getTableState(context);
    final Players players = gameState.getPlayers(context);

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    if (isRunItTwice) {
      /* RUN IT TWICE CASE */

      /* set the board cards first */

      /* set board 1 cards */
      tableState.setBoardCards(
        1,
        boardCards.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
      );

      /* set board 2 cards */
      tableState.setBoardCards(
        2,
        boardCards2.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
      );

      /* process board 1 first
      * 0. get all hi winner players for board 1
      * 1. highlight hi winner
      * 2. highlight winning cards - players and community one's
      * 3. update the rankStr
      * 4. move the pot chip to the winner */

      final Map board1PotWinners = runItTwiceResult['board1Winners'];

      for (final board1Winners in board1PotWinners.entries) {
        final potNo = board1Winners.key;
        final Map winners = board1Winners.value;

        final List highWinners = winners['hiWinners'];
        final List lowWinners = winners['lowWinners'];

        await processForHighWinnersDelayProcessForLowWinners(
          highWinners: highWinners,
          lowWinners: lowWinners,
          gameState: gameState,
          tableState: tableState,
          players: players,
        );
      }

      /* cleanup all highlights and rankStr */
      resetResult(
        tableState: tableState,
        players: players,
        gameState: gameState,
        boardIndex: 1,
      );

      /* wait for a brief duration */
      await Future.delayed(AppConstants.animationDuration);

      /* then, process board 2
      * 0. get all hi winner players for board 1
      * 1. highlight hi winner
      * 2. highlight winning cards - players and community one's
      * 3. update the rankStr
      * 4. move the pot chip to the winner */

      final Map board2PotWinners = runItTwiceResult['board2Winners'];

      for (final board2Winners in board2PotWinners.entries) {
        final potNo = board2Winners.key;
        final Map winners = board2Winners.value;

        final List highWinners = winners['hiWinners'];
        final List lowWinners = winners['lowWinners'];

        await processForHighWinnersDelayProcessForLowWinners(
          highWinners: highWinners,
          lowWinners: lowWinners,
          gameState: gameState,
          tableState: tableState,
          players: players,
          boardIndex: 2,
        );
      }

      /* cleanup all highlights and rankStr */
      resetResult(
        tableState: tableState,
        players: players,
        gameState: gameState,
        boardIndex: 2,
      );

      /* turn off two boards needed flag -> only if we are not from replay */
      if (!fromReplay) tableState.updateTwoBoardsNeeded(false);
    } else {
      /* SIMPLE POT WINNER CASE */

      /**
       * DO the following for each pot:
       *    1. show all the high pot winners
       *    2. delay
       *    3. show all the low pot winners
       */

      for (final potWinner in potWinners.entries) {
        final potNo = potWinner.key;
        final PotWinner winners = potWinner.value;

        final List highWinners =
            winners.hiWinners.map((e) => e.toJson()).toList();
        final List lowWinners =
            winners.lowWinners.map((e) => e.toJson()).toList();

        await processForHighWinnersDelayProcessForLowWinners(
          highWinners: highWinners,
          lowWinners: lowWinners,
          players: players,
          gameState: gameState,
          tableState: tableState,
        );
      }
    }
  }

  Future<void> handleResult(var data) async {
    final Players players = _gameState.getPlayers(_context);
    final tableState = _gameState.getTableState(_context);
    // final resultState = _gameState.getResultState(_context);

    if (data['handResult']['highHand'] != null) {
      HighHandService.handle(
        context: _context,
        data: data['handResult']['highHand'],
        showNotification: false,
      );
    }
    _gameState.resetSeatActions();
    players.clearForShowdown();

    // TODO: VERITY THIS METHOD FOR (NOT) RUN IT TWICE RESULTS

    // get hand winners data and update results
    final handResult = data['handResult'];

    /* showdown time, show other players cards */
    players.updateUserCardsSilent(_getCards(data));

    /* check if the result is a run it twice result */
    final bool isRunItTwice = handResult['runItTwice'] as bool;

    List<int> boardCards = [];
    List<int> boardCards2 = [];
    if (handResult['boardCards'] != null) {
      for (dynamic card in handResult['boardCards']) {
        int cardInt = int.parse(card.toString());
        boardCards.add(cardInt);
      }
    }
    if (handResult['boardCards2'] != null) {
      for (dynamic card in handResult['boardCards2']) {
        int cardInt = int.parse(card.toString());
        boardCards2.add(cardInt);
      }
    }

    await handleResultStatic(
      isRunItTwice: isRunItTwice,
      runItTwiceResult: handResult['handLog']['runItTwiceResult'],
      potWinners: handResult['handLog']['potWinners'],
      boardCards: boardCards,
      boardCards2: boardCards2,
      context: _context,
    );

    // /* then, change the status of the footer to show the result */
    // Provider.of<ValueNotifier<FooterStatus>>(
    //   _context,
    //   listen: false,
    // ).value = FooterStatus.Result;
    //
    // if (isRunItTwice) {
    //   /* RUN IT TWICE CASE */
    //   final runItTwiceResult = handResult['handLog']['runItTwiceResult'];
    //
    //   /* set the board cards first */
    //   final boardCards = handResult['boardCards'];
    //   final boardCards2 = handResult['boardCards2'];
    //
    //   /* set board 1 cards */
    //   tableState.setBoardCards(
    //     1,
    //     boardCards.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
    //   );
    //
    //   /* set board 2 cards */
    //   tableState.setBoardCards(
    //     2,
    //     boardCards2.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
    //   );
    //
    //   /* process board 1 first
    //   * 0. get all hi winner players for board 1
    //   * 1. highlight hi winner
    //   * 2. highlight winning cards - players and community one's
    //   * 3. update the rankStr
    //   * 4. move the pot chip to the winner */
    //
    //   final board1Winners = runItTwiceResult['board1Winners']['0']['hiWinners'];
    //   for (final hiWinner in board1Winners) {
    //     final HiWinnersModel winner = HiWinnersModel.fromJson(hiWinner);
    //
    //     await processWinner(
    //       winner: winner,
    //       players: players,
    //       tableState: tableState,
    //       boardIndex: 1,
    //       gameState: _gameState,
    //     );
    //
    //     /* todo: shall we wait here for a brief moment? */
    //     await Future.delayed(AppConstants.animationDuration);
    //   }
    //
    //   /* cleanup all highlights and rankStr */
    //   resetResult(
    //     tableState: tableState,
    //     players: players,
    //     gameState: _gameState,
    //     boardIndex: 1,
    //   );
    //
    //   /* wait for a brief duration */
    //   await Future.delayed(AppConstants.animationDuration);
    //
    //   /* then, process board 2
    //   * 0. get all hi winner players for board 1
    //   * 1. highlight hi winner
    //   * 2. highlight winning cards - players and community one's
    //   * 3. update the rankStr
    //   * 4. move the pot chip to the winner */
    //   final board2Winners = runItTwiceResult['board2Winners']['0']['hiWinners'];
    //   for (final hiWinner in board2Winners) {
    //     final HiWinnersModel winner = HiWinnersModel.fromJson(hiWinner);
    //
    //     await processWinner(
    //       winner: winner,
    //       players: players,
    //       tableState: tableState,
    //       boardIndex: 2,
    //       gameState: _gameState,
    //     );
    //
    //     /* todo: shall we wait here for a brief moment? */
    //     await Future.delayed(AppConstants.animationDuration);
    //   }
    //
    //   /* cleanup all highlights and rankStr */
    //   resetResult(
    //     tableState: tableState,
    //     players: players,
    //     gameState: _gameState,
    //     boardIndex: 2,
    //   );
    //
    //   /* turn off two boards needed flag */
    //   tableState.updateTwoBoardsNeeded(false);
    // } else {
    //   /* NOT RUN IT TWICE CASE */
    //
    //   final winners = handResult['handLog']['potWinners']['0']['hiWinners'];
    //   for (final hiWinner in winners) {
    //     final HiWinnersModel winner = HiWinnersModel.fromJson(hiWinner);
    //
    //     await processWinner(
    //       winner: winner,
    //       players: players,
    //       tableState: tableState,
    //       boardIndex: 1,
    //       gameState: _gameState,
    //     );
    //
    //     /* todo: shall we wait here for a brief moment? */
    //     await Future.delayed(AppConstants.animationDuration);
    //   }
    // }

    /* In case, if a player has folded, and want to show his/her cards, then that is done there
    * only the marked cards are sent to he game channel are are shown to the other players */

    final MarkedCards markedCards = _gameState.getMarkedCards(_context);

    /* collect the cards needs to be revealed */
    List<CardObject> _cardsToBeRevealed = markedCards.getCards();
    List<int> cardNumbers = _cardsToBeRevealed
        .map<int>((card) => CardHelper.getCardNumber(card))
        .toList();

    /* clear all the marked cards */
    markedCards.clear();

    if (TestService.isTesting) return;

    /* finally send the cardNumbers to the gameChatChannel after 1500 ms */
    // todo: put the delay in the const class after finalizing the delay constant
    await Future.delayed(const Duration(milliseconds: 1500));
    final gameService = _gameState.getGameMessagingService(_context);
    gameService.sendCards(
      cardNumbers,
      players.me?.seatNo,
    );
  }
}
