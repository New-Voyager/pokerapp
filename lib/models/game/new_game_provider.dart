import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/rewards_model.dart';

class NewGameModelProvider extends ChangeNotifier {
  /* This object holds new game settings */
  NewGameModel settings;
  String clubCode;
  // List<String> actionTimes = [];
  List<String> gameTypes = [];
  // List<String> gameLengths = [];
  List<Rewards> rewards = [];
  List<GameType> roeSelectedGames = [];
  List<GameType> dealerSelectedGames = [];

  NewGameModelProvider(String clubCode) {
    settings = NewGameModel.withDefault(clubCode);
    settings.clubCode = clubCode;
    // NewGameConstants.ACTION_TIMES.forEach((key, value) {
    //   actionTimes.add(value);
    // });

    // NewGameConstants.GAME_LENGTH.forEach((key, value) {
    //   gameLengths.add(value);
    // });

    NewGameConstants.SUPPORTED_GAMES.forEach((key, value) {
      gameTypes.add(value);
    });
    roeSelectedGames.addAll([
      GameType.HOLDEM,
      GameType.PLO,
    ]);
    settings.roeGames = roeSelectedGames;

    dealerSelectedGames.addAll([
      GameType.HOLDEM,
      GameType.PLO,
      GameType.PLO_HILO,
      GameType.FIVE_CARD_PLO,
      GameType.FIVE_CARD_PLO_HILO,
    ]);
    settings.dealerChoiceGames = dealerSelectedGames;
  }

  get selectedReward {
    if (settings.rewards == null) {
      return 0;
    }
    int index =
        rewards.indexWhere((element) => element.name == settings.rewards.name);
    if (index == -1) {
      return 0;
    }
    return index;
  }

  set selectedReward(int index) {
    if (index == -1) {
      settings.rewards = null;
      return;
    }

    settings.rewards = rewards[index];
    notifyListeners();
  }

  set setReward(Rewards rewards) {
    settings.rewards = rewards;
    notifyListeners();
  }

  set gameType(int index) {
    if (index == -1) {
    } else {
      String selectedValue = gameTypes[index];
      for (MapEntry e in NewGameConstants.SUPPORTED_GAMES.entries) {
        if (e.value == selectedValue) {
          settings.gameType = e.key;
          break;
        }
      }
    }
    notifyListeners();
  }

  get selectedGameType {
    return gameTypes
        .indexOf(NewGameConstants.SUPPORTED_GAMES[settings.gameType]);
  }

  set selectedGameType(int index) {
    if (index == -1) {
    } else {
      String selectedValue = gameTypes[index];
      for (MapEntry e in NewGameConstants.SUPPORTED_GAMES.entries) {
        if (e.value == selectedValue) {
          settings.gameType = e.key;
          break;
        }
      }
    }
    notifyListeners();
  }

  String get selectedGameTypeText {
    int index =
        gameTypes.indexOf(NewGameConstants.SUPPORTED_GAMES[settings.gameType]);
    if (index != -1) {
      return gameTypes[index];
    }
    return "";
  }

  // int get gameLengthInMins => settings.gameLength;
  // set gameLengthInMins(value) {
  //   settings.gameLength = value;
  //   notifyListeners();
  // }
  int get gameLengthInHrs => settings.gameLength;
  set gameLengthInHrs(value) {
    settings.gameLength = value;
    notifyListeners();
  }

  bool get buyInApproval => settings.buyInApproval ?? false;
  set buyInApproval(value) {
    settings.buyInApproval = value;
    notifyListeners();
  }

  bool get breakAllowed => settings.breakAllowed ?? false;
  set breakAllowed(value) {
    settings.breakAllowed = value;
    notifyListeners();
  }

  int get breakTime => settings.breakTime ?? 5;
  set breakTime(value) {
    settings.breakTime = value;
    notifyListeners();
  }
  
  bool get bombPotEnabled => settings.bombPotEnabled ?? false;
  set bombPotEnabled(value) {
    settings.bombPotEnabled = value;
    notifyListeners();
  }

  int get bombPotBet => settings.bombPotBet ?? 5;
  set bombPotBet(value) {
    settings.bombPotBet = value;
    notifyListeners();
  }

  bool get doubleBoardBombPot => settings.doubleBoardBombPot ?? false;
  set doubleBoardBombPot(value) {
    settings.doubleBoardBombPot = value;
    notifyListeners();
  }

