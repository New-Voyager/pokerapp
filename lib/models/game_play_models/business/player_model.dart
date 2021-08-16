import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;

class StackReloadState {
  int oldStack;
  int newStack;
  int reloadAmount;

  StackReloadState({
    @required this.oldStack,
    @required this.newStack,
    @required this.reloadAmount,
  });
}

class PlayerModel {
  bool isMe = false;
  String name = '';
  int seatNo = -1;
  int playerId = 0;
  String playerUuid = '';
  int buyIn = 0;
  int stack = 0;
  int startingStack = 0;
  String avatarUrl = '';
  String status = '';
  bool inhand = false;
  List<int> _cards = [];
  List<int> highlightCards = [];
  PlayerActedState _action;
  PlayerConnectivityState _connectivity;

  TablePosition playerType;
  bool winner = false;
  bool showFirework = false;
  String rankText = '';
  int noOfCardsVisible = 0;

  // buyin status/timer
  bool showBuyIn = false;
  DateTime buyInTimeExpAt; // unix time in UTC
  bool buyInExpired = false; // buy in time expired
  bool waitForBuyInApproval = false; // waiting for buyin approval

  // player action
  bool animatingFold = false;
  bool highlight = false;
  bool playerFolded = false;

  // reload stack related data - whenever stack reload state is
  StackReloadState stackReloadState;
  bool get reloadAnimation => stackReloadState != null;

  // break time
  bool inBreak = false;
  DateTime breakTimeExpAt;
  DateTime breakTimeStartedAt;

  // audio chat
  bool muted = false;
  bool talking = false;
  bool showMicOn = false;
  bool showMicOff = false;

  PlayerModel({
    String name,
    int seatNo,
    int playerId,
    String playerUuid,
    int buyIn,
    int stack,
    String status,
  }) {
    this.name = name;
    this.seatNo = seatNo;
    this.playerId = playerId;
    this.playerUuid = playerUuid;
    this.buyIn = buyIn;
    this.stack = stack;
    this.status = status;
    this._action = PlayerActedState();
    this._connectivity = PlayerConnectivityState();

    // default values
    this.isMe = false;

    this.playerType = TablePosition.None;
    this.highlight = false;

    // todo: at later point data may contain the player avatar
    // for now randomly choose from the asset files
    int tmpN = math.Random().nextInt(6) + 1;
    this.avatarUrl = 'assets/images/$tmpN.png';
  }

  PlayerModel.fromJson(var data) {
    this.name = data['name'];
    this.seatNo = data['seatNo'];
    this.playerUuid = data['playerUuid'];
    this.buyIn = data['buyIn'];
    this.stack = data['stack'];
    this.status = data['status'];
    this.playerId = int.parse(data['playerId'].toString());
    this._action = PlayerActedState();
    this._connectivity = PlayerConnectivityState();

    DateTime now = DateTime.now();
    if (data['buyInExpTime'] != null) {
      // buyin time is kept in UTC
      this.buyInTimeExpAt = DateTime.tryParse(data['buyInExpTime']);

      print(
          'buyin expires at ${this.buyInTimeExpAt} now: ${now.toIso8601String()} utcNow: ${now.toUtc().toIso8601String()}');
    }

    if (this.status == 'IN_BREAK' && data['breakExpTime'] != null) {
      // buyin time is kept in UTC
      this.breakTimeExpAt = DateTime.tryParse(data['breakExpTime']);
      this.breakTimeStartedAt = DateTime.now();
      if (data['breakStartedTime'] != null) {
        this.breakTimeStartedAt = DateTime.tryParse(data['breakStartedTime']);
      }
      print(
          'break time expires at ${this.breakTimeExpAt} started at: ${this.breakTimeExpAt.toIso8601String()} now: ${now.toIso8601String()}');
    }

    // default values
    this.isMe = false;
    this.playerType = TablePosition.None;
    this.highlight = false;

    this.highlight = false;
    this.playerFolded = false;
    this.animatingFold = false;
    this.showFirework = false;

    this.noOfCardsVisible = 0;

    // todo: at later point data may contain the player avatar
    // for now randomly choose from the asset files
    int tmpN = math.Random().nextInt(6) + 1;
    this.avatarUrl = 'assets/images/$tmpN.png';
  }

