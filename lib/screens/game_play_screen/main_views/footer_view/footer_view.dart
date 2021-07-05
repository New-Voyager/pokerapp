import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:provider/provider.dart';
import 'communication_view.dart';
import 'hand_analyse_view.dart';
import 'hole_cards_view_and_footer_action_view.dart';
import 'seat_change_confirm_widget.dart';

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

  Players _players;

  void onPlayersChanges() {
    final PlayerModel me = _players?.me;
    mePlayerModelVn.value = me;
  }

  /* init */
  void _init() {
    _players = context.read<Players>();
    mePlayerModelVn.value = _players?.me;

    // listen for changes in my PlayerModel state
    _players?.addListener(onPlayersChanges);
  }

  void _dispose() => _players?.removeListener(onPlayersChanges);

  /* hand analyse view builder */
  Widget _buildHandAnalyseView(GameState gameState) =>
      Consumer<GameContextObject>(
        builder: (context, gameContext, _) => Positioned(
          left: 0,
          top: 0,
          child: HandAnalyseView(
            gameState,
            widget.clubCode,
            gameContext,
          ),
        ),
      );

  /* straddle prompt builder / footer action view builder / hole card view builder */
  Widget _buildMainView() {
    final width = MediaQuery.of(context).size.width;

    /* build the HoleCardsViewAndFooterActionView only if me is NOT null */
    return ValueListenableBuilder<PlayerModel>(
      valueListenable: mePlayerModelVn,
      builder: (_, me, __) => me == null
          ? SizedBox(width: width)
          : Consumer2<StraddlePromptState, ActionState>(
              builder: (context, _, ActionState actionState, __) =>
                  HoleCardsViewAndFooterActionView(playerModel: me),
            ),
    );
  }

  Widget _buildCommunicationWidget() => Positioned(
        right: 0,
        top: 0,
        child: CommunicationView(
          widget.chatVisibilityChange,
          widget.gameContext.gameComService.gameMessaging,
        ),
      );

  Widget _buildSeatConfirmWidget(GameState gameState) =>
      Consumer2<SeatChangeNotifier, GameContextObject>(
        builder: (context, hostSeatChange, gameContextObject, _) =>
            (hostSeatChange.seatChangeInProgress ||
                        gameState.hostSeatChangeInProgress) &&
                    gameContextObject.isHost() &&
                    !gameState.playerSeatChangeInProgress
                ? Align(
                    alignment: Alignment.center,
                    child: SeatChangeConfirmWidget(
                      gameCode: widget.gameContext.gameState.gameCode,
                    ),
                  )
                : SizedBox.shrink(),
      );

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
    log('FooterView:  ::build::');
    final gameState = GameState.getState(context);

    return Stack(
      children: [
        /* hand analyse view */
        _buildHandAnalyseView(gameState),

        /* build main view - straddle prompt, hole cards, action view*/
        _buildMainView(),

        /* communication widgets */
        _buildCommunicationWidget(),

        /* seat confirm widget */
        _buildSeatConfirmWidget(gameState),
      ],
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
