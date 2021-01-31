import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/animating_widgets/chip_amount_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/animating_widgets/fold_card_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/count_down_timer.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/dealer_button.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view_util_methods.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class UserViewUtilWidgets {
  UserViewUtilWidgets._();

  /* highlight color --> const Color(0xfff2a365); */
  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

  // TODO: this is only needed for the DEBUGGING Purpose
  static Widget buildSeatNoIndicator({
    @required UserObject userObject,
  }) =>
      Positioned(
        bottom: 0,
        left: 0,
        child: Transform.translate(
          offset: const Offset(0.0, -15.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xff474747),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xff14e81b),
                width: 1.0,
              ),
            ),
            child: Text(
              userObject.serverSeatPos.toString(),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  // the following two widgets are only built for the current active player
  static Widget buildVisibleCard({
    List<CardObject> cards,
    @required playerFolded,
  }) =>
      Transform.scale(
        scale: 1.7,
        child: Transform.translate(
          offset: Offset(
            0.0,
            80.0,
          ),
          child: StackCardView(
            cards: cards,
            deactivated: playerFolded ?? false,
          ),
        ),
      );

  // this widget is only shown to the dealer
  static Widget buildDealerButton({
    int seatPos,
    Alignment alignment,
    bool isMe,
    GameType gameType,
  }) {
    return new DealerButtonWidget(seatPos, isMe, gameType);
  }

  static Widget buildDealerButton1({
    Alignment alignment,
    bool isMe,
  }) {
    dynamic pos = alignment == Alignment.centerRight ? 0.0 : 50.0;

    if (isMe) {
      pos = -50.0;
    }
    return Transform.translate(
      offset: Offset(
        pos,
        -15.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              blurRadius: 2.0,
              spreadRadius: 2.0,
            )
          ],
        ),
        child: const Text(
          'D',
          textAlign: TextAlign.center,
          style: AppStyles.dealerTextStyle,
        ),
      ),
    );
  }

  /* if the footer status becomes footer result
  * then we need to show the user cards
  * as it's a show down time */

  static Widget buildHiddenCard({
    Alignment alignment,
    bool emptySeat = true,
    int cardNo = 0,
    @required int seatPos,
    @required UserObject userObject,
  }) =>
      Consumer<ValueNotifier<FooterStatus>>(
        builder: (_, valueNotifierFooterStatus, __) {
          bool showDown =
              valueNotifierFooterStatus.value == FooterStatus.Result;

          double shiftMultiplier = 1.0;

          if (cardNo == 5) shiftMultiplier = 1.7;
          if (cardNo == 4) shiftMultiplier = 1.45;
          if (cardNo == 3) shiftMultiplier = 1.25;

          double xOffset;
          if (showDown)
            xOffset = (alignment == Alignment.centerLeft ? 1 : -1) *
                25.0 *
                (userObject.cards?.length ?? 0.0);
          else
            xOffset = (alignment == Alignment.centerLeft
                ? 35.0
                : -45.0 * shiftMultiplier);

          return Transform.translate(
            offset: Offset(
              xOffset * 0.50,
              45.0,
            ),
            child: AnimatedSwitcher(
              duration: AppConstants.fastAnimationDuration,
              child: Transform.scale(
                scale: 1.0,
                child: (userObject.playerFolded ?? false)
                    ? FoldCardAnimatingWidget(
                        seatPos: seatPos,
                        userObject: userObject,
                      )
                    : showDown
                        ? const SizedBox.shrink()
                        : HiddenCardView(
                            noOfCards: cardNo,
                          ),
              ),
            ),
          );
        },
      );

  static Widget buildTimer({
    int time = 10,
    BuildContext context,
    @required UserObject userObject,
  }) {
    int remainingTime = Provider.of<RemainingTime>(
      context,
      listen: false,
    ).getRemainingTime();

    if (remainingTime == null) remainingTime = time;

    return Consumer<BoardAttributesObject>(
      builder: (_, boardAttObj, __) => Positioned(
        top: boardAttObj.isOrientationHorizontal ? 15.0 : 0.0,
        right: 0.0,
        child: AnimatedSwitcher(
          duration: AppConstants.fastAnimationDuration,
          reverseDuration: AppConstants.fastAnimationDuration,
          switchOutCurve: Curves.bounceInOut,
          switchInCurve: Curves.bounceInOut,
          child: userObject.highlight ?? false
              ? Transform.translate(
                  offset: const Offset(15.0, -0.0),
                  child: Transform.scale(
                    scale: 0.80,
                    child: CountDownTimer(
                      remainingTime: remainingTime,
                    ),
                  ),
                )
              : shrinkedSizedBox,
        ),
      ),
    );
  }

  static Widget buildAvatarAndLastAction({
    String avatarUrl,
    bool emptySeat,
    @required UserObject userObject,
    Alignment cardsAlignment,
  }) =>
      Stack(
        alignment: Alignment.center,
        children: [
          /* displaying the avatar view */
          Consumer<ValueNotifier<FooterStatus>>(
            builder: (_, valueNotifierFooterStatus, __) {
              bool showDown =
                  valueNotifierFooterStatus.value == FooterStatus.Result;

              Widget avatarWidget = AnimatedOpacity(
                duration: AppConstants.animationDuration,
                curve: Curves.bounceInOut,
                opacity: emptySeat ? 0.0 : 0.90,
                child: Consumer<BoardAttributesObject>(
                  builder: (_, boardAttrObj, __) => Visibility(
                    visible:
                        boardAttrObj.isOrientationHorizontal ? false : true,
                    child: AnimatedContainer(
                      duration: AppConstants.fastAnimationDuration,
                      curve: Curves.bounceInOut,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                          color: userObject.highlight ?? false
                              ? highlightColor
                              : Colors.transparent,
                        ),
                        boxShadow: userObject.highlight ?? false
                            ? [
                                BoxShadow(
                                  color: highlightColor.withAlpha(120),
                                  blurRadius: 20.0,
                                  spreadRadius: 20.0,
                                ),
                              ]
                            : [],
                      ),
                      child: CircleAvatar(
                        radius: 19.50,
                        backgroundImage: AssetImage(
                          avatarUrl ?? 'assets/images/2.png',
                        ),
                      ),
                    ),
                  ),
                ),
              );

              return Container(
                height: 19.50 * 3,
                child: AnimatedSwitcher(
                  duration: AppConstants.fastAnimationDuration,
                  child: showDown &&
                          (userObject.cards != null &&
                              userObject.cards.isNotEmpty)
                      ? (userObject?.isMe ?? false)
                          ? avatarWidget
                          : Transform.scale(
                              scale: 0.70,
                              child: StackCardView(
                                cards: userObject.cards?.map(
                                      (int c) {
                                        List<int> highlightedCards =
                                            userObject.highlightCards;
                                        CardObject card = CardHelper.getCard(c);

                                        card.smaller = true;
                                        if (highlightedCards?.contains(c) ??
                                            false) card.highlight = true;

                                        return card;
                                      },
                                    )?.toList() ??
                                    [],
                              ),
                            )
                      : avatarWidget,
                ),
              );
            },
          ),

          /* showing the user last action */
          // showing user status
          Transform.translate(
            offset: Offset(
              (cardsAlignment == Alignment.centerRight ||
                      cardsAlignment == Alignment.bottomCenter)
                  ? -15
                  : 15,
              10.0,
            ),
            child: UserViewUtilWidgets.buildUserStatus(
              emptySeat: emptySeat,
              userObject: userObject,
            ),
          ),
        ],
      );

  static Widget buildPlayerInfo({
    String name,
    int chips,
    bool emptySeat,
    @required UserObject userObject,
    bool isPresent,
  }) {
    /* changing background color as per last action
    * check/call -> green
    * raise/bet -> shade of yellow / blue might b? */

    Color statusColor = const Color(0xff474747); // default color
    Color boxColor = const Color(0xff474747); // default color

    String status = userObject.status;
    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }
    dynamic borderColor = Colors.black12;
    if (userObject != null &&
        userObject.highlight != null &&
        userObject.highlight) {
      borderColor = highlightColor;
    } else if (status != null) {
      borderColor = statusColor;
    }
    return Transform.translate(
      offset: Offset(0.0, -10.0),
      child: Container(
        // FIXME: the animation is causing to crash
//          duration: AppConstants.fastAnimationDuration,
//          curve: Curves.bounceInOut,
        width: 70.0,
        padding: (emptySeat && !isPresent)
            ? const EdgeInsets.all(10.0)
            : const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 5.0,
              ),
        decoration: BoxDecoration(
          borderRadius: emptySeat ? null : BorderRadius.circular(5.0),
          shape: emptySeat ? BoxShape.circle : BoxShape.rectangle,
          color: boxColor,
          border: Border.all(
            // color: userObject.highlight ?? false
            //     ? highlightColor
            //     : Colors.transparent,
            color: borderColor,
            width: 2.0,
          ),
          boxShadow: (userObject.winner ?? false)
              ? [
                  BoxShadow(
                    color: Colors.lightGreen,
                    blurRadius: 50.0,
                    spreadRadius: 20.0,
                  ),
                ]
              : userObject.highlight ?? false
                  ? [
                      BoxShadow(
                        color: highlightColor.withAlpha(120),
                        blurRadius: 20.0,
                        spreadRadius: 20.0,
                      ),
                    ]
                  : [],
        ),
        child: AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          reverseDuration: AppConstants.animationDuration,
          child: (emptySeat && !isPresent)
              ? Container(
                  child: InkWell(
                  child: Text(
                    'Open',
                    style: AppStyles.openSeatTextStyle,
                  ),
                ))
              : AnimatedOpacity(
                  duration: AppConstants.animationDuration,
                  opacity: emptySeat ? 0.0 : 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        child: Text(
                          name?.toUpperCase() ?? 'name',
                          style: AppStyles.gamePlayScreenPlayerName,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      FittedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // chip asset image
                            Image.asset(
                              'assets/images/chips.png',
                              height: 13.0,
                            ),

                            const SizedBox(width: 5.0),

                            Text(
                              chips?.toString() ?? 'XX',
                              style: AppStyles.gamePlayScreenPlayerChips,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  static Widget buildUserStatus({
    @required bool emptySeat,
    @required UserObject userObject,
  }) {
    /* The status message is not shown, if
    * 1. The seat is empty - nothing to show
    * 2. The current user is to act - the current user is highlighted */
    if (emptySeat || userObject.highlight) return shrinkedSizedBox;

    String status;

    if (userObject.status != null && userObject.status.isNotEmpty)
      status = userObject.status;

    if (userObject.status == AppConstants.WAIT_FOR_BUYIN)
      status = 'Waiting for Buy In';

    if (userObject.buyIn != null) status = 'Buy In ${userObject.buyIn} amount';

    if (userObject.status == AppConstants.PLAYING) status = null;

    // decide color from the status message
    // raise, bet -> red
    // check, call -> green

    return AnimatedSwitcher(
      duration: AppConstants.popUpAnimationDuration,
      reverseDuration: AppConstants.popUpAnimationDuration,
      switchInCurve: Curves.bounceInOut,
      switchOutCurve: Curves.bounceInOut,
      transitionBuilder: (widget, animation) => ScaleTransition(
        alignment: Alignment.topCenter,
        scale: animation,
        child: widget,
      ),
      child: status == null
          ? shrinkedSizedBox
          : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Text(
                status,
                style: UserViewUtilMethods.getStatusTextStyle(status),
              ),
            ),
    );
  }

  static Widget buildChipAmountWidget({
    @required int seatPos,
    @required UserObject userObject,
  }) {
    // to debug coin position
    //userObject.coinAmount = 10;

    Widget chipAmountWidget = Consumer<BoardAttributesObject>(
      builder: (_, boardAttrObj, __) => Transform.translate(
        offset: boardAttrObj.chipAmountWidgetOffsetMapping[seatPos],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* show the coin svg */
            Container(
              height: 20,
              width: 20.0,
              child: SvgPicture.asset(
                AppAssets.coinsImages,
              ),
            ),
            const SizedBox(height: 5.0),

            /* show the coin amount */
            Text(
              userObject.coinAmount.toString(),
              style: AppStyles.gamePlayScreenPlayerChips,
            ),
          ],
        ),
      ),
    );

    return userObject.coinAmount == null || userObject.coinAmount == 0
        ? shrinkedSizedBox
        : (userObject.animatingCoinMovement ?? false)
            ? ChipAmountAnimatingWidget(
                seatPos: seatPos,
                child: chipAmountWidget,
                reverse: userObject.animatingCoinMovementReverse,
              )
            : chipAmountWidget;
  }
}
