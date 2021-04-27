import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';
import 'communication_view.dart';
import 'game_action.dart';
import 'hand_analyse_view.dart';
import 'hole_cards_view.dart';
import 'seat_change_confirm_widget.dart';

class FooterView extends StatefulWidget {
  final GameComService gameComService;
  final String gameCode;
  final String clubCode;
  final String playerUuid;
  final Function chatVisibilityChange;

  FooterView(
    this.gameComService,
    this.gameCode,
    this.playerUuid,
    this.chatVisibilityChange,
    this.clubCode,
  );

  @override
  _FooterViewState createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView>
    with AfterLayoutMixin<FooterView> {
  @override
  Widget build(BuildContext context) {
    final boardAttributes =
        Provider.of<BoardAttributesObject>(context, listen: false);
    final Size footerSize = boardAttributes.footerSize;
    final height = footerSize.height / 2;
    final width = footerSize.width * 2 / 3;
    final screen = boardAttributes.getScreen(context);
    final left = (footerSize.width - width) / 2;
    log('footer size: $footerSize width: $width, height: $height diagonal: ${screen.diagonalInches()}');
    return Consumer2<Players, ActionState>(
      builder: (_, players, actionState, __) {
        return Stack(
          children: [
            Positioned(
                left: left,
                top: 20.0,
                width: width,
                child: players.me == null
                    ? const SizedBox.shrink()
                    : HoleCardsView(
                        playerModel: players.me,
                        showActionWidget: actionState.show,
                      )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HandAnalyseView(widget.gameCode, widget.clubCode),
                CommunicationView(widget.chatVisibilityChange,
                    widget.gameComService.gameMessaging),
              ],
            ),
            Consumer2<HostSeatChange, GameContextObject>(
              builder: (context, hostSeatChange, gameContextObject, _) =>
                  hostSeatChange.seatChangeInProgress &&
                          gameContextObject.playerId ==
                              hostSeatChange.seatChangeHost
                      ? Align(
                          alignment: Alignment.center,
                          child: SeatChangeConfirmWidget(),
                        )
                      : SizedBox.shrink(),
            )
          ],
        );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final RenderBox object = context.findRenderObject();
    final pos = object.localToGlobal(Offset(0, 0));
    final size = object.size;
    log('Footer view size: $size pos: $pos');
    final boardAttr =
        Provider.of<BoardAttributesObject>(context, listen: false);
    boardAttr.setFooterDimensions(pos, size);
  }
}
