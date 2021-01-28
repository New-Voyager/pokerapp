import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view_util_methods.dart';
import 'package:provider/provider.dart';

/* collection of the widgets used by board_view widget */
class BoardViewUtilWidgets {
  static const _cardDistributionAnimationWidgetOffset = const Offset(0.0, 30.0);
  static const _noOffset = const Offset(0.0, 0.0);

  static Widget buildCenterView({
    @required bool isBoardHorizontal,
    List<CardObject> cards,
    List<int> potChips,
    int potChipsUpdates,
    String tableStatus,
    bool showDown = false,
    Function onStartGame,
  }) {
    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);

    /* in case of new hand, show the deck shuffling animation */
    if (_text == AppConstants.NEW_HAND)
      return Transform.scale(
        scale: 1.5,
        child: Transform.translate(
          offset: isBoardHorizontal
              ? _cardDistributionAnimationWidgetOffset
              : _noOffset,
          child: AnimatingShuffleCardView(),
        ),
      );

    Widget tableStatusWidget = Align(
      key: ValueKey('tableStatusWidget'),
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: isBoardHorizontal
            ? const Offset(0.0, 50.0)
            : const Offset(0.0, 0.0),
        child: GestureDetector(
          onTap: () {
            if (tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
              onStartGame();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.black26,
            ),
            child: Text(
              _text ?? '',
              style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );

    /* if reached here, means, the game is RUNNING */
    /* The following view, shows the community cards
    * and the pot chips, if they are nulls, put the default values */

    if (potChips == null) potChips = [0];
    if (cards == null) cards = const [];

    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
      alignment: Alignment.topCenter,
      child: FittedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* rankStr --> needs to be shown only when footer result is not null */
            Consumer<FooterResult>(
              builder: (_, FooterResult footerResult, __) => AnimatedSwitcher(
                duration: AppConstants.animationDuration,
                reverseDuration: AppConstants.animationDuration,
                child: footerResult.isEmpty
                    ? const SizedBox.shrink()
                    : Transform.translate(
                        offset: Offset(
                          0.0,
                          -AppDimensions.cardHeight / 2,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.black26,
                          ),
                          child: Text(
                            footerResult.potWinners.first.rankStr,
                            style: AppStyles.footerResultTextStyle4,
                          ),
                        ),
                      ),
              ),
            ),

            // pot value
            Opacity(
              opacity: showDown ? 0 : 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.black26,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // chip image
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/chips.png',
                        height: 25.0,
                      ),
                    ),

                    // pot amount text
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                        top: 5.0,
                        bottom: 5.0,
                        left: 5.0,
                      ),
                      child: Text(
                        'Pot: ${potChips[0]}', // todo: at later point might need to show multiple pots - need to design UI
                        style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // card stacks
            StackCardView(
              cards: cards,
              isCommunity: true,
            ),

            const SizedBox(height: AppDimensions.cardHeight / 2),

            const SizedBox(height: AppDimensions.cardHeight / 3),

            /* potUpdates view */
            Opacity(
              opacity: showDown || (potChipsUpdates == null) ? 0 : 1,
              child: Visibility(
                visible: potChipsUpdates != null && potChipsUpdates != 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.black26,
                  ),
                  child: Text(
                    'Current: $potChipsUpdates',
                    style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return AnimatedSwitcher(
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      duration: AppConstants.animationDuration,
      reverseDuration: AppConstants.animationDuration,
      child: _text != null ? tableStatusWidget : tablePotAndCardWidget,
    );
  }
}
