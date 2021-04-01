import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/hand_result.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';

import 'board_view_util_methods.dart';

class CenterView extends StatelessWidget {
  final String tableStatus;
  final List<CardObject> cards;
  final List<int> potChips;
  final Function onStartGame;
  final bool showDown;
  final bool isBoardHorizontal;
  final double potChipsUpdates;
  final bool isHost;
  final String gameCode;

  CenterView(
      this.gameCode,
      this.isHost,
      this.isBoardHorizontal,
      this.cards,
      this.potChips,
      this.potChipsUpdates,
      this.tableStatus,
      this.showDown,
      this.onStartGame);

  @override
  Widget build(BuildContext context) {
    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);
    //log('board_view : center_view : _text : $_text');

    /* if the game is paused, show the options available during game pause */
    if (_text == AppConstants.GAME_PAUSED ||
        tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
      return CenterButtonView(
        gameCode: this.gameCode,
        isHost: this.isHost,
        tableStatus: this.tableStatus,
        onStartGame: this.onStartGame,
      );
    }

    /* in case of new hand, show the deck shuffling animation */
    if (_text == AppConstants.NEW_HAND)
      return Transform.scale(
        scale: 1.2,
        child: AnimatingShuffleCardView(),
      );

    // TODO: We don't need this
    // We need to show the status of the in the game banner at the top
    Widget tableStatusWidget = Align(
      key: ValueKey('tableStatusWidget'),
      alignment: Alignment.center,
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
    );

    /* this gap height is the separation height between the three widgets in the center pot */
    const _gapHeight = 5.0;

    /* if reached here, means, the game is RUNNING */
    /* The following view, shows the community cards
    * and the pot chips, if they are nulls, put the default values */
    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* main pot view */
          PotsView(
            this.isBoardHorizontal,
            this.potChips,
            this.showDown,
          ),
          const SizedBox(
            height: _gapHeight,
          ),

          /* community cards view */
          CommunityCardsView(
            cards: this.cards,
            horizontal: true,
          ),
          const SizedBox(height: _gapHeight + AppDimensions.cardHeight / 4),

          /* potUpdates view OR the rank widget (rank widget is shown only when we have a result) */
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

    // empty container
    //return Container();
  }

  Widget potUpdatesView() => Opacity(
        opacity: showDown || (potChipsUpdates == null || potChipsUpdates == 0)
            ? 0
            : 1,
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
      );

  /* rankStr --> needs to be shown only when footer result is not null */
  Widget rankWidget() => Consumer<HandResultState>(
        builder: (_, HandResultState result, __) => AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          reverseDuration: AppConstants.animationDuration,
          child: !result.isAvailable
              ? const SizedBox.shrink()
              : Transform.translate(
                  offset: Offset(
                    0.0,
                    -AppDimensions.cardHeight / 2,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.black26,
                    ),
                    child: Text(
                      result.potWinners.first.rankStr,
                      style: AppStyles.footerResultTextStyle4,
                    ),
                  ),
                ),
        ),
      );
}
