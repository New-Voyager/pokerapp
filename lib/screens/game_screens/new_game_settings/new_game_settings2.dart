import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/enums/approval_type.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/web-routes.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/child_widgets.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/multi_game_selection.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/slider.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../../main_helper.dart';
import '../../../routes.dart';

class NewGameSettings2 extends StatefulWidget {
  static void _joinGame(BuildContext context, String gameCode) {
    if (PlatformUtils.isWeb) {
      Navigator.of(context).pushNamed(
        WebRoutes.game_play + "/${gameCode}",
      );
    } else {
      navigatorKey.currentState.pushNamed(
        Routes.game_play,
        arguments: gameCode,
      );
    }
  }

  static Future<void> show(
    BuildContext context, {
    @required String clubCode,
    @required GameType mainGameType,
    @required List<GameType> subGameTypes,
    NewGameModel savedModel,
  }) async {
    ConnectionDialog.show(context: context, loadingText: 'Please wait...');

    ClubHomePageModel clubHomePageModel =
        await ClubsService.getClubHomePageData(
      clubCode,
    );

    ConnectionDialog.dismiss(context: context);
    NewGameModelProvider gmp = await showDialog<NewGameModelProvider>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: NewGameSettings2(
          clubHomePageModel,
          mainGameType,
          savedModel,
        ),
      ),
    );

    if (gmp == null) {
      return;
    }

    if (gmp.cancelled) {
      return;
    }

    /* otherwise, start tha game */
    final NewGameModel gm = gmp.settings;

    if (mainGameType == GameType.HOLDEM) {
      gm.gameType = mainGameType;
    }

    // gm.gameType = mainGameType;
    // gm.roeGames = subGameTypes;
    // gm.dealerChoiceGames = subGameTypes;

    String gameCode;
    try {
      ConnectionDialog.show(context: context, loadingText: 'Hosting Game...');
      if (clubCode != null && clubCode.isNotEmpty) {
        gameCode = await GameService.configureClubGame(
          clubCode,
          gm,
        );
      } else {
        gameCode = await GameService.configurePlayerGame(gm);
      }
      appState.setNewGame(true);
      ConnectionDialog.dismiss(context: context);
    } catch (err) {
      ConnectionDialog.dismiss(context: context);
    }

    if (gameCode != null)
      _joinGame(context, gameCode);
    else
      showErrorDialog(context, 'Error', 'Creating game failed');
  }

  final ClubHomePageModel clubHomePageModel;
  final GameType mainGameType;
  final NewGameModel savedModel;

  NewGameSettings2(
    this.clubHomePageModel,
    this.mainGameType,
    this.savedModel,
  );

  static const sepV20 = const SizedBox(height: 20.0);
  static const sepV8 = const SizedBox(height: 8.0);
  static const sep12 = const SizedBox(height: 12.0);

  static const sepH10 = const SizedBox(width: 10.0);

  @override
  State<NewGameSettings2> createState() => _NewGameSettings2State();
}

class _NewGameSettings2State extends State<NewGameSettings2> {
  var playerCounts = [2, 4, 6, 8, 9];
  AppTextScreen appScreenText;
  NewGameModelProvider gameSettings;
  bool loading = false;
  @override
  void initState() {
    loading = true;
    appScreenText = getAppTextScreen("newGameSettings2");
    String clubCode = "";
    if (widget.clubHomePageModel != null) {
      clubCode = widget.clubHomePageModel.clubCode;
    }
    gameSettings = NewGameModelProvider(clubCode);
    gameSettings.gameType = widget.mainGameType;
    if (widget.mainGameType == GameType.DEALER_CHOICE) {
      gameSettings.settings.dealerChoiceGames.addAll([
        GameType.HOLDEM,
        GameType.PLO,
        GameType.PLO_HILO,
        GameType.FIVE_CARD_PLO,
        GameType.FIVE_CARD_PLO_HILO,
        GameType.SIX_CARD_PLO,
        GameType.SIX_CARD_PLO_HILO,
      ]);
    } else if (widget.mainGameType == GameType.ROE) {
      gameSettings.settings.roeGames.addAll([GameType.HOLDEM, GameType.PLO]);
    }
    determinePlayerCounts(gameSettings);
    loading = false;
    super.initState();
  }

  Widget _buildSeperator(AppTheme theme) => Container(
        color: theme.fillInColor,
        width: double.infinity,
        height: 1.0,
      );

  Widget _buildRadio({
    @required bool value,
    @required String label,
    @required void Function(bool v) onChange,
    @required AppTheme theme,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /* switch */
          SwitchWidget2(
            label: label,
            value: value,
            onChange: onChange,
          ),

          /* seperator */
          _buildSeperator(theme),
        ],
      );

  Widget _buildAnimatedSwitcher({
    Widget child,
  }) =>
      AnimatedSwitcher(
        transitionBuilder: (child, animation) => SizeTransition(
          sizeFactor: animation,
          child: child,
        ),
        duration: const Duration(milliseconds: 200),
        child: child,
      );