  int get bombPotInterval => settings.bombPotInterval ?? false;
  set bombPotInterval(value) {
    settings.bombPotInterval = value;
    notifyListeners();
  }

  int get actionTime => settings.actionTime;
  set actionTime(int v) {
    settings.actionTime = v;
    notifyListeners();
  }

  set blinds(Blinds blinds) {
    settings.setBlinds(blinds);
    notifyListeners();
  }

  Blinds get blinds {
    return Blinds(
        smallBlind: settings.smallBlind,
        bigBlind: settings.bigBlind,
        straddle: settings.straddleBet,
        ante: settings.ante);
  }

  double get smallBlind => settings.smallBlind;
  set smallBlind(double value) {
    settings.smallBlind = value;
    notifyListeners();
  }

  double get bigBlind => settings.bigBlind;
  set bigBlind(double value) {
    settings.bigBlind = value;
    notifyListeners();
  }

  double get straddleBet => settings.straddleBet;
  set straddleBet(double value) {
    settings.straddleBet = value;
    notifyListeners();
  }

  double get ante => settings.ante;
  set ante(double value) {
    settings.ante = value;
    notifyListeners();
  }

  int get buyInMin => settings.buyInMin;
  int get buyInMax => settings.buyInMax;

  set buyInMin(int value) {
    settings.buyInMin = value;
    if (settings.buyInMax <= settings.buyInMin) {
      settings.buyInMax = value + 100;
    }
    notifyListeners();
  }

  set buyInMax(int value) {
    settings.buyInMax = value;
    notifyListeners();
  }

  double get rakePercentage => settings.rakePercentage;
  double get rakeCap => settings.rakeCap;

  set rakePercentage(double value) {
    settings.rakePercentage = value;
    notifyListeners();
  }

  set rakeCap(double value) {
    settings.rakeCap = value;
    notifyListeners();
  }

  get maxPlayers {
    return settings.maxPlayers;
  }

  set maxPlayers(int value) {
    settings.maxPlayers = value;
    notifyListeners();
  }

  get locationCheck => settings.locationCheck;
  set locationCheck(bool value) {
    settings.locationCheck = value;
    notifyListeners();
  }

  get ipCheck => settings.ipCheck;
  set ipCheck(bool value) {
    settings.locationCheck = value;
    notifyListeners();
  }

  get seatChangeAllowed => settings.seatChangeAllowed;
  set seatChangeAllowed(bool value) {
    settings.seatChangeAllowed = value;
    notifyListeners();
  }

  // TODO: WE NEED THIS IN THE SETTING
  bool _showPlayerBuyin;
  get showPlayerBuyin => _showPlayerBuyin ?? false;
  set showPlayerBuyin(bool value) {
    _showPlayerBuyin = value;
    notifyListeners();
  }

  get runItTwice => settings.runItTwice;
  set runItTwice(bool value) {
    settings.runItTwice = value;
    notifyListeners();
  }

  get waitList => settings.waitList;
  set waitList(bool value) {
    settings.waitList = value;
    notifyListeners();
  }

  get straddleAllowed => settings.utgStraddleAllowed;
  set straddleAllowed(bool value) {
    settings.utgStraddleAllowed = value;
    notifyListeners();
  }

  get botGame => settings.botGame;
  set botGame(bool value) {
    settings.botGame = value;
    notifyListeners();
  }

  get muckLosingHand => settings.muckLosingHand;
  set muckLosingHand(bool value) {
    settings.muckLosingHand = value;
    notifyListeners();
  }

  get audioConference => settings.audioConference;
  set audioConference(bool value) {
    settings.audioConference = value;
    notifyListeners();
  }

  get useAgora => settings.useAgora;
  set useAgora(bool value) {
    settings.useAgora = value;
    settings.audioConference = value;
    notifyListeners();
  }

  get showHandRank => settings.showHandRank;
  set showHandRank(bool value) {
    settings.showHandRank = value;
    notifyListeners();
  }

  get allowRabbitHunt => settings.allowRabbitHunt;
  set allowRabbitHunt(bool value) {
    settings.allowRabbitHunt = value;
    notifyListeners();
  }

  get buyInWaitTime => settings.buyInWaitTime;
  set buyInWaitTime(int value) {
    settings.buyInWaitTime = value;
    notifyListeners();
  }
}
