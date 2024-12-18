import 'dart:developer';
import "dart:math" show pi;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/animation_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_button_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/pots_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/rank_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/listenable.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/cards/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/cards/community_cards_view_2/community_card_view_2.dart';

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
  BoardAttributesObject boa;
  final GlobalKey potKey = GlobalKey();

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
          color: Colors.white,
          fontSize: 8.dp,
          fontWeight: FontWeight.normal,
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
  final vnPotChips = ValueNotifier<List<double>>([]);
  final vnPotChipsUpdates = ValueNotifier<double>(null);
  final vnPotToHighlight = ValueNotifier<int>(null);
  final vnRankStr = ValueNotifier<String>(null);
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
    // vnTableRefresh.value = tableState.tableRefresh;
    vnShowCardShuffling.value = tableState.showCardsShuffling;

    // needs rebuilding check
    if (_needsRebuilding(vnPotChips.value, tableState.potChips))
      vnPotChips.value = List.of(tableState.potChips ?? []);

    vnPotChipsUpdates.value = tableState.potChipsUpdates;
    vnPotToHighlight.value = tableState.potToHighlight;
    vnRankStr.value = tableState.rankStr;
  }

  void calculatePotPosition() {
    if (boa.potGlobalPos == null) {
      final RenderBox box = potKey.currentContext?.findRenderObject();
      if (box == null) return;
      boa.potGlobalPos = box.localToGlobal(const Offset(0, 0));
    }
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("centerView");
    tableState.addListener(tableStateListener);
    final gameState = GameState.getState(context);
    boa = gameState.getBoardAttributes(context);
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
    // don't show start/pause buttons for bot script games or demo games

    // if (gameState?.isBotGame == false &&
    //     gameState?.gameInfo?.demoGame == false) {
    //   if (isGamePausedOrWaiting || !gameState.isGameRunning) {
    //     return _buildGamePauseOptions(gameState);
    //   }
    // }

    /* if we reach here, means, the game is RUNNING */
    /* The following view, shows the community cards
     and the pot chips, if they are nulls, put the default values */
    return _BoardCenterView(
      tableState: tableState,
      vnPotChips: vnPotChips,
      vnPotToHighlight: vnPotToHighlight,
      vnPotChipsUpdates: vnPotChipsUpdates,
      vnRankStr: vnRankStr,
      gameState: gameState,
      potKey: potKey,
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
        log('Build: BoardView');

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

        calculatePotPosition();

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

  final ValueNotifier<String> vnRankStr;

  final ValueNotifier<double> vnPotChipsUpdates;
  final GameState gameState;
  final GlobalKey potKey;

  _BoardCenterView({
    Key key,
    @required this.tableState,
    @required this.vnPotChips,
    @required this.vnPotToHighlight,
    @required this.vnPotChipsUpdates,
    @required this.vnRankStr,
    @required this.gameState,
    @required this.potKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.getTheme(context);
    // Widget rankView = FittedBox(
    //     fit: BoxFit.fitHeight,
    //     child: ValueListenableBuilder<String>(
    //         valueListenable: vnRankStr,
    //         builder: (_, rank, __) {
    //           if (gameState.handState == HandState.RESULT) {
    //             return RankWidget(theme, vnRankStr);
    //           }
    //           return SizedBox.shrink();
    //         }));

    return Column(
      children: [
        // pots update view

        Expanded(
          child: DebugBorderWidget(
            color: Colors.yellow,
            child: _PotUpdatesOrRankWidget(
              vnPotChipsUpdates: vnPotChipsUpdates,
              gameState: gameState,
              vnRankStr: vnRankStr,
            ),
          ),
        ),
// pot view
        Expanded(
          //flex: 2,
          child: DebugBorderWidget(
            color: Colors.green,
            child: _PotViewWidget(
              dimPots: tableState.dimPots,
              vnPotChips: vnPotChips,
              vnPotToHighlight: vnPotToHighlight,
              potKey: potKey,
            ),
          ),
        ),
        // community cards view
        Expanded(
          flex: Screen.isLargeScreen ? 4 : 3,
          child: DebugBorderWidget(
            color: Colors.transparent,
            child: Container(
              width: gameState.gameUIState.centerViewRect.width,
              child: Stack(children: [
                _CommunityCardsWidget(),
                //Align(alignment: Alignment.bottomCenter, child: rankView)
              ]),
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
  final GlobalKey potKey;

  _PotViewWidget({
    Key key,
    @required this.dimPots,
    @required this.vnPotChips,
    @required this.vnPotToHighlight,
    @required this.potKey,
  }) : super(key: key);

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
  const _CommunityCardsWidget({Key key}) : super(key: key);

  Matrix4 get transformMatrix => Matrix4.identity()
    ..setEntry(3, 2, 0.002)
    ..rotateX(-20 * pi / 180);

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final tableState = gameState.tableState;

    return LayoutBuilder(
      builder: (_, constraints) {
        /// available height for the community cards
        final height = constraints.maxHeight;
        final double boardFactor = Screen.isLargeScreen ? 0.80 : 0.90;
        final negativeSpace = (1 - boardFactor) * height * 0.30;

        return Container(
          margin: EdgeInsets.only(top: negativeSpace),
          child: Transform(
            transform: transformMatrix,
            alignment: Alignment.center,
            child: const CommunityCardView2(
              key: Key('CommunityCardView'),
            ),
          ),
        );
      },
    );
  }
}

class _PotUpdatesOrRankWidget extends StatelessWidget {
  final ValueNotifier<double> vnPotChipsUpdates;
  final GameState gameState;
  final ValueNotifier<String> vnRankStr;

  const _PotUpdatesOrRankWidget({
    Key key,
    @required this.vnPotChipsUpdates,
    @required this.gameState,
    @required this.vnRankStr,
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
    log('CenterView: rebuilding pot updates/rank view');
    final theme = AppTheme.getTheme(context);
    Widget potUpdatesView = FittedBox(
      fit: BoxFit.fitHeight,
      child: ValueListenableBuilder2<double, String>(
        vnPotChipsUpdates,
        vnRankStr,
        builder: (_, potChipsUpdates, rank, __) {
          if (gameState.handState == HandState.RESULT) {
            if (vnRankStr.value == null || vnRankStr.value.isEmpty) {
              return Container(width: 1, height: 1, color: Colors.transparent);
            }
            return RankWidget(theme, vnRankStr);
          }

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
                color: Colors.black26,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pot:',
                      style: AppStylesNew.itemInfoTextStyleHeavy.copyWith(
                        color: Colors.blue,
                        fontSize: 9.dp,
                        fontWeight: FontWeight.w800,
                      )),
                  // SvgPicture.asset(
                  //   'assets/icons/potpokerchips.svg',
                  //   color: Colors.yellow,
                  //   width: 20.pw,
                  //   height: 20.pw,
                  //   fit: BoxFit.cover,
                  // ),
                  SizedBox(width: 10),
                  Text(
                    '${DataFormatter.chipsFormat(potChipsUpdates?.toDouble())}',
                    style: AppStylesNew.itemInfoTextStyleHeavy.copyWith(
                      fontSize: 10.dp,
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

    return potUpdatesView;

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
            offset: Offset(0, -20),
            child: FittedBox(child: RankWidget(theme, vnRankStr))),
        potUpdatesView
      ],
    );
  }
}
