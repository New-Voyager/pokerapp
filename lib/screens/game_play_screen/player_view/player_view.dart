import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:provider/provider.dart';

import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'user_view_util_widgets.dart';

class PlayerView extends StatelessWidget {
  final int seatPos;
  final UserObject userObject;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;
  final bool isPresent;

  PlayerView({
    Key key,
    @required this.seatPos,
    @required this.userObject,
    @required this.onUserTap,
    @required this.isPresent,
    this.cardsAlignment = Alignment.centerRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool emptySeat = userObject.name == null;
    bool isMe = userObject.isMe ?? false;

    // enable this line for debugging dealer position
    // userObject.playerType = PlayerType.Dealer;

    int actionTime = Provider.of<ValueNotifier<GameInfoModel>>(
      context,
      listen: false,
    ).value.actionTime;

    return InkWell(
      onTap: emptySeat ? () => onUserTap(isPresent ? -1 : seatPos) : null,
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
                    emptySeat: emptySeat,
                    userObject: userObject,
                    cardsAlignment: cardsAlignment,
                  ),
                  NamePlateWidget(userObject, seatPos, emptySeat),
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
        ],
      ),
    );
  }
}
