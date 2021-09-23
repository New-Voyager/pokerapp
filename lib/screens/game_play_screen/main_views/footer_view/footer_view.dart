import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/my_last_action_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/status_options_buttons.dart';
import 'package:provider/provider.dart';
import 'communication_view.dart';
import 'customization_view.dart';
import 'hand_analyse_view.dart';
import 'hole_cards_view_and_footer_action_view.dart';
import 'seat_change_confirm_widget.dart';
import 'package:collection/collection.dart';

class FooterView extends StatefulWidget {
  final String gameCode;
  final String clubCode;
  final String playerUuid;
  final Function chatVisibilityChange;
  final GameContextObject gameContext;

  FooterView({
    @required this.gameContext,
    @required this.gameCode,
    @required this.playerUuid,
    @required this.chatVisibilityChange,
    @required this.clubCode,
  });

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
  PlayerActedState _myAction;

  final Function eq = const ListEquality().equals;
  GameState _gameState;

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
    return cardsChanged || playerStateChanged;
  }

  void onPlayersChanges() {
    final PlayerModel me = _gameState.me;

    if (me == null) {
      return;
    }

    // we dont update action if HandActions.NONE
    final tmpAction = me?.action?.action;
    if (tmpAction != HandActions.NONE) {
      myLastActionVn.value = null;
      myLastActionVn.value = tmpAction;
      _myAction = me?.action;
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
    bool visible = true;
    if (_gameState.customizationMode) {
      visible = true;
    } else {
      visible = _gameState.gameHiveStore.getHoleCardsVisibilityState();
    }
    isHoleCardsVisibleVn.value = visible;

    // _players = context.read<Players>();
    // mePlayerModelVn.value = _players?.me?.copyWith();

    // // listen for changes in my PlayerModel state
    // _players?.addListener(onPlayersChanges);
    _gameState.myState.addListener(onPlayersChanges);
  }

  void _dispose() {
    _gameState.myState.removeListener(onPlayersChanges);
  }

  /* hand analyse view builder */
  Widget _buildHandAnalyseView(BuildContext context) {
    final gameState = context.read<GameState>();

    return Consumer<GameContextObject>(
      builder: (context, gameContextObject, _) => Positioned(
        left: 0,
        top: 0,
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
        builder: (BuildContext _, MyState myState, Widget __) {
      final me = gameState.mySeat;

      bool showOptionsButtons = false;
      log('Status: My state is changed.');
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
      } else if (!gameState.isPlaying) {
        if (gameState.gameInfo.waitlistAllowed) {
          // observer
          showOptionsButtons = true;
        }
      }
      if (showOptionsButtons) {
        log('Status: building status option widget');
        return StatusOptionsWidget(gameState: gameState);
      }

      /* build the HoleCardsViewAndFooterActionView only if me is NOT null */
      return Consumer<MyState>(builder: (_, ___, __) {
        final me = gameState.me;
        if (me == null) {
          return SizedBox(width: width);
        } else {
          return HoleCardsViewAndFooterActionView(
            playerModel: me,
            isHoleCardsVisibleVn: isHoleCardsVisibleVn,
          );
        }
      });

      // return ValueListenableBuilder<PlayerModel>(
      //     valueListenable: mePlayerModelVn,
      //     builder: (_, me, __) {
      //       if (me == null) {
      //         return SizedBox(width: width);
      //       } else {
      //         return HoleCardsViewAndFooterActionView(
      //           playerModel: me,
      //           isHoleCardsVisibleVn: isHoleCardsVisibleVn,
      //         );
      //       }
      //     });
    });
  }

  Widget _buildCustomizationView() {
    return Positioned(
      right: 0,
      top: 0,
      child: HoleCardCustomizationView(),
    );
  }

  Widget _buildCommunicationWidget() => Positioned(
        right: 0,
        top: 0,
        child: Consumer2<GameSettingsState, CommunicationState>(
            builder: (_, __, ____, ___) {
          return CommunicationView(
            widget.chatVisibilityChange,
            widget.gameContext.gameComService.gameMessaging,
            widget.gameContext,
          );
        }),
      );

  Widget _buildSeatConfirmWidget(BuildContext context) {
    final gameContextObject = context.read<GameContextObject>();
    final gameState = context.read<GameState>();

    final bool isHost = gameContextObject.isHost();

    // FIXME: REBUILD-FIX: need to check if seat change prompts are rebuilding as expected
    return Consumer<SeatChangeNotifier>(
      builder: (_, hostSeatChange, __) {
        final bool seatChangeInProgress = hostSeatChange.seatChangeInProgress ||
            gameState.hostSeatChangeInProgress;

        final bool showSeatChangeConfirmWidget = seatChangeInProgress &&
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
      builder: (_, handAction, __) =>
          MyLastActionAnimatingWidget(myAction: _myAction),
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
    List<Widget> children = [];
    if (gameState.customizationMode) {
      children.add(_buildMainView(gameState));
      /* communication widgets */
      children.add(_buildCustomizationView());
    } else if (!gameState.isPlaying) {
      // the player can join the waitlist
      log('Player is not playing, but can join waitlist');
      children.add(_buildMainView(gameState));
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
    }
    return Stack(
      children: children,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject();
    final pos = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    log('Footer view size: $size pos: $pos');

    final boardAttr = context.read<BoardAttributesObject>();
    boardAttr.setFooterDimensions(pos, size);
  }
}
