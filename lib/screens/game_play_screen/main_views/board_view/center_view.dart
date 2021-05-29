import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
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

  Widget _putToCenterOnBoard({Widget child, scale}) => Align(
        alignment: Alignment.topCenter,
        child: Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(0.0, 30.0),
            child: child,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final boardAttributes = gameState.getBoardAttributes(context);

    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);

    /* if the game is paused, show the options available during game pause */
    if (_text == AppConstants.GAME_PAUSED ||
        tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
      return _putToCenterOnBoard(
        scale: boardAttributes.centerViewCenterScale,
        child: CenterButtonView(
          gameCode: this.gameCode,
          isHost: this.isHost,
          tableStatus: this.tableStatus,
          onStartGame: this.onStartGame,
        ),
      );
    }

    /* in case of new hand, show the deck shuffling animation */
    if (_text == AppConstants.NEW_HAND) {
      return _putToCenterOnBoard(
        scale: boardAttributes.centerViewCenterScale,
        child: Transform.scale(
          scale: 1.2,
          child: AnimatingShuffleCardView(),
        ),
      );
    }

    /* if reached here, means, the game is RUNNING */
    /* The following view, shows the community cards
    * and the pot chips, if they are nulls, put the default values */
    return centerView(context, boardAttributes);
  }

  Widget multiplePots(
    BuildContext context,
    boardAttributes,
  ) {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pots,
    );
  }

  Widget centerView(BuildContext context, boardAttributes) {
    final GlobalKey potsKey = GlobalKey();
    boardAttributes.setPotsKey(0, potsKey);

    // boardAttributes.centerPotBetKey = GlobalKey();

    final bool isCommunityCardsEmpty = this.cards == null || this.cards.isEmpty;

    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* main pot view */
          Transform.scale(
            scale: boardAttributes.centerPotScale,
            child: multiplePots(context, boardAttributes),
          ),

          // divider
          const SizedBox(height: 5.0),

          /* community cards view */
          Opacity(
            opacity: isCommunityCardsEmpty ? 0.0 : 1.0,
            child: CommunityCardsView(
              cards:
                  isCommunityCardsEmpty ? [CardHelper.getCard(17)] : this.cards,
              cardsOther: this.cardsOther,
              twoBoardsNeeded: this.twoBoardsNeeded,
              horizontal: true,
            ),
          ),

          // divider
          const SizedBox(height: 5.0),

          /* potUpdates view OR the rank widget (rank widget is shown only when we have a result) */
          this.showDown
              ? rankWidget(boardAttributes)
              : potUpdatesView(boardAttributes),
        ],
      ),
    );
    return tablePotAndCardWidget;
  }

  Widget potUpdatesView(BoardAttributesObject boa) => Transform.scale(
        scale: boa.centerPotUpdatesScale,
        child: Opacity(
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
        ),
      );

  /* rankStr --> needs to be shown only when footer result is not null */
  Widget rankWidget(BoardAttributesObject boa) {
    return Transform.scale(
      scale: boa.centerRankStrScale,
      child: Consumer<TableState>(
        builder: (_, TableState tableState, __) => AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          reverseDuration: AppConstants.animationDuration,
          child: tableState.rankStr == null || tableState.rankStr.trim().isEmpty
              ? const SizedBox.shrink()
              : Transform.translate(
                  offset: Offset(
                    0.0,
                    -0.0,
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
      ),
    );
  }
}
