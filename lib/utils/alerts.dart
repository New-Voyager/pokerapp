import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/choose_game_new.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/widgets/buttons.dart';

class Alerts {
  static void showSnackBar(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1500)}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColorsNew.appAccentColor,
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      duration: duration,
    ));
  }

  static void showHighHandWinner({
    @required List<int> playerCards,
    @required List<int> boardCards,
    @required List<int> highHandCards,
    @required String name,
    @required int handNo,
    Duration duration = const Duration(milliseconds: 6000),
  }) {
    showOverlayNotification(
      (context) => OverlayHighHandNotificationWidget(
        handNo: handNo,
        name: name,
        highHandCards: highHandCards,
        boardCards: boardCards,
        playerCards: playerCards,
      ),
      position: NotificationPosition.top,
      duration: duration,
    );
  }

  static void showRabbitHuntNotification({
    ChatMessage chatMessage,
    Duration duration = const Duration(milliseconds: 10000),
  }) {
    showOverlayNotification(
      (context) => OverlayRabbitHuntNotificationWidget(
        revealedCards: chatMessage.revealedCards,
        boardCards: chatMessage.boardCards,
        handNo: chatMessage.handNo,
        playerCards: chatMessage.playerCards,
        name: chatMessage.fromName,
      ),
      position: NotificationPosition.top,
      duration: duration,
    );
  }

  static OverlaySupportEntry showNotification({
    @required String titleText,
    String subTitleText,
    IconData leadingIcon,
    Duration duration,
    String imagePath,
    String svgPath,
  }) {
    if (duration == null) {
      duration = Duration(milliseconds: 1500);
    }
    return showOverlayNotification(
      (context) => OverlayNotificationWidget(
        title: titleText,
        subTitle: subTitleText,
        icon: leadingIcon,
        image: imagePath,
        svgPath: svgPath,
      ),
      position: NotificationPosition.top,
      duration: duration,
    );
  }

  static Future<List<GameType>> showChooseGamesDailog(
    List<GameType> existingChoices,
    BuildContext context,
    AppTheme theme,
    bool dealerChoiceOrbit, {
    GameState gameState,
    Future<void> Function() valueChangeFunction,
  }) async {
    return await showDialog(
      context: context,
      builder: (_) {
        List<GameType> list = [];
        list.addAll(existingChoices);
        return AlertDialog(
          backgroundColor: theme.fillInColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: StatefulBuilder(
            builder: (_, localSetState) {
              Widget fiveCardGames = Column(
                children: [
                  GameTypeChip(
                    gameType: GameType.FIVE_CARD_PLO,
                    selected: list.contains(GameType.FIVE_CARD_PLO),
                    onTapFunc: (val) {
                      if (val) {
                        list.add(GameType.FIVE_CARD_PLO);
                      } else {
                        if (list.length <= 2) {
                          toast("minimum 2 game types required");
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
                          toast("minimum 2 game types required");
                          return;
                        }
                        list.remove(GameType.FIVE_CARD_PLO_HILO);
                      }
                      localSetState(() {});
                    },
                  ),
                ],
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Dealer Choice",
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CupertinoSegmentedControl<bool>(
                      borderColor: theme.accentColor, //const Color(0xff40D876),
                      selectedColor:
                          theme.secondaryColor, //const Color(0xff40D876),
                      groupValue: dealerChoiceOrbit ?? true,
                      children: {
                        false: Padding(
                          child: Text(
                            'Every Hand',
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                        true: Text(
                          'Orbit',
                        ),
                      },
                      onValueChanged: (bool v) async {
                        dealerChoiceOrbit = v;
                        if (gameState != null) {
                          gameState.gameSettings?.dealerChoiceOrbit = v;
                          await valueChangeFunction;
                        }
                        localSetState(() {});
                      },
                    ),
                  ),
                  Text(
                    "Choose Games",
                    style: AppDecorators.getHeadLine4Style(theme: theme),
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
                                toast("minimum 2 game types required");
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
                                toast("minimum 2 game types required");
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
                                toast("minimum 2 game types required");
                                return;
                              }
                              list.remove(GameType.PLO_HILO);
                            }
                            localSetState(() {});
                          },
                        ),
                        (gameState == null)
                            ? fiveCardGames
                            : (gameState.gameInfo.maxPlayers == 8)
                                ? fiveCardGames
                                : Container(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RoundRectButton(
                        text: "Cancel",
                        theme: theme,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      RoundRectButton(
                        text: "Save",
                        onTap: () => Navigator.of(context).pop(list),
                        theme: theme,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static dynamic showDailog({
    @required BuildContext context,
    @required Widget child,
    double height = 0.5,
  }) async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        final theme = AppTheme.getTheme(context);
        return SystemPadding(
          child: Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * height,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
                // width: MediaQuery.of(context).size.width * 0.70,
                // height: 200.ph,
                decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.accentColor, width: 3),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
    );
  }

  static dynamic showBottomSheetDailog({
    @required BuildContext context,
    @required Widget child,
  }) async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        final theme = AppTheme.getTheme(context);
        return SystemPadding(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
                // width: MediaQuery.of(context).size.width * 0.70,
                // height: 200.ph,
                decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.accentColor, width: 3),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0.2, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
    );
  }
}

class SystemPadding extends StatelessWidget {
  final Widget child;

  SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 100),
        child: child);
  }
}
