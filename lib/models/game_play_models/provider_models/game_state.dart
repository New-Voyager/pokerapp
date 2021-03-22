import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


/*
 * This class maintains game state. This state is updated by hand messages.
 */
class GameState extends ChangeNotifier {

  ListenableProvider<HandInfoState> _handInfo;

  void initialize() {
    // create hand info provider
    this._handInfo = ListenableProvider<HandInfoState>(create: (_) => HandInfoState());
  }

  void clear() {

  }

  HandInfoState getHandInfo(BuildContext context, {bool listen: false}) {
    return Provider.of<HandInfoState>(context, listen: listen);
  }

  List<SingleChildWidget> get providers {
    return [
      this._handInfo,
    ];
  }
}

/*
 * Maintains state of the current hand information. This information is populated at the beginning of the hand.
 */
class HandInfoState extends ChangeNotifier {
  int _noCards = 0;
  GameType _gameType = GameType.UNKNOWN;
  int _handNum = 0;

  get noCards {
    return _noCards;  
  }

  get gameType {
    return _gameType;
  }

  get handNum {
    return _handNum;
  }

  void clear() {
    this._noCards = 0;
    // this._gameType = GameType.UNKNOWN;
    // this._handNum = 0;
  }

  update({int noCards, GameType gameType, int handNum}) {
    this._noCards = noCards;
    this._gameType = gameType;
    this._handNum = handNum;

    this.notifyListeners();
  }
}
