import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

import 'animating_widgets/chip_amount_animating_widget.dart';
import 'animating_widgets/fold_card_animating_widget.dart';
import 'count_down_timer.dart';
import 'dealer_button.dart';
import 'user_view_util_methods.dart';

class UserViewUtilWidgets {
  UserViewUtilWidgets._();

  /* highlight color --> const Color(0xfff2a365); */
  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

  // TODO: this is only needed for the DEBUGGING Purpose
  static Widget buildSeatNoIndicator({
    @required Seat seat,
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
              seat.serverSeatPos.toString(),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
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

  /* if the footer status becomes footer result
  * then we need to show the user cards
  * as it's a show down time */

  static Widget buildHiddenCard({
    Alignment alignment,
    bool emptySeat = true,
    int cardNo = 0,
    @required int seatPos,
    @required Seat seat,
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
                (seat.cards?.length ?? 0.0);
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
                child: (seat.folded ?? false)
                    ? FoldCardAnimatingWidget(
                        seatPos: seatPos,
                        seat: seat,
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
    @required Seat seat,
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
          child: seat.player?.highlight ?? false
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
    @required Seat seat,
    Alignment cardsAlignment,
  }) {
      if (seat.isOpen) {
        return SizedBox.shrink();
      }
      //return SizedBox.shrink();

      return Stack(
        alignment: Alignment.center,
        children: [
          /* displaying the avatar view */
          Consumer<ValueNotifier<FooterStatus>>(
            builder: (_, valueNotifierFooterStatus, __) {
              bool showDown =
                  valueNotifierFooterStatus.value == FooterStatus.Result;

              Widget avatarWidget = avatar(seat);

              return Container(
                height: 19.50 * 3,
                child: AnimatedSwitcher(
                  duration: AppConstants.fastAnimationDuration,
                  child: showDown &&
                          (seat.player.cards != null &&
                              seat.player.cards.isNotEmpty)
                      ? (seat.isMe ?? false)
                          ? avatarWidget
                          : Transform.scale(
                              scale: 0.70,
                              child: StackCardView(
                                cards: seat.player.cards?.map(
                                      (int c) {
                                        List<int> highlightedCards =
                                            seat.player.highlightCards;
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
              seat: seat,
            ),
          ),
        ],
      );
  }

  static Widget avatar(Seat seat) {
      return AnimatedOpacity(
                duration: AppConstants.animationDuration,
                curve: Curves.bounceInOut,
                opacity: seat.isOpen ? 0.0 : 0.90,
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
                          color: seat.player?.highlight ?? false
                              ? highlightColor
                              : Colors.transparent,
                        ),
                        boxShadow: seat.player?.highlight ?? false
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
                          seat.player.avatarUrl ?? 'assets/images/2.png',
                        ),
                      ),
                    ),
                  ),
                ),
              );    
  }

  static Widget buildUserStatus({
    @required bool emptySeat,
    @required Seat seat,
  }) {
    /* The status message is not shown, if
    * 1. The seat is empty - nothing to show
    * 2. The current user is to act - the current user is highlighted */
    if (emptySeat || seat.player.highlight) return shrinkedSizedBox;

    String status;

    if (seat.player?.status != null && seat.player.status.isNotEmpty)
      status = seat.player.status;

    if (seat.player?.status == AppConstants.WAIT_FOR_BUYIN)
      status = 'Waiting for Buy In';

    if (seat.player.buyIn != null) status = 'Buy In ${seat.player.buyIn} amount';

    if (seat.player?.status == AppConstants.PLAYING) status = null;

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
    @required Seat seat,
  }) {
    // to debug coin position
    //userObject.coinAmount = 10;

    Widget chipAmountWidget = Consumer<BoardAttributesObject>(
      builder: (_, boardAttrObj, __) => Transform.translate(
        offset: boardAttrObj.chipAmountWidgetOffsetMapping[seatPos],
        child: Row(
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
              seat.player?.coinAmount.toString(),
              style: AppStyles.gamePlayScreenPlayerChips,
            ),
          ],
        ),
      ),
    );

    return seat.player?.coinAmount == null || seat.player?.coinAmount == 0
        ? shrinkedSizedBox
        : (seat.player.animatingCoinMovement ?? false)
            ? ChipAmountAnimatingWidget(
                seatPos: seatPos,
                child: chipAmountWidget,
                reverse: seat.player.animatingCoinMovementReverse,
              )
            : chipAmountWidget;
  }
}
