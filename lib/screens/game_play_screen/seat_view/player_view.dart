import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/popup_buttons.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/displaycards.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:provider/provider.dart';

import 'action_status.dart';
import 'animating_widgets/fold_card_animating_widget.dart';
import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'chip_amount_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'open_seat.dart';

/* this contains the player positions <seat-no, position> mapping */
// Map<int, Offset> playerPositions = Map();

class PlayerView extends StatefulWidget {
  final Seat seat;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;
  final GameComService gameComService;
  final BoardAttributesObject boardAttributes;
  final int seatPosIndex;
  final SeatPos seatPos;

  PlayerView({
    Key key,
    @required this.seat,
    @required this.onUserTap,
    @required this.gameComService,
    @required this.boardAttributes,
    @required this.seatPosIndex,
    @required this.seatPos,
    this.cardsAlignment = Alignment.centerRight,
  }) : super(key: key);

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView>
    with SingleTickerProviderStateMixin {
  //AnimationController _animationController;
  PopupWidget popupWidget;
  @override
  void initState() {
    // _animationController = AnimationController(
    //   vsync: this,
    //   lowerBound: 0.0,
    //   upperBound: 1.0,
    //   duration: Duration(milliseconds: 200),
    // );
    // _animationController.addListener(() {
    //   // print("11234 value : ${_animationController.value}");
    //   setState(() {});
    // });
    super.initState();
  }

  onTap(BuildContext context) async {
    // log('11234seat ${widget.seat.serverSeatPos} is tapped');
    if (widget.seat.isOpen) {
      // the player tapped to sit-in
      widget.onUserTap(widget.seat.serverSeatPos);
    } else {
      // log('11234seat starting animation');

      //popupWidget.toggle();

      // _animationController.value > 0
      //     ? _animationController.reverse()
      //     : _animationController.forward();
      // the player tapped to see the player profile
      final gameState = Provider.of<GameState>(
        context,
        listen: false,
      );

      final me = gameState.me(context);
      // If user is not playing do not show dialog
      if (me == null) {
        return;
      }

      if (gameState.getTappedSeatPos == null) {
        gameState.setTappedSeatPos(context, widget.seatPos);
      } else {
        gameState.setTappedSeatPos(context, null);
      }
      // final data = await showModalBottomSheet(
      //   context: context,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       top: Radius.circular(10),
      //     ),
      //   ),
      //   builder: (context) {
      //     return ProfilePopup(
      //       seat: widget.seat,
      //     );
      //   },
      // );

      // if (data == null) return;

      // widget.gameComService.gameMessaging.sendAnimation(
      //   me.seatNo,
      //   widget.seat.serverSeatPos,
      //   data['animationID'],
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.seat.key = GlobalKey(
      debugLabel: 'Seat:${widget.seat.serverSeatPos}',
    ); //this.globalKey;

    bool openSeat = widget.seat.isOpen;
    bool isMe = widget.seat.isMe;
    FooterStatus footerStatus = Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value;

    bool showdown = false;
    if (footerStatus == FooterStatus.Result) {
      showdown = true;
    }

    // if open seat, just show open seat widget
    if (openSeat) {
      return OpenSeat(
          seatPos: widget.seat.serverSeatPos, onUserTap: this.widget.onUserTap);
    }

    final GameInfoModel gameInfo = Provider.of<ValueNotifier<GameInfoModel>>(
      context,
      listen: false,
    ).value;
    String gameCode = gameInfo.gameCode;
    bool isDealer = false;

    if (!openSeat) {
      if (widget.seat.player.playerType == TablePosition.Dealer) {
        isDealer = true;
      }
    }

    final gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);
    widget.seat.betWidgetUIKey = GlobalKey();

    bool animate = widget.seat.player.action.animateAction;

    Widget chipAmountWidget = ChipAmountWidget(
      animate: animate,
      potKey: boardAttributes.getPotsKey(0),
      key: widget.seat.betWidgetUIKey,
      seat: widget.seat,
      boardAttributesObject: boardAttributes,
      gameInfo: gameInfo,
    );
    return DragTarget(
      onWillAccept: (data) {
        print("object data $data");
        return true;
      },
      onAccept: (data) {
        // call the API to make the seat change
        SeatChangeService.hostSeatChangeMove(
          gameCode,
          data,
          widget.seat.serverSeatPos,
        );
      },
      builder: (context, List<int> candidateData, rejectedData) {
        // log("112345OFFSET: ${widget.boardAttributes.getSeatPosAttrib(widget.seatPos).topLeft.dx} : ${widget.boardAttributes.betAmountPosition[widget.seatPos]}");
        return InkWell(
          onTap: () => this.onTap(context),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // FloatingMenuItem(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.yellow,
              //     ),
              //     child: Icon(Icons.volume_down),
              //   ),
              //   controller: _animationController,
              //   seatPosition: widget.seatPos,
              //   itemNo: 1,
              //   onTapFunc: () {
              //     log("TAPPED 1");
              //   },
              // ),
              // FloatingMenuItem(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.blue,
              //     ),
              //     child: Icon(Icons.star),
              //   ),
              //   controller: _animationController,
              //   seatPosition: widget.seatPos,
              //   itemNo: 2,
              //   onTapFunc: () {
              //     log("TAPPED 2");
              //   },
              // ),
              // FloatingMenuItem(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.red,
              //     ),
              //     child: Icon(Icons.volume_mute),
              //   ),
              //   controller: _animationController,
              //   seatPosition: widget.seatPos,
              //   itemNo: 3,
              //   onTapFunc: () {
              //     log("TAPPED 3");
              //   },
              // ),
              
              (!openSeat ? widget.seat.player?.showFirework ?? false : false)
                  ? Transform.translate(
                      offset: Offset(
                        0.0,
                        -20.0,
                      ),
                      child: Image.asset(
                        AppAssets.fireworkGif,
                        height: 100,
                        width: 100,
                      ),
                    )
                  : shrinkedSizedBox,

              // // main user body
              NamePlateWidget(
                widget.seat,
                globalKey: widget.seat.key,
                boardAttributes: boardAttributes,
              ),

              // result cards and show selected cards by a user
              Consumer<ValueNotifier<FooterStatus>>(
                builder: (
                  _,
                  valueNotifierFooterStatus,
                  __,
                ) {
                  return Container(
                    height: boardAttributes.namePlateSize.height,
                    width: boardAttributes.namePlateSize.width,
                    child: DisplayCardsWidget(
                      widget.seat,
                      valueNotifierFooterStatus.value,
                    ),
                  );
                },
              ),

              // player action text
              Positioned(
                top: 0,
                left: 0,
                child: ActionStatusWidget(widget.seat, widget.cardsAlignment),
              ),

              // player hole cards
              Transform.translate(
                offset: boardAttributes.playerHoleCardOffset,
                child: Transform.scale(
                  scale: boardAttributes.playerHoleCardScale,
                  child: gameState.currentPlayerId ==
                              widget.seat.player.playerId &&
                          gameState.currentPlayerUuid == ''
                      ? DisplayCardsWidget(
                          widget.seat,
                          FooterStatus.Result,
                        )
                      : PlayerCardsWidget(
                          widget.seat,
                          this.widget.cardsAlignment,
                          widget.seat.player?.noOfCardsVisible,
                          showdown,
                        ),
                ),
              ),

              // show dealer button, if user is a dealer
              isDealer
                  ? DealerButtonWidget(
                      widget.seat.serverSeatPos,
                      isMe,
                      GameType.HOLDEM,
                    )
                  : shrinkedSizedBox,

              // /* building the chip amount widget */
              animate
                  ? ChipAmountAnimatingWidget(
                      seatPos: widget.seat.serverSeatPos,
                      child: chipAmountWidget,
                      reverse: widget.seat.player.action.winner,
                    )
                  : chipAmountWidget,
              // SeatNoWidget(seat),
              Visibility(
                  visible: widget.seat.player.talking,
                  child: Positioned(
                      top: 0,
                      right: -20,
                      child: Container(
                          width: 22,
                          height: 22,
                          color: Colors.transparent,
                          child: Icon(
                            Icons.volume_up_outlined,
                            color: Colors.white70,
                          )))),
              widget.seat.player.showMicOff
                  ? Positioned(
                      top: 0,
                      right: -20,
                      child: Container(
                          width: 22,
                          height: 22,
                          color: Colors.transparent,
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white70,
                          )))
                  : SizedBox(),
              widget.seat.player.showMicOn
                  ? Positioned(
                      top: 0,
                      right: -20,
                      child: Container(
                        width: 22,
                        height: 22,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.mic,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

class SeatNoWidget extends StatelessWidget {
  final Seat seat;

  const SeatNoWidget(this.seat);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Transform.translate(
        offset: const Offset(0.0, -15.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xff474747),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff14e81b),
              width: 1.0,
            ),
          ),
          child: Text(
            seat.serverSeatPos.toString(),
            style: AppStyles.itemInfoTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerCardsWidget extends StatelessWidget {
  final Seat seat;
  final Alignment alignment;
  final bool showdown;
  final int noCards;

  const PlayerCardsWidget(
    this.seat,
    this.alignment,
    this.noCards,
    this.showdown,
  );

  @override
  Widget build(BuildContext context) {
    // if (seat.folded ?? false) {
    //   return shrinkedSizedBox;
    // }

    double shiftMultiplier = 1.0;
    if (this.noCards == 5) shiftMultiplier = 1.7;
    if (this.noCards == 4) shiftMultiplier = 1.45;
    if (this.noCards == 3) shiftMultiplier = 1.25;

    double xOffset;
    if (showdown)
      xOffset = (alignment == Alignment.centerLeft ? 1 : -1) *
          25.0 *
          (seat.cards?.length ?? 0.0);
    else {
      xOffset =
          (alignment == Alignment.centerLeft ? 35.0 : -45.0 * shiftMultiplier);
      xOffset = -45.0 * shiftMultiplier;
    }
    if (showdown) {
      return const SizedBox.shrink();
    } else if (seat.folded ?? false) {
      return Transform.translate(
        offset: Offset(
          xOffset * 0.50,
          45.0,
        ),
        child: FoldCardAnimatingWidget(seat: seat),
      );
    } else {
      //log('Hole cards');
      return Transform.translate(
        offset: Offset(
          xOffset * 0.50,
          25.0,
        ),
        child: Transform.scale(
          scale: 0.75,
          child: HiddenCardView(noOfCards: this.noCards),
        ),
      );
    }
  }
}

