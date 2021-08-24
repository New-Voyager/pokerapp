import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
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
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
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

class _CenterViewState extends State<CenterView> {
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

  Widget customizationView({
    double scale = 1.0,
    Offset offset = Offset.zero,
    GameState gameState,
  }) {
    AppTheme theme = AppTheme.getTheme(context);
    return Align(
      alignment: Alignment.center,
      child: Transform.translate(
        offset: offset,
        child: Transform.scale(
            scale: scale * 1.2,
            child: GameCircleButton(
              onClickHandler: () async {
                await Navigator.of(context).pushNamed(Routes.select_table);
                await gameState.assets.initialize();
                final redrawTop = gameState.getRedrawTopSectionState(context);
                redrawTop.notify();
                //setState(() {});
              },
              child: Icon(Icons.edit,
                  size: 24, color: theme.primaryColorWithDark()),
            )),
      ),
    );
  }

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
            fontSize: 16.dp,
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
    //log('potViewPos: before game ended.');
    if (gameState.gameInfo.status == AppConstants.GAME_ENDED)
      return centerTextWidget(
        _appScreenText['gameEnded'],
        boardAttributes.centerViewButtonVerticalTranslate,
      );

    //log('potViewPos: before waiting for players.');
    if (!gameState.botGame && gameState.playersInSeatsCount <= 1) {
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
    if (isGamePausedOrWaiting && !gameState.isGameRunning) {
      print('_buildGamePauseOptions');
      return _buildGamePauseOptions(
        gameState,
        boardAttributes.centerViewButtonVerticalTranslate,
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

    return ValueListenableBuilder3<String, String, bool>(
        vnGameStatus, vnTableStatus, vnShowCardShuffling,
        builder: (_, gameStatus, tableStatus, showCardsShuffling, __) {
      if (gameState.customizationMode) {
        return customizationView(
          offset: boardAttributes.centerViewCardShufflePosition,
          scale: boardAttributes.centerViewCenterScale,
          gameState: gameState,
        );
      }
      if (showCardsShuffling) {
        return (gameState?.handInfo?.bombPot ?? false)
            ? _bombPotAnimation()
            : _positionAnimationShuffleCardView(
                offset: boardAttributes.centerViewCardShufflePosition,
                scale: boardAttributes.centerViewCenterScale,
                child: AnimatingShuffleCardView(),
              );
      }
      return _mainBuild(
        context,
        tableStatus: tableStatus,
        gameStatus: gameStatus,
        boardAttributes: boardAttributes,
      );
    });
  }

  Widget _buildMainCenterView(final context, final boardAttributes) {
    //log('potViewPos: building main center view');

    return Transform.translate(
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
          ValueListenableBuilder<int>(
            valueListenable: vnCommunityCardsRefresh,
            builder: (_, __, ___) {
              return ValueListenableBuilder3<List<CardObject>, List<CardObject>,
                  bool>(
                vnCards,
                vnCardOthers,
                vnTwoBoardsNeeded,
                builder: (_, cards, cardsOther, twoBoardsNeeded, __) {
                  return CommunityCardsView(
                    cards: cards,
                    cardsOther: cardsOther,
                    twoBoardsNeeded: twoBoardsNeeded,
                    horizontal: true,
                  );
                },
              );
            },
          ),
          // divider
          SizedBox(height: boardAttributes.centerGap),

          /* potUpdates view OR the rank widget (rank widget is shown only when we have a result) */
          Consumer<ValueNotifier<FooterStatus>>(
            builder: (_, vnFooterStatus, __) {
              bool showDown = vnFooterStatus.value == FooterStatus.Result;
              log('showing rank widget: $showDown');
              return showDown
                  ? rankWidget(boardAttributes)
                  : potUpdatesView(boa: boardAttributes, showDown: showDown);
            },
          ),
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

          if (boardAttributes.setPotsKey(i, potKey)) {
            rebuildSeats = true;
          }
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

          if (boardAttributes.setPotsKey(0, potKey)) {
            rebuildSeats = true;
          }
          pots.add(emptyPotsView);
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
  }) {
    return Transform.scale(
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
              '${_appScreenText['pot']}: ${DataFormatter.chipsFormat(potChipsUpdates?.toDouble())}',
              style: AppStylesNew.itemInfoTextStyleHeavy.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hideRankStr(String rankStr) {
    return rankStr == null || rankStr.trim().isEmpty;
  }

  Widget rankWidget(BoardAttributesObject boa) {
    final theme = AppTheme.getTheme(context);
    var textStyle = AppStylesNew.footerResultTextStyle4
        .copyWith(fontSize: 20.dp, color: Colors.white);
    return Transform.scale(
      scale: boa.centerRankStrScale,
      child: ValueListenableBuilder(
          valueListenable: vnRankStr,
          builder: (_, rankStr, __) {
            log('rank str: $rankStr');
            return AnimatedSwitcher(
              duration: AppConstants.animationDuration,
              reverseDuration: AppConstants.animationDuration,
              child: _hideRankStr(rankStr)
                  ? const SizedBox.shrink()
                  : Container(
                      margin: EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.pw,
                        vertical: 2.pw,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: theme.accentColorWithDark(),
                      ),
                      child: Text(
                        rankStr,
                        style: textStyle,
                      ),
                    ),
            );
          }),
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
