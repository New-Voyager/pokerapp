import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/game_type_item.dart';
import 'package:provider/provider.dart';

class ChooseGameNew extends StatefulWidget {
  @override
  _ChooseGameNewState createState() => _ChooseGameNewState();
}

class _ChooseGameNewState extends State<ChooseGameNew>
    with SingleTickerProviderStateMixin {
  GameType _selectedGameType;
  AnimationController _animationController;
  List<GameType> gamesRoe = [];
  List<GameType> gamesDealerChoice = [];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.bgDecoration,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Text(
                  AppStringsNew.ChooseGameTitle.toUpperCase(),
                  style: AppStylesNew.TitleTextStyle,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => handleItemClick(GameType.HOLDEM),
                        child: GameTypeItem(
                          type: GameType.HOLDEM,
                          imagePath: AppAssetsNew.pathHoldemTypeImage,
                          isSelected: _selectedGameType == GameType.HOLDEM,
                          animValue: _animationController.value,
                        ),
                      ),
                      InkWell(
                        onTap: () => handleItemClick(GameType.PLO),
                        child: GameTypeItem(
                          type: GameType.PLO,
                          imagePath: AppAssetsNew.pathPLOTypeImage,
                          isSelected: _selectedGameType == GameType.PLO,
                          animValue: _animationController.value,
                        ),
                      ),
                      InkWell(
                        onTap: () => handleItemClick(GameType.PLO_HILO),
                        child: GameTypeItem(
                          type: GameType.PLO_HILO,
                          imagePath: AppAssetsNew.pathPLOHiLoTypeImage,
                          isSelected: _selectedGameType == GameType.PLO_HILO,
                          animValue: _animationController.value,
                        ),
                      ),
                      InkWell(
                        onTap: () => handleItemClick(GameType.FIVE_CARD_PLO),
                        child: GameTypeItem(
                          type: GameType.FIVE_CARD_PLO,
                          imagePath: AppAssetsNew.pathFiveCardPLOTypeImage,
                          isSelected:
                              _selectedGameType == GameType.FIVE_CARD_PLO,
                          animValue: _animationController.value,
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            handleItemClick(GameType.FIVE_CARD_PLO_HILO),
                        child: GameTypeItem(
                          type: GameType.FIVE_CARD_PLO_HILO,
                          imagePath: AppAssetsNew.pathFiveCardPLOHiLoTypeImage,
                          isSelected:
                              _selectedGameType == GameType.FIVE_CARD_PLO_HILO,
                          animValue: _animationController.value,
                        ),
                      ),
                      InkWell(
                        onTap: () => handleItemClick(GameType.ROE),
                        child: GameTypeItem(
                          type: GameType.ROE,
                          imagePath: AppAssetsNew.pathROETypeImage,
                          isSelected: _selectedGameType == GameType.ROE,
                          animValue: _animationController.value,
                          gamesList: [GameType.HOLDEM, GameType.FIVE_CARD_PLO],
                        ),
                      ),
                      InkWell(
                        onTap: () => handleItemClick(GameType.DEALER_CHOICE),
                        child: GameTypeItem(
                          type: GameType.DEALER_CHOICE,
                          imagePath: AppAssetsNew.pathDealerChoiceTypeImage,
                          isSelected:
                              _selectedGameType == GameType.DEALER_CHOICE,
                          animValue: _animationController.value,
                          gamesList: [GameType.HOLDEM, GameType.FIVE_CARD_PLO],
                        ),
                      ),
                      AppDimensionsNew.getVerticalSizedBox(64),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleItemClick(GameType gameType) async {
    setState(() {
      _selectedGameType = gameType;
    });
    _animationController.forward(from: 0.0);
    if (gameType == GameType.ROE) {
      gamesRoe.addAll(await showChooseGamesDailog(gamesRoe));
    } else if (gameType == GameType.DEALER_CHOICE) {
      gamesDealerChoice.addAll(await showChooseGamesDailog(gamesRoe));
    }
  }

  showChooseGamesDailog(List<GameType> existingList) async {

    final List<GameType> games = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose Games"),
          content: Container(),
        );
      },
    );
  }
}
