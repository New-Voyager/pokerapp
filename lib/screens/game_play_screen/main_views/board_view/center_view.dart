import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/community_cards_view.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'board_view_util_methods.dart';

class CenterView extends StatefulWidget {
  final TableState tableState;
  // final bool twoBoardsNeeded;
  // final String gameStatus;
  // final String tableStatus;
  // final List<CardObject> cards;
  // final List<CardObject> cardsOther;
  // final List<int> potChips;
  // final int whichPotToHighlight;
  final Function onStartGame;
  final bool isBoardHorizontal;
  // final double potChipsUpdates;
  final bool isHost;
  final String gameCode;

  CenterView({
    // @required this.twoBoardsNeeded,
    @required this.tableState,
    @required this.gameCode,
    @required this.isHost,
    @required this.isBoardHorizontal,
    // @required this.cards,
    // @required this.cardsOther,
    // @required this.potChips,
    // @required this.whichPotToHighlight,
    // @required this.potChipsUpdates,
    // @required this.gameStatus,
    // @required this.tableStatus,
    @required this.onStartGame,
  });

  @override
  _CenterViewState createState() => _CenterViewState();
}

class _CenterViewState extends State<CenterView> {
  TableState get tableState => widget.tableState;

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

  Widget _buildGameEndedWidget() {
    return centerTextWidget(AppStringsNew.gameEndedText);
  }

