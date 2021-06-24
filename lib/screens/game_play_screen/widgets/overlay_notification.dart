import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

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
            border: Border.all(color: AppColorsNew.notificationIconColor)),
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
    return SlideDismissible(
      key: ValueKey("overlayNotification"),
      direction: DismissDirection.horizontal,
      child: SafeArea(
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 8.ph),
            decoration: BoxDecoration(
              color: AppColorsNew.notificationBackgroundColor,
              borderRadius: BorderRadius.circular(8.pw),
            ),
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
                      color: AppColorsNew.darkGreenShadeColor,
                    ),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ],
            ),
          ),
        ),
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
    return SlideDismissible(
      key: ValueKey("overlayNotification"),
      direction: DismissDirection.horizontal,
      child: SafeArea(
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 8.ph),
            decoration: BoxDecoration(
              color: AppColorsNew.notificationBackgroundColor,
              borderRadius: BorderRadius.circular(8.pw),
            ),
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
                      color: AppColorsNew.darkGreenShadeColor,
                    ),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