  Widget _buildBreakConfig(AppTheme theme, NewGameModelProvider gmp) {
    return DecoratedContainer2(
      theme: theme,
      children: [
        SwitchWidget2(
          value: gmp.breakAllowed,
          label: appScreenText['breakAllowed'],
          onChange: (bool value) {
            gmp.breakAllowed = value;
          },
        ),

        // break time
        Consumer<NewGameModelProvider>(
          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
            child: vnGmp.breakAllowed == false
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      LabelText(
                          label: appScreenText['maxBreakTime'], theme: theme),
                      RadioListWidget<int>(
                        defaultValue: gmp.breakTime,
                        values: NewGameConstants.BREAK_WAIT_TIMES,
                        onSelect: (int value) {
                          gmp.breakTime = value;
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuyinConfig(AppTheme theme, NewGameModelProvider gmp) {
    return DecoratedContainer(
      theme: theme,
      children: [
        Consumer<NewGameModelProvider>(builder: (_, vnGmp, __) {
          List<bool> isSelected = [];
          bool showCreditLimit = false;
          isSelected
              .add(gmp.buyInApprovalLimit == BuyInApprovalLimit.BUYIN_NO_LIMIT);

          List<Widget> toggleButtons = [];
          List<String> options = [];

          int defaultValue = 0;
          toggleButtons.add(Container(
              padding: EdgeInsets.all(10),
              child: Text('No Limit',
                  style: TextStyle(
                      color: gmp.buyInApprovalLimit ==
                              BuyInApprovalLimit.BUYIN_NO_LIMIT
                          ? Colors.black
                          : theme.accentColor))));

          if (gmp.buyInApprovalLimit == BuyInApprovalLimit.BUYIN_NO_LIMIT) {
            defaultValue = options.length;
          }
          options.add('No Limit');

          if (widget.clubHomePageModel != null &&
              widget.clubHomePageModel.trackMemberCredit) {
            showCreditLimit = true;
            if (gmp.buyInApprovalLimit ==
                BuyInApprovalLimit.BUYIN_CREDIT_LIMIT) {
              defaultValue = options.length;
            }
            options.add('Credit Limit');

            isSelected.add(gmp.buyInApprovalLimit ==
                BuyInApprovalLimit.BUYIN_CREDIT_LIMIT);
            toggleButtons.add(Container(
                padding: EdgeInsets.all(10),
                child: Text('Credit Limit',
                    style: TextStyle(
                        color: gmp.buyInApprovalLimit ==
                                BuyInApprovalLimit.BUYIN_CREDIT_LIMIT
                            ? Colors.black
                            : theme.accentColor))));
          }

          toggleButtons.add(Container(
              padding: EdgeInsets.all(10),
              child: Text('Host Approval',
                  style: TextStyle(
                      color: gmp.buyInApprovalLimit ==
                              BuyInApprovalLimit.BUYIN_HOST_APPROVAL
                          ? Colors.black
                          : theme.accentColor))));
          if (gmp.buyInApprovalLimit ==
              BuyInApprovalLimit.BUYIN_HOST_APPROVAL) {
            defaultValue = options.length;
          }
          options.add('Host Approval');

          isSelected.add(
              gmp.buyInApprovalLimit == BuyInApprovalLimit.BUYIN_HOST_APPROVAL);

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelText(label: 'Buyin Limit', theme: theme),
              RadioToggleButtonsWidget<String>(
                // children: toggleButtons,
                // isSelected: isSelected,
                // borderColor: theme.accentColor,
                // borderRadius: BorderRadius.all(Radius.circular(25)),
                // selectedColor: Colors.black,
                // fillColor: theme.accentColor,
                values: options,
                defaultValue: defaultValue,
                onSelect: (int index) {
                  if (index == 0) {
                    gmp.buyInApprovalLimit = BuyInApprovalLimit.BUYIN_NO_LIMIT;
                  } else if (index == 1) {
                    if (showCreditLimit) {
                      gmp.buyInApprovalLimit =
                          BuyInApprovalLimit.BUYIN_CREDIT_LIMIT;
                    } else {
                      gmp.buyInApprovalLimit =
                          BuyInApprovalLimit.BUYIN_HOST_APPROVAL;
                    }
                  } else if (index == 2) {
                    gmp.buyInApprovalLimit =
                        BuyInApprovalLimit.BUYIN_HOST_APPROVAL;
                  }
                },
              ),
              // RadioListWidget<String>(
              //   defaultValue: gmp.buyInApprovalLimit.toJson(),
              //   values: NewGameConstants.BUYIN_LIMIT_CHOICES,
              //   onSelect: (String value) {
              //     gmp.buyInApprovalLimit = BuyInApprovalLimitSerialization.fromJson(value);
              //   },
              // ),
            ],
          );
        }),

        // buy in wait time
        Consumer<NewGameModelProvider>(
          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
            child: vnGmp.buyInApprovalLimit ==
                    BuyInApprovalLimit.BUYIN_HOST_APPROVAL
                ? Column(
                    children: [
                      LabelText(
                          label: appScreenText['buyinMaxTime'], theme: theme),
                      RadioListWidget<int>(
                        defaultValue: gmp.buyInWaitTime,
                        values: NewGameConstants.BUYIN_WAIT_TIMES,
                        onSelect: (int value) {
                          gmp.buyInWaitTime = value;
                        },
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonStraddleConfig(AppTheme theme, NewGameModelProvider gmp) {
    return DecoratedContainer2(
      theme: theme,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: SwitchWidget2(
            value: gmp.buttonStraddle,
            label: 'Button Straddle', //_appScreenText['BUYINGAPPROVAL'],
            onChange: (bool value) {
              gmp.buttonStraddle = value;
            },
          ),
        ),

        // buy in wait time
        Consumer<NewGameModelProvider>(
          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
            child: vnGmp.buttonStraddle == false
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: LabelText(
                                label: 'Straddle Max Bet (x BB)',
                                theme: theme)),
                        Text(
                          vnGmp.buttonStraddleBetAmount.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Slider(
                          value: vnGmp.buttonStraddleBetAmount.toDouble(),
                          //thumbColor: theme.accentColor,
                          activeColor: theme.secondaryColor,
                          inactiveColor: theme.primaryColorWithDark(),
                          min: 2,
                          max: 10,
                          divisions: 8,
                          label:
                              vnGmp.buttonStraddleBetAmount.round().toString(),
                          onChanged: (double value) {
                            vnGmp.buttonStraddleBetAmount = value.toInt();
                          },
                        )
                      ],
                    )),
          ),
        ),
      ],
    );
  }

  Widget _buildBombPotConfig(AppTheme theme, NewGameModelProvider gmp) {
    GameType gameType = gmp.settings.gameType;
    if (gmp.settings.gameType == GameType.ROE) {
      if (gmp.settings.roeGames.length == 0) {
        gameType = GameType.PLO;
      } else {
        gameType = gmp.settings.roeGames[0];
      }
    }
    if (gmp.settings.gameType == GameType.DEALER_CHOICE) {
      if (gmp.settings.dealerChoiceGames.length == 0) {
        gameType = GameType.PLO;
      } else {
        gameType = gmp.settings.dealerChoiceGames[0];
      }
    }

    String bombPotDefaultValue = 'PLO';
    if (gameType == GameType.HOLDEM) {
      bombPotDefaultValue = 'NLH';
    } else if (gameType == GameType.PLO) {
      bombPotDefaultValue = 'PLO';
    } else if (gameType == GameType.FIVE_CARD_PLO) {
      bombPotDefaultValue = '5 Card PLO';
    } else if (gameType == GameType.PLO_HILO) {
      bombPotDefaultValue = 'Hi-Lo';
    } else if (gameType == GameType.FIVE_CARD_PLO_HILO) {
      bombPotDefaultValue = '5 Card Hi-Lo';
    }

    return DecoratedContainer2(
      theme: theme,
      children: [
        SwitchWidget2(
          value: gmp.bombPotEnabled,
          label: appScreenText['bombPotEnabled'],
          onChange: (bool value) {
            gmp.bombPotEnabled = value;
          },
        ),

        // bomb pot interval
        Consumer<NewGameModelProvider>(
          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
            child: vnGmp.bombPotEnabled == false
                ? const SizedBox.shrink()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LabelText(label: 'Interval', theme: theme),
                            RadioToggleButtonsWidget<String>(
                              defaultValue: gmp.bombPotIntervalType ==
                                      BombPotIntervalType.TIME_INTERVAL
                                  ? 0
                                  : 1,
                              values: ['Time', 'Hands'],
                              onSelect: (val) {
                                gmp.bombPotIntervalType = val == 0
                                    ? BombPotIntervalType.TIME_INTERVAL
                                    : BombPotIntervalType.EVERY_X_HANDS;
                              },
                            )
                          ]),
                      Visibility(
                        visible: gmp.bombPotIntervalType ==
                            BombPotIntervalType.TIME_INTERVAL,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LabelText(
                                  label: appScreenText['bombPotInterval'],
                                  theme: theme),
                              RadioListWidget<int>(
                                defaultValue: gmp.bombPotInterval,
                                values: NewGameConstants.BOMB_POT_INTERVALS,
                                onSelect: (int value) {
                                  gmp.bombPotInterval = value;
                                },
                              )
                            ]),
                      ),
                      Visibility(
                        visible: gmp.bombPotIntervalType ==
                            BombPotIntervalType.EVERY_X_HANDS,
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabelText(
                                    label:
                                        'Bomb Pot: In every ${gmp.bombPotHandInterval} hands',
                                    theme: theme),
                              ]),
                          PokerSlider(
                            theme: theme,
                            defaultValue: gmp.bombPotHandInterval.toDouble(),
                            min: 1,
                            max: 100,
                            onDragCompleted: (val) {
                              gmp.bombPotHandInterval = val;
                            },
                            onDragging: (val) {
                              gmp.bombPotHandInterval = val;
                            },
                          ),
                        ]),
                      ),
                      NewGameSettings2.sepV8,
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // bomb pot bet
                            LabelText(
                                label: appScreenText['bombPotBet'],
                                theme: theme),

                            RadioListWidget<int>(
                              defaultValue: gmp.bombPotBet,
                              values: NewGameConstants.BOMB_POT_BET_SIZE,
                              onSelect: (int value) {
                                gmp.bombPotBet = value;
                              },
                            )
                          ]),
                      NewGameSettings2.sepV8,
                      LabelText(label: 'Game Type', theme: theme),
                      RadioToggleButtonsWidget<String>(
                        defaultValue: gmp.selectedBombPotGameType,
                        //wrap: true,
                        values: NewGameConstants.BOMB_POT_GAME_TYPES,
                        onSelect: (val) {
                          String value =
                              NewGameConstants.BOMB_POT_GAME_TYPES[val];
                          if (value == 'NLH') {
                            gmp.settings.bombPotGameType = GameType.HOLDEM;
                          } else if (value == 'PLO') {
                            gmp.settings.bombPotGameType = GameType.PLO;
                          } else if (value == 'Hi-Lo') {
                            gmp.settings.bombPotGameType = GameType.PLO_HILO;
                          } else if (value == '5 Card PLO') {
                            gmp.settings.bombPotGameType =
                                GameType.FIVE_CARD_PLO;
                          } else if (value == '5 Card\nHi-Lo') {
                            gmp.settings.bombPotGameType =
                                GameType.FIVE_CARD_PLO_HILO;
                          } else if (value == '6 Card') {
                            gmp.settings.bombPotGameType =
                                GameType.SIX_CARD_PLO;
                          } else if (value == '6 Card\nHi-Lo') {
                            gmp.settings.bombPotGameType =
                                GameType.SIX_CARD_PLO_HILO;
                          }
                        },
                      ),
                      NewGameSettings2.sepV8,
                      SwitchWidget2(
                        value: gmp.doubleBoardBombPot,
                        label:
                            'Double Board', //_appScreenText['doubleBoardBombPot'],
                        onChange: (bool value) {
                          gmp.doubleBoardBombPot = value;
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void determinePlayerCounts(NewGameModelProvider gmp) {
    int maxPlayers = 9;
    playerCounts = [2, 4, 6, 8, 9];

    if (widget.mainGameType == GameType.ROE) {
      if (gmp.settings.roeGames.contains(GameType.FIVE_CARD_PLO) ||
          gmp.settings.roeGames.contains(GameType.FIVE_CARD_PLO_HILO)) {
        maxPlayers = 8;
      }
      if (gmp.settings.roeGames.contains(GameType.SIX_CARD_PLO) ||
          gmp.settings.roeGames.contains(GameType.SIX_CARD_PLO_HILO)) {
        maxPlayers = 6;
      }
    }
    if (widget.mainGameType == GameType.DEALER_CHOICE) {
      if (gmp.settings.dealerChoiceGames.contains(GameType.FIVE_CARD_PLO) ||
          gmp.settings.dealerChoiceGames
              .contains(GameType.FIVE_CARD_PLO_HILO)) {
        maxPlayers = 8;
      }
      if (gmp.settings.dealerChoiceGames.contains(GameType.SIX_CARD_PLO) ||
          gmp.settings.dealerChoiceGames.contains(GameType.SIX_CARD_PLO_HILO)) {
        maxPlayers = 6;
      }
    }
    if (gmp.gameType == GameType.FIVE_CARD_PLO ||
        gmp.gameType == GameType.FIVE_CARD_PLO_HILO) {
      maxPlayers = 8;
    }
    if (gmp.gameType == GameType.SIX_CARD_PLO ||
        gmp.gameType == GameType.SIX_CARD_PLO_HILO) {
      maxPlayers = 6;
    }
    if (maxPlayers == 8) {
      playerCounts = [2, 4, 6, 8];
    }
    if (maxPlayers == 6) {
      playerCounts = [2, 4, 6];
    }

    gmp.maxPlayers = maxPlayers;
    gmp.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    log('NewGameSettings: build 1');
    if (loading) {
      return Container();
    }
    return ListenableProvider<NewGameModelProvider>(
      create: (_) => gameSettings,
      builder: (BuildContext context, _) {
        final NewGameModelProvider gmp = context.read<NewGameModelProvider>();
        log('NewGameSettings: build 2');
        if (widget.clubHomePageModel != null) {
          gmp.settings.showResultOption =
              widget.clubHomePageModel.showGameResult;
          if (!gmp.settings.showResultOption) {
            gmp.showResult = false;
          }
        }

        // Load default values if it is not from Saved Settings.
        if (widget.savedModel == null) {
          // Initializing values
          // Initial value for BigBlind
          gmp.bigBlind = 2.0;
          // Initial value for Buyin Min and max
          gmp.buyInMin = 30;
          gmp.buyInMax = 100;
          gmp.rakePercentage = 0;
          gmp.rakeCap = 0;
          gmp.buyInWaitTime = 120;
        } else {
          gmp.bigBlind = widget.savedModel.bigBlind;
          gmp.settings = widget.savedModel;
        }
        gmp.notify = true;

        List<String> orbitChoices = ["Orbit", "Button"];

        return Consumer<NewGameModelProvider>(builder: (_, __, ___) {
          return Container(
            // decoration: AppDecorators.bgRadialGradient(theme).copyWith(
            //   border: Border.all(
            //     color: theme.secondaryColorWithDark(),
            //     width: 2,
            //   ),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            constraints: BoxConstraints(maxWidth: AppDimensionsNew.maxWidth),
            decoration:
                BoxDecoration(color: theme.secondaryColorWithDark(0.40)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleImageButton(
                      onTap: () async {
                        await onSaveSettings(context, theme, gmp);
                      },
                      icon: Icons.save,
                      theme: theme,
                    ),
                    /* HEADING */
                    Expanded(
                      child: HeadingWidget(
                        heading: appScreenText['gameSettings'],
                      ),
                    ),
                    CircleImageButton(
                      onTap: () {
                        gmp.cancelled = true;
                        Navigator.pop(context, null);
                      },
                      theme: theme,
                      icon: Icons.close,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration:
                        AppDecorators.tileDecorationWithoutBorder(theme),
                    child: Scrollbar(
                      thickness: PlatformUtils.isWeb ? 5 : 1,
                      isAlwaysShown: true,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(right: 10),
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /* game types */
                          (widget.mainGameType == GameType.PLO)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //_buildLabel('Choose Type', theme),
                                    RadioListWidget<String>(
                                      defaultValue: 'PLO',
                                      wrap: true,
                                      values: [
                                        'PLO',
                                        'Hi-Lo',
                                        '5 Card',
                                        '5 Card Hi-Lo',
                                        '6 Card',
                                        '6 Card Hi-Lo',
                                      ],
                                      onSelect: (String value) {
                                        if (value == 'PLO') {
                                          gmp.settings.gameType = GameType.PLO;
                                        } else if (value == 'Hi-Lo') {
                                          gmp.settings.gameType =
                                              GameType.PLO_HILO;
                                        } else if (value == '5 Card') {
                                          gmp.settings.gameType =
                                              GameType.FIVE_CARD_PLO;
                                        } else if (value == '5 Card Hi-Lo') {
                                          gmp.settings.gameType =
                                              GameType.FIVE_CARD_PLO_HILO;
                                        } else if (value == '6 Card') {
                                          gmp.settings.gameType =
                                              GameType.SIX_CARD_PLO;
                                        } else if (value == '6 Card Hi-Lo') {
                                          gmp.settings.gameType =
                                              GameType.SIX_CARD_PLO_HILO;
                                        }
                                        determinePlayerCounts(gmp);
                                        //setState(() {});
                                      },
                                    ),
                                    NewGameSettings2.sepV20
                                  ],
                                )
                              : Container(),
                          (widget.mainGameType == GameType.ROE ||
                                  widget.mainGameType == GameType.DEALER_CHOICE)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.mainGameType ==
                                            GameType.DEALER_CHOICE
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LabelText(
                                                  label: 'Dealer Choice',
                                                  theme: theme),
                                              Consumer<NewGameModelProvider>(
                                                builder: (_, vnGmp, __) {
                                                  return RadioToggleButtonsWidget<
                                                          String>(
                                                      values: orbitChoices,
                                                      defaultValue:
                                                          gmp.dealerChoiceOrbit
                                                              ? 0
                                                              : 1,
                                                      onSelect: (value) {
                                                        if (value == 1) {
                                                          gmp.dealerChoiceOrbit =
                                                              false;
                                                        } else {
                                                          gmp.dealerChoiceOrbit =
                                                              true;
                                                        }
                                                      });
                                                },
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    NewGameSettings2.sepV20,
                                    LabelText(
                                        label: 'Choose Games', theme: theme),
                                    MultiGameSelection([
                                      GameType.HOLDEM,
                                      GameType.PLO,
                                      GameType.PLO_HILO,
                                      GameType.FIVE_CARD_PLO,
                                      GameType.FIVE_CARD_PLO_HILO,
                                      GameType.SIX_CARD_PLO,
                                      GameType.SIX_CARD_PLO_HILO,
                                    ], onSelect: (games) {
                                      if (widget.mainGameType == GameType.ROE) {
                                        gmp.settings.roeGames.addAll(games);
                                      } else {
                                        gmp.settings.dealerChoiceGames
                                            .addAll(games);
                                      }
                                      determinePlayerCounts(gmp);
                                    }, onRemove: (game) {
                                      if (widget.mainGameType == GameType.ROE) {
                                        gmp.settings.roeGames.remove(game);
                                      } else {
                                        gmp.settings.dealerChoiceGames
                                            .remove(game);
                                      }
                                      determinePlayerCounts(gmp);
                                    },
                                        existingChoices: widget.mainGameType ==
                                                GameType.ROE
                                            ? gmp.settings.roeGames
                                            : gmp.settings.dealerChoiceGames),
                                    NewGameSettings2.sepV20
                                  ],
                                )
                              : Container(),
                          /* players */
                          NewGameSettings2.sep12,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  flex: 3,
                                  child: LabelText(
                                      label: 'Players', theme: theme)),
                              Flexible(
                                  flex: 7,
                                  child: RadioListWidget<int>(
                                      key: UniqueKey(),
                                      defaultValue: gmp.maxPlayers,
                                      values: playerCounts,
                                      onSelect: (int value) {
                                        gmp.maxPlayers = value;
                                      }))
                            ],
                          ),

                          /* chip unit */
                          NewGameSettings2.sep12,
                          Consumer<NewGameModelProvider>(
                            builder: (_, vnGmp, __) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: LabelText(
                                          label: 'Chip Unit', theme: theme)),
                                  Flexible(
                                    flex: 7,
                                    child: Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RadioToggleButtonsWidget<String>(
                                            onSelect: (int index) {
                                              if (index == 0) {
                                                gmp.chipUnit = ChipUnit.DOLLAR;
                                              } else {
                                                gmp.chipUnit = ChipUnit.CENT;
                                              }
                                            },
                                            defaultValue:
                                                gmp.chipUnit == ChipUnit.DOLLAR
                                                    ? 0
                                                    : 1,
                                            values: [
                                              '1',
                                              '.01',
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          /* big blind & ante */
                          NewGameSettings2.sepV8,
                          Consumer<NewGameModelProvider>(
                              builder: (_, vnGmp, __) {
                            double minValue = 2;
                            double maxValue = 10000000;
                            if (gmp.chipUnit == ChipUnit.CENT) {
                              minValue = 0.1;
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: LabelText(
                                    label: 'Big Blind',
                                    theme: theme,
                                  ),
                                ),
                                /* big blind */

                                Flexible(
                                  flex: 7,
                                  child: TextInputWidget(
                                    value: gmp.bigBlind,
                                    decimalAllowed:
                                        gmp.chipUnit == ChipUnit.CENT,
                                    //label: 'BB', //appScreenText['bigBlind'],
                                    minValue: minValue,
                                    maxValue: maxValue,
                                    evenNumber: true,
                                    title: appScreenText['enterBigBlind'],
                                    onChange: (value) {
                                      //gmp.blinds.bigBlind = value.toDouble();
                                      gmp.bigBlind = value.toDouble();
                                    },
                                  ),
                                ),
                                // Expanded(
                                //   flex: 4,
                                //   child: SizedBox(width: 30),
                                // )
                              ],
                            );
                          }),
                          NewGameSettings2.sepV8,
                          Consumer<NewGameModelProvider>(
                              builder: (_, vnGmp, __) {
                            double minValue = 2;
                            double maxValue = 10000000;
                            if (gmp.chipUnit == ChipUnit.CENT) {
                              minValue = 0.1;
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child:
                                        LabelText(label: 'Ante', theme: theme)),
                                /* big blind */
                                Flexible(
                                  flex: 7,
                                  child: TextInputWidget(
                                    value: gmp.ante,
                                    decimalAllowed:
                                        gmp.chipUnit == ChipUnit.CENT,
                                    minValue: 0,
                                    maxValue: gmp.bigBlind,
                                    evenNumber: true,
                                    title: 'Enter Ante',
                                    onChange: (value) {
                                      //gmp.blinds.bigBlind = value.toDouble();
                                      gmp.ante = value.toDouble();
                                    },
                                  ),
                                ),
                                // Expanded(
                                //   flex: 4,
                                //   child: SizedBox(width: 30),
                                // )
                              ],
                            );
                          }),
                          /* buyin */
                          NewGameSettings2.sepV8,
                          Consumer<NewGameModelProvider>(
                            builder: (_, vnGmp, __) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: LabelText(
                                        label:
                                            'Buyin Range (xBB)', //appScreenText['buyin'],
                                        theme: theme),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: TextInputWidget(
                                            value: gmp.buyInMin.toDouble(),
                                            small: true,
                                            //label: appScreenText['min'],
                                            trailing: '', //appScreenText['bb'],
                                            title:
                                                appScreenText['enterMinBuyin'],
                                            minValue: 0,
                                            maxValue: 2000,
                                            onChange: (value) {
                                              gmp.buyInMin = value.floor();

                                              if (gmp.buyInMax <=
                                                  value.floor()) {
                                                gmp.buyInMax =
                                                    gmp.buyInMin + 10;
                                              }
                                            },
                                          ),
                                        ),
                                        NewGameSettings2.sepH10,
                                        Text('-'),
                                        NewGameSettings2.sepH10,
                                        Flexible(
                                          flex: 3,
                                          child: TextInputWidget(
                                            key: UniqueKey(),
                                            value: gmp.buyInMax.toDouble(),
                                            small: true,
                                            title:
                                                appScreenText['enterMaxBuyin'],
                                            trailing:
                                                '', // appScreenText['bb'],
                                            minValue:
                                                gmp.buyInMin.toDouble() + 1,
                                            maxValue:
                                                10 * gmp.buyInMin.toDouble(),
                                            onChange: (value) {
                                              gmp.buyInMax = value.floor();
                                              if (gmp.buyInMin >=
                                                  value.floor()) {
                                                Alerts.showNotification(
                                                    titleText:
                                                        'Max buyin should be more than min buyin',
                                                    duration:
                                                        Duration(seconds: 5));
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Consumer<NewGameModelProvider>(
                              builder: (_, vnGmp, __) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: LabelText(
                                        label: '', //appScreenText['buyin'],
                                        theme: theme)),
                                Flexible(
                                  flex: 7,
                                  child: Text(
                                    '(${DataFormatter.chipsFormat(gmp.buyInMin * gmp.bigBlind)} - ${DataFormatter.chipsFormat(gmp.buyInMax * gmp.bigBlind)})',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }),
                          /* tips */
                          NewGameSettings2.sepV8,
                          Consumer<NewGameModelProvider>(
                            builder: (_, vnGmp, __) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: LabelText(
                                          label: 'Tips', theme: theme)),
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: TextInputWidget(
                                            value: gmp.rakePercentage,
                                            small: true,
                                            //label: appScreenText['min'],
                                            trailing:
                                                '%', //appScreenText['bb'],
                                            title: appScreenText["tipsPercent"],
                                            minValue: 0,
                                            maxValue: 50,
                                            decimalAllowed:
                                                gmp.chipUnit == ChipUnit.CENT,
                                            onChange: (value) {
                                              gmp.rakePercentage = value;
                                            },
                                          ),
                                        ),
                                        NewGameSettings2.sepH10,
                                        Text('Cap:'),
                                        NewGameSettings2.sepH10,
                                        Flexible(
                                          flex: 3,
                                          child: TextInputWidget(
                                            key: UniqueKey(),
                                            value: gmp.rakeCap,
                                            small: true,
                                            decimalAllowed:
                                                gmp.chipUnit == ChipUnit.CENT,
                                            title: appScreenText['maxTips'],
                                            trailing:
                                                '', // appScreenText['bb'],
                                            minValue: 0,
                                            maxValue: -1,
                                            onChange: (value) {
                                              gmp.rakeCap = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          /* action time */
                          NewGameSettings2.sepV8,
                          Consumer<NewGameModelProvider>(
                            builder: (_, vnGmp, __) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: LabelText(
                                          label: appScreenText['actionTime'],
                                          theme: theme)),
                                  Flexible(
                                    flex: 7,
                                    child: RadioListWidget<int>(
                                      defaultValue: gmp.actionTime,
                                      values: NewGameConstants.ACTION_TIMES,
                                      onSelect: (int value) {
                                        gmp.actionTime = value;
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          /* game time */
                          NewGameSettings2.sepV8,
                          Consumer<NewGameModelProvider>(
                            builder: (_, vnGmp, __) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: LabelText(
                                        label: appScreenText['gameTime'],
                                        theme: theme),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: RadioListWidget<int>(
                                      defaultValue: gmp.gameLengthInMins ~/ 60,
                                      values: NewGameConstants.GAME_LENGTH,
                                      onSelect: (int value) {
                                        gmp.gameLengthInMins = value * 60;
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          /* sep */
                          NewGameSettings2.sepV8,

                          /* UTG straddle */
                          _buildRadio(
                            label: appScreenText['utgStraddle'],
                            value: gmp.straddleAllowed,
                            onChange: (bool b) {
                              gmp.straddleAllowed = b;
                            },
                            theme: theme,
                          ),
                          NewGameSettings2.sepV8,
                          _buildButtonStraddleConfig(theme, gmp),
                          NewGameSettings2.sepV8,

                          /* allow run it twice */
                          _buildRadio(
                            label: appScreenText['allowRunItTwice'],
                            value: gmp.runItTwice,
                            onChange: (bool b) {
                              gmp.runItTwice = b;
                            },
                            theme: theme,
                          ),
                          /* sep */
                          NewGameSettings2.sepV8,
                          /* allow audio conference */
                          _buildRadio(
                            label: appScreenText['useAudioConf'],
                            value: gmp.audioConference,
                            onChange: (bool b) {
                              gmp.audioConference = b;
                            },
                            theme: theme,
                          ),
                          /* sep */
                          NewGameSettings2.sepV8,

                          /* Highhand Tracked */
                          _buildRadio(
                            label: appScreenText['hhTracked'],
                            value: gmp.highHandTracked,
                            onChange: (bool b) {
                              gmp.highHandTracked = b;
                            },
                            theme: theme,
                          ),
                          NewGameSettings2.sepV8,
                          _buildBuyinConfig(theme, gmp),
                          ExpansionTile(
                            iconColor: theme.accentColor,
                            collapsedIconColor: theme.accentColor,
                            subtitle: Text(appScreenText['chooseAdvanceConfig'],
                                style: AppDecorators.getHeadLine6Style(
                                    theme: theme)),
                            title: Text(
                                'More Settings', //_appScreenText['advanceConfig'],
                                style: AppDecorators.getHeadLine4Style(
                                    theme: theme)),
                            children: [
                              _buildBreakConfig(theme, gmp),
                              NewGameSettings2.sepV8,
                              _buildBombPotConfig(theme, gmp),

                              /* sep */
                              NewGameSettings2.sepV8,
                              _buildRadio(
                                label: appScreenText['botGame'],
                                value: gmp.botGame,
                                onChange: (bool b) {
                                  gmp.botGame = b;
                                },
                                theme: theme,
                              ),
                              /* location check */
                              _buildRadio(
                                label: appScreenText['locationCheck'],
                                value: gmp.locationCheck,
                                onChange: (bool b) {
                                  gmp.locationCheck = b;
                                },
                                theme: theme,
                              ),

                              /* ip check */
                              _buildRadio(
                                label: appScreenText['ipCheck'],
                                value: gmp.ipCheck,
                                onChange: (bool b) {
                                  gmp.ipCheck = b;
                                },
                                theme: theme,
                              ),

                              /* waitlist */
                              _buildRadio(
                                label: appScreenText['waitlist'],
                                value: gmp.waitList,
                                onChange: (bool b) {
                                  gmp.waitList = b;
                                },
                                theme: theme,
                              ),

                              /* seat change allowed */
                              _buildRadio(
                                label: appScreenText['seatChangeAllowed'],
                                value: gmp.seatChangeAllowed,
                                onChange: (bool b) {
                                  gmp.seatChangeAllowed = b;
                                },
                                theme: theme,
                              ),

                              /* allow fun animations */
                              _buildRadio(
                                label: appScreenText['allowFunAnimation'],
                                theme: theme,
                                value: gmp.allowFunAnimations,
                                onChange: (bool b) {
                                  gmp.allowFunAnimations = b;
                                },
                              ),

                              /* allow run it twice */
                              // _buildRadio(
                              //   label: _appScreenText['muckLosingHand'],
                              //   value: gmp.muckLosingHand,
                              //   onChange: (bool b) {
                              //     gmp.muckLosingHand = b;
                              //   },
                              //   theme: theme,
                              // ),

                              // /* show player buyin */
                              // _buildRadio(
                              //   label: _appScreenText['showPlayerBuyin'],
                              //   value: gmp.showPlayerBuyin,
                              //   onChange: (bool b) {
                              //     gmp.showPlayerBuyin = b;
                              //   },
                              //   theme: theme,
                              // ),

                              /* allow rabbit hunt */
                              _buildRadio(
                                label: appScreenText['allowRabbitHunt'],
                                value: gmp.allowRabbitHunt,
                                onChange: (bool b) {
                                  gmp.allowRabbitHunt = b;
                                },
                                theme: theme,
                              ),

                              /* show hand rank */
                              _buildRadio(
                                label: appScreenText['showHandRank'],
                                value: gmp.showHandRank,
                                onChange: (bool b) {
                                  gmp.showHandRank = b;
                                },
                                theme: theme,
                              ),

                              /* show table result */
                              Visibility(
                                visible: gmp.showResultOption,
                                child: _buildRadio(
                                  label: appScreenText['showResult'],
                                  value: gmp.showResult,
                                  onChange: (bool b) {
                                    gmp.showResult = b;
                                  },
                                  theme: theme,
                                ),
                              ),
                            ],
                          ),
                          NewGameSettings2.sepV8,
                          Visibility(
                            visible: false, // service fee is not shown for v1
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabelText(
                                    label: appScreenText['serviceFee'],
                                    theme: theme),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LabelText(label: "10", theme: theme),
                                    Image.asset(
                                      'assets/images/appcoin.png',
                                      height: 16.pw,
                                      width: 16.pw,
                                    ),
                                    LabelText(
                                        label: "coins/hour", theme: theme),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          NewGameSettings2.sep12,

                          /* start button */
                          /* sep */
                          NewGameSettings2.sepV8,
                          NewGameSettings2.sepV8,
                          Column(

                              ///alignment: Alignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '*Audio Beta: This feature may or may not be available in future versions',
                                    style: AppDecorators.getHeadLine6Style(
                                        theme: theme)),
                                Text(
                                    '*High-hand: Tracks high hand occurred in the entire game',
                                    style: AppDecorators.getHeadLine6Style(
                                        theme: theme)),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
                NewGameSettings2.sep12,
                Row(
                  //alignment: Alignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(
                      text: appScreenText['start'],
                      onTap: () {
                        if (gmp.buyInMax < gmp.buyInMin) {
                          Alerts.showNotification(
                            titleText: appScreenText['gameCreationFailed'],
                            subTitleText: appScreenText['checkBuyinRange'],
                            duration: Duration(seconds: 5),
                          );
                          return;
                        } else {
                          Navigator.pop(context, gmp);
                        }
                      },
                    ),
                    // CircleImageButton(
                    //   onTap: () async {
                    //     await onSaveSettings(context, theme, gmp);
                    //   },
                    //   icon: Icons.save,
                    //   theme: theme,
                    // ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> onSaveSettings(
      BuildContext context, AppTheme theme, NewGameModelProvider gmp) async {
    String gameType = gameTypeShortStr(gmp.gameType);
    String blinds =
        '${DataFormatter.chipsFormat(gmp.smallBlind)}/${DataFormatter.chipsFormat(gmp.bigBlind)}';
    String maxPlayers = '${gmp.maxPlayers}';
    String title = '$gameType-$blinds-$maxPlayers';
    final keys = appService.gameTemplates.getSettings();
    bool found = keys.indexOf(title) != -1;
    if (found) {
      // add a suffix to get a new name
      for (int i = 0; i < 100; i++) {
        String titleTmp = '$title-$i';
        if (keys.indexOf(title) == -1) {
          title = titleTmp;
          break;
        }
      }
    }

    // Setting default name for settings with timestamp
    String defaultText = title;
    TextEditingController _controller =
        TextEditingController(text: defaultText);
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.fillInColor,
        title: Text(
          appScreenText['saveSettings'],
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              theme: theme,
              controller: _controller,
              maxLines: 1,
              hintText: appScreenText['enterText'],
            ),
            AppDimensionsNew.getVerticalSizedBox(12),
            RoundRectButton(
              text: appScreenText['save'],
              theme: theme,
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.of(context).pop(_controller.text);
                }
              },
            ),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      log(jsonEncode(gmp.settings.toJson()));
      await appService.gameTemplates.save(result, gmp.settings.toJson());
    }
  }

  Widget gameTypesList(AppTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.accentColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(8),
      child: Center(child: Text("PLO")),
    );
  }
}
