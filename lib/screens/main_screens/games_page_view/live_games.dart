import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/numeric_keyboard.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';

class LiveGamesScreen extends StatefulWidget {
  @override
  _LiveGamesScreenState createState() => _LiveGamesScreenState();
}

class _LiveGamesScreenState extends State<LiveGamesScreen> {
  bool _isLoading = true;
  List<GameModel> liveGames = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TestService.isTesting ? _loadTestLiveGames() : _fetchLiveGames();
    });
    super.initState();
  }

  _fetchLiveGames() async {
    // Load actual games from server graphql
  }

  _loadTestLiveGames() async {
    ConnectionDialog.show(context: context, loadingText: "Getting games..");
    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/livegames.json");
    // log(data);

    final jsonResult = json.decode(data);

    for (var item in jsonResult['liveGames']) {
      liveGames.add(GameModel.fromJson(item));
    }
    log("Size : ${liveGames.length}");
    setState(() {
      _isLoading = false;
    });
    ConnectionDialog.dismiss(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.newBackgroundBlackColor,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/backgrounds/commonbg.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  AppStrings.liveGamesText.toUpperCase(),
                  style: AppStyles.newTitleTextStyle,
                ),
              ),
              _isLoading
                  ? Container()
                  : liveGames.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "No Live Games.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              GameModel model = liveGames[index];
                              return buildLiveGameTile(model);
                            },
                            padding: EdgeInsets.only(bottom: 64, top: 16),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 16,
                            ),
                            itemCount: liveGames.length,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLiveGameTile(GameModel model) {
    return Stack(
      children: [
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 16),
        //   padding: EdgeInsets.symmetric(vertical: 8),
        //   color: AppColors.newBackgroundBlackColor,
        //   child: Image.asset(
        //     "assets/images/cards/livegames_background.png",
        //     fit: BoxFit.fitWidth,
        //   ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.only(
            left: 16,
            top: 8,
            bottom: 8,
          ),
          constraints: BoxConstraints(
            minHeight: 140,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.newBorderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.newBackgroundBlackColor,
            image: DecorationImage(
              image: AssetImage(
                "assets/images/cards/livegames_background.png",
              ),
              fit: BoxFit.contain,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/cards/livegame_chip.png',
                      height: 100,
                      width: 100,
                    ),
                    Image.asset(
                      GameModel.getGameTypeImageAsset(model.gameType),
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Buy In: ${model.buyInMin}-${model.buyInMax}',
                              style: TextStyle(
                                color: AppColors.newTextColor,
                                fontFamily: AppAssets.fontFamilyPoppins,
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                        Text(
                          "${GameModel.getGameTypeStr(model.gameType)} ${model.smallBlind}/${model.bigBlind}",
                          style: TextStyle(
                              color: AppColors.newTextColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppAssets.fontFamilyPoppins),
                        ),
                        sizedBox4,
                        Text(
                          "Game ID - ${model.gameCode}",
                          style: TextStyle(
                              color: AppColors.newTextGreenColor,
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              fontFamily: AppAssets.fontFamilyPoppins),
                        ),
                        sizedBox2,
                        Text(
                          GameModel.getSeatsAvailble(model) > 0
                              ? "${model.maxPlayers} Open Seats"
                              : model.waitlistCount > 0
                                  ? "Table is Full. (${model.waitlistCount} waiting)"
                                  : "Table is Full.",
                          style: TextStyle(
                              color: AppColors.newTextColor,
                              fontSize: 12,
                              fontFamily: AppAssets.fontFamilyPoppins),
                        ),
                        sizedBox8,
                        Text(
                          "Started ${GameModel.getTimeInHHMMFormat(model)} ago.",
                          style: TextStyle(
                              color: AppColors.newTextColor,
                              fontSize: 10,
                              fontFamily: AppAssets.fontFamilyPoppins),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 8,
          child: InkWell(
            onTap: () {
              // TODO handle join
            },
            child: Container(
              child: Text(
                GameModel.getSeatsAvailble(model) > 0 ? "JOIN" : "VIEW",
                style: TextStyle(
                  color: AppColors.newBackgroundBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/livegames/join.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber,
                      offset: Offset(1, 0),
                      blurRadius: 5,
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}

class GameModel {
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

  GameModel(
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

  GameModel.fromJson(Map<String, dynamic> json) {
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
        gameTypeStr = 'No Limit Holdem';
        break;
      case 'PLO':
        gameTypeStr = 'PLO';
        break;
      case 'PLO_HILO':
        gameTypeStr = 'PLO HiLo';
        break;
      case 'FIVE_CARD_PLO':
        gameTypeStr = '5 Card PLO';
        break;
      case 'FIVE_CARD_PLO_HILO':
        gameTypeStr = '5 Card PLO HiLo';
        break;
      case 'ROE':
        gameTypeStr = 'ROE';
        break;
      case 'DEALER_CHOICE':
        gameTypeStr = 'Dealer Choice';
        break;
      default:
        print("Returning unknown : $str");
        gameTypeStr = 'Game';
    }
    return gameTypeStr;
  }

  static String getGameTypeImageAsset(String str) {
    String path = "";
    switch (str) {
      case 'HOLDEM':
        path = 'assets/images/cards/holdem.png';
        break;
      case 'PLO':
        path = 'assets/images/cards/plo.png';
        break;
      case 'PLO_HILO':
        path = 'assets/images/cards/plo-hi-lo.png';
        break;
      case 'FIVE_CARD_PLO':
        path = 'assets/images/cards/5card-plo.png';
        break;
      case 'FIVE_CARD_PLO_HILO':
        path = 'assets/images/cards/5card-plo-hi-lo.png';
        break;
      default:
        path = 'assets/images/cards/livegame_chip.png';
    }
    return path;
  }

  static int getSeatsAvailble(GameModel model) {
    return model.maxPlayers - model.tableCount;
  }

  static String getTimeInHHMMFormat(GameModel model) {
    if (model.elapsedTime <= 60) {
      return "seconds";
    }
    double mins = model.elapsedTime / 60;
    if (mins > 0 && mins < 60) {
      return "${mins.toStringAsFixed(0)} mins";
    }
    return "${(mins / 60).toStringAsFixed(0)}hrs.${(mins % 60).toStringAsFixed(0)}mins";
  }
}
