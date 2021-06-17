import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';

class GameModelNew {
  String gameCode;
  String gameType;
  String clubName;
  int buyInMin;
  int buyInMax;
  int smallBlind;
  int bigBlind;
  int maxPlayers;
  int tableCount;
  int elapsedTime;
  int waitlistCount;

  GameModelNew(
      {this.gameCode,
      this.gameType,
      this.clubName,
      this.buyInMin,
      this.buyInMax,
      this.smallBlind,
      this.bigBlind,
      this.maxPlayers,
      this.tableCount,
      this.elapsedTime,
      this.waitlistCount});

  GameModelNew.fromJson(Map<String, dynamic> json) {
    gameCode = json['gameCode'];
    gameType = json['gameType'];
    clubName = json['clubName'];
    buyInMin = json['buyInMin'];
    buyInMax = json['buyInMax'];
    smallBlind = json['smallBlind'];
    bigBlind = json['bigBlind'];
    maxPlayers = json['maxPlayers'];
    tableCount = json['tableCount'];
    elapsedTime = json['elapsedTime'];
    waitlistCount = json['waitlistCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameCode'] = this.gameCode;
    data['gameType'] = this.gameType;
    data['clubName'] = this.clubName;
    data['buyInMin'] = this.buyInMin;
    data['buyInMax'] = this.buyInMax;
    data['smallBlind'] = this.smallBlind;
    data['bigBlind'] = this.bigBlind;
    data['maxPlayers'] = this.maxPlayers;
    data['elapsedTime'] = this.elapsedTime;
    data['tableCount'] = this.tableCount;
    data['waitlistCount'] = this.waitlistCount;

    return data;
  }

  // Util methods
  static String getGameTypeStr(String str) {
    String gameTypeStr = "";
    switch (str) {
      case 'HOLDEM':
        gameTypeStr = AppStringsNew.HoldemType;
        break;
      case 'PLO':
        gameTypeStr = AppStringsNew.PLOType;
        break;
      case 'PLO_HILO':
        gameTypeStr = AppStringsNew.PLOHiLoType;
        break;
      case 'FIVE_CARD_PLO':
        gameTypeStr = AppStringsNew.FiveCardPLOType;
        break;
      case 'FIVE_CARD_PLO_HILO':
        gameTypeStr = AppStringsNew.FiveCardPLOHiLoType;
        break;
      case 'ROE':
        gameTypeStr = AppStringsNew.ROEType;
        break;
      case 'DEALER_CHOICE':
        gameTypeStr = AppStringsNew.DealerChoiceType;
        break;
      default:
        gameTypeStr = AppStringsNew.DefaultType;
    }
    return gameTypeStr;
  }

  static String getGameTypeImageAsset(String str) {
    switch (str) {
      case 'HOLDEM':
      case 'NLH':
        return AppAssetsNew.pathHoldemTypeImage;
        break;
      case 'PLO':
        return AppAssetsNew.pathPLOTypeImage;
        break;
      case 'PLO_HILO':
        return AppAssetsNew.pathPLOHiLoTypeImage;
        break;
      case 'FIVE_CARD_PLO':
        return AppAssetsNew.pathFiveCardPLOTypeImage;
        break;
      case 'FIVE_CARD_PLO_HILO':
        return AppAssetsNew.pathFiveCardPLOHiLoTypeImage;
        break;
      default:
        return AppAssetsNew.pathDefaultTypeImage;
    }
  }

  static int getSeatsAvailble(GameModelNew model) {
    return model.maxPlayers - model.tableCount;
  }

 
}
