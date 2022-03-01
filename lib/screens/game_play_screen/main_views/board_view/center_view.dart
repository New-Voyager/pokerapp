import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/animation_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/cards/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/community_cards_view.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';
import "dart:math" show pi;

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

  Widget _dealerChoicePrompt() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        '${tableState.dealerChoicePromptPlayer} is choosing next game',
      ),
    );
  }

  Widget centerTextWidget(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.dp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGamePauseOptions(GameState gameState) {
    // log('Center: center_view _buildGamePauseOptions');
    return Consumer2<SeatChangeNotifier, TableState>(
      builder: (_, SeatChangeNotifier seatChange, TableState tableState, __) =>
          ValueListenableBuilder2<String, String>(
        vnGameStatus,
        vnTableStatus,
        builder: (_, gameStatus, tableStatus, __) {
          // log('Center: Rebuilding center view: Is game running: ${gameState.isGameRunning}');
          return CenterButtonView(
            isHost: this.widget.isHost,
            onStartGame: this.widget.onStartGame,
          );
        },
      ),
    );
  }

  final vnGameStatus = ValueNotifier<String>(null);
  final vnTableStatus = ValueNotifier<String>(null);
  final vnCards = ValueNotifier<List<CardObject>>([]);
  final vnCardOthers = ValueNotifier<List<CardObject>>([]);
  final vnTwoBoardsNeeded = ValueNotifier<bool>(false);
  final vnPotChips = ValueNotifier<List<double>>([]);
  final vnPotChipsUpdates = ValueNotifier<double>(null);
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

  Widget _mainBuild({
    @required GameState gameState,
    @required final String gameStatus,
    @required final String tableStatus,
  }) {
    // log('Center: CenterView _mainBuild status: ${gameState.gameInfo.status}');
    //log('potViewPos: before game ended.');
    if (gameState.gameInfo.status == AppConstants.GAME_ENDED)
      return centerTextWidget(_appScreenText['gameEnded']);

    //log('potViewPos: before waiting for players.');
    if (!gameState.botGame &&
        gameState.playersInSeatsCount <= 1 &&
        gameState.gameInfo.status != AppConstants.GAME_CONFIGURED) {
      return centerTextWidget(_appScreenText['waitingForPlayersToJoin']);
    }

    if (gameState.tableState.tableStatus ==
        AppConstants.TABLE_STATUS_NOT_ENOUGH_PLAYERS) {
      return centerTextWidget(_appScreenText['waitingForPlayersToJoin']);
    }

    //log('potViewPos: before seat change progress.');
    if (gameState.gameInfo.tableStatus ==
        AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      return centerTextWidget(_appScreenText['seatChangeInProgress']);
    }

    final bool isGamePausedOrWaiting = gameState.gameInfo.status ==
            AppConstants.GAME_PAUSED ||
        gameState.gameInfo.tableStatus == AppConstants.WAITING_TO_BE_STARTED;

    /* if the game is paused, show the options available during game pause */
    // don't show start/pause buttons for bot script games
    if (!gameState.isBotGame) {
      if (isGamePausedOrWaiting || !gameState.isGameRunning) {
        return _buildGamePauseOptions(gameState);
      }
    }

    /* if we reach here, means, the game is RUNNING */
    /* The following view, shows the community cards
     and the pot chips, if they are nulls, put the default values */
    return _BoardCenterView(
      tableState: tableState,
      vnPotChips: vnPotChips,
      vnPotToHighlight: vnPotToHighlight,
      vnCommunityCardsRefresh: vnCommunityCardsRefresh,
      vnCards: vnCards,
      vnCardOthers: vnCardOthers,
      vnTwoBoardsNeeded: vnTwoBoardsNeeded,
      vnPotChipsUpdates: vnPotChipsUpdates,
      gameState: gameState,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    return ValueListenableBuilder3<String, String, bool>(
      vnGameStatus,
      vnTableStatus,
      vnShowCardShuffling,
      builder: (_, gameStatus, tableStatus, showCardsShuffling, __) {
        List<Widget> children = [];
        if (showCardsShuffling) {
          bool showBombAnimation = (gameState?.handInfo?.bombPot) ?? false;
          if (gameState.gameSettings.bombPotEveryHand ?? false) {
            showBombAnimation = false;
          }
          if (showBombAnimation) {
            children.add(_bombPotAnimation());
          } else if (tableState.dealerChoicePrompt) {
            children.add(_dealerChoicePrompt());
          } else {
            children.add(AnimatingShuffleCardView());
          }
        }
        children.add(_mainBuild(
          gameState: gameState,
          tableStatus: tableStatus,
          gameStatus: gameStatus,
        ));

        return Stack(
          alignment: Alignment.center,
          children: children,
        );
      },
    );
  }
}

/// this view is mainly divided into 3 parts,
/// 1. Pot View
/// 2. Community Cards
/// 3. Pots Update
class _BoardCenterView extends StatelessWidget {
  final TableState tableState;
  final ValueNotifier<List<double>> vnPotChips;
  final ValueNotifier<int> vnPotToHighlight;

  final ValueNotifier<int> vnCommunityCardsRefresh;
  final ValueNotifier<List<CardObject>> vnCards;
  final ValueNotifier<List<CardObject>> vnCardOthers;
  final ValueNotifier<bool> vnTwoBoardsNeeded;

  final ValueNotifier<double> vnPotChipsUpdates;
  final GameState gameState;

  _BoardCenterView({
    Key key,
    @required this.tableState,
    @required this.vnPotChips,
    @required this.vnPotToHighlight,
    @required this.vnCommunityCardsRefresh,
    @required this.vnCards,
    @required this.vnCardOthers,
    @required this.vnTwoBoardsNeeded,
    @required this.vnPotChipsUpdates,
    @required this.gameState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // pot view
        Expanded(
          child: DebugBorderWidget(
            color: Colors.green,
            child: _PotViewWidget(
              dimPots: tableState.dimPots,
              vnPotChips: vnPotChips,
              vnPotToHighlight: vnPotToHighlight,
            ),
          ),
        ),

        // community cards view
        Expanded(
          flex: Screen.isLargeScreen ? 4 : 3,
          child: DebugBorderWidget(
            color: Colors.green,
            child: _CommunityCardsWidget(
              vnCommunityCardsRefresh: vnCommunityCardsRefresh,
              vnCards: vnCards,
              vnCardOthers: vnCardOthers,
              vnTwoBoardsNeeded: vnTwoBoardsNeeded,
            ),
          ),
        ),

        // pots update view
        Expanded(
          child: DebugBorderWidget(
            color: Colors.green,
            child: _PotUpdatesOrRankWidget(
              vnPotChipsUpdates: vnPotChipsUpdates,
              gameState: gameState,
            ),
          ),
        ),
      ],
    );
  }
}

