import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/profile_popup.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:provider/provider.dart';

import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'user_view_util_widgets.dart';

class PlayerView extends StatelessWidget {
  final GlobalKey globalKey;
  final int seatPos;
  final Seat userObject;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;
  final bool isPresent;
  final GameComService gameComService;
  int counter = 0;
  PlayerView({
    Key key,
    @required this.globalKey,
    @required this.seatPos,
    @required this.userObject,
    @required this.onUserTap,
    @required this.isPresent,
    @required this.gameComService,
    this.cardsAlignment = Alignment.centerRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool emptySeat = userObject.openSeat;
    bool isMe = userObject?.isMe ?? false;

    // enable this line for debugging dealer position
    // userObject.playerType = PlayerType.Dealer;
    if (emptySeat) {
      return OpenSeat(seatPos: userObject.serverSeatPos, onUserTap: this.onUserTap);
    }

    final GameInfoModel gameInfo = Provider.of<ValueNotifier<GameInfoModel>>(context, listen: false).value; 
    int actionTime = gameInfo.actionTime;
    String gameCode = gameInfo.gameCode;
    return DragTarget(
      onWillAccept: (data) {
        print("object data $data");
        return true;
      },
      onAccept: (data) {
        // call the API to make the seat change
        debugPrint("$counter Seat change player from: $data to seat ${userObject.serverSeatPos}");
        counter++;
        SeatChangeService.hostSeatChangeMove(gameCode, data, userObject.serverSeatPos);
      },
      builder: (context, List<int> candidateData, rejectedData) {
        return InkWell(
          onTap: () async {
                  Players players = Provider.of<Players>(
                    context,
                    listen: false,
                  );
                  // If user is not playing do not show dialog
                  if (players.me == null) {
                    return;
                  }
                  final userPrefrence = await showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                    builder: (context) {
                      return ProfilePopup(
                        userObject: userObject,
                      );
                    },
                  );
                  gameComService.chat.sendAnimation(players.me.seatNo, userObject.serverSeatPos, 'poop');
                },
          child: Stack(
            alignment: Alignment.center,
            children: [
              (userObject.showFirework ?? false)
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

              // main user body
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserViewUtilWidgets.buildAvatarAndLastAction(
                        avatarUrl: userObject.avatarUrl,
                        userObject: userObject,
                        cardsAlignment: cardsAlignment,
                      ),
                      NamePlateWidget(
                        userObject,
                        seatPos,
                        globalKey: globalKey,
                      ),
                    ],
                  ),
                ],
              ),

              emptySeat
                  ? shrinkedSizedBox
                  : UserViewUtilWidgets.buildHiddenCard(
                      alignment: this.cardsAlignment,
                      emptySeat: emptySeat,
                      cardNo: userObject.noOfCardsVisible,
                      seatPos: seatPos,
                      userObject: userObject,
                    ),

              // hidden cards show only for the folding animation
              isMe && (userObject.playerFolded ?? false)
                  ? UserViewUtilWidgets.buildHiddenCard(
                      seatPos: seatPos,
                      userObject: userObject,
                      alignment: this.cardsAlignment,
                      emptySeat: emptySeat,
                      cardNo: userObject.noOfCardsVisible,
                    )
                  : shrinkedSizedBox,

              // show dealer button, if user is a dealer
              userObject.playerType != null &&
                      userObject.playerType == PlayerType.Dealer
                  ? DealerButtonWidget(seatPos, isMe, GameType.HOLDEM)
                  : shrinkedSizedBox,

              /* timer
                      * the timer is show to the highlighted user
                      * */
              UserViewUtilWidgets.buildTimer(
                context: context,
                time: actionTime,
                userObject: userObject,
              ),

              /* building the chip amount widget */
              UserViewUtilWidgets.buildChipAmountWidget(
                seatPos: seatPos,
                userObject: userObject,
              ),

              UserViewUtilWidgets.buildSeatNoIndicator(userObject: userObject),
            ],
          ),
        );
      },
    );
  }
}
