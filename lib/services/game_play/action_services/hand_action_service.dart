import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/high_hand_service.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:pokerapp/utils/card_helper.dart';
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
      this._gameComService, this._message, this._messageType, this._messageId);

  run() async {
    DateTime lastSentTime = DateTime.now();
    _messageSentTime = lastSentTime;
    bool firstAttempt = true;
    // runs a loop until we receive acknowledgement or cancel
    while (!_cancel || !_ackReceived) {
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

  playerActed(
      int playerID, int handNum, int seatNo, String action, int amount) {
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
      }
    } catch (err) {
      log('Error: ${err.toString()}');
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
        bigBlind: bigBlind);

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

  /* seat-no, value mapping */
  static Map<int, int> _getUpdatedStack(var data) {
    Map<int, int> stacks = Map<int, int>();

    var players = data['handResult']['players'];
    players.forEach(
        (key, p) => stacks[int.parse(key.toString())] = p['balance']['after']);

    return stacks;
  }

  /* seat-no, list of cards mapping */
  static Map<int, List<int>> _getCards(var data) {
    var players = data['handResult']['players'];

    Map<int, List<int>> seatNoCardsMap = Map<int, List<int>>();
    players.forEach((seatNo, d) =>
        seatNoCardsMap[int.parse(seatNo.toString())] =
            d['cards']?.map<int>((e) => int.parse(e.toString()))?.toList());

    return seatNoCardsMap;
  }

  /* get back the board cards that needs to be highlighted */
  static List<int> _getBoardCards(var data) {
    var boardCards = data['handResult']['handLog']['potWinners']['0']
        ['hiWinners'][0]['boardCards'];

    return boardCards.map<int>((c) => int.parse(c.toString())).toList();
  }

  /* get back the player cards that needs to be highlighted */
  static Map<String, dynamic> _getPlayerData(var data) {
    var hiWinner =
        data['handResult']['handLog']['potWinners']['0']['hiWinners'][0];

    int seatNo = hiWinner['seatNo'];
    var playerCards = hiWinner['playerCards'];

    return {
      'seatNo': seatNo,
      'playerCards':
          playerCards.map<int>((c) => int.parse(c.toString())).toList(),
    };
  }

  Future<void> handleResult(var data) async {
    final Players players = _gameState.getPlayers(_context);
    final tableState = _gameState.getTableState(_context);
    final resultState = _gameState.getResultState(_context);

    if (data['handResult']['highHand'] != null) {
      HighHandService.handle(
        context: _context,
        data: data['handResult']['highHand'],
        showNotification: false,
      );
    }
    _gameState.resetSeatActions();
    players.clearForShowdown();
    // debugPrint(jsonEncode(data));
    // get hand winners data and update results
    final winnersData = data['handResult']['handLog']['potWinners'];
    final winners = resultState.updateWinners(winnersData);

    /* showdown time, show other players cards */
    players.updateUserCardsSilent(_getCards(data));

    // get the winner seat No and highlight the winner
    winners.forEach((winner) {
      // highlight the winner seat No
      players.highlightWinnerSilent(winner.seatNo);
    });

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.Result;

    /* highlight cards of players and community cards for winner */
    tableState.highlightCardsSilent(_getBoardCards(data));
    tableState.notifyAll();

    Map<String, dynamic> playerData = _getPlayerData(data);

    players.highlightCardsSilent(
      seatNo: playerData['seatNo'],
      cards: playerData['playerCards'],
    );

    /* update stack of every player after showing the reverse pot chip animation */
    for (HiWinnersModel winner in winners) {
      final seat = _gameState.getSeat(_context, winner.seatNo);
      seat.player.action.amount = winner.amount.toDouble();
      seat.player.action.winner = true;
    }
    _gameState.animateSeatActions();
    players.notifyAll();

    // wait for the animation to finish, then update the stack
    Future.delayed(AppConstants.animationDuration).then(
      (_) {
        players.updateStackBulkSilent(_getUpdatedStack(data));
        players.notifyAll();
      },
    );

    final MarkedCards markedCards = _gameState.getMarkedCards(_context);

    /* collect the cards needs to be revealed */
    List<CardObject> _cardsToBeRevealed = markedCards.getCards();
    List<int> cardNumbers = _cardsToBeRevealed
        .map<int>((card) => CardHelper.getCardNumber(card))
        .toList();

    /* clear all the marked cards */
    markedCards.clear();

    // todo: put the delay in the const class after finalizing the delay constant
    /* finally send the cardNumbers to the gameChatChannel after 1500 ms */
    /* Future.delayed(const Duration(milliseconds: 1500)).then(
      (_) => _gameState.getGameMessagingService(_context).sendCards(
            cardNumbers,
            players.me?.seatNo,
          ),
    ); */
  }
}
