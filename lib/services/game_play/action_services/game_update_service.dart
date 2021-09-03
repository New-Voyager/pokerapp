import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
//import 'package:pokerapp/proto/enums.pbserver.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/seat_change_confirmation_pop_up.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/count_down_timer.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class GameUpdateService {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];
  bool closed = false;
  AppTextScreen _appScreenText = getAppTextScreen("gameUpdateService");

  AudioPlayer audioPlayer;

  GameUpdateService(this._context, this._gameState, this.audioPlayer);

  void close() {
    closed = true;
    clear();
  }

  void clear() {
    _messages.clear();
    this.audioPlayer?.stop();
  }

  loop() async {
    while (!closed) {
      if (_messages.length > 0) {
        // don't process table message in the middle of the hand
        dynamic message = _messages[0];

        //String messageType = message['messageType'];
        log(':GameUpdateService: ${jsonEncode(message)}');
        // if (_gameState.handState != HandState.UNKNOWN &&
        //     _gameState.handState != HandState.ENDED) {
        //   if (messageType == AppConstants.GAME_STATUS ||
        //       messageType == AppConstants.TABLE_UPDATE) {
        //     _messages.removeAt(0);
        //     _messages.add(message);
        //     await Future.delayed(Duration(milliseconds: 500));
        //     continue;
        //   }
        // }

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
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  handle(String message) async {
    assert(_gameState != null);
    assert(_context != null);
    assert(message != null && message.isNotEmpty);

    var data = jsonDecode(message);
    _messages.add(data);
  }

  Future<void> handleMessage(dynamic data) async {
    // if the service is closed, don't process incoming messages
    if (closed) return;

    String messageType = data['messageType'];
    if (messageType != null &&
        messageType.indexOf('PLAYER_CONNECTIVITY') == -1) {
      final jsonData = jsonEncode(data);
      debugPrint(jsonData);
      debugLog(_gameState.gameCode, jsonData);
    }
    String type = data['type']; // new format used by API server
    if (messageType != null) {
      // delegate further actions to sub services as per messageType
      switch (messageType) {
        case AppConstants.PLAYER_UPDATE:
          return handlePlayerUpdate(
            data: data,
          );

        case AppConstants.STACK_RELOADED:
          return handleStackReloaded(
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

        case AppConstants.PLAYER_CONNECTIVITY_LOST:
          List<int> playerIds =
              List<String>.from(data['networkConnectivity']['playerIds'])
                  .map((s) => int.parse(s))
                  .toList();
          return handlePlayerConnectivityLost(
            playerIds: playerIds,
          );

        case AppConstants.PLAYER_CONNECTIVITY_RESTORED:
          List<int> playerIds =
              List<String>.from(data['networkConnectivity']['playerIds'])
                  .map((s) => int.parse(s))
                  .toList();
          return handlePlayerConnectivityRestored(
            playerIds: playerIds,
          );
      }
    } else if (type != null) {
      type = type.toUpperCase();
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
        case AppConstants.STACK_RELOADED:
          return handleStackReloaded(
            data: data,
          );
        case AppConstants.NEW_HIGHHAND_WINNER:
          return handleNewHighhandWinner(
            data: data,
          );
        case AppConstants.PLAYER_UPDATE:
          return handleNewPlayerUpdate(
            data: data,
          );
        case AppConstants.TABLE_UPDATE:
          return handleNewTableUpdate(
            data: data,
          );
        case AppConstants.GAME_STATUS:
          return handleNewUpdateStatus(
            data: data,
          );
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
      // new player
      //_gameState.refresh(_context, rebuildSeats: true);
      handleNewPlayerInSeat(seatNo: seatNo, status: status);
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
      status: status,
    );
    if (closed) return;
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
    if (closed) return;

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
    if (closed) return;

    debugLog(_gameState.gameCode, 'New player message');
    debugLog(_gameState.gameCode, jsonEncode(playerUpdate));

    debugLog(_gameState.gameCode, 'Fetching game information');
    final start = DateTime.now();
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(_gameState.gameCode);
    assert(_gameInfoModel != null);
    List<PlayerModel> playerModels = _gameInfoModel.playersInSeats;
    PlayerModel newPlayerModel = playerModels.firstWhere(
      (pm) => pm.seatNo == seatNo,
      orElse: () => null,
    ); // this must return a PLayerModel object
    final end = DateTime.now();
    final timeTaken = end.difference(start);
    debugLog(_gameState.gameCode,
        'Time taken to fetch game information: ${timeTaken.inMilliseconds}');

    assert(newPlayerModel != null);
    // put the status of the fetched player
    newPlayerModel?.status = playerUpdate['status'];

    if (newPlayerModel.playerUuid == _gameState.currentPlayerUuid) {
      newPlayerModel.isMe = true;
    }

    if (!newPlayerModel.isMe) {
      bool found = _gameState.newPlayer(_context, newPlayerModel);
      if (!found) {
        if (newPlayerModel.stack == 0) {
          newPlayerModel.showBuyIn = true;
        }
      }
    }

    if (closed) return;
    final tableState = _gameState.tableState;
    tableState.notifyAll();
    _gameState.updatePlayers(_context);
  }

  void handleNewPlayerInSeat(
      {@required int seatNo, @required String status}) async {
    // fetch new player using GameInfo API and add to the game
    if (closed) return;

    debugLog(_gameState.gameCode, 'Fetching game information');
    final start = DateTime.now();
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(_gameState.gameCode);
    assert(_gameInfoModel != null);
    List<PlayerModel> playerModels = _gameInfoModel.playersInSeats;
    PlayerModel newPlayerModel = playerModels.firstWhere(
      (pm) => pm.seatNo == seatNo,
      orElse: () => null,
    ); // this must return a PLayerModel object
    final end = DateTime.now();
    final timeTaken = end.difference(start);
    debugLog(_gameState.gameCode,
        'Time taken to fetch game information: ${timeTaken.inMilliseconds}');

    assert(newPlayerModel != null);
    // put the status of the fetched player
    newPlayerModel?.status = status;

    if (newPlayerModel.playerUuid == _gameState.currentPlayerUuid) {
      newPlayerModel.isMe = true;
    }

    if (!newPlayerModel.isMe) {
      bool found = _gameState.newPlayer(_context, newPlayerModel);
      if (!found) {
        if (newPlayerModel.stack == 0) {
          newPlayerModel.showBuyIn = true;
        }
      }
    }

    if (closed) return;
    final tableState = _gameState.tableState;
    tableState.notifyAll();
    _gameState.updatePlayers(_context);
  }

  void handlePlayerLeftGame({
    @required var playerUpdate,
  }) {
    int seatNo = playerUpdate['seatNo'];
    if (seatNo != null && seatNo != 0) {
      removePlayer(seatNo);
    }
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
    final seat = _gameState.getSeat(_context, seatNo);
    if (seat.isMe) {
      if (_gameState.buyInKeyboardShown) {
        Navigator.pop(_context);
        _gameState.buyInKeyboardShown = false;
      }
    }
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
    if (closed) return;
    final seat = _gameState.getSeat(_context, seatNo);
    if (seat != null && seat.player != null && seat.player.isMe) {
      seat.player.showBuyIn = true;
      seat.notify();
      _gameState.myState.status = PlayerStatus.NOT_PLAYING;
      _gameState.myState.notify();
    }

    if (closed) return;
    _gameState.removePlayer(_context, seatNo);
    if (closed) return;
    _gameState.updatePlayers(_context);
    if (closed) return;
    _gameState.markOpenSeat(_context, seatNo);
    if (closed) return;
    final tableState = _gameState.tableState;
    tableState.notifyAll();
  }

  void handlePlayerSwitchSeat({
    @required var playerUpdate,
  }) async {
    int newSeatNo = playerUpdate['seatNo'] as int;
    int oldSeatNo = playerUpdate['oldSeat'] as int;

    print('\n\n newSeat: $newSeatNo : oldSeat: $oldSeatNo \n\n');

    int stack = playerUpdate['stack'] as int;

    final gameInfo = _gameState.gameInfo;
    final player1 = _gameState.fromSeat(_context, oldSeatNo);
    final player1Seat = _gameState.getSeat(_context, oldSeatNo);

    if (player1 == null) return;
    if (player1Seat == null) return;

    player1.seatNo = newSeatNo;

    if (gameInfo.status == 'CONFIGURED' &&
        gameInfo.tableStatus == 'WAITING_TO_BE_STARTED') {
      // switch seat for the player
      if (closed) return;
      final oldSeat = _gameState.getSeat(_context, oldSeatNo);
      oldSeat.player = null;
      if (closed) return;
      _gameState.refresh(_context);
      // final newSeat = gameState.getSeat(context, oldSeatNo);
      // oldSeat.player = null;

    } else {
      if (closed) return;
      final ValueNotifier<SeatChangeModel> vnSeatChangeModel =
          _context.read<ValueNotifier<SeatChangeModel>>();

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
    if (closed) return;
    _gameState.updatePlayers(_context);
  }

  void handlePlayerWaitForBuyinApproval({
    @required var playerUpdate,
  }) async {
    int seatNo = playerUpdate['seatNo'];
    if (closed) return;
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
            if (closed) return;
            final myState = _gameState.getMyState(_context);
            myState.notify();
          }
          break;
        }
      }
      seat.notify();
    }
    if (closed) return;
    final tableState = _gameState.tableState;
    tableState.notifyAll();
  }

  void handlePlayerBuyinDenied({
    @required var playerUpdate,
  }) {
    if (closed) return;
    final GameState gameState = GameState.getState(_context);
    int seatNo = playerUpdate['seatNo'];
    if (closed) return;
    final seat = gameState.getSeat(_context, seatNo);
    log('Buyin is denied');
    if (closed) return;
    final players = gameState.getPlayers(_context);
    players.removePlayerSilent(seatNo);
    bool isMe = false;
    if (seat.player.isMe) {
      isMe = true;
    }
    seat.player = null;
    seat.notify();

    if (isMe) {
      if (closed) return;
      final myState = gameState.getMyState(_context);
      myState.notify();

      showAlertDialog(_context, _appScreenText['buyInRequest'],
          _appScreenText['TheHostDeniedTheBuyinRequest']);
    }
  }

  void handlePlayerTakeBreak({
    @required var playerUpdate,
  }) async {
    if (closed) return;
    final GameState gameState = GameState.getState(_context);
    int seatNo = playerUpdate['seatNo'];
    if (closed) return;
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
            if (closed) return;
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
    if (closed) return;
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
            if (closed) return;
            final myState = _gameState.getMyState(_context);
            myState.notify();
          }
          break;
        }
      }
      seat.notify();
    }
  }

  void handleStackReloaded({
    var data,
  }) async {
    /*
    * {"gameCode":"cgkmtdhya","messageType":"STACK_RELOADED", "playerId":"3",
    * "oldStack":200,"newStack":250,"reloadAmount":50,"status":"PLAYING"}
    */

    int playerId = int.parse(data['playerId'].toString());
    int oldStack = int.parse(data['oldStack'].toString());
    int newStack = int.parse(data['newStack'].toString());
    int reloadAmount = int.parse(data['reloadAmount'].toString());

    final _players = _context.read<Players>();

    _players.updateStackReloadStateSilent(
        playerId,
        StackReloadState(
          oldStack: oldStack,
          newStack: newStack,
          reloadAmount: reloadAmount,
        ));

    _players.notifyAll();

    // wait for the animation to end
    await Future.delayed(const Duration(milliseconds: 2000));

    // finally end animation
    _players.updateStackReloadStateSilent(playerId, null);
    _players.notifyAll();
  }

  void handleNewHighhandWinner({
    var data,
  }) async {
    log(jsonEncode(data));

    /*
        {
          "type": "NEW_HIGHHAND_WINNER",
          "gameCode": "cgorysdcm",
          "handNum": 1,
          "boardCards": [52, 49, 50, 17, 4],
          "winners": [{
            "gameCode": "cgorysdcm",
            "playerId": "223",
            "playerUuid": "4b93e2be-7992-45c3-a2dd-593c2f708cb7",
            "playerName": "brian",
            "boardCards": [52, 49, 50, 17, 4],
            "playerCards": [56, 72],
            "hhCards": [56, 72, 52, 49, 50]
          }],
          "requestId": "a32c44c3-640c-4fcc-9483-2f6db49fc4f7"
        }
    */
    _gameState.highHand = data;
  }

  void handlePlayerUpdate({
    var data,
  }) {
    var playerUpdate = data['playerUpdate'];
    String newUpdate = playerUpdate['newUpdate'];
    String playerStatus = playerUpdate['status'];
    String playerId = playerUpdate['playerId'];

    if (playerId == _gameState.currentPlayerId.toString()) {
      if (playerStatus == AppConstants.PLAYING &&
          _gameState.myState.status != PlayerStatus.PLAYING) {
        _gameState.myState.status = PlayerStatus.PLAYING;
        if (closed) return;
        _gameState.myState.notify();
      }
    }

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

  void handleNewPlayerUpdate({
    var data,
  }) {
    var playerUpdate = data;
    String newUpdate = playerUpdate['newUpdate'];
    String playerStatus = playerUpdate['status'];
    int playerId = int.parse(playerUpdate['playerId'].toString());

    if (playerId == _gameState.currentPlayerId) {
      if (playerStatus == AppConstants.PLAYING &&
          _gameState.myState.status != PlayerStatus.PLAYING) {
        _gameState.myState.status = PlayerStatus.PLAYING;
        if (closed) return;
        _gameState.myState.notify();
      }
    }

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
    if (closed) return;
    _gameState.resetPlayers(_context);

    /* clean up from result views */
    /* set footer status to none  */
    if (closed) return;
    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.None;
    if (closed) return;
    _gameState.clear(_context);
  }

  void handleTableUpdate({
    var data,
  }) async {
    var tableUpdate = data['tableUpdate'];
    String type = tableUpdate['type'];
    String jsonData = jsonEncode(data);
    log(jsonData);
    // {"gameId":"494","gameCode":"cgnmxhehyy","messageType":"TABLE_UPDATE","tableUpdate":{"type":"HostSeatChangeInProcessStart","seatChangeHost":"1927"}}

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

  void handleNewTableUpdate({
    var data,
  }) async {
    String type = data['subType'];
    String jsonData = jsonEncode(data);
    log(jsonData);
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

  void handlePlayerConnectivityLost({
    List<int> playerIds,
  }) async {
    // log("HANDLING PLAYER CONNECTIVITY LOST: " + playerIds.toString());
    for (int playerId in playerIds) {
      // log(playerId.toString());
      Seat seat = _gameState.getSeatByPlayer(playerId);
      if (seat == null) {
        continue;
      }
      // log(seat.toString());
      PlayerModel player = seat.player;
      assert(player.playerId == playerId);
      // log(player.toString());
      if (!player.connectivity.connectivityLost) {
        player.connectivity.connectivityLost = true;
        seat.notify();
      }
    }
  }

  void handlePlayerConnectivityRestored({
    List<int> playerIds,
  }) async {
    // log("HANDLING PLAYER CONNECTIVITY RESTORED: " + playerIds.toString());
    for (int playerId in playerIds) {
      // log(playerId.toString());
      Seat seat = _gameState.getSeatByPlayer(playerId);
      if (seat == null) {
        continue;
      }
      // log(seat.toString());
      PlayerModel player = seat.player;
      assert(player.playerId == playerId);
      // log(player.toString());
      if (player.connectivity.connectivityLost) {
        player.connectivity.connectivityLost = false;
        seat.notify();
      }
    }
  }

  void handleWaitlistSeating({
    var data,
  }) async {
    log('waitlist seating message received');
    if (closed) return;
    final waitlistState = _gameState.getWaitlistState(_context);
    waitlistState.fromJson(data);
    waitlistState.notify();
    String message =
        '${waitlistState.name} ${_appScreenText['isInvitedToTakeTheOpenSeat']}';

    showOverlayNotification(
      (context) => OverlayNotificationWidget(
        title: '${_appScreenText['Waitlist']}',
        subTitle: message,
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

    if (closed) return;
    final player = _gameState.fromSeat(_context, seatChangeSeatNo[0]);
    assert(player != null);

    /* If I am in this list, show me a confirmation popup */
    if (player.isMe) {
      if (closed) return;
      SeatChangeConfirmationPopUp.dialog(
        context: _context,
        gameCode: _gameState.gameCode,
      );
    } else {}

    if (closed) return;
    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      _context,
      listen: false,
    );

    valueNotifierNotModel.value = GeneralNotificationModel(
      titleText: '${_appScreenText['seatChangeInProgress']}',
      subTitleText:
          '${_appScreenText['seatChangeRequestedBy']} ${player.name} ${_appScreenText['atSeatNo']} ${player.seatNo}',
      trailingWidget: CountDownTimer(
        remainingTime:
            seatChangeTime * seatChangeSeatNo.length, // TODO: MULTIPLE PLAYERS?
      ),
    );

    await Future.delayed(
      Duration(
        seconds: seatChangeTime * seatChangeSeatNo.length,
      ),
    );

    /* remove notification */
    valueNotifierNotModel.value = null;
  }

  void handleHostSeatChangeStart({
    var data,
  }) async {
    final gameCode = _gameState.gameCode;
    final seatChangeHost = int.parse(data["seatChangeHostId"].toString());
    final seatChange = Provider.of<SeatChangeNotifier>(_context, listen: false);
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

    final seatChange = Provider.of<SeatChangeNotifier>(_context, listen: false);
    seatChange.updateSeatChangeInProgress(false);
    seatChange.notifyAll();
    _gameState.refresh(_context);
  }

  void handleHostSeatChangeMove({
    var data,
  }) async {
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeMove", "seatMoves":[{"playerId":"131", "playerUuid":"290bf492-9dde-448e-922d-40270e163649", "name":"rich", "oldSeatNo":6, "newSeatNo":1}, {"playerId":"122", "playerUuid":"c2dc2c3d-13da-46cc-8c66-caa0c77459de", "name":"yong", "oldSeatNo":1, "newSeatNo":6}]}}
    // player is moved, show animation of the move

    final hostSeatChange =
        Provider.of<SeatChangeNotifier>(_context, listen: false);
    var seatMoves = data['seatMoves'];
    for (var move in seatMoves) {
      int from = int.parse(move['oldSeatNo'].toString());
      int to = int.parse(move['newSeatNo'].toString());
      String name = move['name'].toString();
      // double stack = double.parse(move['stack'].toString());
      debugPrint('Seatchange: Player $name from seat $from to $to');

      /* start animation */
      hostSeatChange.onSeatDrop(from, to);

      /* wait for the animation to finish */
      await Future.delayed(AppConstants.seatChangeAnimationDuration);
    }
    final gameCode = _gameState.gameCode;
    // get current seat positions

    final gameState = Provider.of<GameState>(
      _context,
      listen: false,
    );

    final players = gameState.getPlayers(_context);

    /* refresh the player model */
    final positions =
        await SeatChangeService.hostSeatChangeSeatPositions(gameCode);
    players.refreshWithPlayerInSeat(positions);
  }

  void handleHighHand({
    var data,
    bool showNotification = false,
  }) async {
    if (data == null) return;

    String gameCode = data['gameCode'] as String;
    int handNum = data['handNum'] as int;

    // TODO: HANDLE MULTIPLE HIGHHAND WINNERS
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
      playSoundEffect(AppAssets.fireworksSound);
      seat.notify();
      await Future.delayed(AppConstants.notificationDuration);

      // turn off firework
      player.showFirework = false;
      seat.notify();
    }
  }

  void handleUpdateStatus({
    var status,
  }) async {
    String tableStatus = status['tableStatus'];
    String gameStatus = status['status'];

    /*
      {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"ACTIVE","tableStatus":"WAITING_TO_BE_STARTED"}}
      {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"PAUSED","tableStatus":"GAME_RUNNING"}}
      else if (type == AppConstants.GAME_PAUSED) {
      // {"gameId":"494","gameCode":"cgnmxhehyy","messageType":"GAME_STATUS","status":{"status":"PAUSED","tableStatus":"GAME_RUNNING"}}

    }
    */

    final tableState = _gameState.tableState;

    if (tableState.tableStatus != tableStatus ||
        tableState.gameStatus != gameStatus) {
      tableState.updateTableStatusSilent(tableStatus);
      tableState.updateGameStatusSilent(gameStatus);

      if (gameStatus == AppConstants.GAME_ACTIVE &&
          (tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING ||
              tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING_1)) {
        log('Game is running. Update the state: ${_gameState.isGameRunning}');
        //_gameState.refresh(_context);
        /* QUERY_CURRENT_HAND is done here, only after making sure,
        * that the game is running.
        * This is done to get update of the game */
        //gameContext.handActionService.queryCurrentHand();
      } else if (gameStatus == AppConstants.GAME_ENDED) {
        if (_gameState.handInProgress) {
          // if we are in middle of the hand, don't close it yet
          while (_gameState.handInProgress) {
            await Future.delayed(Duration(milliseconds: 1000));
          }
        }
        // end the game
        log('Game has ended. Update the state');
        resetBoard();
        _gameState.refresh(_context);
        tableState.updateTableStatusSilent(AppConstants.GAME_ENDED);
      } else if (gameStatus == AppConstants.GAME_PAUSED) {
        log('Game has paused. Update the state');
        resetBoard();
        Alerts.showNotification(
            titleText: "${_appScreenText['game']}",
            svgPath: 'assets/images/casino.svg',
            subTitleText: _appScreenText['theGameIsPaused']);

        _gameState.refresh(_context);
        // paused the game
        tableState.updateTableStatusSilent(AppConstants.GAME_PAUSED);
      }

      tableState.notifyAll();
    }
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
        "playerUuid": " ",
        "expTime": "2021-05-29T22:46:13.000Z",
        "promptSecs": 10,
        "requestId": "SEATCHANGE:1622328363754"
      }    
    */
    _gameState.playerSeatChangeInProgress = true;
    // we are in seat change
    Provider.of<SeatChangeNotifier>(
      _context,
      listen: false,
    )..updateSeatChangeInProgress(true);
    _gameState.refresh(_context);

    final playerId = data['playerId'];
    final player = _gameState.getSeatByPlayer(playerId);
    log('Seat Change: Prompt player ${player.player.name}');
    final promptSecs = int.parse(data['promptSecs'].toString());
    final openedSeat = int.parse(data['openedSeat'].toString());
    final openSeats = await GameService.getOpenSeats(_gameState.gameCode);
    for (final seatNo in openSeats) {
      final seat = _gameState.getSeat(_context, seatNo);
      if (seat != null) {
        seat.notify();
      }
    }

    // is it sent to me ??
    if (player != null) {
      if (player.isMe) {
        SeatChangeConfirmationPopUp.dialog(
            context: _context,
            gameCode: _gameState.gameCode,
            openedSeat: openedSeat,
            openSeats: openSeats,
            promptSecs: promptSecs);
      } else {
        String title = '${_appScreenText['seatChangeInProgress']}';
        String playerName = '${_appScreenText['player']}';
        if (player != null && player.player != null) {
          playerName = player.player.name;
        }
        String subTitle =
            '$playerName ${_appScreenText['isPromptedToSwitchToAnOpenSeat']}';

        showOverlayNotification(
          (context) => OverlayNotificationWidget(
            title: title,
            subTitle: subTitle,
            svgPath: 'assets/images/seatchange.svg',
          ),
          duration: Duration(seconds: promptSecs - 1),
        );
      }
    }
  }

  void handleNewUpdateStatus({
    var data,
  }) async {
    String tableStatus = data['tableStatus'];
    String gameStatus = data['gameStatus'];

    /*
      {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"ACTIVE","tableStatus":"WAITING_TO_BE_STARTED"}}
      {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"PAUSED","tableStatus":"GAME_RUNNING"}}
      else if (type == AppConstants.GAME_PAUSED) {
      // {"gameId":"494","gameCode":"cgnmxhehyy","messageType":"GAME_STATUS","status":{"status":"PAUSED","tableStatus":"GAME_RUNNING"}}

    }
    */

    final tableState = _gameState.tableState;

    // if the status hasn't changed, don't do anything
    if (gameStatus == tableState.gameStatus) {
      if (tableStatus == tableState.tableStatus) {
        return;
      }

      if (tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING ||
          tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING_1) {
        tableStatus = AppConstants.TABLE_STATUS_GAME_RUNNING;
      }
      if (tableStatus == tableState.tableStatus) {
        return;
      }
    }

    if (gameStatus == AppConstants.GAME_PAUSED) {
      log('Game has paused. Update the state');
      resetBoard();
      Alerts.showNotification(
          titleText: "${_appScreenText['game']}",
          svgPath: 'assets/images/casino.svg',
          subTitleText: _appScreenText['theGameIsPaused']);

      _gameState.refresh(_context);
      // paused the game
      tableState.updateTableStatusSilent(AppConstants.GAME_PAUSED);
      tableState.notifyAll();
      return;
    }

    if (tableState.tableStatus != tableStatus ||
        tableState.gameStatus != gameStatus) {
      tableState.updateTableStatusSilent(tableStatus);
      tableState.updateGameStatusSilent(gameStatus);

      if (gameStatus == AppConstants.GAME_ACTIVE &&
          (tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING ||
              tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING_1)) {
        log('Game is running. Update the state: ${_gameState.isGameRunning}');
        //_gameState.refresh(_context);
        /* QUERY_CURRENT_HAND is done here, only after making sure,
        * that the game is running.
        * This is done to get update of the game */
        //gameContext.handActionService.queryCurrentHand();
      } else if (gameStatus == AppConstants.GAME_ENDED) {
        if (_gameState.handInProgress) {
          // if we are in middle of the hand, don't close it yet
          while (_gameState.handInProgress) {
            await Future.delayed(Duration(milliseconds: 1000));
          }
        }
        // end the game
        log('Game has ended. Update the state');
        resetBoard();
        _gameState.refresh(_context);
        tableState.updateTableStatusSilent(AppConstants.GAME_ENDED);
      }

      tableState.notifyAll();
    }
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

    log('SeatChange: player name: $playerName id: $playerId oldSeatNo: $oldSeatNo newSeatNo: $newSeatNo');

    final hostSeatChange =
        Provider.of<SeatChangeNotifier>(_context, listen: false);

    /* start animation */
    hostSeatChange.onSeatDrop(oldSeatNo, newSeatNo);

    /* wait for the animation to finish */
    await Future.delayed(AppConstants.seatChangeAnimationDuration);
    _gameState.refresh(_context);

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
    // we are in seat change
    Provider.of<SeatChangeNotifier>(
      _context,
      listen: false,
    )..updateSeatChangeInProgress(false);

    log('Seat change done');
    // refresh the table
    resetBoard();
  }

  void resetBoard() async {
    _gameState.clear(_context);
    _gameState.resetPlayers(_context);
    _gameState.refresh(_context);

    /* clean up from result views */
    /* set footer status to none  */
    Provider.of<ValueNotifier<FooterStatus>>(
      _context,
      listen: false,
    ).value = FooterStatus.None;
  }

  playSoundEffect(String soundFile) {
    return;

    if (_gameState.settings.gameSound) {
      _gameState
          .getAudioBytes(soundFile)
          .then((value) => audioPlayer.playBytes(value));
      // log('In playSoundEffect(), gameSounds = ${_gameState.settings.gameSound}');
    }
  }
}
