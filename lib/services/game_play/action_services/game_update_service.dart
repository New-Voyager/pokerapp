import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/seat_change_confirmation_pop_up.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/count_down_timer.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class GameUpdateService {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];
  bool closed = false;
  GameUpdateService(this._context, this._gameState);

  void close() {
    closed = true;
    _messages.clear();
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

  handle(String message) async {
    assert(_gameState != null);
    assert(_context != null);
    assert(message != null && message.isNotEmpty);

    //debugPrint(message);
    var data = jsonDecode(message);
//    List<dynamic> messages = data['messages'];
    _messages.addAll([data]);
  }

  Future<void> handleMessage(dynamic data) async {
    // if the service is closed, don't process incoming messages
    if (closed) {
      return;
    }
    debugPrint(jsonEncode(data));
    String messageType = data['messageType'];
    String type = data['type']; // new format used by API server
    if (messageType != null) {
      // delegate further actions to sub services as per messageType
      switch (messageType) {
        case AppConstants.PLAYER_UPDATE:
          return handlePlayerUpdate(
            data: data,
          );

        case AppConstants.TABLE_UPDATE:
          return handleTableUpdate(
            data: data,
          );

        case AppConstants.HIGH_HAND:
          return handleHighHand(
            data: data['highHand'],
            showNotification: true,
          );

        case AppConstants.GAME_STATUS:
          return handleUpdateStatus(
            status: data['status'],
          );
      }
    } else if (type != null) {
      print('\n\n\n\n type: $type \n\n\n\n');

      // new type
      switch (type) {
        case AppConstants.PLAYER_SEAT_CHANGE_PROMPT:
          handlePlayerSeatChangePrompt(data: data);
          break;
        case AppConstants.PLAYER_SEAT_MOVE:
          handlePlayerSeatChangeMove(data: data);
          break;
        case AppConstants.PLAYER_SEAT_CHANGE_DONE:
          handlePlayerSeatChangeDone(data: data);
          break;
      }
    }
  }

  void updatePlayer({
    @required var playerUpdate,
  }) async {
    int seatNo = playerUpdate['seatNo'];
    final player = _gameState.fromSeat(_context, seatNo);
    final status = playerUpdate['status'];
    final newUpdate = playerUpdate['newUpdate'];

    // fixme: this is until all the player update messages have a newUpdate field
    if (player == null) {
      return;
    }
    //   return handleNewPlayer(
    //     context: context,
    //     playerUpdate: playerUpdate,
    //   );
    // }

    bool showBuyIn = false;
    if (status == AppConstants.PLAYING) {
      showBuyIn = false;
    }

    if (newUpdate == AppConstants.NEW_BUYIN) {
      log('Player ${player.name} new buy in');
      showBuyIn = false;
    }

    if (status == AppConstants.WAIT_FOR_BUYIN ||
        status == AppConstants.NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL) {
      showBuyIn = true;
    }

    player.update(
      stack: playerUpdate['stack'],
      buyIn: playerUpdate['buyIn'],
      showBuyIn: showBuyIn,
      status: null,
    );
    final seat = _gameState.getSeat(_context, seatNo);
    seat.notify();

    // wait for "AppConstants.userPopUpMessageHoldDuration" showing the BUY-IN amount
    // after that remove the buyIn amount information
    await Future.delayed(AppConstants.userPopUpMessageHoldDuration);

    player.update(
      stack: playerUpdate['stack'],
      showBuyIn: false,
      status: null,
    );
    seat.notify();

    // update my state to remove buyin button
    if (player.isMe) {
      final myState = _gameState.getMyState(_context);
      myState.notify();
    }
  }

  void handleNewPlayer({
    @required var playerUpdate,
  }) async {
    int seatNo = playerUpdate['seatNo'];
    // fetch new player using GameInfo API and add to the game
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(_gameState.gameCode);
    assert(_gameInfoModel != null);
    List<PlayerModel> playerModels = _gameInfoModel.playersInSeats;
    PlayerModel newPlayerModel = playerModels.firstWhere(
      (pm) => pm.seatNo == seatNo,
      orElse: () => null,
    ); // this must return a PLayerModel object

    assert(newPlayerModel != null);

    // put the status of the fetched player
    newPlayerModel?.status = playerUpdate['status'];

    if (newPlayerModel.playerUuid == _gameState.currentPlayerUuid) {
      newPlayerModel.isMe = true;
    }
    _gameState.newPlayer(_context, newPlayerModel);

    if (newPlayerModel.stack == 0) {
      newPlayerModel.showBuyIn = true;
    }

    if (newPlayerModel.isMe) {
      await Future.delayed(Duration(milliseconds: 100));
      final mySeat = _gameState.mySeat(_context);
      mySeat.player = newPlayerModel;
      mySeat.notify();

      _gameState.myState.status = PlayerStatus.WAIT_FOR_BUYIN_APPROVAL;
      _gameState.myState.notify();
    }
    final tableState = _gameState.getTableState(_context);
    tableState.notifyAll();
    _gameState.updatePlayers(_context);
  }

  void handlePlayerLeftGame({
    @required var playerUpdate,
  }) {
    int seatNo = playerUpdate['seatNo'];
    removePlayer(seatNo);
  }

  void handlePlayerNotPlaying({
    @required var playerUpdate,
  }) {
    int seatNo = playerUpdate['seatNo'];
    removePlayer(seatNo);
  }

  void handlePlayerBuyinTimedout({
    @required var playerUpdate,
  }) {
    int seatNo = playerUpdate['seatNo'];
    removePlayer(seatNo);
  }

  void handlePlayerBreakTimedout({
    @required var playerUpdate,
  }) {
    int seatNo = playerUpdate['seatNo'];
    if (seatNo != null) {
      final seat = _gameState.getSeat(_context, seatNo);
      // update my state to show sitback button
      if (seat != null && seat.player != null && seat.player.isMe) {
        final myState = _gameState.getMyState(_context);
        myState.notify();
      }

      removePlayer(seatNo);
    }
  }

  void removePlayer(int seatNo) {
    final seat = _gameState.getSeat(_context, seatNo);
    if (seat != null && seat.player != null && seat.player.isMe) {
      _gameState.myState.status = PlayerStatus.NOT_PLAYING;
      _gameState.myState.notify();
    }

    _gameState.removePlayer(_context, seatNo);
    _gameState.updatePlayers(_context);
    _gameState.markOpenSeat(_context, seatNo);
    final tableState = _gameState.getTableState(_context);
    tableState.notifyAll();
  }

  void handlePlayerSwitchSeat({
    @required var playerUpdate,
  }) async {
    int newSeatNo = playerUpdate['seatNo'] as int;
    int oldSeatNo = playerUpdate['oldSeat'] as int;
    int stack = playerUpdate['stack'] as int;

    final gameInfo = _gameState.gameInfo;
    final player1 = _gameState.fromSeat(_context, oldSeatNo);
    if (player1 == null) {
      return;
    }

    player1.seatNo = newSeatNo;

    if (gameInfo.status == 'CONFIGURED' &&
        gameInfo.tableStatus == 'WAITING_TO_BE_STARTED') {
      // switch seat for the player
      final oldSeat = _gameState.getSeat(_context, oldSeatNo);
      oldSeat.player = null;
      _gameState.refresh(_context);
      // final newSeat = gameState.getSeat(context, oldSeatNo);
      // oldSeat.player = null;

    } else {
      final ValueNotifier<SeatChangeModel> vnSeatChangeModel =
          Provider.of<ValueNotifier<SeatChangeModel>>(
        _context,
        listen: false,
      );

      /* animate the stack */
      vnSeatChangeModel.value = SeatChangeModel(
        newSeatNo: newSeatNo,
        oldSeatNo: oldSeatNo,
        stack: stack,
      );

      /* wait for the seat change animation to finish */
      await Future.delayed(AppConstants.seatChangeAnimationDuration);

      /* remove the animating widget */
      vnSeatChangeModel.value = null;
    }
    _gameState.updatePlayers(_context);
  }

  void handlePlayerWaitForBuyinApproval({
    @required var playerUpdate,
  }) async {
    int seatNo = playerUpdate['seatNo'];
    final seat = _gameState.getSeat(_context, seatNo);

    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(_gameState.gameCode);
    assert(_gameInfoModel != null);

    if (seat != null && seat.player != null) {
      seat.player.waitForBuyInApproval = true;
      seat.player.status = PlayerStatus.WAIT_FOR_BUYIN
          .toString()
          .replaceAll('PlayerStatus.', '');
      // get break exp time
      for (final player in _gameInfoModel.playersInSeats) {
        if (player.seatNo == seat.serverSeatPos) {
          seat.player.buyInTimeExpAt = player.buyInTimeExpAt.toLocal();
          DateTime now = DateTime.now();
          if (seat.player.buyInTimeExpAt != null) {
            final diff = seat.player.buyInTimeExpAt.difference(now);
            log('now: ${now.toIso8601String()} buyInTimeExpAt: ${seat.player.buyInTimeExpAt.toIso8601String()} buyInTimeExpAt time expires in ${diff.inSeconds}');
          }

          // update my state to show sitback button
          if (seat.player.isMe) {
            final myState = _gameState.getMyState(_context);
            myState.notify();
          }
          break;
        }
      }
      seat.notify();
    }
    final tableState = _gameState.getTableState(_context);
    tableState.notifyAll();
  }

  void handlePlayerBuyinDenied({
    @required var playerUpdate,
  }) {
    final GameState gameState = GameState.getState(_context);
    int seatNo = playerUpdate['seatNo'];
    final seat = gameState.getSeat(_context, seatNo);
    log('Buyin is denied');
    final players = gameState.getPlayers(_context);
    players.removePlayerSilent(seatNo);
    bool isMe = false;
    if (seat.player.isMe) {
      isMe = true;
    }
    seat.player = null;
    seat.notify();

    if (isMe) {
      final myState = gameState.getMyState(_context);
      myState.notify();

      showAlertDialog(
          _context, "BuyIn Request", "The host denied the buyin request");
    }
  }

  void handlePlayerTakeBreak({
    @required var playerUpdate,
  }) async {
    final GameState gameState = GameState.getState(_context);
    int seatNo = playerUpdate['seatNo'];
    final seat = gameState.getSeat(_context, seatNo);
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(_gameState.gameCode);
    assert(_gameInfoModel != null);

    if (seat != null && seat.player != null) {
      seat.player.inBreak = true;
      // get break exp time
      for (final player in _gameInfoModel.playersInSeats) {
        if (player.seatNo == seat.serverSeatPos) {
          seat.player.status = player.status;
          seat.player.breakTimeExpAt = player.breakTimeExpAt.toLocal();
          DateTime now = DateTime.now();
          if (seat.player.breakTimeExpAt != null) {
            final diff = seat.player.breakTimeExpAt.difference(now);
            log('now: ${now.toIso8601String()} breakTimeExpAt: ${seat.player.breakTimeExpAt.toIso8601String()} break time expires in ${diff.inSeconds}');
          }

          // update my state to show sitback button
          if (seat.player.isMe) {
            final myState = _gameState.getMyState(_context);
            myState.notify();
          }
          break;
        }
      }
      seat.notify();
    }
  }

  void handlePlayerSitBack({
    @required var playerUpdate,
  }) async {
    final GameState gameState = GameState.getState(_context);
    int seatNo = playerUpdate['seatNo'];
    final seat = gameState.getSeat(_context, seatNo);
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(_gameState.gameCode);
    assert(_gameInfoModel != null);

    if (seat != null && seat.player != null) {
      // get break exp time
      for (final player in _gameInfoModel.playersInSeats) {
        if (player.seatNo == seat.serverSeatPos) {
          seat.player.status = player.status;
          if (player.status != 'IN_BREAK') {
            seat.player.inBreak = false;
          }
          // update my state to show sitback button
          if (seat.player.isMe) {
            final myState = _gameState.getMyState(_context);
            myState.notify();
          }
          break;
        }
      }
      seat.notify();
    }
  }

  void handlePlayerUpdate({
    var data,
  }) {
    var playerUpdate = data['playerUpdate'];
    String newUpdate = playerUpdate['newUpdate'];
    var jsonData = jsonEncode(newUpdate);
    log(jsonData);
    switch (newUpdate) {
      case AppConstants.NEW_PLAYER:
        return handleNewPlayer(
          playerUpdate: playerUpdate,
        );

      case AppConstants.LEFT:
      case AppConstants.LEFT_THE_GAME:
        return handlePlayerLeftGame(
          playerUpdate: playerUpdate,
        );

      case AppConstants.SWITCH_SEAT:
        return handlePlayerSwitchSeat(
          playerUpdate: playerUpdate,
        );

      case AppConstants.NEWUPDATE_NOT_PLAYING:
      case AppConstants.NOT_PLAYING:
        return handlePlayerNotPlaying(
          playerUpdate: playerUpdate,
        );

      case AppConstants.BUYIN_TIMEDOUT:
        return handlePlayerBuyinTimedout(
          playerUpdate: playerUpdate,
        );

      case AppConstants.TAKE_BREAK:
        return handlePlayerTakeBreak(
          playerUpdate: playerUpdate,
        );

      case AppConstants.NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL:
      case AppConstants.WAIT_FOR_BUYIN_APPROVAL:
        return handlePlayerWaitForBuyinApproval(
          playerUpdate: playerUpdate,
        );
      case AppConstants.BUYIN_DENIED:
        return handlePlayerBuyinDenied(
          playerUpdate: playerUpdate,
        );

      case AppConstants.SIT_BACK:
        return handlePlayerSitBack(
          playerUpdate: playerUpdate,
        );

      default:
        return updatePlayer(
          playerUpdate: playerUpdate,
        );
    }
  }

  /* this method clears the result views and
  removes community cards, pots and everything */
  void _clearTable() {
    _gameState.resetPlayers(_context);

    /* clean up from result views */
    /* set footer status to none  */
    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.None;
    _gameState.clear(_context);
  }

  void handleTableUpdate({
    var data,
  }) async {
    var tableUpdate = data['tableUpdate'];
    String type = tableUpdate['type'];
    String jsonData = jsonEncode(data);
    log(jsonData);

    // TODO: HOW TO HANDLE MULTIPLE PLAYER'S SEAT CHANGE?
    if (type == AppConstants.SeatChangeInProgress) {
      handlePlayerSeatChange(data: data);
    } else if (type == AppConstants.TableHostSeatChangeProcessStart) {
      handleHostSeatChangeStart(data: data);
    } else if (type == AppConstants.TableHostSeatChangeMove) {
      handleHostSeatChangeMove(data: data);
    } else if (type == AppConstants.TableHostSeatChangeProcessEnd) {
      handleHostSeatChangeDone(data: data);
    } else if (type == AppConstants.TableWaitlistSeating) {
      // show a flush bar at the top
      handleWaitlistSeating(data: data);
    }
  }

  void handleWaitlistSeating({
    var data,
  }) async {
    log('waitlist seating message received');
    final waitlistState = _gameState.getWaitlistState(_context);
    waitlistState.fromJson(data);
    waitlistState.notify();
    String message = '${waitlistState.name} is invited to take the open seat.';

    showOverlayNotification(
      (context) => OverlayNotificationWidget(
        title: message,
        subTitle: '',
      ),
      duration: Duration(seconds: 10),
    );
  }

  void handlePlayerSeatChange({
    var data,
  }) async {
    var tableUpdate = data['tableUpdate'];
    /* clear everything */
    _clearTable();

    /* show notification */
    int seatChangeTime = tableUpdate['seatChangeTime'] as int;
    List<int> seatChangeSeatNo =
        tableUpdate['seatChangeSeatNo'].map<int>((s) => int.parse(s)).toList();

    final player = _gameState.fromSeat(_context, seatChangeSeatNo[0]);
    assert(player != null);

    /* If I am in this list, show me a confirmation popup */
    if (player.isMe) {
      SeatChangeConfirmationPopUp.dialog(
        context: _context,
        gameCode: _gameState.gameCode,
      );
    }

    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      _context,
      listen: false,
    );

    valueNotifierNotModel.value = GeneralNotificationModel(
      titleText: 'Seat change in progress',
      subTitleText:
          'Seat change requested by ${player.name} at seat no ${player.seatNo}',
      trailingWidget: CountDownTimer(
        remainingTime:
            seatChangeTime * seatChangeSeatNo.length, // TODO: MULTIPLE PLAYERS?
      ),
    );

    await Future.delayed(
      Duration(
        seconds: seatChangeTime * seatChangeSeatNo.length,
      ), // TODO: MULTIPLE PLAYERS?
    );

    /* remove notification */
    valueNotifierNotModel.value = null;
  }

  void handleHostSeatChangeStart({
    var data,
  }) async {
    // if the current player is making the seat changes, then show additional buttons
    // Confirm Changes, Cancel Changes
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeInProcessStart", "seatChangeHost":"122"}}

    // for other players, show the banner sticky (stay at the top)
    // Seat arrangement in progress
    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      _context,
      listen: false,
    );

    valueNotifierNotModel.value = GeneralNotificationModel(
      titleText: 'Seat change',
      subTitleText: 'Host is making changes to the table',
    );

    final gameCode = data["gameCode"].toString();
    final seatChangeHost =
        int.parse(data["tableUpdate"]["seatChangeHost"].toString());
    final seatChange = Provider.of<HostSeatChange>(_context, listen: false);
    seatChange.updateSeatChangeInProgress(true);
    seatChange.updateSeatChangeHost(seatChangeHost);

    // get current seat positions
    List<PlayerInSeat> playersInSeats =
        await SeatChangeService.hostSeatChangeSeatPositions(gameCode);
    seatChange.updatePlayersInSeats(playersInSeats);

    seatChange.notifyAll();
  }

  void handleHostSeatChangeDone({
    var data,
  }) async {
    // if the current player is making the seat changes, remove the additional buttons
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeInProcessEnd", "seatChangeHost":"122"}}
    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      _context,
      listen: false,
    );
    /* remove notification */
    valueNotifierNotModel.value = null;

    final seatChange = Provider.of<HostSeatChange>(_context, listen: false);
    seatChange.updateSeatChangeInProgress(false);
    seatChange.notifyAll();
  }

  void handleHostSeatChangeMove({
    var data,
  }) async {
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeMove", "seatMoves":[{"playerId":"131", "playerUuid":"290bf492-9dde-448e-922d-40270e163649", "name":"rich", "oldSeatNo":6, "newSeatNo":1}, {"playerId":"122", "playerUuid":"c2dc2c3d-13da-46cc-8c66-caa0c77459de", "name":"yong", "oldSeatNo":1, "newSeatNo":6}]}}
    // player is moved, show animation of the move

    final hostSeatChange = Provider.of<HostSeatChange>(_context, listen: false);
    var seatMoves = data['tableUpdate']['seatMoves'];
    for (var move in seatMoves) {
      int from = int.parse(move['oldSeatNo'].toString());
      int to = int.parse(move['newSeatNo'].toString());
      String name = move['name'].toString();
      double stack = double.parse(move['stack'].toString());
      debugPrint('Seatchange: Player $name from seat $from to $to');

      /* start animation */
      hostSeatChange.onSeatDrop(from, to);

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.seatChangeAnimationDuration);
    }
    final gameCode = data["gameCode"].toString();
    // get current seat positions

    final gameState = Provider.of<GameState>(
      _context,
      listen: false,
    );

    final players = gameState.getPlayers(_context);

    /* refresh the player model */
    players.refreshWithPlayerInSeat(
      await SeatChangeService.hostSeatChangeSeatPositions(gameCode),
    );
  }

  void handleHighHand({
    var data,
    bool showNotification = false,
  }) async {
    if (data == null) return;

    String gameCode = data['gameCode'] as String;
    int handNum = data['handNum'] as int;

    // TODO: DO WE NEED MULTIPLE PLAYERS?
    var winner = data['winners'][0];

    String playerName = winner['playerName'];
    List<CardObject> hhCards = winner['hhCards']
        ?.map<CardObject>((c) => CardHelper.getCard(c as int))
        ?.toList();

    List<CardObject> playerCards = winner['playerCards']
        ?.map<CardObject>((c) => CardHelper.getCard(c as int))
        ?.toList();

    if (showNotification) {
      // show a notification

      var notificationValueNotifier =
          Provider.of<ValueNotifier<HHNotificationModel>>(
        _context,
        listen: false,
      );

      notificationValueNotifier.value = HHNotificationModel(
        gameCode: gameCode,
        handNum: handNum,
        playerName: playerName,
        hhCards: hhCards,
        playerCards: playerCards,
      );

      /* wait for 5 seconds, then remove the notification */
      await Future.delayed(AppConstants.notificationDuration);

      notificationValueNotifier.value = null;
    } else {
      /* the player is in the current game - firework this user */
      int seatNo = winner['seatNo'] as int;

      final GameState gameState = Provider.of<GameState>(
        _context,
        listen: false,
      );

      // show firework
      final player = gameState.fromSeat(_context, seatNo);
      player.showFirework = true;
      final seat = gameState.getSeat(_context, seatNo);
      seat.notify();

      await Future.delayed(AppConstants.notificationDuration);

      // turn off firework
      player.showFirework = false;
      seat.notify();
    }
  }

  void handleUpdateStatus({
    var status,
  }) {
    String tableStatus = status['tableStatus'];
    String gameStatus = status['status'];

    /*
      {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"ACTIVE","tableStatus":"WAITING_TO_BE_STARTED"}}
      {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"PAUSED","tableStatus":"GAME_RUNNING"}}
    */

    final GameContextObject gameContext =
        Provider.of<GameContextObject>(_context, listen: false);

    final tableState = _gameState.getTableState(_context);

    tableState.updateTableStatusSilent(tableStatus);
    tableState.updateGameStatusSilent(gameStatus);

    if (tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING) {
      /* QUERY_CURRENT_HAND is done here, only after making sure,
      * that the game is running.
      * This is done to get update of the game */
      gameContext.handActionService.queryCurrentHand();
    } else if (gameStatus == AppConstants.GAME_ENDED) {
      // end the game
      tableState.updateTableStatusSilent(AppConstants.GAME_ENDED);
      resetBoard();
    } else if (gameStatus == AppConstants.GAME_PAUSED) {
      // paused the game
      tableState.updateTableStatusSilent(AppConstants.GAME_PAUSED);
      resetBoard();
    }

    tableState.notifyAll();
  }

  void handlePlayerSeatChangePrompt({
    var data,
    bool showNotification = false,
  }) async {
    if (data == null) return;
    /*
      {
        "type": "PLAYER_SEAT_CHANGE_PROMPT",
        "gameCode": "test",
        "playerName": "yong",
        "playerId": 630,
        "openedSeat": 4,
        "playerUuid": "c2dc2c3d-13da-46cc-8c66-caa0c77459de",
        "expTime": "2021-05-29T22:46:13.000Z",
        "promptSecs": 10,
        "requestId": "SEATCHANGE:1622328363754"
      }    
    */

    final playerId = data['playerId'];
    final player = _gameState.getSeatByPlayer(playerId);
    final promptSecs = int.parse(data['promptSecs'].toString());
    final openedSeat = int.parse(data['openedSeat'].toString());
    final gameState = GameState.getState(_context);
    gameState.playerSeatChangeInProgress = true;
    gameState.seatChangeSeat = openedSeat;
    final seat = _gameState.getSeat(_context, openedSeat);
    seat.notify();

    // is it sent to me ??
    if (player.isMe) {
      SeatChangeConfirmationPopUp.dialog(
          context: _context,
          gameCode: _gameState.gameCode,
          openedSeat: openedSeat,
          promptSecs: promptSecs);
    }
    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      _context,
      listen: false,
    );

    // valueNotifierNotModel.value = GeneralNotificationModel(
    //   titleText: 'Seat change in progress',
    //   subTitleText:
    //       'Seat change prompted ',
    //   trailingWidget: CountDownTimer(
    //     remainingTime:
    //         promptSecs, // TODO: MULTIPLE PLAYERS?
    //   ),
    // );
  }

  void handlePlayerSeatChangeMove({
    var data,
    bool showNotification = false,
  }) async {
    if (data == null) return;
    final playerName = data['playerName'];
    final playerId = data['playerId'];
    // show animation
    /*
      {
        "type": "PLAYER_SEAT_MOVE",
        "gameCode": "test",
        "playerName": "yong",
        "playerId": 630,
        "playerUuid": "c2dc2c3d-13da-46cc-8c66-caa0c77459de",
        "oldSeatNo": 1,
        "newSeatNo": 3,
        "requestId": "SEATMOVE:1622328368918"
      }    
    */
    final oldSeatNo = data['oldSeatNo'];
    final newSeatNo = data['newSeatNo'];

    log('Seat move: player name: $playerName id: $playerId oldSeatNo: $oldSeatNo newSeatNo: $newSeatNo');

    final hostSeatChange = Provider.of<HostSeatChange>(_context, listen: false);

    /* start animation */
    hostSeatChange.onSeatDrop(oldSeatNo, newSeatNo);

    /* wait for the animation to finish */
    await Future.delayed(AppConstants.seatChangeAnimationDuration);

    // we refresh, when we get the PLAYER_SEAT_CHANGE_DONE message
  }

  void handlePlayerSeatChangeDone({
    var data,
    bool showNotification = false,
  }) async {
    if (data == null) return;

    /*
      {
        "type": "PLAYER_SEAT_CHANGE_DONE",
        "gameCode": "test",
        "requestId": "SEATMOVE:1622328379110"
      }    
    */
    log('Seat change done');
    // refresh the table
    _gameState.refresh(_context);
  }

  void resetBoard() async {
    _gameState.clear(_context);
    _gameState.resetPlayers(_context);

    /* clean up from result views */
    /* set footer status to none  */
    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.None;
  }
}
