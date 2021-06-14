import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
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
  final String gameStatus;
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
    this.gameStatus,
    this.tableStatus,
    this.showDown,
    this.onStartGame,
    this.flipSpeed,
  ) : super(key: key);

  Widget _positionAnimationShuffleCardView({
    Widget child,
    double scale = 1.0,
    Offset offset = Offset.zero,
  }) =>
      Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: offset,
          child: Transform.scale(
            scale: scale * 1.2,
            child: child,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final boardAttributes = gameState.getBoardAttributes(context);
    //log('gameStatus: $gameStatus tableStatus: $tableStatus');
    String _text = showDown ? null : BoardViewUtilMethods.getText(tableStatus);

    if (gameStatus == AppConstants.GAME_ENDED) {
      return Center(
          child: Text(
        'Game Ended',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      ));
    }

    /* if the game is paused, show the options available during game pause */
    if (gameStatus == AppConstants.GAME_PAUSED ||
        tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
      return Transform.translate(
        offset: boardAttributes.centerViewButtonVerticalTranslate,
        child: Consumer<SeatChangeNotifier>(
          builder: (_, SeatChangeNotifier seatChange, __) => CenterButtonView(
            gameCode: this.gameCode,
            isHost: this.isHost,
            gameStatus: this.gameStatus,
            tableStatus: this.tableStatus,
            onStartGame: this.onStartGame,
          ),
        ),
      );
    }

    /* in case of new hand, show the deck shuffling animation */
    if (_text == AppConstants.NEW_HAND) {
      return _positionAnimationShuffleCardView(
        offset: boardAttributes.centerViewCardShufflePosition,
        scale: boardAttributes.centerViewCenterScale,
        child: AnimatingShuffleCardView(),
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
      double potChipValue = 10;
      potChipValue = cleanedPotChips[i].toDouble();

      final potKey = GlobalKey();

      final potsView = PotsView(
        isBoardHorizontal: this.isBoardHorizontal,
        potChip: potChipValue,
        uiKey: potKey,
        highlight: (whichPotToHighlight ?? -1) == i,
      );

      boardAttributes.setPotsKey(i, potKey);
      pots.add(potsView);
    }

    // transparent pots to occupy the space
    if (pots.length == 0) {
      final potKey = GlobalKey();

      final emptyPotsView = PotsView(
        isBoardHorizontal: this.isBoardHorizontal,
        potChip: 0,
        uiKey: potKey,
        highlight: false,
        transparent: true,
      );

      boardAttributes.setPotsKey(0, potKey);
      pots.add(emptyPotsView);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pots,
    );
  }

  Widget centerView(
    BuildContext context,
    BoardAttributesObject boardAttributes,
  ) =>
      Transform.translate(
        offset: boardAttributes.centerViewVerticalTranslate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* main pot view */
            Transform.scale(
              scale: boardAttributes.centerPotScale,
              alignment: Alignment.topCenter,
              child: multiplePots(context, boardAttributes),
            ),

            // divider
            SizedBox(height: boardAttributes.centerGap),

            /* community cards view */
            CommunityCardsView(
              cards: this.cards,
              cardsOther: this.cardsOther,
              twoBoardsNeeded: this.twoBoardsNeeded,
              horizontal: true,
            ),

            // divider
            SizedBox(height: boardAttributes.centerGap),

            /* potUpdates view OR the rank widget (rank widget is shown only when we have a result) */
            this.showDown
                ? rankWidget(boardAttributes)
                : potUpdatesView(boardAttributes),
          ],
        ),
      );

  Widget potUpdatesView(BoardAttributesObject boa) {
    double updates = potChipsUpdates;

    return Transform.scale(
      scale: boa.centerPotUpdatesScale,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: showDown || (updates == null || updates == 0) ? 0 : 1,
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

  /* rankStr --> needs to be shown only when footer result is not null */
  Widget rankWidget(BoardAttributesObject boa) => Transform.scale(
        scale: boa.centerRankStrScale,
        child: Consumer<TableState>(
          builder: (_, TableState tableState, __) => AnimatedSwitcher(
            duration: AppConstants.animationDuration,
            reverseDuration: AppConstants.animationDuration,
            child:
                tableState.rankStr == null || tableState.rankStr.trim().isEmpty
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
