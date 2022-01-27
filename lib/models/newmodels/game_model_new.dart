import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';

class GameModelNew {
  String gameCode;
  String gameType;
  String clubName;
  double buyInMin;
  double buyInMax;
  double smallBlind;
  double bigBlind;
  int maxPlayers;
  int tableCount;
  int elapsedTime;
  int waitlistCount;
  String clubCode;
  String clubPicUrl;

  GameModelNew({
    this.gameCode,
    this.gameType,
    this.clubName,
    this.buyInMin,
    this.buyInMax,
    this.smallBlind,
    this.bigBlind,
    this.maxPlayers,
    this.tableCount,
    this.elapsedTime,
    this.waitlistCount,
    this.clubCode,
  });

  GameModelNew.fromJson(Map<String, dynamic> json, {bool playedGame}) {
    gameCode = json['gameCode'];
    gameType = json['gameType'];
    clubName = json['clubName'];
    buyInMin = double.parse(json['buyInMin'].toString());
    buyInMax = double.parse(json['buyInMax'].toString());
    smallBlind = double.parse(json['smallBlind'].toString());
    bigBlind = double.parse(json['bigBlind'].toString());
    maxPlayers = json['maxPlayers'];
    tableCount = json['tableCount'];
    elapsedTime = json['elapsedTime'];
    waitlistCount = json['waitlistCount'];
    clubCode = json['clubCode'];
    clubPicUrl = json['clubPicUrl'];
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
    data['clubCode'] = this.clubCode;

    return data;
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
      case 'SIX_CARD_PLO':
        return AppAssetsNew.pathFiveCardPLOTypeImage;
        break;
      case 'SIX_CARD_PLO_HILO':
        return AppAssetsNew.pathFiveCardPLOHiLoTypeImage;
        break;
      case 'ROE':
        return AppAssetsNew.pathROETypeImage;
        break;
      case 'DEALER_CHOICE':
        return AppAssetsNew.pathDealerChoiceTypeImage;
        break;
      default:
        return AppAssetsNew.pathDefaultTypeImage;
    }
  }

  static String getGameTypeImageAssetFromEnum(GameType type) {
    switch (type) {
      case GameType.HOLDEM:
        return AppAssetsNew.pathHoldemTypeImage;
        break;
      case GameType.PLO:
        return AppAssetsNew.pathPLOTypeImage;
        break;
      case GameType.PLO_HILO:
        return AppAssetsNew.pathPLOHiLoTypeImage;
        break;
      case GameType.FIVE_CARD_PLO:
        return AppAssetsNew.pathFiveCardPLOTypeImage;
        break;
      case GameType.FIVE_CARD_PLO_HILO:
        return AppAssetsNew.pathFiveCardPLOHiLoTypeImage;
        break;
      case GameType.ROE:
        return AppAssetsNew.pathROETypeImage;
        break;
      case GameType.DEALER_CHOICE:
        return AppAssetsNew.pathDealerChoiceTypeImage;
        break;
      default:
        return AppAssetsNew.pathDefaultTypeImage;
    }
  }

  static int getSeatsAvailble(GameModelNew model) {
    return model.maxPlayers - model.tableCount;
  }
}