  Widget centerTextWidget(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16.dp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGamePauseOptions(
      GameState gameState, Offset centerViewButtonOffset) {
    return Transform.translate(
      offset: centerViewButtonOffset,
      child: Consumer2<SeatChangeNotifier, TableState>(
        builder:
            (_, SeatChangeNotifier seatChange, TableState tableState, __) =>
                ValueListenableBuilder2<String, String>(
          vnGameStatus,
          vnTableStatus,
          builder: (_, gameStatus, tableStatus, __) {
            log('Rebuilding center view: Is game running: ${gameState.isGameRunning}');
            return CenterButtonView(
              gameCode: this.widget.gameCode,
              isHost: this.widget.isHost,
              gameStatus: gameState.gameInfo.status,
              tableStatus: gameState.gameInfo.tableStatus,
              onStartGame: this.widget.onStartGame,
            );
          },
        ),
      ),
    );
  }

  final vnGameStatus = ValueNotifier<String>(null);
  final vnTableStatus = ValueNotifier<String>(null);
  final vnCards = ValueNotifier<List<CardObject>>([]);
  final vnCardOthers = ValueNotifier<List<CardObject>>([]);
  final vnTwoBoardsNeeded = ValueNotifier<bool>(false);
  final vnPotChips = ValueNotifier<List<int>>([]);
  final vnPotChipsUpdates = ValueNotifier<int>(null);
  final vnPotToHighlight = ValueNotifier<int>(null);
  final vnRankStr = ValueNotifier<String>(null);

  final Function eq = const ListEquality().equals;

  bool _needsRebuilding(List a, List b) {
    // if a and b are not equal we need to rebuild
    return !eq(a, b);
  }

  void tableStateListener() {
    vnGameStatus.value = tableState.gameStatus;
    vnTableStatus.value = tableState.tableStatus;

    // need rebuilding check
    if (_needsRebuilding(vnCards.value, tableState.cards))
      vnCards.value = List.of(tableState.cards ?? []);

    // need rebuilding check
    if (_needsRebuilding(vnCardOthers.value, tableState.cardsOther))
      vnCardOthers.value = List.of(tableState.cardsOther ?? []);

    // needs rebuilding check
    if (_needsRebuilding(vnPotChips.value, tableState.potChips))
      vnPotChips.value = List.of(tableState.potChips ?? []);

    vnTwoBoardsNeeded.value = tableState.twoBoardsNeeded;
    vnPotChipsUpdates.value = tableState.potChipsUpdates;
    vnPotToHighlight.value = tableState.potToHighlight;
    vnRankStr.value = tableState.rankStr;
  }

  @override
  void initState() {
    super.initState();
    tableState.addListener(tableStateListener);
  }

  @override
  void dispose() {
    tableState.removeListener(tableStateListener);
    super.dispose();
  }

  Widget _mainBuild(
    BuildContext context, {
    @required final String gameStatus,
    @required final String tableStatus,
    @required final BoardAttributesObject boardAttributes,
  }) {
    final gameState = GameState.getState(context);
    if (gameState.gameInfo.status == AppConstants.GAME_ENDED)
      return _buildGameEndedWidget();

    if (!gameState.botGame && gameState.playersInSeatsCount <= 1) {
      String text = 'Waiting for players to join';
      return centerTextWidget(text);
    }

    if (gameState.gameInfo.tableStatus ==
        AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      return centerTextWidget('Seat change in progress');
    }

    final bool isGamePausedOrWaiting = gameState.gameInfo.status ==
            AppConstants.GAME_PAUSED ||
        gameState.gameInfo.tableStatus == AppConstants.WAITING_TO_BE_STARTED;

    /* if the game is paused, show the options available during game pause */
    if (isGamePausedOrWaiting) {
      return _buildGamePauseOptions(
        gameState,
        boardAttributes.centerViewButtonVerticalTranslate,
      );
    }
    String text = BoardViewUtilMethods.getText(tableStatus);

    /* in case of new hand, show the deck shuffling animation */
    if (text == AppConstants.NEW_HAND) {
      return _positionAnimationShuffleCardView(
        offset: boardAttributes.centerViewCardShufflePosition,
        scale: boardAttributes.centerViewCenterScale,
        child: AnimatingShuffleCardView(),
      );
    }

    /* if we reach here, means, the game is RUNNING */
    /* The following view, shows the community cards
     and the pot chips, if they are nulls, put the default values */
    return _buildMainCenterView(context, boardAttributes);
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final boardAttributes = gameState.getBoardAttributes(context);

    return ValueListenableBuilder2<String, String>(
      vnGameStatus,
      vnTableStatus,
      builder: (_, gameStatus, tableStatus, __) => _mainBuild(
        context,
        tableStatus: tableStatus,
        gameStatus: gameStatus,
        boardAttributes: boardAttributes,
      ),
    );
  }

  Widget _buildMainCenterView(final context, final boardAttributes) =>
      Transform.translate(
        offset: boardAttributes.centerViewVerticalTranslate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* main pot view */
            Transform.scale(
              scale: boardAttributes.centerPotScale,
              alignment: Alignment.topCenter,
              child: _buildMultiplePots(boardAttributes),
            ),

            // divider
            SizedBox(height: boardAttributes.centerGap),

            /* community cards view */
            ValueListenableBuilder3<List<CardObject>, List<CardObject>, bool>(
              vnCards,
              vnCardOthers,
              vnTwoBoardsNeeded,
              builder: (_, cards, cardsOther, twoBoardsNeeded, __) =>
                  CommunityCardsView(
                cards: cards,
                cardsOther: cardsOther,
                twoBoardsNeeded: twoBoardsNeeded,
                horizontal: true,
              ),
            ),
            // divider
            SizedBox(height: boardAttributes.centerGap),

            /* potUpdates view OR the rank widget (rank widget is shown only when we have a result) */
            Consumer<ValueNotifier<FooterStatus>>(
              builder: (_, vnFooterStatus, __) {
                bool showDown = vnFooterStatus.value == FooterStatus.Result;
                return showDown
                    ? rankWidget(boardAttributes)
                    : potUpdatesView(boa: boardAttributes, showDown: showDown);
              },
            ),
          ],
        ),
      );

  Widget _buildMultiplePots(boardAttributes) =>
      ValueListenableBuilder2<List<int>, int>(
        vnPotChips,
        vnPotToHighlight,
        builder: (context, potChips, potToHighlight, __) {
          final List<Widget> pots = [];

          final List<int> cleanedPotChips = potChips ?? [];

          for (int i = 0; i < cleanedPotChips.length; i++) {
            if (cleanedPotChips[i] == null) cleanedPotChips[i] = 0;

            double potChipValue = 10;
            potChipValue = cleanedPotChips[i]?.toDouble();

            final potKey = GlobalKey();

            final potsView = PotsView(
              isBoardHorizontal: this.widget.isBoardHorizontal,
              potChip: potChipValue,
              uiKey: potKey,
              highlight: (potToHighlight ?? -1) == i,
            );

            boardAttributes.setPotsKey(i, potKey);
            pots.add(potsView);
          }

          // transparent pots to occupy the space
          if (pots.length == 0) {
            final potKey = GlobalKey();

            final emptyPotsView = PotsView(
              isBoardHorizontal: this.widget.isBoardHorizontal,
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
        },
      );

  double _getOpacityForPotUpdatesView({
    final bool showDown,
    final int potChipsUpdates,
  }) {
    return showDown || (potChipsUpdates == null || potChipsUpdates == 0)
        ? 0
        : 1;
  }

  Widget potUpdatesView({
    final BoardAttributesObject boa,
    final bool showDown,
  }) =>
      Transform.scale(
        scale: boa.centerPotUpdatesScale,
        alignment: Alignment.bottomCenter,
        child: ValueListenableBuilder<int>(
          valueListenable: vnPotChipsUpdates,
          builder: (_, potChipsUpdates, __) => Opacity(
            opacity: _getOpacityForPotUpdatesView(
              showDown: showDown,
              potChipsUpdates: potChipsUpdates,
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
                'Pot: ${DataFormatter.chipsFormat(potChipsUpdates?.toDouble())}',
                style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );

  bool _hideRankStr(String rankStr) {
    return rankStr == null || rankStr.trim().isEmpty;
  }

  Widget rankWidget(BoardAttributesObject boa) => Transform.scale(
        scale: boa.centerRankStrScale,
        child: ValueListenableBuilder(
          valueListenable: vnRankStr,
          builder: (_, rankStr, __) => AnimatedSwitcher(
            duration: AppConstants.animationDuration,
            reverseDuration: AppConstants.animationDuration,
            child: _hideRankStr(rankStr)
                ? const SizedBox.shrink()
                : Container(
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
                      rankStr,
                      style: AppStyles.footerResultTextStyle4,
                    ),
                  ),
          ),
        ),
      );
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  ValueListenableBuilder2(
    this.first,
    this.second, {
    Key key,
    this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget child;
  final Widget Function(BuildContext context, A a, B b, Widget child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}

class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  ValueListenableBuilder3(
    this.first,
    this.second,
    this.third, {
    Key key,
    this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget child;
  final Widget Function(BuildContext context, A a, B b, C c, Widget child)
      builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (_, b, __) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, c, __) {
                return builder(context, a, b, c, child);
              },
            );
          },
        );
      },
    );
  }
}
