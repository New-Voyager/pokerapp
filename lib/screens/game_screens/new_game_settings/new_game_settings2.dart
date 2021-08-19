import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
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
  static AppTextScreen _appScreenText;

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
              text: _appScreenText['OK'],
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
      _showError(context, _appScreenText['ERROR'],
          _appScreenText['CREATINGGAMEFAILED']);
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
    _appScreenText = getAppTextScreen("newGameSettings2");
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
                            '${_appScreenText['SETTINGS']}_${DataFormatter.yymmddhhmmssFormat()}';
                        TextEditingController _controller =
                            TextEditingController(text: defaultText);
                        final result = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: theme.fillInColor,
                            title: Text(
                              _appScreenText['SAVESETTINGS'],
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
                                  hintText: _appScreenText['ENTERTEXT'],
                                ),
                                AppDimensionsNew.getVerticalSizedBox(12),
                                RoundedColorButton(
                                  text: _appScreenText['SAVE'],
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
                        heading: _appScreenText['GAMESETTINGS'],
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
                _buildLabel('PLAYERS', theme),
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
                        label: _appScreenText['BIGBLIND'],
                        minValue: 2,
                        maxValue: 1000,
                        title: _appScreenText['ENTERBIGBLIND'],
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
                _buildLabel(_appScreenText['BUYIN'], theme),
                sepV8,
                _buildDecoratedContainer(
                  child: Row(
                    children: [
                      /* min */
                      Expanded(
                        child: TextInputWidget(
                          value: gmp.buyInMin.toDouble(),
                          small: true,
                          label: _appScreenText['MIN'],
                          trailing: _appScreenText['BB'],
                          title: _appScreenText['ENTERMINBUYING'],
                          minValue: 0,
                          maxValue: 1000,
                          onChange: (value) {
                            gmp.buyInMin = value.floor();

                            if (gmp.buyInMax <= value.floor()) {
                              Alerts.showNotification(
                                  titleText: _appScreenText[
                                      'BUYINMINMUSTBELESSTHANMAX'],
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
                          label: _appScreenText['MAX'],
                          title: _appScreenText['ENTERMAXBUYING'],
                          trailing: _appScreenText['BB'],
                          minValue: 0,
                          maxValue: 1000,
                          onChange: (value) {
                            gmp.buyInMax = value.floor();
                            if (gmp.buyInMin >= value.floor()) {
                              Alerts.showNotification(
                                  titleText: _appScreenText[
                                      'BUYINMAXMUSTBEGREATERTHANMIN'],
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
                _buildLabel(_appScreenText["TIPS"], theme),
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
                          title: _appScreenText["ENTERTIPSINOFPOT"],
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
                          leading: _appScreenText['CAP'],
                          title: _appScreenText['ENTERMAXTIPSTAKENFROMTHEPOT'],
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
                _buildLabel(_appScreenText['ACTIONTIME'], theme),
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
                _buildLabel(_appScreenText['GAMETIME'], theme),
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
                  label: _appScreenText['UTGSTRADDLE'],
                  value: gmp.straddleAllowed,
                  onChange: (bool b) {
                    gmp.straddleAllowed = b;
                  },
                  theme: theme,
                ),
                sepV20,

                /* allow run it twice */
                _buildRadio(
                  label: _appScreenText['ALLOWRUNITTWICE'],
                  value: gmp.runItTwice,
                  onChange: (bool b) {
                    gmp.runItTwice = b;
                  },
                  theme: theme,
                ),
                sepV20,
                /* buy in approval */

                ExpansionTile(
                  subtitle: Text(_appScreenText['CHOOSEADVANCECONFIGURATIONS'],
                      style: AppStylesNew.labelTextStyle),
                  title: Text(_appScreenText['ADVANCESETTINGS']),
                  children: [
                    _buildDecoratedContainer(
                      theme: theme,
                      children: [
                        SwitchWidget(
                          value: gmp.buyInApproval,
                          label: _appScreenText['BUYINGAPPROVAL'],
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
                                          _appScreenText['BUYINGMAXWAITTIME'],
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
                          label: _appScreenText['BREAKALLOWED'],
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
                                    label: _appScreenText['MAXBREAKTIME'],
                                    value: 10,
                                    trailing: _appScreenText['MINS'],
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
                          label: _appScreenText['USEAUDIOCONFERENCE'],
                          value: gmp.audioConference,
                          onChange: (bool b) {
                            gmp.audioConference = b;
                          },
                          theme: theme,
                        ),

                        /* allow audio conference */
                        _buildRadio(
                          label: _appScreenText['USEAGORAAUDIOCONFERENCE'],
                          value: gmp.useAgora,
                          onChange: (bool b) {
                            gmp.useAgora = b;
                          },
                          theme: theme,
                        ),

                        /* bot games */
                        _buildRadio(
                          label: _appScreenText['BOTGAME'],
                          value: gmp.botGame,
                          onChange: (bool b) {
                            gmp.botGame = b;
                          },
                          theme: theme,
                        ),
                        /* location check */
                        _buildRadio(
                          label: _appScreenText['LOCATIONCHECK'],
                          value: gmp.locationCheck,
                          onChange: (bool b) {
                            gmp.locationCheck = b;
                          },
                          theme: theme,
                        ),

                        /* ip check */
                        _buildRadio(
                          label: _appScreenText['IPCHECK'],
                          value: gmp.ipCheck,
                          onChange: (bool b) {
                            gmp.ipCheck = b;
                          },
                          theme: theme,
                        ),

                        /* waitlist */
                        _buildRadio(
                          label: _appScreenText['WAITLIST'],
                          value: gmp.waitList,
                          onChange: (bool b) {
                            gmp.waitList = b;
                          },
                          theme: theme,
                        ),

                        /* allow run it twice */
                        _buildRadio(
                          label: _appScreenText['ALLOWFUNANIMATION'],
                          theme: theme,
                          value: true,
                          onChange: (bool b) {},
                        ),

                        /* allow run it twice */
                        _buildRadio(
                          label: _appScreenText['MUCKLOSINGHAND'],
                          value: false,
                          onChange: (bool b) {},
                          theme: theme,
                        ),

                        /* show player buyin */
                        _buildRadio(
                          label: _appScreenText['SHOWPLAYERBUYING'],
                          value: gmp.showPlayerBuyin,
                          onChange: (bool b) {
                            gmp.showPlayerBuyin = b;
                          },
                          theme: theme,
                        ),

                        /* allow rabbit hunt */
                        _buildRadio(
                          label: _appScreenText['ALLOWRABBITHUNT'],
                          value: gmp.allowRabbitHunt,
                          onChange: (bool b) {
                            gmp.allowRabbitHunt = b;
                          },
                          theme: theme,
                        ),

                        /* show hand rank */
                        _buildRadio(
                          label: _appScreenText['SHOWHANDRANK'],
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
                  text: _appScreenText['START'],
                  onTap: () {
                    if (gmp.blinds.bigBlind % 2 != 0) {
                      Alerts.showNotification(
                        titleText: _appScreenText['GAMECREATIONFAILED'],
                        subTitleText: _appScreenText['CHECKBIGBLIND'],
                        duration: Duration(seconds: 5),
                      );
                      return;
                    } else if (gmp.buyInMax < gmp.buyInMin) {
                      Alerts.showNotification(
                        titleText: _appScreenText['GAMECREATIONFAILED'],
                        subTitleText: _appScreenText['CHECKBUYINGMINMAX'],
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
