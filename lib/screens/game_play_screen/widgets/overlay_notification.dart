import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ParentOverlayNotificationWidget extends StatelessWidget {
  final Widget child;
  final bool isDismissible;

  ParentOverlayNotificationWidget({
    @required this.child,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.read<AppTheme>();
    return SlideDismissible(
      key: ValueKey("overlayNotification"),
      direction:
          isDismissible ? DismissDirection.vertical : DismissDirection.none,
      child: SafeArea(
        child: Card(
          color: appTheme.primaryColorWithDark(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 2,
              color: appTheme.accentColor,
            ),
          ),
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.pw),
            padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 10.ph),
            // decoration: BoxDecoration(
            //   color: AppColorsNew.notificationBackgroundColor,
            //   borderRadius: BorderRadius.circular(8.pw),
            // ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class OverlayNotificationWidget extends StatelessWidget {
  final String amount;
  final String playerName;
  final int pendingCount;
  final String title;
  final String subTitle;
  final String image;
  final IconData icon;
  final String svgPath;

  OverlayNotificationWidget(
      {this.amount,
      this.playerName,
      this.pendingCount,
      this.title,
      this.subTitle,
      this.image,
      this.icon,
      this.svgPath});
  @override
  Widget build(BuildContext context) {
    String title = this.title;
    String subTitle = this.subTitle;
    if (title == null || title == '') {
      title = "Buyin request of '$amount' from '$playerName'";
      if (subTitle == null || subTitle == '') {
        subTitle = "Total pending buyin requests : $pendingCount";
      }
    }

    Widget leadingImage;
    if (image != null) {
      leadingImage = Image.asset(image);
    } else if (icon != null) {
      leadingImage = Icon(
        icon,
        size: 20.pw,
        color: Colors.white60,
      );
    } else if (svgPath != null) {
      leadingImage = SvgPicture.asset(
        svgPath,
        height: 24.pw,
        width: 24.pw,
      );
    }
    if (leadingImage != null) {
      leadingImage = Container(
        height: 32.pw,
        width: 32.pw,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Colors.black,
          border: Border.all(
            color: AppColorsNew.notificationIconColor,
          ),
        ),
        padding: EdgeInsets.all(5.pw),
        margin: EdgeInsets.symmetric(
          horizontal: 5.pw,
          vertical: 5.pw,
        ),
        child: leadingImage,
      );
    } else {
      leadingImage = Icon(
        Icons.info_outline,
      );
    }
    return ParentOverlayNotificationWidget(
      child: Row(
        children: [
          leadingImage,
          AppDimensionsNew.getHorizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColorsNew.notificationTitleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.dp,
                  ),
                ),
                subTitle == null
                    ? SizedBox.shrink()
                    : Text(
                        subTitle,
                        style: TextStyle(
                          color: AppColorsNew.notificationTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 8.dp,
                        ),
                      ),
              ],
            ),
          ),
          AppDimensionsNew.getHorizontalSpace(8),
          IconButton(
            icon: Icon(
              Icons.cancel_rounded,
              color: AppColorsNew.notificationIconColor,
            ),
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
          ),
        ],
      ),
    );
  }
}

class OverlayRabbitHuntNotificationWidget extends StatelessWidget {
  final List<int> playerCards;
  final List<int> boardCards;
  final List<int> revealedCards;
  final String name;
  final int handNo;

  OverlayRabbitHuntNotificationWidget({
    @required this.name,
    @required this.handNo,
    @required this.playerCards,
    @required this.boardCards,
    @required this.revealedCards,
  });

