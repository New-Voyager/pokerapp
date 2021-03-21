import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:provider/provider.dart';

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
      Players players = Provider.of<Players>(
        context,
        listen: false,
      );
      // If user is not playing do not show dialog
      if (players.me == null) {
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
      gameComService.chat.sendAnimation(players.me.seatNo, seat.serverSeatPos, 'poop');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool openSeat = seat.isOpen;
    bool isMe = seat.isMe;

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

              openSeat
                  ? shrinkedSizedBox
                  : UserViewUtilWidgets.buildHiddenCard(
                      alignment: this.cardsAlignment,
                      cardNo: seat.player?.noOfCardsVisible ?? 0,
                      seat: seat,
                    ),

              // hidden cards show only for the folding animation
              isMe && (seat.folded ?? false)
                  ? UserViewUtilWidgets.buildHiddenCard(
                      seat: seat,
                      alignment: this.cardsAlignment,
                      cardNo: seat.player?.noOfCardsVisible ?? 0,
                    )
                  : shrinkedSizedBox,

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

              UserViewUtilWidgets.buildSeatNoIndicator(seat: seat),
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

