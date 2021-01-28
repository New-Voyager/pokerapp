import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/animating_widgets/chip_amount_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/animating_widgets/fold_card_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/count_down_timer.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view_util_widgets.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  final int seatPos;
  final UserObject userObject;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;
  final bool isPresent;

  UserView({
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
                  UserViewUtilWidgets.buildPlayerInfo(
                    name: this.userObject.name,
                    chips: this.userObject.stack,
                    emptySeat: emptySeat,
                    isPresent: isPresent,
                    userObject: userObject,
                  ),
                ],
              ),
            ],
          ),

          // cards
          isMe
              ? UserViewUtilWidgets.buildVisibleCard(
                  playerFolded: userObject.playerFolded,
                  cards: userObject.cards?.map(
                        (int c) {
                          CardObject card = CardHelper.getCard(c);
                          card.smaller = true;

                          return card;
                        },
                      )?.toList() ??
                      List<CardObject>(),
                )
              : emptySeat
                  ? shrinkedSizedBox
                  : UserViewUtilWidgets.buildHiddenCard(
                      alignment: this.cardsAlignment,
                      emptySeat: emptySeat,
                      cardNo: userObject.noOfCardsVisible,
                      seatPos: seatPos,
                      userObject: userObject,
                    ),

          // hidden cards for me to show animation
          isMe
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
              ? UserViewUtilWidgets.buildDealerButton(
                  alignment: this.cardsAlignment,
                  isMe: isMe,
                )
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
