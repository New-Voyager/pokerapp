import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/displaycards.dart';
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
import 'dart:math' as math;
/* this contains the player positions <seat-no, position> mapping */
// Map<int, Offset> playerPositions = Map();

class PlayerView extends StatelessWidget {
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

  onTap(BuildContext context) async {
    final seatChangeContext = Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    );

    if (seatChangeContext != null && seatChangeContext.seatChangeInProgress) {
      return;
    }
    log('seat ${seat.serverSeatPos} is tapped');
    if (seat.isOpen) {
      // the player tapped to sit-in
      onUserTap(seat.serverSeatPos);
    } else {
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
      final mySeat = gameState.mySeat(context);
      if (seat.serverSeatPos == mySeat.serverSeatPos) {
        return;
      }

      // Enable this for popup buttons
      gameState.setTappedSeatPos(context, seatPos, seat, gameComService);

      // final data = await showModalBottomSheet(
      //   context: context,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       top: Radius.circular(10),
      //     ),
      //   ),
      //   builder: (context) {
      //     return ProfilePopup(
      //       seat: seat,
      //     );
      //   },
      // );
      // if (data == null) return;

      // gameComService.gameMessaging.sendAnimation(
      //   me.seatNo,
      //   seat.serverSeatPos,
      //   data['animationID'],
      // );
    }
  }

  Widget _buildDisplayCardsWidget(
    Seat seat,
    FooterStatus footerStatus,
  ) =>
      Transform.translate(
        // TODO: NEED TO VERIFY THIS FOR DIFF SCREEN SIZES
        offset: const Offset(0.0, 20.0),
        child: Container(
          height: boardAttributes.namePlateSize.height,
          width: boardAttributes.namePlateSize.width,
          child: DisplayCardsWidget(
            seat,
            footerStatus,
          ),
        ),
      );

  bool _showHoleCard(GameState gameState, Seat seat) {
    return gameState.currentPlayerId == seat.player.playerId &&
        gameState.currentPlayerUuid == '';
  }

  @override
  Widget build(BuildContext context) {
    seat.key = GlobalKey(
      debugLabel: 'Seat:${seat.serverSeatPos}',
    ); //this.globalKey;

    // the player tapped to see the player profile
    final gameState = GameState.getState(context);
    bool openSeat = seat.isOpen;
    bool isMe = seat.isMe;
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
      bool seatChangeSeat = false;
      if (gameState.playerSeatChangeInProgress) {
        seatChangeSeat = seat.serverSeatPos == gameState.seatChangeSeat;
      }

      final openSeatWidget = OpenSeat(
        seatPos: seat.serverSeatPos,
        onUserTap: this.onUserTap,
        seatChangeInProgress: gameState.playerSeatChangeInProgress,
        seatChangeSeat: seatChangeSeat,
      );

      if (seat.isDealer)
        return Stack(
          alignment: Alignment.center,
          children: [
            // dealer button
            DealerButtonWidget(
              seat.uiSeatPos,
              isMe,
              GameType.HOLDEM,
            ),

            // main open seat widget
            openSeatWidget,
          ],
        );

      return openSeatWidget;
    }

    final GameInfoModel gameInfo = Provider.of<ValueNotifier<GameInfoModel>>(
      context,
      listen: false,
    ).value;
    String gameCode = gameInfo.gameCode;
    bool isDealer = false;

    if (!openSeat) {
      if (seat.player.playerType == TablePosition.Dealer) {
        isDealer = true;
      }
    }

    final boardAttributes = gameState.getBoardAttributes(context);
    seat.betWidgetUIKey = GlobalKey();

    bool animate = seat.player.action.animateAction;

    Widget chipAmountWidget = ChipAmountWidget(
      animate: animate,
      potKey: boardAttributes.getPotsKey(0),
      key: seat.betWidgetUIKey,
      seat: seat,
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
          seat.serverSeatPos,
        );
      },
      builder: (context, List<int> candidateData, rejectedData) {
        return InkWell(
          onTap: () => this.onTap(context),
          child: Stack(
            overflow: Overflow.visible,
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              (!openSeat ? seat.player?.showFirework ?? false : false)
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
                seat,
                globalKey: seat.key,
                boardAttributes: boardAttributes,
              ),

              // result cards and show selected cards by a user
              Consumer<ValueNotifier<FooterStatus>>(
                builder: (_, vnFooterStatus, __) =>
                    _buildDisplayCardsWidget(seat, vnFooterStatus.value),
              ),
              // Transform.translate(
              //     offset: Offset(70, 40),
              //     child:
              //         GamePlayScreenUtilMethods.breakBuyIntimer(context, seat)),

              // player action text
              Positioned(
                top: -6,
                left: 0,
                child: ActionStatusWidget(seat, cardsAlignment),
              ),

              // player hole cards
              Transform.translate(
                offset: boardAttributes.playerHoleCardOffset,
                child: Transform.scale(
                  scale: boardAttributes.playerHoleCardScale,
                  child: _showHoleCard(gameState, seat)
                      ? _buildDisplayCardsWidget(seat, FooterStatus.Result)
                      : PlayerCardsWidget(
                          seat,
                          this.cardsAlignment,
                          seat.player?.noOfCardsVisible,
                          showdown,
                        ),
                ),
              ),

              // show dealer button, if user is a dealer
              isDealer
                  ? DealerButtonWidget(
                      seat.uiSeatPos,
                      isMe,
                      GameType.HOLDEM,
                    )
                  : shrinkedSizedBox,

              // /* building the chip amount widget */
              animate
                  ? ChipAmountAnimatingWidget(
                      seatPos: seat.serverSeatPos,
                      child: chipAmountWidget,
                      reverse: seat.player.action.winner,
                    )
                  : chipAmountWidget,

              Consumer<SeatChangeNotifier>(
                builder: (_, scn, __) => scn.seatChangeInProgress
                    ? SeatNoWidget(seat)
                    : const SizedBox.shrink(),
              ),

              talkingAnimation(),
              seat.player.showMicOff
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
              seat.player.showMicOn
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

  Widget talkingAnimation() {
    double left;
    double right = -20;
    double talkingAngle = 0;
    if (seat.uiSeatPos == SeatPos.topRight ||
        seat.uiSeatPos == SeatPos.middleRight ||
        seat.uiSeatPos == SeatPos.bottomRight) {
      left = -15;
      right = null;
      talkingAngle = -math.pi;
    }

    return Visibility(
        visible: seat.player.talking,
        child: Positioned(
            bottom: 0,
            left: left,
            right: right,
            child: Transform.rotate(
                angle: talkingAngle,
                child: BlinkWidget(
                  children: [
                    SvgPicture.asset('assets/images/speak/speak-one.svg',
                        width: 16, height: 16, color: Colors.cyan),
                    SvgPicture.asset('assets/images/speak/speak-two.svg',
                        width: 16, height: 16, color: Colors.cyan),
                    SvgPicture.asset('assets/images/speak/speak-all.svg',
                        width: 16, height: 16, color: Colors.cyan),
                    SvgPicture.asset('assets/images/speak/speak-two.svg',
                        width: 16, height: 16, color: Colors.cyan),
                  ],
                ))));
  }
}

class SeatNoWidget extends StatelessWidget {
  final Seat seat;

  const SeatNoWidget(this.seat);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Transform.translate(
        offset: const Offset(-10.0, -10.0),
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