  // a util method for updating the class variables
  void update({
    int seatNo,
    int buyIn,
    int stack,
    String status,
    bool showBuyIn,
    TablePosition playerType,
  }) {
    this.seatNo = seatNo ?? this.seatNo;
    this.buyIn = buyIn ?? this.buyIn;
    this.stack = stack ?? this.stack;
    this.status = status;
    this.showBuyIn = showBuyIn ?? this.showBuyIn;
    this.playerType = playerType ?? this.playerType;

    if (!this.showBuyIn) {
      this.buyInTimeExpAt = null;
    }
  }

  List<int> get cards {
    return this._cards;
  }

  bool get isActive {
    if (this.playerFolded ?? false) {
      return true;
    }
    return this.inhand;
  }

  set cards(List<int> v) {
    log('HoleCards: cards set $v');
    this._cards = v;
  }

  List<CardObject> get cardObjects {
    return this.cards.map<CardObject>((c) => CardHelper.getCard(c)).toList();
  }

  @override
  String toString() => this.name;

  set action(PlayerActedState action) => this._action = action;
  PlayerActedState get action => this._action;
  PlayerConnectivityState get connectivity => this._connectivity;

  void reset({bool stickAction}) {
    this.highlight = false;
    this._action.reset(stickAction: stickAction);
    this._connectivity.reset();
  }

  PlayerModel copyWith({
    bool isMe,
    String name,
    int seatNo,
    int playerId,
    String playerUuid,
    int buyIn,
    int stack,
    int startingStack,
    String avatarUrl,
    String status,
    List<int> cards,
    List<int> highlightCards,
    PlayerActedState action,
    PlayerConnectivityState connectivity,
    TablePosition playerType,
    bool winner,
    bool showFirework,
    String rankText,
    int noOfCardsVisible,
    bool showBuyIn,
    DateTime buyInTimeExpAt,
    bool buyInExpired,
    bool waitForBuyInApproval,
    bool animatingFold,
    bool highlight,
    bool playerFolded,
    StackReloadState stackReloadState,
    bool inBreak,
    DateTime breakTimeExpAt,
    DateTime breakTimeStartedAt,
    bool muted,
    bool talking,
    bool showMicOn,
    bool showMicOff,
  }) {
    final p = PlayerModel(
      name: name ?? this.name,
      seatNo: seatNo ?? this.seatNo,
      playerId: playerId ?? this.playerId,
      playerUuid: playerUuid ?? this.playerUuid,
      buyIn: buyIn ?? this.buyIn,
      stack: stack ?? this.stack,
      status: status ?? this.status,
    );

    p.isMe = isMe ?? this.isMe;
    p.startingStack = startingStack ?? this.startingStack;
    p.avatarUrl = avatarUrl ?? this.avatarUrl;
    p.cards = cards ?? this.cards;
    p.highlightCards = highlightCards ?? this.highlightCards;
    p._action = action ?? this.action;
    p._connectivity = connectivity ?? this.connectivity;
    p.playerType = playerType ?? this.playerType;
    p.winner = winner ?? this.winner;
    p.showFirework = showFirework ?? this.showFirework;
    p.rankText = rankText ?? this.rankText;
    p.noOfCardsVisible = noOfCardsVisible ?? this.noOfCardsVisible;
    p.showBuyIn = showBuyIn ?? this.showBuyIn;
    p.buyInTimeExpAt = buyInTimeExpAt ?? this.buyInTimeExpAt;
    p.buyInExpired = buyInExpired ?? this.buyInExpired;
    p.waitForBuyInApproval = waitForBuyInApproval ?? this.waitForBuyInApproval;
    p.animatingFold = animatingFold ?? this.animatingFold;
    p.highlight = highlight ?? this.highlight;
    p.playerFolded = playerFolded ?? this.playerFolded;
    p.stackReloadState = stackReloadState ?? this.stackReloadState;
    p.inBreak = inBreak ?? this.inBreak;
    p.breakTimeExpAt = breakTimeExpAt ?? this.breakTimeExpAt;
    p.breakTimeStartedAt = breakTimeStartedAt ?? this.breakTimeStartedAt;
    p.muted = muted ?? this.muted;
    p.talking = talking ?? this.talking;
    p.showMicOn = showMicOn ?? this.showMicOn;
    p.showMicOff = showMicOff ?? this.showMicOff;

    return p;
  }
}

