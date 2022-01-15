import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/widgets/game_type_item.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';

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
  AppTextScreen _appScreenText;

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
    _appScreenText = getAppTextScreen("chooseGameNew");

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
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                /* BUILD HEADER */
                Row(
                  children: [
                    AppDimensionsNew.getHorizontalSpace(8),
                    CircleImageButton(
                      onTap: () {
                        _handleLoadGameClick(context, theme);
                      },
                      icon: Icons.open_in_browser_rounded,
                      theme: theme,
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
                        heading: _appScreenText['gameSettings'],
                      ),
                    ),
                    CircleImageButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icons.close,
                      theme: theme,
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
                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onTap: () => handleItemClick(GameType.PLO_HILO),
                        //   child: GameTypeItem(
                        //     clubCode: widget.clubCode,
                        //     type: GameType.PLO_HILO,
                        //     imagePath: AppAssetsNew.pathPLOHiLoTypeImage,
                        //     isSelected: _selectedGameType == GameType.PLO_HILO,
                        //     animValue: _animationController.value,
                        //     onArrowClick: () =>
                        //         handleArrowClick(GameType.PLO_HILO, context),
                        //   ),
                        // ),
                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onTap: () => handleItemClick(GameType.FIVE_CARD_PLO),
                        //   child: GameTypeItem(
                        //     clubCode: widget.clubCode,
                        //     type: GameType.FIVE_CARD_PLO,
                        //     imagePath: AppAssetsNew.pathFiveCardPLOTypeImage,
                        //     isSelected:
                        //         _selectedGameType == GameType.FIVE_CARD_PLO,
                        //     animValue: _animationController.value,
                        //     onArrowClick: () => handleArrowClick(
                        //         GameType.FIVE_CARD_PLO, context),
                        //   ),
                        // ),
                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onTap: () =>
                        //       handleItemClick(GameType.FIVE_CARD_PLO_HILO),
                        //   child: GameTypeItem(
                        //     clubCode: widget.clubCode,
                        //     type: GameType.FIVE_CARD_PLO_HILO,
                        //     imagePath:
                        //         AppAssetsNew.pathFiveCardPLOHiLoTypeImage,
                        //     isSelected: _selectedGameType ==
                        //         GameType.FIVE_CARD_PLO_HILO,
                        //     animValue: _animationController.value,
                        //     onArrowClick: () => handleArrowClick(
                        //         GameType.FIVE_CARD_PLO_HILO, context),
                        //   ),
                        // ),
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
                            onSettingsClick: () => handleSettingsClick(
                                GameType.ROE, gamesRoe, theme),
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
                                GameType.DEALER_CHOICE,
                                gamesDealerChoice,
                                theme),
                            onArrowClick: () => handleArrowClick(
                                GameType.DEALER_CHOICE, context),
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
      ),
    );
  }

  _handleLoadGameClick(BuildContext context, AppTheme theme) async {
    // final instance =
    //     HiveDatasource.getInstance.getBox(BoxType.GAME_SETTINGS_BOX);
    int selectedIndex = -1;
    final templates = appService.gameTemplates.getSettings();
    final indexSelected = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColorsNew.darkGreenShadeColor,
          scrollable: true,
          title: Text(_appScreenText['loadSettings']),
          content: StatefulBuilder(
            builder: (BuildContext context, localSetState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    templates.length == 0
                        ? Expanded(
                            child: Center(
                                child: Text(_appScreenText['noSavedSettings'])))
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    tileColor: (selectedIndex == index)
                                        ? AppColorsNew.yellowAccentColor
                                        : AppColorsNew.actionRowBgColor,
                                    title: Text("${templates[index]}"),
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
                              itemCount: templates.length,
                              physics: ClampingScrollPhysics(),
                            ),
                          ),
                    RoundRectButton(
                        onTap: () {
                          if (templates.length == 0) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop(selectedIndex);
                          }
                        },
                        text: templates.length == 0
                            ? _appScreenText['ok']
                            : _appScreenText['start'],
                        theme: theme),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (indexSelected != null && indexSelected != -1) {
      final jsonGame =
          appService.gameTemplates.getSetting(templates[indexSelected]);
      if (jsonGame != null) {
        NewGameModel game;
        try {
          game = NewGameModel.fromJson(jsonGame);
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
      GameType gameType, List<GameType> existingChoices, AppTheme theme) async {
    setState(() => _selectedGameType = null);

    final List<GameType> games = await Alerts.showChooseGamesDailog(
        existingChoices, context, theme, true);

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
    final theme = AppTheme.getTheme(context);
    return RawChip(
      label: Text(
        '${gameTypeShortStr(gameType)}',
        style: selected
            ? AppDecorators.getHeadLine4Style(theme: theme)
                .copyWith(color: theme.primaryColorWithDark())
            : AppDecorators.getHeadLine4Style(theme: theme)
                .copyWith(color: theme.secondaryColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      selected: selected,
      selectedColor: theme.secondaryColor,
      backgroundColor: theme.fillInColor,
      onSelected: onTapFunc,
      checkmarkColor: theme.primaryColorWithDark(),
    );
  }
}
