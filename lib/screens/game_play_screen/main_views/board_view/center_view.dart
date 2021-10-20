import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/animation_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/rank_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/community_cards_view.dart';
import 'package:provider/provider.dart';

class CenterView extends StatefulWidget {
  final TableState tableState;
  final Function onStartGame;
  final bool isBoardHorizontal;
  final bool isHost;
  final String gameCode;

  CenterView({
    @required this.tableState,
    @required this.gameCode,
    @required this.isHost,
    @required this.isBoardHorizontal,
    @required this.onStartGame,
  });

  @override
  _CenterViewState createState() => _CenterViewState();
}

class _CenterViewState extends State<CenterView> with WidgetsBindingObserver {
  TableState get tableState => widget.tableState;
  AppTextScreen _appScreenText;

  Widget _bombPotAnimation() {
    return LottieBuilder.asset(
      AnimationAssets.bombPotAnimation,
      key: UniqueKey(),
    );
  }

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

  Widget centerTextWidget(
    String text,
    Offset offset,
  ) {
    return Transform.translate(
      offset: offset,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.dp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildGamePauseOptions(
    GameState gameState,
    Offset centerViewButtonOffset,
  ) {
    log('Center: center_view _buildGamePauseOptions');
    return Transform.translate(
      offset: centerViewButtonOffset,
      child: Consumer2<SeatChangeNotifier, TableState>(
        builder:
            (_, SeatChangeNotifier seatChange, TableState tableState, __) =>
                ValueListenableBuilder2<String, String>(
          vnGameStatus,
          vnTableStatus,
          builder: (_, gameStatus, tableStatus, __) {
            log('Center: Rebuilding center view: Is game running: ${gameState.isGameRunning}');
            return CenterButtonView(
              isHost: this.widget.isHost,
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
  final vnCommunityCardsRefresh = ValueNotifier<int>(null);
  // final vnTableRefresh = ValueNotifier<int>(null);
  final vnShowCardShuffling = ValueNotifier<bool>(false);

  final Function eq = const ListEquality().equals;

  bool _needsRebuilding(List a, List b) {
    // if a and b are not equal we need to rebuild
    return !eq(a, b);
  }

  void tableStateListener() {
    vnGameStatus.value = tableState.gameStatus;
    vnTableStatus.value = tableState.tableStatus;
    vnCommunityCardsRefresh.value = tableState.communityCardRefresh;
    // vnTableRefresh.value = tableState.tableRefresh;
    vnShowCardShuffling.value = tableState.showCardsShuffling;

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
    _appScreenText = getAppTextScreen("centerView");
    tableState.addListener(tableStateListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = GameState.getState(context);
      final boardAttributes = gameState.getBoardAttributes(context);
      // get pot view position and store in board attributes
      if (boardAttributes.potKey != null) {
        final RenderBox potViewBox =
            boardAttributes.potKey.currentContext.findRenderObject();
        boardAttributes.potGlobalPos = potViewBox.localToGlobal(Offset(0, 0));
        log('BoardView global potViewPos: ${boardAttributes.potGlobalPos}');
      }
    });
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
    log('Center: CenterView _mainBuild status: ${gameState.gameInfo.status}');
    //log('potViewPos: before game ended.');
    if (gameState.gameInfo.status == AppConstants.GAME_ENDED)
      return centerTextWidget(
        _appScreenText['gameEnded'],
        boardAttributes.centerViewButtonVerticalTranslate,
      );

    //log('potViewPos: before waiting for players.');
    if (!gameState.botGame &&
        gameState.playersInSeatsCount <= 1 &&
        gameState.gameInfo.status != AppConstants.GAME_CONFIGURED) {
      String text = _appScreenText['waitingForPlayersToJoin'];
      return centerTextWidget(
          text, boardAttributes.centerViewButtonVerticalTranslate);
    }

    //log('potViewPos: before seat change progress.');
    if (gameState.gameInfo.tableStatus ==
        AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      return centerTextWidget(_appScreenText['seatChangeInProgress'],
          boardAttributes.centerViewButtonVerticalTranslate);
    }

    final bool isGamePausedOrWaiting = gameState.gameInfo.status ==
            AppConstants.GAME_PAUSED ||
        gameState.gameInfo.tableStatus == AppConstants.WAITING_TO_BE_STARTED;

    //log('potViewPos: before is paused or waiting isGameRunning: ${gameState.isGameRunning} isGamePausedOrWaiting: $isGamePausedOrWaiting ${gameState.gameInfo.tableStatus}');
    /* if the game is paused, show the options available during game pause */
    List<Widget> children = [];
    // don't show start/pause buttons for bot script games
    if (!gameState.isBotGame) {
      if (isGamePausedOrWaiting || !gameState.isGameRunning) {
        children.add(Align(
            alignment: Alignment.center,
            child: _buildGamePauseOptions(
              gameState,
              boardAttributes.centerViewButtonVerticalTranslate,
            )));
      }
    }

    /* if we reach here, means, the game is RUNNING */
    /* The following view, shows the community cards
     and the pot chips, if they are nulls, put the default values */
    children.add(_buildMainCenterView(context, boardAttributes));
    return Stack(
      alignment: Alignment.topCenter,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);
    log('Center: CenterView build');

    return ValueListenableBuilder3<String, String, bool>(
        vnGameStatus, vnTableStatus, vnShowCardShuffling,
        builder: (_, gameStatus, tableStatus, showCardsShuffling, __) {
      List<Widget> children = [];
      if (showCardsShuffling) {
        children.add((gameState?.handInfo?.bombPot ?? false)
            ? _bombPotAnimation()
            : _positionAnimationShuffleCardView(
                offset: boardAttributes.centerViewCardShufflePosition,
                scale: boardAttributes.centerViewCenterScale,
                child: AnimatingShuffleCardView(),
              ));
      }
      children.add(_mainBuild(
        context,
        tableStatus: tableStatus,
        gameStatus: gameStatus,
        boardAttributes: boardAttributes,
      ));

      return Stack(
        alignment: Alignment.topCenter,
        children: children,
      );
    });
  }

  Widget _buildMainCenterView(
      final context, final BoardAttributesObject boardAttributes) {
    //log('potViewPos: building main center view');

    /**
     * Pots on the board have two controls stacked on each other.
     * emptyPotsView: Always created with transparent color. Used for identifying the location where the chips moved from the players.
     * multiplePots: Multiple pots above the community cards 
     */
    final potKey = GlobalKey();
    final emptyPotsView = PotsView(
      isBoardHorizontal: this.widget.isBoardHorizontal,
      potChip: 0,
      uiKey: potKey,
      highlight: false,
      transparent: true,
    );
    boardAttributes.potKey = potKey;
    log('ChipAmountWidget: buildMainCenterView. potKey: ${boardAttributes.potKey}');

    Widget multiplePots = _buildMultiplePots(boardAttributes);

    Widget potsStack = Stack(
      alignment: Alignment.topCenter,
      children: [
        emptyPotsView,
        multiplePots,
      ],
    );
    /* main pot view */
    Widget pots = Transform.scale(
      scale: boardAttributes.centerPotScale,
      alignment: Alignment.bottomCenter,
      child: potsStack,
    );

    final theme = AppTheme.getTheme(context);

    return Transform.translate(
      offset: boardAttributes.centerViewVerticalTranslate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pots,

          // divider
          SizedBox(height: boardAttributes.centerGap),

          /* community cards view */
          ValueListenableBuilder<int>(
            valueListenable: vnCommunityCardsRefresh,
            builder: (_, __, ___) {
              return ValueListenableBuilder3<List<CardObject>, List<CardObject>,
                  bool>(
                vnCards,
                vnCardOthers,
                vnTwoBoardsNeeded,
                builder: (_, cards, cardsOther, twoBoardsNeeded, __) {
                  final gameState = GameState.getState(context);
                  final tableState = gameState.tableState;
                  log('CommunityCards: cards: ${tableState.cards} cardsOther: ${tableState.cardsOther} twoboards: ${tableState.twoBoardsNeeded}');
                  return CommunityCardsView(
                    cards: tableState.cards,
                    cardsOther: tableState.cardsOther,
                    twoBoardsNeeded: tableState.twoBoardsNeeded,
                    horizontal: true,
                  );
                },
              );
            },
          ),

          // divider
          SizedBox(height: boardAttributes.potsViewGap),

          Stack(
            alignment: Alignment.topCenter,
            children: [
              RankWidget(boardAttributes, theme, vnRankStr),
              potUpdatesView(boa: boardAttributes)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMultiplePots(boardAttributes) {
    //log('potViewPos: building multiple pots');
    return ValueListenableBuilder2<List<int>, int>(
      vnPotChips,
      vnPotToHighlight,
      builder: (context, potChips, potToHighlight, __) {
        final List<Widget> pots = [];

        final List<int> cleanedPotChips = potChips ?? [];
        bool rebuildSeats = false;
        for (int i = 0; i < cleanedPotChips.length; i++) {
          if (cleanedPotChips[i] == null) cleanedPotChips[i] = 0;

          double potChipValue = 10;
          potChipValue = cleanedPotChips[i]?.toDouble();

          final potKey = GlobalKey();
          bool dimView = tableState.dimPots;
          bool highlight = (potToHighlight ?? -1) == i;
          if (highlight) {
            dimView = false;
          }

          final potsView = PotsView(
            isBoardHorizontal: this.widget.isBoardHorizontal,
            potChip: potChipValue,
            uiKey: potKey,
            highlight: highlight,
            dim: dimView,
          );

          pots.add(potsView);
        }

        if (rebuildSeats) {
          Future.delayed(Duration(milliseconds: 100), () {
            final gameState = GameState.getState(context);
            gameState.rebuildSeats();
          });
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: pots,
        );
      },
    );
  }

  double _getOpacityForPotUpdatesView({
    final int potChipsUpdates,
  }) {
    return (potChipsUpdates == null || potChipsUpdates == 0) ? 0 : 1;
  }

  Widget potUpdatesView({final BoardAttributesObject boa}) {
    final gameState = GameState.getState(context);
    if (gameState.handState == HandState.RESULT) {
      return SizedBox.shrink();
    }

    return Transform.scale(
      scale: boa.centerPotUpdatesScale,
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<int>(
        valueListenable: vnPotChipsUpdates,
        builder: (_, potChipsUpdates, __) => Opacity(
          opacity: _getOpacityForPotUpdatesView(
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
              '${_appScreenText['pot']}: ${DataFormatter.chipsFormat(potChipsUpdates?.toDouble())}',
              style: AppStylesNew.itemInfoTextStyleHeavy.copyWith(
                fontSize: 13.dp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