  List<CardObject> _getCards() {
    List<CardObject> cards = [];

    for (int c in boardCards) {
      final CardObject co = CardHelper.getCard(c);
      co.cardType = CardType.HandLogOrHandHistoryCard;

      if (revealedCards.contains(c)) co.highlight = true;

      cards.add(co);
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return ParentOverlayNotificationWidget(
      child: Row(
        children: [
          // icon
          SvgPicture.asset(
            AppAssets.rabbit,
            height: 24.pw,
            width: 24.pw,
            color: Colors.white,
          ),

          // sep
          AppDimensionsNew.getHorizontalSpace(8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // hand number
                Text(
                  'Hand #$handNo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColorsNew.notificationTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 8.dp,
                  ),
                ),

                // cards
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      // player cards
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name),
                          StackCardView00(cards: playerCards),
                        ],
                      ),

                      // spacer
                      Spacer(),

                      // community cards
                      Column(
                        children: [
                          Text('Community'),
                          StackCardView(
                            cards: _getCards(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // sep
          AppDimensionsNew.getHorizontalSpace(8),

          // cancel button
          IconButton(
            icon: Icon(
              Icons.cancel_rounded,
              color: AppColorsNew.notificationIconColor,
            ),
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
          ),
        ],
      ),
    );
  }
}

class OverlayHighHandNotificationWidget extends StatelessWidget {
  final List<int> playerCards;
  final List<int> boardCards;
  final List<int> highHandCards;
  final String name;
  final int handNo;

  OverlayHighHandNotificationWidget({
    @required this.playerCards,
    @required this.boardCards,
    @required this.highHandCards,
    @required this.name,
    @required this.handNo,
  });

  List<CardObject> _getCards() {
    List<CardObject> cards = [];

    for (final card in boardCards) {
      final CardObject co = CardHelper.getCard(card);
      co.cardType = CardType.HandLogOrHandHistoryCard;
      if (highHandCards.contains(card)) co.highlight = true;
      cards.add(co);
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return ParentOverlayNotificationWidget(
      child: Row(
        children: [
          // icon
          SvgPicture.asset(
            AppAssets.highHand,
            height: 24.pw,
            width: 24.pw,
            color: Colors.white,
          ),

          // sep
          AppDimensionsNew.getHorizontalSpace(8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // hand number
                Text(
                  'Hand #$handNo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColorsNew.notificationTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 8.dp,
                  ),
                ),

                // cards
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      // player cards
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name),
                          StackCardView00(cards: playerCards),
                        ],
                      ),

                      // spacer
                      Spacer(),

                      // community cards
                      Column(
                        children: [
                          Text('Community'),
                          StackCardView(cards: _getCards()),
                        ],
                      ),
                    ],
                  ),
                ),

                // sep
                AppDimensionsNew.getVerticalSizedBox(5.0),

                // high hand cards
                Column(
                  children: [
                    Text('High Hand Cards'),
                    StackCardView00(cards: highHandCards),
                  ],
                ),
              ],
            ),
          ),

          // sep
          AppDimensionsNew.getHorizontalSpace(8),

          // cancel button
          IconButton(
            icon: Icon(
              Icons.cancel_rounded,
              color: AppColorsNew.notificationIconColor,
            ),
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
          ),
        ],
      ),
    );
  }
}

class OverlayRunItTwice extends StatelessWidget {
  static void showPrompt({
    @required GameState gameState,
    @required GameContextObject gameContextObject,
    @required final int expiresAtInSeconds,
    @required final BuildContext context,
  }) {
    showOverlayNotification(
      (context) => OverlayRunItTwice(
        expiresAtInSeconds: expiresAtInSeconds,
        gameContextObject: gameContextObject,
        gameState: gameState,
      ),
      duration: Duration(seconds: expiresAtInSeconds),
      context: context,
      position: NotificationPosition.bottom,
    );
  }

  final int expiresAtInSeconds;
  final GameState gameState;
  final GameContextObject gameContextObject;

  const OverlayRunItTwice({
    @required this.gameState,
    @required this.gameContextObject,
    @required this.expiresAtInSeconds,
  });

  void _handleButtonTaps({
    @required bool isYes,
    @required BuildContext context,
  }) {
    final String playerAction =
        isYes ? AppConstants.RUN_IT_TWICE_YES : AppConstants.RUN_IT_TWICE_NO;

    /* if we are in testing mode just return from this function */
    if (TestService.isTesting) {
      // dismiss the prompt
      OverlaySupportEntry.of(context).dismiss();
      return;
    }

    // final gameContextObj = context.read<GameContextObject>();
    // final gameState = context.read<GameState>();
    log('RunItTwice: action: $playerAction');
    /* send the player action, as PLAYER_ACTED message: RUN_IT_TWICE_YES or RUN_IT_TWICE_NO */
    HandActionProtoService.takeAction(
      gameState: gameState,
      gameContextObject: gameContextObject,
      action: playerAction,
    );

    // dismiss the prompt
    OverlaySupportEntry.of(context).dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = context.read<AppTheme>();
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10.0,
        left: 5.0,
        right: 5.0,
      ),
      child: ParentOverlayNotificationWidget(
        isDismissible: false,
        child: Row(
          children: [
            // count down timer
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Countdown(
                seconds: expiresAtInSeconds,
                onFinished: () {
                  Navigator.pop(context);
                },
                build: (_, timeLeft) {
                  if (timeLeft == 0) {
                    HandActionProtoService.takeAction(
                      gameState: gameState,
                      gameContextObject: gameContextObject,
                      action: AppConstants.RUN_IT_TWICE_NO,
                    );
                  }
                  return Text(
                    //DataFormatter.timeFormatMMSS(timeLeft),
                    timeLeft.toInt().toString(),
                    style: TextStyle(color: Colors.red, fontSize: 13.dp),
                  );
                },
              ),
            ),

            // run it twice text
            Expanded(
              flex: 3,
              child: Text(
                'Run it twice?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.dp),
              ),
            ),

            // finally yes / no buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /* true button */
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.check_circle_outline_sharp,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _handleButtonTaps(isYes: true, context: context);
                  },
                ),