class PlayerActedState {
  HandActions _playerAction;
  double _amount = 0.0;
  bool _show = false;
  bool _animate = false;
  bool _winner = false;
  bool _sb = false;
  bool _bb = false;
  bool _straddle = false;
  bool _button = false;

  PlayerActedState() {
    reset();
  }

  get amount => this._amount;

  set amount(double value) => this._amount = value;

  get animateAction => this._animate;

  set animateAction(bool v) => this._animate = v;

  get show => this._show;

  set show(bool v) => this._show = v;

  bool get winner => this._winner;

  set winner(bool winner) => this._winner = winner;

  bool get sb => this._sb;

  set sb(bool v) => this._sb = v;

  bool get bb => this._bb;

  set bb(bool v) => this._bb = v;

  bool get straddle => this._straddle;

  set straddle(bool v) => this._straddle = v;

  bool get button => this._button;

  set button(bool v) => this._button = v;

  HandActions get action => this._playerAction;

  void setAction(dynamic data) {
    if (data is ActionElement) {
      _playerAction = data.action;
      _amount = data.amount?.toDouble();
      print('paul debug: $_playerAction $_amount');
      return;
    }

    dynamic action = data['action'];
    if (action == AppConstants.BET) {
      _playerAction = HandActions.BET;
    } else if (action == AppConstants.RAISE) {
      _playerAction = HandActions.RAISE;
    } else if (action == AppConstants.CALL) {
      _playerAction = HandActions.CALL;
    } else if (action == AppConstants.FOLD) {
      _playerAction = HandActions.FOLD;
    } else if (action == AppConstants.ALLIN) {
      _playerAction = HandActions.ALLIN;
    } else if (action == AppConstants.CHECK) {
      _playerAction = HandActions.CHECK;
    }
    dynamic amountStr = data['amount'];
    if (amountStr != null) {
      double amount = double.parse(amountStr.toString());
      _amount = amount;
    }
  }

  void setActionProto(proto.HandAction handAction) {
    if (handAction.action == proto.ACTION.BET) {
      _playerAction = HandActions.BET;
    } else if (handAction.action == proto.ACTION.RAISE) {
      _playerAction = HandActions.RAISE;
    } else if (handAction.action == proto.ACTION.CALL) {
      _playerAction = HandActions.CALL;
    } else if (handAction.action == proto.ACTION.FOLD) {
      _playerAction = HandActions.FOLD;
    } else if (handAction.action == proto.ACTION.ALLIN) {
      _playerAction = HandActions.ALLIN;
    } else if (handAction.action == proto.ACTION.CHECK) {
      _playerAction = HandActions.CHECK;
    } else if (handAction.action == proto.ACTION.BOMB_POT_BET) {
      _playerAction = HandActions.BOMB_POT_BET;
    }
    _amount = handAction.amount;
    if (_amount == null) {
      _amount = 0;
    }
  }

  void setBombPotAction(double amount) {
    _playerAction = HandActions.BOMB_POT_BET;
    _amount = amount;
  }

  void reset({bool stickAction}) {
    amount = 0.0;
    _animate = false;
    winner = false;
    _sb = false;
    _bb = false;
    _button = false;
    _straddle = false;
    if (!(stickAction ?? false)) _playerAction = HandActions.NONE;
  }
}

class PlayerConnectivityState {
  // the player is not responding to the connectivity check
  bool _connectivityLost = false;

  PlayerConnectivityState() {
    reset();
  }

  bool get connectivityLost => this._connectivityLost;

  set connectivityLost(bool v) => this._connectivityLost = v;

  void reset({bool stickAction}) {
    _connectivityLost = false;
  }
}
