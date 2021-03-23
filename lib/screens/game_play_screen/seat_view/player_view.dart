import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:provider/provider.dart';

import 'animating_widgets/fold_card_animating_widget.dart';
import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'user_view_util_widgets.dart';

class PlayerView extends StatelessWidget {
  final GlobalKey globalKey;
  final Seat seat;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;
  final GameComService gameComService;
  PlayerView({
    Key key,
    @required this.globalKey,
    @required this.seat,
    @required this.onUserTap,
    @required this.gameComService,
    this.cardsAlignment = Alignment.centerRight,
  }) : super(key: key);

  onTap(BuildContext context) async {
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

      await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) {
          return ProfilePopup(
            seat: seat,
          );
        },
      );
      gameComService.chat.sendAnimation(me.seatNo, seat.serverSeatPos, 'poop');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Rebuilding seat: ${seat.serverSeatPos}');

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

    // if open seat, just show openseat widget
    if (openSeat) {
      return OpenSeat(seatPos: seat.serverSeatPos, onUserTap: this.onUserTap);
    }

    // enable this line for debugging dealer position
    // userObject.playerType = PlayerType.Dealer;

    final GameInfoModel gameInfo = Provider.of<ValueNotifier<GameInfoModel>>(context, listen: false).value; 
    int actionTime = gameInfo.actionTime;
    String gameCode = gameInfo.gameCode;
    bool isDealer = false;

    if (!openSeat) {
      if(seat.player.playerType == TablePosition.Dealer) {
        isDealer = true;
      }
    }

    return DragTarget(
      onWillAccept: (data) {
        print("object data $data");
        return true;
      },
      onAccept: (data) {
        // call the API to make the seat change
        SeatChangeService.hostSeatChangeMove(gameCode, data, seat.serverSeatPos);
      },
      builder: (context, List<int> candidateData, rejectedData) {        
        return InkWell(
          onTap: () =>  this.onTap(context),
          child: Stack(
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserViewUtilWidgets.buildAvatarAndLastAction(
                        avatarUrl: seat.player?.avatarUrl,
                        seat: seat,
                        cardsAlignment: cardsAlignment,
                      ),
                      NamePlateWidget(
                        seat,
                        globalKey: globalKey,
                      ),
                    ],
                  ),
                ],
              ),

              PlayerCardsWidget(seat, this.cardsAlignment, seat.player?.noOfCardsVisible, showdown),

              // show dealer button, if user is a dealer
              isDealer ? DealerButtonWidget(seat.serverSeatPos, isMe, GameType.HOLDEM)
                  : shrinkedSizedBox,

              // clock
              UserViewUtilWidgets.buildTimer(
                context: context,
                time: actionTime,
                seat: seat,
              ),

              // /* building the chip amount widget */
              UserViewUtilWidgets.buildChipAmountWidget(
                seat: seat,
              ),

              SeatNoWidget(seat),
            ],
          ),
        );
      },
    );
  }
}


class OpenSeat extends StatelessWidget {
  final int seatPos;
  final Function(int) onUserTap;

  const OpenSeat({
    this.seatPos,
    this.onUserTap,
    Key key,
  }) : super(key: key);

  Widget _openSeat() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          log('Pressed $seatPos');
          this.onUserTap(seatPos);
        },
        child: Text(
          'Open $seatPos',
          style: AppStyles.openSeatTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Container(
          width: 70.0,
          padding: const EdgeInsets.all(10.0),
          child: _openSeat(),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0XFF494444),
          ),
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

  const PlayerCardsWidget(this.seat, this.alignment, this.noCards, this.showdown);
  
  @override
  Widget build(BuildContext context) {

    if (seat.folded ?? false) {
      return shrinkedSizedBox;  
    }
 
    double shiftMultiplier = 1.0;
    if (this.noCards == 5) shiftMultiplier = 1.7;
    if (this.noCards == 4) shiftMultiplier = 1.45;
    if (this.noCards == 3) shiftMultiplier = 1.25;

    double xOffset;
    if (showdown)
      xOffset = (alignment == Alignment.centerLeft ? 1 : -1) *
          25.0 *
          (seat.cards?.length ?? 0.0);
    else
      xOffset = (alignment == Alignment.centerLeft
          ? 35.0
          : -45.0 * shiftMultiplier);

    return Transform.translate(
      offset: Offset(
        xOffset * 0.50,
        45.0,
      ),
      child: AnimatedSwitcher(
        duration: AppConstants.fastAnimationDuration,
        child: Transform.scale(
          scale: 1.0,
          child: (seat.folded ?? false) ? FoldCardAnimatingWidget(seat: seat)
                    : showdown ? const SizedBox.shrink()
                      : HiddenCardView(noOfCards: this.noCards),
        ),
      ),
    );    
  }
}