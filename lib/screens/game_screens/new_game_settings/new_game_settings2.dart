import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
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
  }) async {
    NewGameModelProvider gmp = await showDialog<NewGameModelProvider>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: NewGameSettings2(clubCode),
      ),
    );

    if (gmp == null) return;

    /* otherwise, start tha game */
    final NewGameModel gm = gmp.settings;

    gm.gameType = mainGameType;
    gm.roeGames = subGameTypes;
    gm.dealerChoiceGames = subGameTypes;

    String gameCode = await GameService.configureClubGame(
      clubCode,
      gm,
    );

    if (gameCode != null)
      _joinGame(context, gameCode);
    else
      _showError(context, 'Error', 'Creating game failed');
  }

  final String clubCode;
  NewGameSettings2(this.clubCode);

  Widget _buildLabel(String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      );

  Widget _buildDecoratedContainer({
    Widget child,
    List<Widget> children,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
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

  Widget _buildSeperator() => Container(
        color: Color(0x33ffffff),
        width: double.infinity,
        height: 1.0,
      );

  Widget _buildRadio({
    @required bool value,
    @required String label,
    @required void Function(bool v) onChange,
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
          _buildSeperator(),
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
  Widget build(BuildContext context) =>
      ListenableProvider<NewGameModelProvider>(
        create: (_) => NewGameModelProvider(clubCode),
        builder: (BuildContext context, _) {
          final NewGameModelProvider gmp = context.read<NewGameModelProvider>();
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.centerLeft,
                radius: 0.8,
                colors: [
                  const Color(0xff033614),
                  const Color(0xff02290F),
                  const Color(0xff02290F),
                  Colors.black,
                ],
              ),
            ),
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
                        onTap: () {},
                        child: CircleAvatar(
                          child: Icon(Icons.save),
                          backgroundColor:
                              AppColorsNew.newGreenRadialStartColor,
                        ),
                      ),
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
                          backgroundColor:
                              AppColorsNew.newGreenRadialStartColor,
                        ),
                      ),
                    ],
                  ),

                  /* players */
                  _buildLabel('Players'),
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
                          value: gmp.blinds.bigBlind,
                          label: 'Big Blind',
                          minValue: 0.0,
                          maxValue: 1000,
                          onChange: (value) {
                            gmp.bigBlind = value.toDouble();
                          },
                        ),
                      ),

                      // sep
                      sepH10,

                      /* ante */
                      Expanded(
                        child: TextInputWidget(
                          value: gmp.blinds.ante,
                          label: 'Ante',
                          minValue: 0.0,
                          maxValue: 1000,
                          onChange: (value) {
                            gmp.ante = value.toDouble();
                          },
                        ),
                      ),
                    ],
                  ),

                  /* buyin */
                  sepV20,
                  _buildLabel('Buyin'),
                  sepV8,
                  _buildDecoratedContainer(
                    child: Row(
                      children: [
                        /* min */
                        Expanded(
                          child: TextInputWidget(
                            value: gmp.buyInMin,
                            small: true,
                            label: 'min',
                            trailing: 'BB',
                            minValue: 0.0,
                            maxValue: 1000,
                            onChange: (value) {
                              gmp.buyInMin = value;
                            },
                          ),
                        ),

                        // sep
                        sepH10,

                        /* max */
                        Expanded(
                          child: TextInputWidget(
                            value: gmp.buyInMax,
                            small: true,
                            label: 'max',
                            trailing: 'BB',
                            minValue: 0.0,
                            maxValue: 1000,
                            onChange: (value) {
                              gmp.buyInMax = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* tips */
                  sepV20,
                  _buildLabel('Tips'),
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
                            minValue: 0.0,
                            maxValue: 1000,
                            onChange: (value) {
                              gmp.rakePercentage = value.toDouble();
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
                            minValue: 0.0,
                            maxValue: 1000,
                            onChange: (value) {
                              gmp.rakeCap = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* action time */
                  sepV20,
                  _buildLabel('Action Time (in seconds)'),
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
                  _buildLabel('Game Time (in hours)'),
                  sepV8,
                  RadioListWidget(
                    defaultValue: gmp.gameLengthInMins ~/ 60,
                    values: NewGameConstants.GAME_LENGTH,
                    onSelect: (int value) {
                      gmp.gameLengthInMins = value;
                    },
                  ),

                  /* sep */
                  sepV20,

                  /* buy in approval */
                  _buildDecoratedContainer(
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
                              : TextInputWidget(
                                  label: 'Buyin wait time',
                                  value: 120,
                                  trailing: 'secs',
                                  minValue: 0.0,
                                  maxValue: 100,
                                  onChange: (value) {},
                                ),
                        ),
                      ),

                      /* seperator */
                      sepV20,
                      _buildSeperator(),

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
                    children: [
                      /* allow audio conference */
                      _buildRadio(
                        label: 'Allow Audio Conference',
                        value: gmp.audioConference,
                        onChange: (bool b) {
                          gmp.audioConference = b;
                        },
                      ),

                      /* bot games */
                      _buildRadio(
                        label: 'Bot Game',
                        value: gmp.botGame,
                        onChange: (bool b) {
                          gmp.botGame = b;
                        },
                      ),

                      /* UTG straddle */
                      _buildRadio(
                        label: 'UTG Straddle',
                        value: gmp.straddleAllowed,
                        onChange: (bool b) {
                          gmp.straddleAllowed = b;
                        },
                      ),

                      /* location check */
                      _buildRadio(
                        label: 'Location Check',
                        value: gmp.locationCheck,
                        onChange: (bool b) {
                          gmp.locationCheck = b;
                        },
                      ),

                      /* ip check */
                      _buildRadio(
                        label: 'IP Check',
                        value: gmp.ipCheck,
                        onChange: (bool b) {
                          gmp.ipCheck = b;
                        },
                      ),

                      /* waitlist */
                      _buildRadio(
                        label: 'Waitlist',
                        value: gmp.waitList,
                        onChange: (bool b) {
                          gmp.waitList = b;
                        },
                      ),

                      /* allow run it twice */
                      _buildRadio(
                        label: 'Allow Run It Twice',
                        value: gmp.runItTwice,
                        onChange: (bool b) {
                          gmp.runItTwice = b;
                        },
                      ),

                      /* allow run it twice */
                      _buildRadio(
                        label: 'Allow Fun Animations',
                        value: true,
                        onChange: (bool b) {},
                      ),

                      /* allow run it twice */
                      _buildRadio(
                        label: 'Muck Losing Hand',
                        value: false,
                        onChange: (bool b) {},
                      ),

                      /* show player buyin */
                      _buildRadio(
                        label: 'Show player buyin',
                        value: gmp.showPlayerBuyin,
                        onChange: (bool b) {
                          gmp.showPlayerBuyin = b;
                        },
                      ),

                      /* allow rabbit hunt */
                      _buildRadio(
                        label: 'Allow Rabbit Hunt',
                        value: gmp.allowRabbitHunt,
                        onChange: (bool b) {
                          gmp.allowRabbitHunt = b;
                        },
                      ),

                      /* show hand rank */
                      _buildRadio(
                        label: 'Show Hand Rank',
                        value: gmp.showHandRank,
                        onChange: (bool b) {
                          gmp.showHandRank = b;
                        },
                      ),
                    ],
                  ),

                  /* start button */
                  sepV20,
                  ButtonWidget(
                    text: 'Start',
                    onTap: () {
                      Navigator.pop(context, gmp);
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
