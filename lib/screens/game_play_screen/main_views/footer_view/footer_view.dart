import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/my_last_action_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/status_options_buttons.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/help_text.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'communication_view.dart';
import 'customization_view.dart';
import 'hand_analyse_view.dart';
import 'hole_cards_view_and_footer_action_view.dart';
import 'seat_change_confirm_widget.dart';
import 'package:collection/collection.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class FooterView extends StatefulWidget {
  final String gameCode;
  final String clubCode;
  final String playerUuid;
  final Function chatVisibilityChange;
  final GameContextObject gameContext;
  final Function onStartGame;

  FooterView(
      {@required this.gameContext,
      @required this.gameCode,
      @required this.playerUuid,
      @required this.chatVisibilityChange,
      @required this.clubCode,
      @required this.onStartGame});

  @override
  _FooterViewState createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView>
    with AfterLayoutMixin<FooterView> {
  final ValueNotifier<PlayerModel> mePlayerModelVn = ValueNotifier(null);

  /* this value notifier is used in a child widget - hole cards view */
  final ValueNotifier<bool> isHoleCardsVisibleVn = ValueNotifier(false);

  /* holds changes for MY last action */
  final ValueNotifier<HandActions> myLastActionVn = ValueNotifier(null);

  final Function eq = const ListEquality().equals;
  GameState _gameState;
  AppTextScreen _appScreenText;

  bool _needsRebuilding(PlayerModel me) {
    bool cardsChanged = true;
    bool playerStateChanged = true;
    if (mePlayerModelVn.value.cards != null && me != null && me.cards != null) {
      cardsChanged = !eq(mePlayerModelVn.value.cards, me.cards);
    }
    if (mePlayerModelVn.value != null && me != null) {
      playerStateChanged =
          (mePlayerModelVn.value.playerFolded != me.playerFolded);
    }
    bool rebuild = cardsChanged || playerStateChanged;
    log('RedrawFooter: FooterView rebuild: $rebuild');

    return rebuild;
  }

  void onPlayersChanges() {
    final PlayerModel me = _gameState.me;
    log('RedrawFooter: onPlayersChanges');

    if (me == null) {
      return;
    }

    // we don't update action if HandActions.NONE
    final tmpAction = me?.action?.action;
    if (tmpAction != HandActions.NONE) {
      myLastActionVn.value = null;
      myLastActionVn.value = tmpAction;
    }

    if (mePlayerModelVn.value == null) {
      // if me is null, fill value of me
      mePlayerModelVn.value = me.copyWith();
    } else {
      // if the cards in players object and local me object is not same, rebuild the hole card widget
      // also, if folded, rebuild the widget
      if (_needsRebuilding(me)) {
        mePlayerModelVn.value = me.copyWith();
      }
    }
  }

  /* init */
  void _init() {
    // get the game card visibility state from local storage
    _gameState = GameState.getState(context);
    var tableState = _gameState.tableState;
    tableState.addListener(tableStateListener);
    vnGameStatus.value = tableState.gameStatus;
    vnTableStatus.value = tableState.tableStatus;
    bool visible = true;
    if (_gameState.customizationMode) {
      visible = true;
    } else {
      visible = _gameState.gameHiveStore.getHoleCardsVisibilityState();
    }
    isHoleCardsVisibleVn.value = visible;
    _gameState.myState.addListener(onPlayersChanges);
  }

  void _dispose() {
    _gameState.myState.removeListener(onPlayersChanges);
  }

  void tableStateListener() {
    vnGameStatus.value = _gameState.tableState.gameStatus;
    vnTableStatus.value = _gameState.tableState.tableStatus;
    vnShowCardShuffling.value = _gameState.tableState.showCardsShuffling;
  }

  /* hand analyse view builder */
  Widget _buildHandAnalyseView(BuildContext context) {
    final gameState = context.read<GameState>();

    return Consumer<GameContextObject>(
      builder: (context, gameContextObject, _) => Positioned(
        left: 8,
        top: 10,
        child: HandAnalyseView(
          gameState: gameState,
          clubCode: widget.clubCode,
          gameContextObject: gameContextObject,
        ),
      ),
    );
  }

  /* straddle prompt builder / footer action view builder / hole card view builder */
  Widget _buildMainView(GameState gameState) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<MyState>(
      builder: (
        BuildContext _,
        MyState myState,
        Widget __,
      ) {
        final me = gameState.mySeat;

        bool showOptionsButtons = false;
        if (me != null && me.player != null) {
          if (me.player.inBreak) {
            //log('footerview: building status option widget: IN BREAK');
            showOptionsButtons = true;
          } else if (me.player.status == AppConstants.WAIT_FOR_BUYIN ||
              me.player.status == AppConstants.WAIT_FOR_BUYIN_APPROVAL) {
            showOptionsButtons = true;
          } else if (me.player.missedBlind) {
            showOptionsButtons = true;
          }
        } else {
          if (gameState.gameInfo.waitlistAllowed) {
            // observer
            showOptionsButtons = true;
          }
        }
        if (showOptionsButtons) {
          return StatusOptionsWidget(gameState: gameState);
        }

        /* build the HoleCardsViewAndFooterActionView only if me is NOT null */
        final mee = gameState.me;
        if (mee == null && !gameState.customizationMode) {
          log('RedrawFooter: rebuilding hole card me is null');
          return SizedBox(width: width);
        } else {
          log('RedrawFooter: rebuilding hole card');

          return HoleCardsViewAndFooterActionView(
            playerModel: mee,
            isHoleCardsVisibleVn: isHoleCardsVisibleVn,
          );
        }
      },
    );
  }

  /* straddle prompt builder / footer action view builder / hole card view builder */
  Widget _buildGameInfo(GameState gameState) {
    final width = MediaQuery.of(context).size.width;
    final theme = AppTheme.getTheme(context);
    List<Widget> children = [];
    if (gameState.currentPlayer.isHost()) {
      children.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Code',
                style: AppDecorators.getHeadLine3Style(theme: theme)),
            SizedBox(width: 10),
            Text(gameState.gameInfo.gameCode,
                style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
                    color: theme.accentColor, fontWeight: FontWeight.bold)),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8.pw),
                child: Icon(
                  Icons.copy,
                  color: theme.secondaryColor,
                  size: 24.pw,
                ),
              ),
              onTap: () {
                Clipboard.setData(
                  new ClipboardData(text: gameState.gameInfo.gameCode),
                );
                Alerts.showNotification(
                  titleText: 'Code copied to clipboard',
                );
              },
            )
          ],
        ),
        SizedBox(height: 20),
        Text('Invite your friends to join',
            style: AppDecorators.getHeadLine4Style(theme: theme)),
      ]);
    }
    if (!gameState.isPlaying) {
      children.addAll([
        SizedBox(height: 20),
        // BlinkText('Select an open seat to play',
        // style:  AppDecorators.getHeadLine4Style(theme: theme),
        // duration: Duration(seconds: 2),)

        Shimmer.fromColors(
          period: Duration(seconds: 3),
          baseColor: Colors.white,
          highlightColor: Colors.white.withOpacity(0.50),
          child: Text('Tap on open seat to play',
              style: AppDecorators.getHeadLine4Style(theme: theme)),
        )
      ]);
    }
    return Align(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: children));

    //Text('Game Code: ${gameState.gameInfo.gameCode}'));
  }

  Widget _buildCustomizationView() {
    return Positioned(
      right: 0,
      top: 0,
      child: HoleCardCustomizationView(),
    );
  }

  Widget _buildCommunicationWidget() {
    return Positioned(
      right: 5,
      top: 0,
      child: Column(children: [
        Consumer2<GameSettingsState, CommunicationState>(
            builder: (_, __, ____, ___) {
          return CommunicationView(
            widget.chatVisibilityChange,
            widget.gameContext.gameComService.gameMessaging,
            widget.gameContext,
          );
        }),
      ]),
    );
  }

  Widget _buildSeatConfirmWidget(BuildContext context) {
    final gameContextObject = context.read<GameContextObject>();
    final gameState = context.read<GameState>();

    final bool isHost = gameContextObject.isHost();

    // FIXME: REBUILD-FIX: need to check if seat change prompts are rebuilding as expected
    return Consumer<SeatChangeNotifier>(
      builder: (_, hostSeatChange, __) {
        final bool showSeatChangeConfirmWidget =
            gameState.hostSeatChangeInProgress &&
                isHost &&
                !gameState.playerSeatChangeInProgress;

        return showSeatChangeConfirmWidget
            ? Align(
                alignment: Alignment.center,
                child: SeatChangeConfirmWidget(
                  gameCode: widget.gameContext.gameState.gameCode,
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildMyLastActionWidget(context) {
    return ValueListenableBuilder<HandActions>(
      valueListenable: myLastActionVn,
      builder: (_, handAction, __) {
        // log('footer_view : _buildMyLastActionWidget : $handAction');
        return MyLastActionAnimatingWidget(
          myAction: handAction,
        );
      },
    );
  }

  final vnGameStatus = ValueNotifier<String>(null);
  final vnTableStatus = ValueNotifier<String>(null);
  final vnShowCardShuffling = ValueNotifier<bool>(false);

  Widget _buildGamePauseOptions(
    GameState gameState,
    Offset centerViewButtonOffset,
  ) {
    // log('Center: center_view _buildGamePauseOptions');
    final gameContext = Provider.of<GameContextObject>(context, listen: false);

    return Transform.translate(
      offset: centerViewButtonOffset,
      child: Consumer2<SeatChangeNotifier, TableState>(
        builder:
            (_, SeatChangeNotifier seatChange, TableState tableState, __) =>
                ValueListenableBuilder2<String, String>(
          vnGameStatus,
          vnTableStatus,
          builder: (_, gameStatus, tableStatus, __) {
            // log('Center: Rebuilding center view: Is game running: ${gameState.isGameRunning}');

            if (tableState.gameStatus == AppConstants.GAME_PAUSED) {
              if (!seatChange.seatChangeInProgress) {
                if (gameContext.isHost()) {
                  return pauseButtons(context);
                }
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _onResumePress(BuildContext context, gameCode) {
    GameService.resumeGame(gameCode);

    // redraw the top section
    final gameState = GameState.getState(context);
    gameState.redrawBoard();
  }

  Future<void> _onTerminatePress(BuildContext context) async {
    final response = await showPrompt(
        context, 'End Game', "Do you want to end the game?",
        positiveButtonText: 'Yes', negativeButtonText: 'No');
    if (response != null && response == true) {
      final gameState = GameState.getState(context);
      log('Termininating game ${gameState.gameCode}');
      await GameService.endGame(gameState.gameCode);
      if (gameState.uiClosing) {
        return;
      }
      if (appState != null) {
        appState.setGameEnded(true);
      }
      if (!gameState.isGameRunning) {
        gameState.refresh();
      }
    }
  }

  void _onRearrangeSeatsPress(context) async {
    GameContextObject gameContextObject = Provider.of<GameContextObject>(
      context,
      listen: false,
    );
    final gameState = GameState.getState(context);

    Alerts.showNotification(
        titleText: _appScreenText['game'],
        svgPath: AppAssetsNew.seatChangeImagePath,
        subTitleText: _appScreenText['movePlayerDescription'],
        duration: Duration(seconds: 30));

    Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    )
      ..updateSeatChangeHost(gameContextObject.playerId)
      ..updateSeatChangeInProgress(true);
    await SeatChangeService.hostSeatChangeBegin(gameState.gameCode);
    gameState.hostSeatChangeInProgress = true;

    await gameState.refresh();
    gameState.redrawFooter();
    log('status: ${gameState.gameInfo.status} table status: ${gameState.gameInfo.tableStatus}');
  }

  Widget pauseButtons(BuildContext context) {
    final gameContext = Provider.of<GameContextObject>(context, listen: false);
    final gameState = GameState.getState(context);
    log('is admin: ${gameContext.isAdmin()} isHost: ${gameContext.isHost()}');
    final providerContext = context;
    return Consumer<GameContextObject>(
      builder: (context, gameContext, _) => gameContext.isAdmin()
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: AppStylesNew.resumeBgDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      _appScreenText['gamePaused'],
                      style: AppStylesNew.cardHeaderTextStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Resume Button
                      IconAndTitleWidget(
                        child: SvgPicture.asset(
                          AppAssetsNew.resumeImagePath,
                          height: 48.ph,
                          width: 48.pw,
                        ),
                        onTap: () {
                          _onResumePress(context, gameState.gameCode);
                        },
                        text: _appScreenText['resume'],
                      ),

                      // Rearrange Button
                      IconAndTitleWidget(
                        child: SvgPicture.asset(
                          AppAssetsNew.seatChangeImagePath,
                          height: 48.ph,
                          width: 48.pw,
                        ),
                        onTap: () {
                          _onRearrangeSeatsPress(providerContext);
                        },
                        text: _appScreenText['rearrange'],
                      ),

                      // Terminate Button
                      IconAndTitleWidget(
                        child: SvgPicture.asset(
                          AppAssetsNew.terminateImagePath,
                          height: 48.ph,
                          width: 48.pw,
                        ),
                        onTap: () {
                          _onTerminatePress(context);
                        },
                        text: _appScreenText['terminate'],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final theme = AppTheme.getTheme(context);
    _appScreenText = getAppTextScreen("centerButtonView");
    bool playerGame = false;
    if (gameState.gameInfo.clubCode == null ||
        gameState.gameInfo.clubCode == '') {
      playerGame = true;
    }
    List<Widget> children = [];
    if (gameState.customizationMode) {
      children.add(_buildMainView(gameState));
      /* communication widgets */
      children.add(_buildCustomizationView());
    } else if (gameState.tableState.gameStatus ==
            AppConstants.GAME_CONFIGURED &&
        playerGame) {
      // display game information
      children.add(_buildGameInfo(gameState));
      /* hand analyse view */
      children.add(_buildHandAnalyseView(context));
      /* communication widgets */
      children.add(_buildCommunicationWidget());
    } else if (!gameState.isPlaying) {
      // the player can join the waitlist
      log('Player is not playing, but can join waitlist');
      children.add(_buildMainView(gameState));

      /* seat confirm widget */
      children.add(_buildSeatConfirmWidget(context));

      /* hand analyse view */
      children.add(_buildHandAnalyseView(context));
      /* communication widgets */
      children.add(_buildCommunicationWidget());
    } else {
      /* build main view - straddle prompt, hole cards, action view*/
      children.add(_buildMainView(gameState));
      /* hand analyse view */
      children.add(_buildHandAnalyseView(context));

      /* communication widgets */
      children.add(_buildCommunicationWidget());

      /* seat confirm widget */
      children.add(_buildSeatConfirmWidget(context));

      /* my last action */
      children.add(_buildMyLastActionWidget(context));
      children.add(
        Consumer<MyState>(builder: (_, __, ___) {
          //appService.appSettings.showHoleCardTip = true;
          if (gameState.me == null ||
              gameState.me.cards.length == 0 ||
              !appService.appSettings.showHoleCardTip) {
            return Container();
          }
          return Align(
              alignment: Alignment.topCenter,
              child: HelpText(
                show: appService.appSettings.showHoleCardTip,
                text:
                    'Tap the cards to flip or \nUse finger gesture to peek the cards',
                theme: theme,
                onTap: () {
                  // store this information, and don't show this again
                  appService.appSettings.showHoleCardTip = false;
                },
              ));
        }),
      );
    }

    final bool isGamePausedOrWaiting = gameState.gameInfo.status ==
            AppConstants.GAME_PAUSED ||
        gameState.gameInfo.tableStatus == AppConstants.WAITING_TO_BE_STARTED;

    final boardAttr = context.read<BoardAttributesObject>();

    /* if the game is paused, show the options available during game pause */
    // don't show start/pause buttons for bot script games
    children.add(ValueListenableBuilder3<String, String, bool>(
        vnGameStatus, vnTableStatus, vnShowCardShuffling,
        builder: (_, gameStatus, tableStatus, showCardsShuffling, __) {
      if (!gameState.isBotGame) {
        if (isGamePausedOrWaiting || !gameState.isGameRunning) {
          return Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: _buildGamePauseOptions(
                gameState,
                boardAttr.centerButtonsPos,
              ),
            ),
          );
        }
      }
      return Container();
    }));

    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   border: Border.all(color: Colors.green, width: 3),
        // ),
      ),
      ...children,
    ]);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject();
    final pos = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final boardAttr = context.read<BoardAttributesObject>();
    boardAttr.setFooterDimensions(pos, size);
  }
}
