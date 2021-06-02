import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
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
import 'package:pokerapp/screens/game_screens/widgets/new_button_widget.dart';
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
      duration: Duration(milliseconds: 250),
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
                          onSettingsClick: () =>
                              handleSettingsClick(GameType.ROE, gamesRoe),
                          gamesList: gamesRoe,
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
                          onSettingsClick: () => handleSettingsClick(
                              GameType.DEALER_CHOICE, gamesDealerChoice),
                          gamesList: gamesDealerChoice,
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
    // if (gameType == GameType.ROE) {
    //   gamesRoe.addAll(await showChooseGamesDailog(gamesRoe));
    // } else if (gameType == GameType.DEALER_CHOICE) {
    //   gamesDealerChoice.addAll(await showChooseGamesDailog(gamesDealerChoice));
    // }
  }

  Future<List<GameType>> handleSettingsClick(
      GameType gameType, List<GameType> existingChoices) async {
    setState(() {
      _selectedGameType = null;
    });
    final List<GameType> games = await showDialog(
      context: context,
      builder: (context) {
        List<GameType> list = [];
        list.addAll(existingChoices);
        return AlertDialog(
          backgroundColor: AppColorsNew.newDialogBgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: StatefulBuilder(builder: (context, localSetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Games",
                  style: AppStylesNew.InactiveChipTextStyle,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Wrap(
                    spacing: 4,
                    children: [
                      GameTypeChip(
                        gameType: GameType.HOLDEM,
                        selected: list.contains(GameType.HOLDEM),
                        onTapFunc: (val) {
                          if (val) {
                            list.add(GameType.HOLDEM);
                          } else {
                            if (list.length <= 2) {
                              toast("Minimum two types required");
                              return;
                            }
                            list.remove(GameType.HOLDEM);
                          }
                          localSetState(() {});
                        },
                      ),
                      GameTypeChip(
                        gameType: GameType.PLO,
                        selected: list.contains(GameType.PLO),
                        onTapFunc: (val) {
                          if (val) {
                            list.add(GameType.PLO);
                          } else {
                            if (list.length <= 2) {
                              toast("Minimum two types required");
                              return;
                            }
                            list.remove(GameType.PLO);
                          }
                          localSetState(() {});
                        },
                      ),
                      GameTypeChip(
                        gameType: GameType.PLO_HILO,
                        selected: list.contains(GameType.PLO_HILO),
                        onTapFunc: (val) {
                          if (val) {
                            list.add(GameType.PLO_HILO);
                          } else {
                            if (list.length <= 2) {
                              toast("Minimum two types required");
                              return;
                            }
                            list.remove(GameType.PLO_HILO);
                          }
                          localSetState(() {});
                        },
                      ),
                      GameTypeChip(
                        gameType: GameType.FIVE_CARD_PLO,
                        selected: list.contains(GameType.FIVE_CARD_PLO),
                        onTapFunc: (val) {
                          if (val) {
                            list.add(GameType.FIVE_CARD_PLO);
                          } else {
                            if (list.length <= 2) {
                              toast("Minimum two types required");
                              return;
                            }
                            list.remove(GameType.FIVE_CARD_PLO);
                          }
                          localSetState(() {});
                        },
                      ),
                      GameTypeChip(
                        gameType: GameType.FIVE_CARD_PLO_HILO,
                        selected: list.contains(GameType.FIVE_CARD_PLO_HILO),
                        onTapFunc: (val) {
                          if (val) {
                            list.add(GameType.FIVE_CARD_PLO_HILO);
                          } else {
                            if (list.length <= 2) {
                              toast("Minimum two types required");
                              return;
                            }
                            list.remove(GameType.FIVE_CARD_PLO_HILO);
                          }
                          localSetState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NewButton(
                      text: "CANCEL",
                      style: AppStylesNew.cancelButtonStyle,
                      onTapFunc: () => Navigator.of(context).pop(),
                    ),
                    NewButton(
                      text: "SAVE",
                      style: AppStylesNew.saveButtonStyle,
                      onTapFunc: () {
                        Navigator.of(context).pop(list);
                      },
                    )
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
    if (games != null && games.isNotEmpty) {
      if (gameType == GameType.ROE) {
        gamesRoe.clear();
        gamesRoe.addAll(games);
      } else if (gameType == GameType.DEALER_CHOICE) {
        gamesDealerChoice.clear();
        gamesDealerChoice.addAll(games);
      }
      setState(() {});
    }
  }
}

class GameTypeChip extends StatelessWidget {
  final bool selected;
  final GameType gameType;
  final Function onTapFunc;
  GameTypeChip({this.selected, this.gameType, this.onTapFunc});
  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(
        '${gameTypeShortStr(gameType)}',
        style: selected
            ? AppStylesNew.ActiveChipTextStyle
            : AppStylesNew.InactiveChipTextStyle,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      selected: selected,
      selectedColor: AppColorsNew.newActiveBoxColor,
      backgroundColor: AppColorsNew.newTileBgBlackColor,
      onSelected: onTapFunc,
    );
  }
}
