import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/community_cards_view.dart';
import 'package:provider/provider.dart';

import 'board_view_util_methods.dart';

class CenterView extends StatelessWidget {
  final bool twoBoardsNeeded;
  final String tableStatus;
  final List<CardObject> cards;
  final List<CardObject> cardsOther;
  final List<int> potChips;
  final int whichPotToHighlight;
  final Function onStartGame;
  final bool showDown;
  final bool isBoardHorizontal;
  final double potChipsUpdates;
  final bool isHost;
  final String gameCode;
  final int flipSpeed;

  CenterView(
    Key key,
    this.twoBoardsNeeded,
    this.gameCode,
    this.isHost,
    this.isBoardHorizontal,
    this.cards,
    this.cardsOther,
    this.potChips,
    this.whichPotToHighlight,
    this.potChipsUpdates,
    this.tableStatus,
    this.showDown,
    this.onStartGame,
    this.flipSpeed,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);

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

    final List<int> cleanedPotChips = potChips ?? [];

    for (int i = 0; i < cleanedPotChips.length; i++) {
      if (cleanedPotChips[i] == null) cleanedPotChips[i] = 0;
      GlobalKey key = GlobalKey();
      double potChipValue = 0;
      potChipValue = cleanedPotChips[i].toDouble();

      final potsView = PotsView(
        isBoardHorizontal: this.isBoardHorizontal,
        potChip: potChipValue,
        uiKey: key,
        highlight: (whichPotToHighlight ?? -1) == i,
      );

      boardAttributes.setPotsKey(i, key);
      pots.add(potsView);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: pots);
  }

  Widget centerView(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final boardAttributes = gameState.getBoardAttributes(context);
    final GlobalKey potsKey = GlobalKey();
    boardAttributes.setPotsKey(0, potsKey);

    // boardAttributes.centerPotBetKey = GlobalKey();

    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        //mainAxisSize: MainAxisSize.min,
        children: [
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
                cardsOther: this.cardsOther,
                twoBoardsNeeded: this.twoBoardsNeeded,
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
    final child = Consumer<TableState>(
      builder: (_, TableState tableState, __) => AnimatedSwitcher(
        duration: AppConstants.animationDuration,
        reverseDuration: AppConstants.animationDuration,
        child: tableState.rankStr == null
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
                    color: Colors.black.withOpacity(0.70),
                  ),
                  child: Text(
                    tableState.rankStr,
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
