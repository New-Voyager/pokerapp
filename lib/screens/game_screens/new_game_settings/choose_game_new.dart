import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/widgets/game_type_item.dart';
import 'package:pokerapp/screens/game_screens/widgets/new_button_widget.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

import '../../../routes.dart';

class ChooseGameNew extends StatefulWidget {
  final String clubCode;

  ChooseGameNew({
    @required this.clubCode,
  });

  @override
  _ChooseGameNewState createState() => _ChooseGameNewState();
}

class _ChooseGameNewState extends State<ChooseGameNew>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  @override
  String get routeName => Routes.new_game_settings;

  GameType _selectedGameType;
  AnimationController _animationController;
  List<GameType> gamesRoe = [GameType.HOLDEM, GameType.PLO];
  List<GameType> gamesDealerChoice = [
    GameType.HOLDEM,
    GameType.PLO,
    GameType.PLO_HILO,
    GameType.FIVE_CARD_PLO,
    GameType.FIVE_CARD_PLO_HILO
  ];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _animationController.addListener(() => setState(() {}));
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
              /* BUILD HEADER */
              Row(
                children: [
                  AppDimensionsNew.getHorizontalSpace(8),
                  InkWell(
                    onTap: () {
                      _handleLoadGameClick(context);
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.open_in_browser_rounded),
                      backgroundColor: AppColorsNew.newGreenRadialStartColor,
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //                           color: AppColorsNew.newGreenButtonColor,

                  //       border: Border.all(
                  //         color: AppColorsNew.newSelectedGreenColor,
                  //       )),
                  //   child: IconButton(
                  //     onPressed: () => Navigator.of(context).pop(),
                  //     icon: Icon(Icons.open_in_browser_rounded),
                  //     tooltip: "Load Settings",
                  //   ),
                  // ),
                  /* HEADING */
                  Expanded(
                    child: HeadingWidget(
                      heading: 'game settings',
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: AppColorsNew.newGreenRadialStartColor,
                    ),
                  ),
                  AppDimensionsNew.getHorizontalSpace(8),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => handleItemClick(GameType.HOLDEM),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.HOLDEM,
                          imagePath: AppAssetsNew.pathHoldemTypeImage,
                          isSelected: _selectedGameType == GameType.HOLDEM,
                          animValue: _animationController.value,
                          onArrowClick: () =>
                              handleArrowClick(GameType.HOLDEM, context),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => handleItemClick(GameType.PLO),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.PLO,
                          imagePath: AppAssetsNew.pathPLOTypeImage,
                          isSelected: _selectedGameType == GameType.PLO,
                          animValue: _animationController.value,
                          onArrowClick: () =>
                              handleArrowClick(GameType.PLO, context),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => handleItemClick(GameType.PLO_HILO),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.PLO_HILO,
                          imagePath: AppAssetsNew.pathPLOHiLoTypeImage,
                          isSelected: _selectedGameType == GameType.PLO_HILO,
                          animValue: _animationController.value,
                          onArrowClick: () =>
                              handleArrowClick(GameType.PLO_HILO, context),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => handleItemClick(GameType.FIVE_CARD_PLO),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.FIVE_CARD_PLO,
                          imagePath: AppAssetsNew.pathFiveCardPLOTypeImage,
                          isSelected:
                              _selectedGameType == GameType.FIVE_CARD_PLO,
                          animValue: _animationController.value,
                          onArrowClick: () =>
                              handleArrowClick(GameType.FIVE_CARD_PLO, context),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () =>
                            handleItemClick(GameType.FIVE_CARD_PLO_HILO),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.FIVE_CARD_PLO_HILO,
                          imagePath: AppAssetsNew.pathFiveCardPLOHiLoTypeImage,
                          isSelected:
                              _selectedGameType == GameType.FIVE_CARD_PLO_HILO,
                          animValue: _animationController.value,
                          onArrowClick: () => handleArrowClick(
                              GameType.FIVE_CARD_PLO_HILO, context),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => handleItemClick(GameType.ROE),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.ROE,
                          imagePath: AppAssetsNew.pathROETypeImage,
                          isSelected: _selectedGameType == GameType.ROE,
                          animValue: _animationController.value,
                          onSettingsClick: () =>
                              handleSettingsClick(GameType.ROE, gamesRoe),
                          gamesList: gamesRoe,
                          onArrowClick: () =>
                              handleArrowClick(GameType.ROE, context),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => handleItemClick(GameType.DEALER_CHOICE),
                        child: GameTypeItem(
                          clubCode: widget.clubCode,
                          type: GameType.DEALER_CHOICE,
                          imagePath: AppAssetsNew.pathDealerChoiceTypeImage,
                          isSelected:
                              _selectedGameType == GameType.DEALER_CHOICE,
                          animValue: _animationController.value,
                          onSettingsClick: () => handleSettingsClick(
                              GameType.DEALER_CHOICE, gamesDealerChoice),
                          gamesList: gamesDealerChoice,
                          onArrowClick: () =>
                              handleArrowClick(GameType.DEALER_CHOICE, context),
                        ),
                      ),
                      // AppDimensionsNew.getVerticalSizedBox(64),
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

  _handleLoadGameClick(BuildContext context) async {
    final instance =
        HiveDatasource.getInstance.getBox(BoxType.GAME_SETTINGS_BOX);
    int selectedIndex = -1;

    final indexSelected = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColorsNew.darkGreenShadeColor,
          scrollable: true,
          title: Text(AppStringsNew.loadSettingsTitle),
          content: StatefulBuilder(
            builder: (BuildContext context, localSetState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    instance.keys.toList().length == 0
                        ? Expanded(
                            child: Center(child: Text("No Saved Settings")))
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    tileColor: (selectedIndex == index)
                                        ? AppColorsNew.yellowAccentColor
                                        : AppColorsNew.actionRowBgColor,
                                    title: Text(
                                        "${instance.keys.toList()[index]}"),
                                    leading: (selectedIndex == index)
                                        ? Icon(Icons.done)
                                        : null,
                                    onTap: () {
                                      localSetState(() {
                                        selectedIndex = index;
                                      });
                                    });
                              },
                              separatorBuilder: (context, index) =>
                                  AppDimensionsNew.getVerticalSizedBox(8),
                              itemCount: instance.keys.toList().length,
                              physics: ClampingScrollPhysics(),
                            ),
                          ),
                    RoundedColorButton(
                      onTapFunction: () {
                        if (instance.keys.toList().length == 0) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop(selectedIndex);
                        }
                      },
                      text: instance.keys.toList().length == 0
                          ? AppStringsNew.okText
                          : AppStringsNew.startText,
                      backgroundColor: AppColorsNew.yellowAccentColor,
                      textColor: AppColorsNew.darkGreenShadeColor,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (indexSelected != null && indexSelected != -1) {
      final jsonGame = instance.get(instance.keys.toList()[indexSelected]);
      if (jsonGame != null) {
        NewGameModel game;
        try {
          game = NewGameModel.fromJson(jsonGame.cast<String, dynamic>());
        } on Exception {
          log("Failed to parse game string");
        }

        if (game != null) {
          NewGameSettings2.show(
            context,
            clubCode: widget.clubCode,
            mainGameType: game.gameType,
            subGameTypes: game.gameType == GameType.DEALER_CHOICE
                ? game.dealerChoiceGames
                : game.gameType == GameType.ROE
                    ? game.roeGames
                    : [],
            savedModel: game,
          );
        }
      }
    }
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

  handleArrowClick(GameType gameType, BuildContext context) {
    Navigator.of(context).pop({
      'gameType': gameType,
      'gameTypes': (gameType == GameType.ROE)
          ? gamesRoe
          : (gameType == GameType.DEALER_CHOICE)
              ? gamesDealerChoice
              : [],
    });
  }

  Future<void> handleSettingsClick(
      GameType gameType, List<GameType> existingChoices) async {
    setState(() => _selectedGameType = null);

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
                  style: AppStylesNew.inactiveChipTextStyle,
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
            ? AppStylesNew.activeChipTextStyle
            : AppStylesNew.inactiveChipTextStyle,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      selected: selected,
      selectedColor: AppColorsNew.newActiveBoxColor,
      backgroundColor: AppColorsNew.newTileBgBlackColor,
      onSelected: onTapFunc,
    );
  }
}
