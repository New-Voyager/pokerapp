import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'communication_view.dart';
import 'hand_analyse_view.dart';
import 'hole_cards_view_and_footer_action_view.dart';
import 'seat_change_confirm_widget.dart';

class FooterView extends StatefulWidget {
  //final GameComService gameComService;
  final String gameCode;
  final String clubCode;
  final String playerUuid;
  final Function chatVisibilityChange;
  final GameContextObject gameContext;

  FooterView(
    this.gameContext,
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
    // final boardAttributes = Provider.of<BoardAttributesObject>(
    //   context,
    //   listen: false,
    // );
    /*  final Size footerSize = boardAttributes.footerSize;
    final height = footerSize.height / 2;
    final width = footerSize.width * 2 / 3;
    final screen = boardAttributes.getScreen(context);
    final left = (footerSize.width - width) / 2;
    log('footer size: $footerSize width: $width, height: $height diagonal: ${screen.diagonalInches()}');
     */
    //
    // Screen s = boardAttributes.getScreen(context);
    //
    // final width = s.width() - 100;
    // final screen = boardAttributes.getScreen(context);
    // final height = screen.height() / 3;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Consumer2<Players, ActionState>(
      builder: (_, players, actionState, __) {
        bool me = players.me != null;

        // Need to use stack instead of Row to accomodate Voice text widget
        return Stack(
          children: [
            /* hand analyse view */
            Consumer<GameContextObject>(builder: (context, gameContext, _) {
              return Positioned(
                left: 0,
                top: 0,
                child: HandAnalyseView(
                  widget.gameCode,
                  widget.clubCode,
                  gameContext,
                ),
              );
            }),

            /* hole card view & footer action view */
            !me
                ? Container(width:screenWidth, height:screenHeight/3)
                : HoleCardsViewAndFooterActionView(
                    gameContext: widget.gameContext,
                    playerModel: players.me,
                    showActionWidget: actionState.show,
                  ),

            /* communication widgets */
            Positioned(
              right: 0,
              top: 0,
              child: CommunicationView(
                widget.chatVisibilityChange,
                widget.gameContext.gameComService.gameMessaging,
              ),
            ),

            /* seat confirm widget */
            // FIXME: BUG INTRODUCED HERE, CHECK HOW THE SEAT CHANGE CONFIRMED WIDGET IS DISPLAYED
            Consumer2<SeatChangeNotifier, GameContextObject>(
              builder: (
                context,
                hostSeatChange,
                gameContextObject,
                _,
              ) =>
                  hostSeatChange.seatChangeInProgress &&
                          gameContextObject.playerId ==
                              hostSeatChange.seatChangeHost
                      ? Align(
                          alignment: Alignment.center,
                          child: SeatChangeConfirmWidget(
                              gameCode: widget.gameContext.gameState.gameCode),
                        )
                      : SizedBox.shrink(),
            )
          ],
        );

        /*

        return Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: HandAnalyseView(widget.gameCode, widget.clubCode),
            ),
            !me
                ? SizedBox.shrink()
                : Positioned(
                    left: 50,
                    top: 0,
                    width: width,
                    height: height,
                    child: HoleCardsView(
                      gameContext: widget.gameContext,
                      playerModel: players.me,
                      showActionWidget: actionState.show,
                    ),
                  ),
            Align(
                alignment: Alignment.topRight,
                child: CommunicationView(widget.chatVisibilityChange,
                    widget.gameContext.gameComService.gameMessaging)),
            Consumer2<HostSeatChange, GameContextObject>(
              builder: (
                context,
                hostSeatChange,
                gameContextObject,
                _,
              ) =>
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
         */

        // Column(children: [
        //   SizedBox.fromSize(size: Size(0, 0)),
        //   Row(
        //     children: [
        //       HandAnalyseView(widget.gameCode, widget.clubCode),
        //       Expanded(
        //         child: !me
        //             ? SizedBox.shrink()
        //             : HoleCardsView(
        //                   playerModel: players.me,
        //                   showActionWidget: actionState.show,
        //                 ),

        //       ),
        //       CommunicationView(widget.chatVisibilityChange,
        //           widget.gameComService.gameMessaging),
        //       Consumer2<HostSeatChange, GameContextObject>(
        //         builder: (context, hostSeatChange, gameContextObject, _) =>
        //             hostSeatChange.seatChangeInProgress &&
        //                     gameContextObject.playerId ==
        //                         hostSeatChange.seatChangeHost
        //                 ? Align(
        //                     alignment: Alignment.center,
        //                     child: SeatChangeConfirmWidget(),
        //                   )
        //                 : SizedBox.shrink(),
        //       )
        //     ],
        //   )
        // ]);
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final RenderBox object = context.findRenderObject();
    final pos = object.localToGlobal(Offset(0, 0));
    final size = object.size;
    log('Footer view size: $size pos: $pos');
    final boardAttr = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    );
    boardAttr.setFooterDimensions(pos, size);
  }
}
