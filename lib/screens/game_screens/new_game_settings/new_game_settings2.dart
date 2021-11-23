import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/child_widgets.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../../main_helper.dart';
import '../../../routes.dart';

class NewGameSettings2 extends StatelessWidget {
  static AppTextScreen _appScreenText;

  static void _joinGame(BuildContext context, String gameCode) =>
      navigatorKey.currentState.pushNamed(
        Routes.game_play,
        arguments: gameCode,
      );

  static Future<void> show(
    BuildContext context, {
    @required String clubCode,
    @required GameType mainGameType,
    @required List<GameType> subGameTypes,
    NewGameModel savedModel,
  }) async {
    NewGameModelProvider gmp = await showDialog<NewGameModelProvider>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: NewGameSettings2(
          clubCode,
          mainGameType,
          subGameTypes,
          savedModel,
        ),
      ),
    );

    if (gmp == null) return;

    /* otherwise, start tha game */
    final NewGameModel gm = gmp.settings;

    gm.gameType = mainGameType;
    gm.roeGames = subGameTypes;
    gm.dealerChoiceGames = subGameTypes;

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
      Provider.of<AppState>(context, listen: false).setNewGame(true);
      ConnectionDialog.dismiss(context: context);
    } catch (err) {
      ConnectionDialog.dismiss(context: context);
    }

    if (gameCode != null)
      _joinGame(context, gameCode);
    else
      showErrorDialog(
          context, _appScreenText['error'], _appScreenText['createGameFailed']);
  }

  final String clubCode;
  final GameType mainGameType;
  final List<GameType> subGameTypes;
  final NewGameModel savedModel;
  NewGameSettings2(
    this.clubCode,
    this.mainGameType,
    this.subGameTypes,
    this.savedModel,
  );

  Widget _buildLabel(String label, AppTheme theme) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          label,
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
      );

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
          SwitchWidget(
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

  static const sepV20 = const SizedBox(height: 20.0);
  static const sepV8 = const SizedBox(height: 8.0);

  static const sepH10 = const SizedBox(width: 10.0);

  Widget _buildBreakConfig(AppTheme theme, NewGameModelProvider gmp) {
    return DecoratedContainer(
      theme: theme,
      children: [
        SwitchWidget(
          value: gmp.breakAllowed,
          label: _appScreenText['breakAllowed'],
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
                      _buildLabel(_appScreenText['maxBreakTime'], theme),
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
        SwitchWidget(
          value: gmp.buyInApproval,
          label: _appScreenText['buyinApproval'],
          onChange: (bool value) {
            gmp.buyInApproval = value;
          },
        ),

        // buy in wait time
        Consumer<NewGameModelProvider>(
          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
            child: vnGmp.buyInApproval == false
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      _buildLabel(_appScreenText['buyinMaxTime'], theme),
                      RadioListWidget<int>(
                        defaultValue: gmp.buyInWaitTime,
                        values: NewGameConstants.BUYIN_WAIT_TIMES,
                        onSelect: (int value) {
                          gmp.buyInWaitTime = value;
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonStraddleConfig(AppTheme theme, NewGameModelProvider gmp) {
    return DecoratedContainer(
      theme: theme,
      children: [
        SwitchWidget(
          value: gmp.buttonStraddle,
          label: 'Button Straddle', //_appScreenText['BUYINGAPPROVAL'],
          onChange: (bool value) {
            gmp.buttonStraddle = value;
          },
        ),

        // buy in wait time
        Consumer<NewGameModelProvider>(
          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
            child: vnGmp.buttonStraddle == false
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: _buildLabel('Straddle Max Bet (x BB)', theme)),
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
                        label: vnGmp.buttonStraddleBetAmount.round().toString(),
                        onChanged: (double value) {
                          vnGmp.buttonStraddleBetAmount = value.toInt();
                        },
                      )
                      // RadioListWidget(
                      //   defaultValue: gmp.buyInWaitTime,
                      //   values: NewGameConstants.BUYIN_WAIT_TIMES,
                      //   onSelect: (int value) {
                      //     gmp.buyInWaitTime = value;
                      //   },
                      // ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBombPotConfig(AppTheme theme, NewGameModelProvider gmp) {
    return DecoratedContainer(
      theme: theme,
      children: [
        SwitchWidget(
          value: gmp.bombPotEnabled,
          label: _appScreenText['bombPotEnabled'],
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
                      // bomb pot bet
                      _buildLabel(_appScreenText['bombPotBet'], theme),

                      RadioListWidget<int>(
                        defaultValue: gmp.bombPotBet,
                        values: NewGameConstants.BOMB_POT_BET_SIZE,
                        onSelect: (int value) {
                          gmp.bombPotBet = value;
                        },
                      ),
                      _buildLabel(_appScreenText['bombPotInterval'], theme),
                      RadioListWidget<int>(
                        defaultValue: gmp.bombPotInterval,
                        values: NewGameConstants.BOMB_POT_INTERVALS,
                        onSelect: (int value) {
                          gmp.bombPotInterval = value;
                        },
                      ),
                      sepV20,

                      SwitchWidget(
                        value: gmp.doubleBoardBombPot,
                        label: _appScreenText['doubleBoardBombPot'],
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

  @override
  Widget build(BuildContext context) {
    _appScreenText = getAppTextScreen("newGameSettings2");
    final theme = AppTheme.getTheme(context);
    return ListenableProvider<NewGameModelProvider>(
      create: (_) => NewGameModelProvider(clubCode),
      builder: (BuildContext context, _) {
        final NewGameModelProvider gmp = context.read<NewGameModelProvider>();

        gmp.gameType = mainGameType;
        if (mainGameType == GameType.ROE) {
          gmp.roeGames = subGameTypes;
        } else {
          gmp.dealerChoiceGames = subGameTypes;
        }

        // Load default values if it is not from Saved Settings.
        if (savedModel == null) {
          // Initializing values
          // Initial value for BigBlind
          gmp.blinds.bigBlind = 2.0;
          // Initial value for Buyin Min and max
          gmp.buyInMin = 30;
          gmp.buyInMax = 100;
          gmp.rakePercentage = 0;
          gmp.rakeCap = 0;
          gmp.buyInWaitTime = 120;
        } else {
          gmp.blinds = Blinds(bigBlind: savedModel.bigBlind);
          gmp.settings = savedModel;
        }
        gmp.notify = true;

        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleImageButton(
                      onTap: () async {
                        // Setting default name for settings with timestamp
                        String defaultText =
                            '${_appScreenText['settings']}_${DataFormatter.yymmddhhmmssFormat()}';
                        TextEditingController _controller =
                            TextEditingController(text: defaultText);
                        final result = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: theme.fillInColor,
                            title: Text(
                              _appScreenText['saveSettings'],
                              style:
                                  AppDecorators.getHeadLine4Style(theme: theme),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CardFormTextField(
                                  theme: theme,
                                  controller: _controller,
                                  maxLines: 1,
                                  hintText: _appScreenText['enterText'],
                                ),
                                AppDimensionsNew.getVerticalSizedBox(12),
                                RoundRectButton(
                                  text: _appScreenText['save'],
                                  theme: theme,
                                  onTap: () {
                                    if (_controller.text.isNotEmpty) {
                                      Navigator.of(context)
                                          .pop(_controller.text);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          final instance = HiveDatasource.getInstance
                              .getBox(BoxType.GAME_SETTINGS_BOX);
                          log(jsonEncode(gmp.settings.toJson()));
                          await instance.put(result, gmp.settings.toJson());
                        }
                      },
                      icon: Icons.save,
                      theme: theme,
                    ),
                    /* HEADING */
                    Expanded(
                      child: HeadingWidget(
                        heading: _appScreenText['gameSettings'],
                      ),
                    ),
                    CircleImageButton(
                      onTap: () => Navigator.of(context).pop(),
                      theme: theme,
                      icon: Icons.close,
                    ),
                  ],
                ),

                /* players */
                _buildLabel('PLAYERS', theme),
                sepV8,
                RadioListWidget<int>(
                  defaultValue: gmp.maxPlayers,
                  values: [2, 4, 6, 8, 9],
                  onSelect: (int value) => gmp.maxPlayers = value,
                ),

                /* chip unit */
                sepV20,
                Consumer<NewGameModelProvider>(builder: (_, vnGmp, __) {
                  return Row(children: [
                    Expanded(
                      child: Text('Chip Unit'),
                    ),
                    Expanded(
                        child: ToggleButtons(
                      selectedColor: Colors.black,
                      borderColor: theme.accentColor,
                      fillColor: theme.accentColor,
                      onPressed: (int index) {
                        if (index == 0) {
                          gmp.chipUnit = ChipUnit.DOLLAR;
                        } else {
                          gmp.chipUnit = ChipUnit.CENT;
                        }
                      },
                      isSelected: [
                        gmp.chipUnit == ChipUnit.DOLLAR,
                        gmp.chipUnit == ChipUnit.CENT,
                      ],
                      children: [
                        Text('1'),
                        Text('.01'),
                      ],
                    ))
                  ]);
                }),

                /* big blind & ante */
                sepV20,
                Row(
                  children: [
                    /* big blind */
                    Expanded(
                      child: TextInputWidget(
                        value: gmp.bigBlind,
                        label: _appScreenText['bigBlind'],
                        minValue: 2,
                        maxValue: 1000,
                        title: _appScreenText['enterBigBlind'],
                        onChange: (value) {
                          //gmp.blinds.bigBlind = value.toDouble();
                          gmp.bigBlind = value.toDouble();
                        },
                      ),
                    ),

                    // sep
                    sepH10,

                    /* ante */
                    // Expanded(
                    //   child: TextInputWidget(
                    //     value: gmp.blinds.ante,
                    //     label: 'Ante',
                    //     title: 'Enter ante',
                    //     minValue: 0,
                    //     maxValue: 1000,
                    //     onChange: (value) {
                    //       gmp.blinds.ante = value.toDouble();
                    //     },
                    //   ),
                    // ),
                  ],
                ),

                /* buyin */
                sepV20,
                _buildLabel(_appScreenText['buyin'], theme),
                sepV8,
                DecoratedContainer(
                  child: Column(children: [
                    Row(
                      children: [
                        /* min */
                        Expanded(
                          child: TextInputWidget(
                            value: gmp.buyInMin.toDouble(),
                            small: true,
                            label: _appScreenText['min'],
                            trailing: _appScreenText['bb'],
                            title: _appScreenText['enterMinBuyin'],
                            minValue: 0,
                            maxValue: 1000,
                            onChange: (value) {
                              gmp.buyInMin = value.floor();

                              if (gmp.buyInMax <= value.floor()) {
                                Alerts.showNotification(
                                    titleText:
                                        _appScreenText['buyInMoreThanMin'],
                                    duration: Duration(seconds: 5));
                              }
                            },
                          ),
                        ),

                        // sep
                        sepH10,

                        /* max */
                        Expanded(
                          child: TextInputWidget(
                            value: gmp.buyInMax.toDouble(),
                            small: true,
                            label: _appScreenText['max'],
                            title: _appScreenText['enterMaxBuyin'],
                            trailing: _appScreenText['bb'],
                            minValue: 0,
                            maxValue: 1000,
                            onChange: (value) {
                              gmp.buyInMax = value.floor();
                              if (gmp.buyInMin >= value.floor()) {
                                Alerts.showNotification(
                                    titleText:
                                        _appScreenText['buyinMaxBBGreater'],
                                    duration: Duration(seconds: 5));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.ph),
                    Consumer<NewGameModelProvider>(builder: (_, vnGmp, __) {
                      return Text(
                          ' (${DataFormatter.chipsFormat(gmp.buyInMin * gmp.bigBlind)} - ${DataFormatter.chipsFormat(gmp.buyInMax * gmp.bigBlind)}) ');
                    }),
                  ]),
                  theme: theme,
                ),

                /* tips */
                sepV20,
                _buildLabel(_appScreenText["tips"], theme),
                sepV8,
                DecoratedContainer(
                  child: Row(
                    children: [
                      /* min */
                      Expanded(
                        child: TextInputWidget(
                          value: gmp.rakePercentage,
                          small: true,
                          trailing: '%',
                          title: _appScreenText["tipsPercent"],
                          minValue: 0,
                          maxValue: 50,
                          onChange: (value) {
                            gmp.rakePercentage = value;
                          },
                        ),
                      ),

                      // sep
                      sepH10,

                      /* max */
                      Expanded(
                        child: TextInputWidget(
                          value: gmp.rakeCap,
                          small: true,
                          leading: _appScreenText['cap'],
                          title: _appScreenText['maxTips'],
                          minValue: 0,
                          maxValue: -1,
                          onChange: (value) {
                            gmp.rakeCap = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  theme: theme,
                ),

                /* action time */
                sepV20,
                _buildLabel(_appScreenText['actionTime'], theme),
                sepV8,
                RadioListWidget<int>(
                  defaultValue: gmp.actionTime,
                  values: NewGameConstants.ACTION_TIMES,
                  onSelect: (int value) {
                    gmp.actionTime = value;
                  },
                ),

                /* game time */
                sepV20,
                _buildLabel(_appScreenText['gameTime'], theme),
                sepV8,
                RadioListWidget<int>(
                  defaultValue: gmp.gameLengthInMins ~/ 60,
                  values: NewGameConstants.GAME_LENGTH,
                  onSelect: (int value) {
                    gmp.gameLengthInMins = value * 60;
                  },
                ),

                /* sep */
                sepV20,

                /* UTG straddle */
                _buildRadio(
                  label: _appScreenText['utgStraddle'],
                  value: gmp.straddleAllowed,
                  onChange: (bool b) {
                    gmp.straddleAllowed = b;
                  },
                  theme: theme,
                ),
                sepV20,
                _buildButtonStraddleConfig(theme, gmp),
                sepV20,

                /* allow run it twice */
                _buildRadio(
                  label: _appScreenText['allowRunItTwice'],
                  value: gmp.runItTwice,
                  onChange: (bool b) {
                    gmp.runItTwice = b;
                  },
                  theme: theme,
                ),
                /* sep */
                sepV20,

                /* Highhand Tracked */
                _buildRadio(
                  label: _appScreenText['hhTracked'],
                  value: gmp.highHandTracked,
                  onChange: (bool b) {
                    gmp.highHandTracked = b;
                  },
                  theme: theme,
                ),
                sepV20,
                ExpansionTile(
                  subtitle: Text(_appScreenText['chooseAdvanceConfig'],
                      style: AppStylesNew.labelTextStyle),
                  title: Text(_appScreenText['advanceConfig']),
                  children: [
                    _buildBuyinConfig(theme, gmp),
                    sepV20,
                    _buildBreakConfig(theme, gmp),
                    sepV20,
                    _buildBombPotConfig(theme, gmp),

                    /* sep */
                    sepV20,
                    DecoratedContainer(
                      theme: theme,
                      children: [
                        /* allow audio conference */
                        _buildRadio(
                          label: _appScreenText['useAudioConf'],
                          value: gmp.audioConference,
                          onChange: (bool b) {
                            gmp.audioConference = b;
                          },
                          theme: theme,
                        ),

                        /* allow audio conference */
                        // _buildRadio(
                        //   label: _appScreenText['USEAGORAAUDIOCONFERENCE'],
                        //   value: gmp.useAgora,
                        //   onChange: (bool b) {
                        //     gmp.useAgora = b;
                        //   },
                        //   theme: theme,
                        // ),

                        /* bot games */
                        _buildRadio(
                          label: _appScreenText['botGame'],
                          value: gmp.botGame,
                          onChange: (bool b) {
                            gmp.botGame = b;
                          },
                          theme: theme,
                        ),
                        /* location check */
                        _buildRadio(
                          label: _appScreenText['locationCheck'],
                          value: gmp.locationCheck,
                          onChange: (bool b) {
                            gmp.locationCheck = b;
                          },
                          theme: theme,
                        ),

                        /* ip check */
                        _buildRadio(
                          label: _appScreenText['ipCheck'],
                          value: gmp.ipCheck,
                          onChange: (bool b) {
                            gmp.ipCheck = b;
                          },
                          theme: theme,
                        ),

                        /* waitlist */
                        _buildRadio(
                          label: _appScreenText['waitlist'],
                          value: gmp.waitList,
                          onChange: (bool b) {
                            gmp.waitList = b;
                          },
                          theme: theme,
                        ),

                        /* seat change allowed */
                        _buildRadio(
                          label: _appScreenText['seatChangeAllowed'],
                          value: gmp.seatChangeAllowed,
                          onChange: (bool b) {
                            gmp.seatChangeAllowed = b;
                          },
                          theme: theme,
                        ),

                        /* allow fun animations */
                        _buildRadio(
                          label: _appScreenText['allowFunAnimation'],
                          theme: theme,
                          value: gmp.allowFunAnimations,
                          onChange: (bool b) {
                            gmp.allowFunAnimations = b;
                          },
                        ),

                        /* allow run it twice */
                        _buildRadio(
                          label: _appScreenText['muckLosingHand'],
                          value: gmp.muckLosingHand,
                          onChange: (bool b) {
                            gmp.muckLosingHand = b;
                          },
                          theme: theme,
                        ),

                        /* show player buyin */
                        _buildRadio(
                          label: _appScreenText['showPlayerBuyin'],
                          value: gmp.showPlayerBuyin,
                          onChange: (bool b) {
                            gmp.showPlayerBuyin = b;
                          },
                          theme: theme,
                        ),

                        /* allow rabbit hunt */
                        _buildRadio(
                          label: _appScreenText['allowRabbitHunt'],
                          value: gmp.allowRabbitHunt,
                          onChange: (bool b) {
                            gmp.allowRabbitHunt = b;
                          },
                          theme: theme,
                        ),

                        /* show hand rank */
                        _buildRadio(
                          label: _appScreenText['showHandRank'],
                          value: gmp.showHandRank,
                          onChange: (bool b) {
                            gmp.showHandRank = b;
                          },
                          theme: theme,
                        ),

                        /* show table result */
                        _buildRadio(
                          label: _appScreenText['showResult'],
                          value: gmp.showResult,
                          onChange: (bool b) {
                            gmp.showResult = b;
                          },
                          theme: theme,
                        ),
                      ],
                    ),
                  ],
                ),

                /* start button */
                sepV20,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ButtonWidget(
                      text: _appScreenText['start'],
                      onTap: () {
                        // if (gmp.blinds.bigBlind % 2 != 0) {
                        //   Alerts.showNotification(
                        //     titleText: _appScreenText['gameCreationFailed'],
                        //     subTitleText: _appScreenText['checkBigBlind'],
                        //     duration: Duration(seconds: 5),
                        //   );
                        //   return;
                        // } else
                        if (gmp.buyInMax < gmp.buyInMin) {
                          Alerts.showNotification(
                            titleText: _appScreenText['gameCreationFailed'],
                            subTitleText: _appScreenText['checkBuyinRange'],
                            duration: Duration(seconds: 5),
                          );
                          return;
                        } else {
                          Navigator.pop(context, gmp);
                        }
                      },
                    ),
                    Positioned(
                      right: 0,
                      child: CircleImageButton(
                        onTap: () async {},
                        icon: Icons.save,
                        theme: theme,
                      ),
                    ),
                  ],
                ),

                /* sep */
                sepV20,
              ],
            ),
          ),
        );
      },
    );
  }
}
