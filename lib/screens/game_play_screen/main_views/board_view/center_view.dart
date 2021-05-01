import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/hand_result.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_cards_view/community_cards_view.dart';
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
      Key key,
      this.gameCode,
      this.isHost,
      this.isBoardHorizontal,
      this.cards,
      this.potChips,
      this.potChipsUpdates,
      this.tableStatus,
      this.showDown,
      this.onStartGame)
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);
    log('table status: $_text');
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
    if (_text == AppConstants.NEW_HAND) {
      // log('show shuffling');
      return Transform.scale(
        scale: 1.2,
        child: AnimatingShuffleCardView(),
      );
    }
    /* if reached here, means, the game is RUNNING */
    /* The following view, shows the community cards
    * and the pot chips, if they are nulls, put the default values */
    return centerView(context);
  }

  Widget multiplePots(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final boardAttributes = gameState.getBoardAttributes(context);
    List<Widget> pots = [];

    for (int i = 0; i < 1; i++) {
      GlobalKey key = GlobalKey();
      double potChipValue = 0;
      if (potChips != null && potChips.length > i)
        potChipValue = this.potChips[i].toDouble();

      final potsView = PotsView(
        this.isBoardHorizontal,
        potChipValue,
        this.showDown,
        key,
      );
      boardAttributes.setPotsKey(i, key);
      pots.add(potsView);
      pots.add(SizedBox(
        width: 5,
      ));
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: pots);
  }

  Widget centerView(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final boardAttributes = gameState.getBoardAttributes(context);
    final GlobalKey potsKey = GlobalKey();
    boardAttributes.setPotsKey(0, potsKey);

    boardAttributes.centerPotBetKey = GlobalKey();

    /* this gap height is the separation height between the three widgets in the center pot */
    const _gapHeight = 5.0;
    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        //mainAxisSize: MainAxisSize.min,
        children: [
          /* dummy view for pots to pull bets **/
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              key: boardAttributes.centerPotBetKey,
              offset: Offset(0, 30),
              child: Container(
                width: 50,
                height: 30,
                color: Colors.transparent,
              ),
            ),
          ),

          /* main pot view */
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, 15),
              child: multiplePots(context),
            ),
          ),

          /* community cards view */
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, 50),
              child: CommunityCardsView(
                cards: this.cards,
                horizontal: true,
              ),
            ),
          ),

          /* potUpdates view OR the rank widget (rank widget is shown only when we have a result) */
          this.showDown ? rankWidget() : potUpdatesView(),
        ],
      ),
    );
    return tablePotAndCardWidget;
  }

  Widget potUpdatesView() {
    final child = Opacity(
      opacity:
          showDown || (potChipsUpdates == null || potChipsUpdates == 0) ? 0 : 1,
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

    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: Offset(0, 100),
        child: child,
      ),
    );
  }

  /* rankStr --> needs to be shown only when footer result is not null */
  Widget rankWidget() {
    final child = Consumer<HandResultState>(
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

    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: Offset(0, 120),
        child: child,
      ),
    );
  }
}