                /* no button */
                IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _handleButtonTaps(isYes: false, context: context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OverlayStraddle extends StatelessWidget {
  static void showPrompt({
    @required GameState gameState,
    @required GameContextObject gameContextObject,
    @required final int expiresAtInSeconds,
    @required final BuildContext context,
  }) {
    showOverlayNotification(
      (context) => OverlayStraddle(
        expiresAtInSeconds: expiresAtInSeconds,
        gameContextObject: gameContextObject,
        gameState: gameState,
      ),
      duration: Duration(seconds: expiresAtInSeconds),
      context: context,
      position: NotificationPosition.bottom,
    );
  }

  final int expiresAtInSeconds;
  final GameState gameState;
  final GameContextObject gameContextObject;

  const OverlayStraddle({
    @required this.gameState,
    @required this.gameContextObject,
    @required this.expiresAtInSeconds,
  });

  void _handleButtonTaps({
    @required bool isYes,
    @required BuildContext context,
  }) {
    gameState.straddlePrompt = false;
    gameState.straddlePromptState.notify();
    OverlaySupportEntry.of(context).dismiss();
    /* if we are in testing mode just return from this function */
    if (TestService.isTesting) {
      // dismiss the prompt
      return;
    }

    if (isYes) {
      // straddle
      HandActionProtoService.takeAction(
        gameContextObject: gameContextObject,
        gameState: gameState,
        action: AppConstants.STRADDLE,
        amount: 2.0 * gameState.gameInfo.bigBlind,
      );
    } else {
      // don't straddle
      gameState.showAction(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10.0,
        left: 5.0,
        right: 5.0,
      ),
      child: ParentOverlayNotificationWidget(
          isDismissible: false,
          child: Column(children: [
            Row(
              children: [
                // count down timer
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Countdown(
                    seconds: expiresAtInSeconds,
                    onFinished: () {
                      OverlaySupportEntry.of(context).dismiss();
                      // Navigator.pop(context);
                    },
                    build: (_, timeLeft) {
                      if (timeLeft == 0) {
                        // no straddle
                      }
                      return Text(
                        //DataFormatter.timeFormatMMSS(timeLeft),
                        timeLeft.toInt().toString(),
                        style: TextStyle(color: Colors.red, fontSize: 13.dp),
                      );
                    },
                  ),
                ),

                // run it twice text
                Expanded(
                  flex: 3,
                  child: Text(
                    'Straddle?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.dp),
                  ),
                ),

                // finally yes / no buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /* true button */
                    IconButton(
                      iconSize: 35.0,
                      icon: Icon(
                        Icons.check_circle_outline_sharp,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _handleButtonTaps(isYes: true, context: context);
                      },
                    ),

                    /* no button */
                    IconButton(
                      iconSize: 35.0,
                      icon: Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _handleButtonTaps(isYes: false, context: context);
                      },
                    ),
                  ],
                ),
              ],
            ),

            RadioToggleButtonsWidget<String>(
              onSelect: (int index) {
                // if (index == 0) {
                //   gmp.chipUnit = ChipUnit.DOLLAR;
                // } else {
                //   gmp.chipUnit = ChipUnit.CENT;
                // }
              },
              // defaultValue: gmp.chipUnit == ChipUnit.DOLLAR ? 0 : 1,
              defaultValue: 0,
              values: [
                'Auto Straddle',
                'Ask Everytime',
                'Straddle Off',
              ],
            ),
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //   RoundRectButton(
            //     onTap: () {
            //       gameState.straddlePrompt = false;
            //       gameState.straddlePromptState.notify();
            //       // straddle this hand and auto straddle
            //       OverlaySupportEntry.of(context).dismiss();
            //       gameState.playerSettings.autoStraddle = true;
            //       gameState.playerLocalConfig.straddle = true;

            //       HandActionProtoService.takeAction(
            //         gameContextObject: gameContextObject,
            //         gameState: gameState,
            //         action: AppConstants.STRADDLE,
            //         amount: 2.0 * gameState.gameInfo.bigBlind,
            //       );
            //     },
            //     theme: theme,
            //     text: 'Auto Straddle',
            //     negative: true,
            //   ),
            //   RoundRectButton(
            //     onTap: () {
            //       // don't straddle
            //       gameState.straddlePrompt = false;
            //       gameState.straddlePromptState.notify();
            //       OverlaySupportEntry.of(context).dismiss();
            //       gameState.playerSettings.autoStraddle = false;
            //       gameState.playerLocalConfig.straddle = false;

            //       // don't straddle
            //       gameState.showAction(true);
            //     },
            //     theme: theme,
            //     text: 'Straddle Off',
            //     negative: true,
            //   ),
            // ])
          ])),
    );
  }
}
