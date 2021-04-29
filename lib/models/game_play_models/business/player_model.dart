import 'dart:math';

import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';

class PlayerModel {
  bool isMe = false;
  String name = '';
  int seatNo = -1;
  String playerUuid = '';
  int buyIn = 0;
  int stack = 0;
  String avatarUrl = '';
  String status = '';
  List<int> cards = [];
  List<int> highlightCards = [];
  PlayerActedState _action;

  TablePosition playerType;
  bool winner = false;
  bool showFirework = false;

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

  // break time
  bool inBreak = false;
  DateTime breakTimeExpAt;

  PlayerModel({
    String name,
    int seatNo,
    String playerUuid,
    int buyIn,
    int stack,
    String status,
  }) {
    this.name = name;
    this.seatNo = seatNo;
    this.playerUuid = playerUuid;
    this.buyIn = buyIn;
    this.stack = stack;
    this.status = status;
    this._action = PlayerActedState();

    // default values
    this.isMe = false;

    /* TODO: WHY IS PLAYER TYPE VARIBLAE HOLDING TABLE POSITION? */
    this.playerType = TablePosition.None;
    this.highlight = false;

    // todo: at later point data may contain the player avatar
    // for now randomly choose from the asset files
    int tmpN = Random().nextInt(6) + 1;
    this.avatarUrl = 'assets/images/$tmpN.png';
  }

  PlayerModel.fromJson(var data) {
    this.name = data['name'];
    this.seatNo = data['seatNo'];
    this.playerUuid = data['playerUuid'];
    this.buyIn = data['buyIn'];
    this.stack = data['stack'];
    this.status = data['status'];
    this._action = PlayerActedState();

    if (data['buyInExpTime'] != null) {
      // buyin time is kept in UTC
      this.buyInTimeExpAt = DateTime.tryParse(data['buyInExpTime']);
      // if (this.buyInTimeExpAt != null) {
      //   this.buyInTimeExpAt = this.buyInTimeExpAt.toLocal();
      // }
      DateTime now = DateTime.now();

      print(
          'buyin expires at ${this.buyInTimeExpAt} now: ${now.toIso8601String()} utcNow: ${now.toUtc().toIso8601String()}');
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
    int tmpN = Random().nextInt(6) + 1;
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

  List<CardObject> get cardObjects {
    return this.cards.map<CardObject>((c) => CardHelper.getCard(c)).toList();
  }

  @override
  String toString() => this.name;

  PlayerActedState get action => this._action;

  void reset() {
    this._action.reset();
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

  void setAction(dynamic json) {
    dynamic action = json['action'];
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
    dynamic amountStr = json['amount'];
    if (amountStr != null) {
      double amount = double.parse(amountStr.toString());
      _amount = amount;
    }
  }

  void reset() {
    amount = 0.0;
    _animate = false;
    winner = false;
    _sb = false;
    _bb = false;
    _button = false;
    _straddle = false;
    _playerAction = HandActions.NONE;
  }
}
