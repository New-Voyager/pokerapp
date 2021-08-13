import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../routes.dart';

class NewGameSettings2 extends StatelessWidget {
  static void _joinGame(BuildContext context, String gameCode) =>
      navigatorKey.currentState.pushNamed(
        Routes.game_play,
        arguments: gameCode,
      );

  static Future<void> _showError(
      BuildContext context, String title, String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            CustomTextButton(
              text: 'OK',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
        child:
            NewGameSettings2(clubCode, mainGameType, subGameTypes, savedModel),
      ),
    );

    if (gmp == null) return;

    /* otherwise, start tha game */
    final NewGameModel gm = gmp.settings;

    gm.gameType = mainGameType;
    gm.roeGames = subGameTypes;
    gm.dealerChoiceGames = subGameTypes;

    String gameCode;

    if (clubCode != null && clubCode.isNotEmpty) {
      gameCode = await GameService.configureClubGame(
        clubCode,
        gm,
      );
    } else {
      gameCode = await GameService.configurePlayerGame(gm);
    }

    if (gameCode != null)
      _joinGame(context, gameCode);
    else
      _showError(context, 'Error', 'Creating game failed');
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

  Widget _buildDecoratedContainer({
    Widget child,
    List<Widget> children,
    @required AppTheme theme,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: theme.fillInColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: children != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : child,
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

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return ListenableProvider<NewGameModelProvider>(
      create: (_) => NewGameModelProvider(clubCode),
      builder: (BuildContext context, _) {
        final NewGameModelProvider gmp = context.read<NewGameModelProvider>();

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
                    InkWell(
                      onTap: () async {
                        // Setting default name for settings with timestamp
                        String defaultText =
                            'Settings_${DataFormatter.yymmddhhmmssFormat()}';
                        TextEditingController _controller =
                            TextEditingController(text: defaultText);
                        final result = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: theme.fillInColor,
                            title: Text(
                              AppStringsNew.saveGameSettingsTitle,
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
                                  hintText: AppStringsNew.hintTextForTextField,
                                ),
                                AppDimensionsNew.getVerticalSizedBox(12),
                                RoundedColorButton(
                                  text: AppStringsNew.saveButtonText,
                                  backgroundColor: theme.accentColor,
                                  textColor: theme.primaryColorWithDark(),
                                  onTapFunction: () {
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
                          await instance.put(result, gmp.settings.toJson());
                        }
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.save,
                          color: theme.primaryColorWithDark(),
                        ),
                        backgroundColor: theme.accentColor,
                      ),
                    ),
                    /* HEADING */
                    Expanded(
                      child: HeadingWidget(
                        heading: AppStringsNew.gameSettingsTitle,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.close,
                          color: theme.primaryColorWithDark(),
                        ),
                        backgroundColor: theme.accentColor,
                      ),
                    ),
                  ],
                ),

                /* players */
                _buildLabel(AppStringsNew.playersText, theme),
                sepV8,
                RadioListWidget(
                  defaultValue: gmp.maxPlayers,
                  values: [2, 4, 6, 8, 9],
                  onSelect: (int value) => gmp.maxPlayers = value,
                ),

                /* big blind & ante */
                sepV20,
                Row(
                  children: [
                    /* big blind */
                    Expanded(
                      child: TextInputWidget(
                        value: gmp.bigBlind,
                        label: 'Big Blind',
                        minValue: 2,
                        maxValue: 1000,
                        title: 'Enter big blind',
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
                _buildLabel(AppStringsNew.BuyIn, theme),
                sepV8,
                _buildDecoratedContainer(
                  child: Row(
                    children: [
                      /* min */
                      Expanded(
                        child: TextInputWidget(
                          value: gmp.buyInMin.toDouble(),
                          small: true,
                          label: 'min',
                          trailing: 'BB',
                          title: 'Enter min buyin (x BB)',
                          minValue: 0,
                          maxValue: 1000,
                          onChange: (value) {
                            gmp.buyInMin = value.floor();

                            if (gmp.buyInMax <= value.floor()) {
                              Alerts.showNotification(
                                  titleText:
                                      "Buyin Min must be less than Buyin Max",
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
                          label: 'max',
                          title: 'Enter max buyin (x BB)',
                          trailing: 'BB',
                          minValue: 0,
                          maxValue: 1000,
                          onChange: (value) {
                            gmp.buyInMax = value.floor();
                            if (gmp.buyInMin >= value.floor()) {
                              Alerts.showNotification(
                                  titleText:
                                      "Buyin Max must be greater than Buyin Min",
                                  duration: Duration(seconds: 5));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  theme: theme,
                ),

                /* tips */
                sepV20,
                _buildLabel(AppStringsNew.tips, theme),
                sepV8,
                _buildDecoratedContainer(
                  child: Row(
                    children: [
                      /* min */
                      Expanded(
                        child: TextInputWidget(
                          value: gmp.rakePercentage,
                          small: true,
                          trailing: '%',
                          title: 'Enter tips in % of pot',
                          minValue: 0,
                          maxValue: 1000,
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
                          leading: 'cap',
                          title: 'Enter max tips taken from the pot',
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
                _buildLabel(AppStringsNew.actionTimeLabel, theme),
                sepV8,
                RadioListWidget(
                  defaultValue: gmp.actionTime,
                  values: NewGameConstants.ACTION_TIMES,
                  onSelect: (int value) {
                    gmp.actionTime = value;
                  },
                ),

                /* game time */
                sepV20,
                _buildLabel(AppStringsNew.gameTimeLabel, theme),
                sepV8,
                RadioListWidget(
                  defaultValue: gmp.gameLengthInHrs,
                  values: NewGameConstants.GAME_LENGTH,
                  onSelect: (int value) {
                    gmp.gameLengthInHrs = value;
                  },
                ),

                /* sep */
                sepV20,

                /* UTG straddle */
                _buildRadio(
                  label: 'UTG Straddle',
                  value: gmp.straddleAllowed,
                  onChange: (bool b) {
                    gmp.straddleAllowed = b;
                  },
                  theme: theme,
                ),
                sepV20,

                /* allow run it twice */
                _buildRadio(
                  label: 'Allow Run It Twice',
                  value: gmp.runItTwice,
                  onChange: (bool b) {
                    gmp.runItTwice = b;
                  },
                  theme: theme,
                ),
                sepV20,
                /* buy in approval */

                ExpansionTile(
                  subtitle: Text("Choose advanced configurations",
                      style: AppDecorators.getSubtitle3Style(theme: theme)),
                  title: Text("Advanced Settings"),
                  children: [
                    _buildDecoratedContainer(
                      theme: theme,
                      children: [
                        SwitchWidget(
                          value: gmp.buyInApproval,
                          label: 'Buyin Approval',
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
                                      _buildLabel(
                                          AppStringsNew.buyinMaxWaitTimeLabel,
                                          theme),
                                      RadioListWidget(
                                        defaultValue: gmp.buyInWaitTime,
                                        values:
                                            NewGameConstants.BUYIN_WAIT_TIMES,
                                        onSelect: (int value) {
                                          gmp.buyInWaitTime = value;
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        /* seperator */
                        sepV20,
                        _buildSeperator(theme),

                        /* sep */
                        sepV20,

                        SwitchWidget(
                          value: gmp.breakAllowed,
                          label: 'Break allowed',
                          onChange: (bool value) {
                            gmp.breakAllowed = value;
                          },
                        ),

                        // buy in wait time
                        Consumer<NewGameModelProvider>(
                          builder: (_, vnGmp, __) => _buildAnimatedSwitcher(
                            child: vnGmp.breakAllowed == false
                                ? const SizedBox.shrink()
                                : TextInputWidget(
                                    label: 'Max break time',
                                    value: 10,
                                    trailing: 'mins',
                                    minValue: 0.0,
                                    maxValue: 100,
                                    onChange: (value) {},
                                  ),
                          ),
                        ),
                      ],
                    ),

                    /* sep */
                    sepV20,
                    _buildDecoratedContainer(
                      theme: theme,
                      children: [
                        /* allow audio conference */
                        _buildRadio(
                          label: 'Use Audio Conference    (Beta)',
                          value: gmp.audioConference,
                          onChange: (bool b) {
                            gmp.audioConference = b;
                          },
                          theme: theme,
                        ),

                        /* allow audio conference */
                        _buildRadio(
                          label: 'Use Agora Audio Conference    (Beta)',
                          value: gmp.useAgora,
                          onChange: (bool b) {
                            gmp.useAgora = b;
                          },
                          theme: theme,
                        ),

                        /* bot games */
                        _buildRadio(
                          label: 'Bot Game',
                          value: gmp.botGame,
                          onChange: (bool b) {
                            gmp.botGame = b;
                          },
                          theme: theme,
                        ),
                        /* location check */
                        _buildRadio(
                          label: 'Location Check',
                          value: gmp.locationCheck,
                          onChange: (bool b) {
                            gmp.locationCheck = b;
                          },
                          theme: theme,
                        ),

                        /* ip check */
                        _buildRadio(
                          label: 'IP Check',
                          value: gmp.ipCheck,
                          onChange: (bool b) {
                            gmp.ipCheck = b;
                          },
                          theme: theme,
                        ),

                        /* waitlist */
                        _buildRadio(
                          label: 'Waitlist',
                          value: gmp.waitList,
                          onChange: (bool b) {
                            gmp.waitList = b;
                          },
                          theme: theme,
                        ),

                        /* allow run it twice */
                        _buildRadio(
                          theme: theme,
                          label: 'Allow Fun Animations',
                          value: true,
                          onChange: (bool b) {},
                        ),

                        /* allow run it twice */
                        _buildRadio(
                          label: 'Muck Losing Hand',
                          value: false,
                          onChange: (bool b) {},
                          theme: theme,
                        ),

                        /* show player buyin */
                        _buildRadio(
                          label: 'Show player buyin',
                          value: gmp.showPlayerBuyin,
                          onChange: (bool b) {
                            gmp.showPlayerBuyin = b;
                          },
                          theme: theme,
                        ),

                        /* allow rabbit hunt */
                        _buildRadio(
                          label: 'Allow Rabbit Hunt',
                          value: gmp.allowRabbitHunt,
                          onChange: (bool b) {
                            gmp.allowRabbitHunt = b;
                          },
                          theme: theme,
                        ),

                        /* show hand rank */
                        _buildRadio(
                          label: 'Show Hand Rank',
                          value: gmp.showHandRank,
                          onChange: (bool b) {
                            gmp.showHandRank = b;
                          },
                          theme: theme,
                        ),
                      ],
                    ),
                  ],
                ),

                /* start button */
                sepV20,
                ButtonWidget(
                  text: 'Start',
                  onTap: () {
                    if (gmp.blinds.bigBlind % 2 != 0) {
                      Alerts.showNotification(
                        titleText: "Game creation failed!",
                        subTitleText: "Please check Bigblind values",
                        duration: Duration(seconds: 5),
                      );
                      return;
                    } else if (gmp.buyInMax < gmp.buyInMin) {
                      Alerts.showNotification(
                        titleText: "Game creation failed!",
                        subTitleText:
                            "Please check Buyin Min and Buyin max values",
                        duration: Duration(seconds: 5),
                      );
                      return;
                    } else {
                      Navigator.pop(context, gmp);
                    }
                  },
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
