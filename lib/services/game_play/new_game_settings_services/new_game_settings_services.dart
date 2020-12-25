import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/create_game_input.dart';
import 'package:pokerapp/services/graphQL/mutations/create_game.dart';

import '../../../main.dart';

class NewGameSettingsServices extends ChangeNotifier {
  // ClubModel
  ClubModel _clubModel;
  ClubModel get clubModel => _clubModel;
  String _gameCode;
  NewGameSettingsServices(this._clubModel);

  // general boolean
  bool _general = false;
  bool get general => _general;

  updateGeneral(bool general) {
    _general = general;
    notifyListeners();
  }

  final List<String> _gameTypes = [
    "No Limit Holdem",
    "PLO",
    "PLO(Hi-Lo)",
    "5 Card PLO",
    "5 Card PLO(Hi-Lo)",
    // "ROE(NLH, PLO)",
    // "ROE(NLH, PLO, PLO Hi-Lo)",
    // "ROE(PLO, PLO Hi-Lo)",
    // "ROE(5 Card PLO, 5 Card PLO Hi-Lo)"
  ];

  final Map<String, String> _gameTypesValues = {
    "No Limit Holdem": "HOLDEM",
    "PLO": "PLO",
    "PLO(Hi-Lo)": "PLO_HILO",
    "5 Card PLO": "FIVE_CARD_PLO",
    "5 Card PLO(Hi-Lo)": "FIVE_CARD_PLO_HILO"
  };

  List<String> _numberOfPlayers = ["2", "3", "4", "5", "6", "7", "8", "9"];

  String _currentGameType = "No Limit Holdem";
  int _currentGameIndex = 0;
  int _smallBlind = 1;
  int _bigBlind = 2;
  int _blindStraddle = 4;
  int _ante = 0;
  int _minChips = 20;
  int _maxChips = 80;
  int _choosenMaxPlayer = 7;

  String get currentGameType => _currentGameType;
  int get currentGameIndex => _currentGameIndex;
  int get smallBlind => _smallBlind;
  int get bigBlind => _bigBlind;
  int get blindStraddle => _blindStraddle;
  int get ante => _ante;
  int get minChips => _minChips;
  int get maxChips => _maxChips;
  int get choosenMaxPlayer => _choosenMaxPlayer;

  List<String> get gameTypes => _gameTypes;
  List<String> get numberOfPlayers => _numberOfPlayers;

  // Starting Club Tips

  // Club Tips Variable
  int _percentage = 2;
  int _cap = 5;

  // Club Tips getter
  int get percentage => _percentage;
  int get cap => _cap;

  // Club Tips methods

  updatePercentage(int p) {
    _percentage = p;
    notifyListeners();
  }

  updateCap(int c) {
    _cap = c;
    notifyListeners();
  }

  // Ending Club Tips

  // Starting Straddle

  // Straddle variable
  bool _straddle = true;
  bool get straddle => _straddle;

  // Straddle methods
  updateStraddle(bool s) {
    _straddle = s;
    notifyListeners();
  }

  // Ending Straddle

  // Starting Action Time

  // Action Time variables

  List<ActionTime> _actionTimeList = [
    ActionTime(time: "10 Seconds", originTime: 10),
    ActionTime(time: "20 Seconds", originTime: 10),
    ActionTime(time: "25 Seconds", originTime: 10),
    ActionTime(time: "30 Seconds", originTime: 10),
    ActionTime(time: "45 Seconds", originTime: 10),
    ActionTime(time: "1 minute", originTime: 10),
    ActionTime(time: "2 minute", originTime: 10),
    ActionTime(time: "5 minute", originTime: 10)
  ];

  int _choosenActionTimeIndex = 1;

  // Action Time getter

  List<ActionTime> get actionTimeList => _actionTimeList;

  int get choosenActionTimeIndex => _choosenActionTimeIndex;

  // Action Time methods

  updateActionTime(int i) {
    _choosenActionTimeIndex = i;
    notifyListeners();
  }

  // Ending Action Time

  updateGameType(int index) {
    _currentGameIndex = index;
    _currentGameType = _gameTypes[index];
    notifyListeners();
  }

  updateSmallBlind(int smallBlind) {
    _smallBlind = smallBlind;
    notifyListeners();
  }

  updateBigBlind(int bigBlind) {
    _bigBlind = bigBlind;
    notifyListeners();
  }

  updateBlindStraddle(int s) {
    _blindStraddle = s;
    notifyListeners();
  }

  updateAnte(int ante) {
    _ante = ante;
    notifyListeners();
  }

  updateMinChips(int min) {
    _minChips = min;
    _maxChips = min * 2;
    notifyListeners();
  }

  updateMaxChips(int max) {
    _maxChips = max;
    notifyListeners();
  }

  updateChooseMaxPlayer(int index) {
    _choosenMaxPlayer = index;
    notifyListeners();
  }

  // Start the Game

  Future<bool> startGame() async {
    CreateGameInput createGameInput = CreateGameInput(
        title: _currentGameType,
        gameType: _gameTypesValues[_currentGameType],
        smallBlind: _smallBlind,
        bigBlind: _bigBlind,
        utgStraddleAllowed: _straddle,
        straddleBet: _blindStraddle,
        minPlayers: 2,
        maxPlayers: int.parse(_numberOfPlayers[_choosenMaxPlayer]),
        gameLength: 60,
        buyInApproval: false,
        rakePercentage: _percentage,
        rakeCap: _cap,
        buyInMin: _minChips,
        buyInMax: _maxChips,
        actionTime: _actionTimeList[_choosenActionTimeIndex].originTime);

    Map<String, dynamic> variables = {
      "clubCode": _clubModel.clubCode,
      "gameInput":  createGameInput.toJson(),
    };
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = CreateGame.createGameQuery;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    //print(result.exception);

    if (result.hasException) return false;

    Map game = (result.data as LazyCacheMap).data['configuredGame'];
    _gameCode = game['gameCode'];
    log('Created game: $_gameCode');
    return true;
  }
}

class ActionTime {
  String time;
  int originTime;

  ActionTime({this.time, this.originTime});
}
