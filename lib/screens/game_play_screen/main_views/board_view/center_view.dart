import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';

import 'board_view_util_methods.dart';

class CenterView extends StatelessWidget {
  static const _cardDistributionAnimationWidgetOffset = const Offset(0.0, 30.0);
  static const _noOffset = const Offset(0.0, 0.0);
  final String tableStatus;
  final List<CardObject> cards;
  final List<int> potChips;
  final Function onStartGame;
  final bool showDown;
  final bool isBoardHorizontal;
  final double potChipsUpdates;

  CenterView(this.isBoardHorizontal, this.cards, this.potChips,
      this.potChipsUpdates, this.tableStatus, this.showDown, this.onStartGame);

  @override
  Widget build(BuildContext context) {
    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);

    /* in case of new hand, show the deck shuffling animation */
    if (_text == AppConstants.NEW_HAND)
      return Transform.scale(
        scale: 1,
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
    dynamic potChips = this.potChips;
    dynamic cards = this.cards;
    if (potChips == null) potChips = [0];
    if (cards == null) cards = const [];

    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PotsView(this.isBoardHorizontal, this.potChips, this.showDown),
          CommunityCardsView(
            cards: cards,
            horizontal: true,
          ),
          const SizedBox(height: AppDimensions.cardHeight / 4),

          /* potUpdates view */
          this.showDown ? rankWidget() : potUpdatesView(),
        ],
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

  Widget potUpdatesView() {
    if (potChipsUpdates == null) {
      return SizedBox.shrink();
    }
    return Opacity(
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
            'Pot: ${DataFormatter.chipsFormat(potChipsUpdates)}',
            style: AppStyles.itemInfoTextStyleHeavy.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget rankWidget() {
    return /* rankStr --> needs to be shown only when footer result is not null */
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
    );
  }
}
