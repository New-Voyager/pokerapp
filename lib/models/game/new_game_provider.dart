import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/rewards_model.dart';
import 'package:pokerapp/services/app/rewards_service.dart';

class NewGameModelProvider extends ChangeNotifier {
  /* This object holds new game settings */
  NewGameModel settings;
  String clubCode;
  List<String> actionTimes = [];
  List<String> gameTypes = [];
  List<String> gameLengths = [];
  List<Rewards> rewards = [];
  List<GameType> roeSelectedGames = [];
  NewGameModelProvider(String clubCode) {
    settings = NewGameModel.withDefault(clubCode);
    settings.clubCode = clubCode;
    NewGameConstants.ACTION_TIMES.forEach((key, value) {
      actionTimes.add(value);
    });

    NewGameConstants.GAME_LENGTH.forEach((key, value) {
      gameLengths.add(value);
    });

    NewGameConstants.SUPPORTED_GAMES.forEach((key, value) {
      gameTypes.add(value);
    });
    roeSelectedGames.addAll(
      [
        GameType.HOLDEM,
        GameType.PLO,
      ]
    );
    settings.roeGames = roeSelectedGames;
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

  set blinds(Blinds blinds) {
    settings.setBlinds(blinds);
    notifyListeners();
  }

  int get gameLength => settings.gameLength;
  int get selectedGameLength {
    return gameLengths
        .indexOf(NewGameConstants.GAME_LENGTH[settings.gameLength]);
  }

  set selectedGameLength(int index) {
    if (index == -1) {
    } else {
      String selectedValue = gameLengths[index];
      for (MapEntry e in NewGameConstants.GAME_LENGTH.entries) {
        if (e.value == selectedValue) {
          settings.gameLength = e.key;
          break;
        }
      }
    }
    notifyListeners();
  }

  String get selectedGameLengthText {
    int index =
        gameLengths.indexOf(NewGameConstants.GAME_LENGTH[settings.gameLength]);
    if (index != -1) {
      return gameLengths[index];
    }
    return "";
  }

  int get actionTime => settings.actionTime;
  int get selectedActionTime {
    return actionTimes
        .indexOf(NewGameConstants.ACTION_TIMES[settings.actionTime]);
  }

  set selectedActionTime(int index) {
    if (index == -1) {
    } else {
      String selectedValue = actionTimes[index];
      for (MapEntry e in NewGameConstants.ACTION_TIMES.entries) {
        if (e.value == selectedValue) {
          settings.actionTime = e.key;
          break;
        }
      }
    }
    notifyListeners();
  }

  String get selectedActionTimeText {
    int index =
        actionTimes.indexOf(NewGameConstants.ACTION_TIMES[settings.actionTime]);
    if (index != -1) {
      return actionTimes[index];
    }
    return "";
  }

  Blinds get blinds {
    return Blinds(
        smallBlind: settings.smallBlind,
        bigBlind: settings.bigBlind,
        straddle: settings.straddleBet,
        ante: settings.ante);
  }

  set smallBlind(double value) {
    settings.smallBlind = value;
    notifyListeners();
  }

  set bigBlind(double value) {
    settings.bigBlind = value;
    notifyListeners();
  }

  set straddleBet(double value) {
    settings.straddleBet = value;
    notifyListeners();
  }

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

  get rakePercentage => settings.rakePercentage;
  get rakeCap => settings.rakeCap;

  set rakePercentage(double value) {
    settings.rakePercentage = value;
    notifyListeners();
  }

  set rakeCap(int value) {
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
}
