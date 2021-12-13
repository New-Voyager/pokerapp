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
          isDismissible ? DismissDirection.horizontal : DismissDirection.none,
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
    @required final int expiresAtInSeconds,
    @required final BuildContext context,
  }) {
    showOverlayNotification(
      (context) => OverlayRunItTwice(expiresAtInSeconds: expiresAtInSeconds),
      duration: Duration(seconds: expiresAtInSeconds),
      context: context,
      position: NotificationPosition.bottom,
    );
  }

  final int expiresAtInSeconds;

  const OverlayRunItTwice({
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
      return;
    }

    final gameContextObj = context.read<GameContextObject>();
    final gameState = context.read<GameState>();

    /* send the player action, as PLAYER_ACTED message: RUN_IT_TWICE_YES or RUN_IT_TWICE_NO */
    HandActionProtoService.takeAction(
      gameState: gameState,
      gameContextObject: gameContextObj,
      action: playerAction,
    );

    // dismiss the prompt
    OverlaySupportEntry.of(context).dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return ParentOverlayNotificationWidget(
      isDismissible: false,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
        decoration: AppDecorators.bgRadialGradient(theme).copyWith(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.accentColor, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* show count down timer */
            Countdown(
              seconds: expiresAtInSeconds,
              onFinished: () {
                Navigator.pop(context);
              },
              build: (_, timeLeft) {
                return Text(
                  DataFormatter.timeFormatMMSS(timeLeft),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.dp,
                  ),
                );
              },
            ),

            // sep
            SizedBox(height: 15.ph),
            Text(
              'Do you want to run it twice?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.dp),
            ),
            // sep
            SizedBox(height: 15.ph),

            /* yes / no button */
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* no button */
                  RoundRectButton(
                    onTap: () {
                      _handleButtonTaps(isYes: false, context: context);
                    },
                    text: "No",
                    theme: theme,
                    icon: Icon(
                      Icons.cancel,
                      color: theme.accentColor,
                    ),
                  ),

                  /* divider */
                  const SizedBox(width: 10.0),

                  /* true button */
                  RoundRectButton(
                    onTap: () {
                      _handleButtonTaps(isYes: true, context: context);
                    },
                    text: "Yes",
                    theme: theme,
                    icon: Icon(
                      Icons.check,
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