class _PotViewWidget extends StatelessWidget {
  final bool dimPots;
  final ValueNotifier<List<double>> vnPotChips;
  final ValueNotifier<int> vnPotToHighlight;

  _PotViewWidget({
    Key key,
    @required this.dimPots,
    @required this.vnPotChips,
    @required this.vnPotToHighlight,
  }) : super(key: key);

  final potKey = GlobalKey();

  Widget _buildMultiplePots() {
    return ValueListenableBuilder2<List<double>, int>(
      vnPotChips,
      vnPotToHighlight,
      builder: (context, potChips, potToHighlight, __) {
        final List<Widget> pots = [];

        final List<double> cleanedPotChips = potChips ?? [];
        bool rebuildSeats = false;
        for (int i = 0; i < cleanedPotChips.length; i++) {
          if (cleanedPotChips[i] == null) cleanedPotChips[i] = 0;

          double potChipValue = 10;
          potChipValue = cleanedPotChips[i]?.toDouble();

          bool dimView = dimPots;
          bool highlight = (potToHighlight ?? -1) == i;
          if (highlight) {
            dimView = false;
          }

          final potsView = PotsView(
            potChip: potChipValue,
            uiKey: GlobalKey(),
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

  @override
  Widget build(BuildContext context) {
    /**
     * Pots on the board have two controls stacked on each other.
     * emptyPotsView: Always created with transparent color. Used for identifying the location where the chips moved from the players.
     * multiplePots: Multiple pots above the community cards
     */
    final emptyPotsView = PotsView(
      potChip: 0,
      uiKey: potKey,
      highlight: false,
      transparent: true,
    );

    context.read<BoardAttributesObject>().potKey = potKey;

    Widget multiplePots = _buildMultiplePots();

    /// we just need the stack here, for the emptyPotsView
    return FittedBox(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          emptyPotsView,
          multiplePots,
        ],
      ),
    );
  }
}

class _CommunityCardsWidget extends StatelessWidget {
  final ValueNotifier<int> vnCommunityCardsRefresh;
  final ValueNotifier<List<CardObject>> vnCards;
  final ValueNotifier<List<CardObject>> vnCardOthers;
  final ValueNotifier<bool> vnTwoBoardsNeeded;

  const _CommunityCardsWidget({
    Key key,
    @required this.vnCommunityCardsRefresh,
    @required this.vnCards,
    @required this.vnCardOthers,
    @required this.vnTwoBoardsNeeded,
  }) : super(key: key);

  Matrix4 get transformMatrix => Matrix4.identity()
    ..setEntry(3, 2, 0.005)
    ..rotateX(-20 * pi / 180);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
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

            return LayoutBuilder(
              builder: (_, constraints) {
                /// available height for the community cards
                final height = constraints.maxHeight;

                /// single board factor = 4/5 of available height
                final double singleBoardFactor =
                    Screen.isLargeScreen ? 3.0 / 4 : 4.0 / 5;

                /// double board factor = full available height
                final double doubleBoardFactor =
                    Screen.isLargeScreen ? 0.90 : 1.0;

                /// board factor depending upon if single board / double board
                final boardFactor =
                    twoBoardsNeeded ? doubleBoardFactor : singleBoardFactor;

                final negativeSpace = (1 - boardFactor) * height;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: negativeSpace),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Transform(
                      transform: transformMatrix,
                      alignment: Alignment.center,
                      child: CommunityCardsView(
                        cards: tableState.cards,
                        cardsOther: tableState.cardsOther,
                        twoBoardsNeeded: tableState.twoBoardsNeeded,
                        horizontal: true,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _PotUpdatesOrRankWidget extends StatelessWidget {
  final ValueNotifier<double> vnPotChipsUpdates;
  final GameState gameState;

  const _PotUpdatesOrRankWidget({
    Key key,
    @required this.vnPotChipsUpdates,
    @required this.gameState,
  }) : super(key: key);

  double _getOpacityForPotUpdatesView({
    final double potChipsUpdates,
    GameState gameState,
  }) {
    bool show = false;
    final tableState = gameState.tableState;
    if (tableState.potChips != null && tableState.potChips.length > 1) {
      show = true;
    } else if (tableState.potChips != null && tableState.potChips.length == 1) {
      if (tableState.potChipsUpdates != 0 &&
          tableState.potChips[0] != tableState.potChipsUpdates) {
        show = true;
      }
    } else {
      if (tableState.potChipsUpdates != null &&
          tableState.potChipsUpdates != 0) {
        show = true;
      }
    }
    if (show) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (gameState.handState == HandState.RESULT) {
      return SizedBox.shrink();
    }

    return FittedBox(
      child: ValueListenableBuilder<double>(
        valueListenable: vnPotChipsUpdates,
        builder: (_, potChipsUpdates, __) {
          double opacity = _getOpacityForPotUpdatesView(
            potChipsUpdates: potChipsUpdates,
            gameState: gameState,
          );
          if (gameState.handState == HandState.RESULT) {
            opacity = 0.0;
          }
          return Opacity(
            opacity: opacity,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/potpokerchips.svg',
                    color: Colors.yellow,
                    width: 24.pw,
                    height: 24.pw,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${DataFormatter.chipsFormat(potChipsUpdates?.toDouble())}',
                    style: AppStylesNew.itemInfoTextStyleHeavy.copyWith(
                      fontSize: 13.dp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
