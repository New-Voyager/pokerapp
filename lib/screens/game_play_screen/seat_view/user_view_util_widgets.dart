import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

import 'action_status.dart';
import 'animating_widgets/chip_amount_animating_widget.dart';
import 'chip_amount_widget.dart';
import 'count_down_timer.dart';

class UserViewUtilWidgets {
  UserViewUtilWidgets._();

  /* highlight color --> const Color(0xfff2a365); */
  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

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
    @required Seat seat,
    Alignment cardsAlignment,
  }) {
    if (seat.isOpen) {
      return SizedBox.shrink();
    }

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
                              cards: seat.player.cards?.map<CardObject>(
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
          child: ActionStatusWidget(seat, cardsAlignment),
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
          visible: boardAttrObj.isOrientationHorizontal ? false : true,
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

  static Widget buildChipAmountWidget1({
    @required Seat seat,
  }) {
    seat.seatBet.uiKey = GlobalKey();

    Widget chipAmountWidget = Consumer<BoardAttributesObject>(
      builder: (_, boardAttrObj, __) => Transform.translate(
        offset: boardAttrObj.chipAmountWidgetOffsetMapping[seat.serverSeatPos],
        child: Row(
          key: seat.seatBet.uiKey,
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
                seatPos: seat.serverSeatPos,
                child: chipAmountWidget,
                reverse: seat.player.animatingCoinMovementReverse,
              )
            : chipAmountWidget;
  }

  static Widget buildChipAmountWidget({
    @required BuildContext context,
    @required Seat seat,
  }) {
    if (seat.player?.coinAmount == null || seat.player?.coinAmount == 0)
      return shrinkedSizedBox;

    seat.seatBet.uiKey = GlobalKey();
    Widget chipAmountWidget = ChipAmountWidget(
      key: seat.seatBet.uiKey,
      seat: seat,
    );

    // /* after the widgets are drawn get their positions */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = GameState.getState(context);
      final boardAttributes = gameState.getBoardAttributes(context);
      final RenderBox potView =
          boardAttributes.getPotsKey(0).currentContext.findRenderObject();
      final globalPos = potView.localToGlobal(Offset(0, 0));
      final RenderBox renderBox =
          seat.seatBet.uiKey.currentContext.findRenderObject();
      final potViewPos = renderBox.globalToLocal(globalPos);
      final pos = renderBox.localToGlobal(Offset(0, 0));
      seat.seatBet.potViewPos = potViewPos;
      log('Seat: ${seat.serverSeatPos}, pos: $pos potView: $potViewPos');
    });

    //if (seat.serverSeatPos != 9) return chipAmountWidget;

    return (seat.player.animatingCoinMovement ?? false)
        ? ChipAmountAnimatingWidget(
            seatPos: seat.serverSeatPos,
            child: chipAmountWidget,
            reverse: seat.player.animatingCoinMovementReverse,
          )
        : chipAmountWidget;
  }
}
