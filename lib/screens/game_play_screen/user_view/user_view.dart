import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

const shrinkedSizedBox = const SizedBox.shrink();
const highlightColor = const Color(0xfff2a365);

class UserView extends StatelessWidget {
  final int seatPos;
  final UserObject userObject;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;

  UserView({
    Key key,
    @required this.seatPos,
    @required this.userObject,
    @required this.onUserTap,
    this.cardsAlignment = Alignment.centerRight,
  }) : super(key: key);

  Widget _buildAvatar({
    String avatarUrl,
    bool emptySeat,
  }) =>
      AnimatedOpacity(
        duration: AppConstants.opacityAnimationDuration,
        opacity: emptySeat ? 0.0 : 0.70,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2.0,
              color: userObject.highlight ?? false
                  ? highlightColor
                  : Colors.transparent,
            ),
          ),
          child: CircleAvatar(
            radius: 26.0,
            /* todo: this needs to be replaced with NetworkImage */
            backgroundImage: AssetImage(avatarUrl ?? 'assets/images/2.png'),
          ),
        ),
      );

  Widget _buildPlayerInfo({
    String name,
    int chips,
    bool emptySeat,
  }) =>
      Transform.translate(
        offset: Offset(0.0, -5.0),
        child: Container(
          width: 90.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff474747),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: userObject.highlight ?? false
                  ? highlightColor
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: AnimatedOpacity(
            duration: AppConstants.opacityAnimationDuration,
            opacity: emptySeat ? 0.0 : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Text(
                    name?.toUpperCase() ?? 'name',
                    style: AppStyles.itemInfoTextStyleHeavy,
                  ),
                ),
                const SizedBox(height: 3.0),
                FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // chip asset image
                      Image.asset(
                        'assets/images/chips.png',
                        height: 15.0,
                      ),

                      const SizedBox(width: 5.0),

                      Text(
                        chips?.toString() ?? 'XX',
                        style: AppStyles.itemInfoTextStyleHeavy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHiddenCard({Alignment alignment}) => Transform.translate(
        offset: Offset(
          alignment == Alignment.centerRight ? 38.0 : -48.0,
          -15.0,
        ),
        child: Transform.rotate(
          angle: 0.08,
          child: HiddenCardView(),
        ),
      );

  // the following two widgets are only built for the current active player
  Widget _buildVisibleCard({
    List<CardObject> cards,
  }) =>
      Transform.translate(
        offset: Offset(
          -48.0,
          -15.0,
        ),
        child: StackCardView(
          cards: cards,
        ),
      );

  // this widget is only shown to the dealer
  Widget _buildDealerButton({Alignment alignment}) => Transform.translate(
        offset: Offset(
          alignment == Alignment.centerRight ? 88.0 : -88.0,
          0.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 2.0,
                spreadRadius: 2.0,
              )
            ],
          ),
          child: const Text(
            'D',
            textAlign: TextAlign.center,
            style: AppStyles.dealerTextStyle,
          ),
        ),
      );

  // TODO: this is only needed for the DEBUGGING Purpose
  Widget _buildSeatNoIndicator() => Positioned(
        top: 0,
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
              userObject.serverSeatPos.toString(),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget _buildTimer({
    int time = 10,
    BuildContext context,
  }) {
    int remainingTime = Provider.of<RemainingTime>(
      context,
      listen: false,
    ).getRemainingTime();

    if (remainingTime == null) remainingTime = time;

    return Positioned(
      top: 0,
      right: 0,
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
          child: Countdown(
            seconds: remainingTime,
            build: (_, time) => Text(
              time.toStringAsFixed(0),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserStatus(bool emptySeat) {
    if (emptySeat) return shrinkedSizedBox;

    String status;

    if (userObject.status != null && userObject.status.isNotEmpty)
      status = userObject.status;

    if (userObject.status == AppConstants.WAIT_FOR_BUYIN)
      status = 'Waiting for Buy In';

    if (userObject.buyIn != null) status = 'Buy In ${userObject.buyIn} amount';

    return AnimatedSwitcher(
      duration: AppConstants.popUpAnimationDuration,
      reverseDuration: AppConstants.popUpAnimationDuration,
      switchInCurve: Curves.bounceInOut,
      switchOutCurve: Curves.bounceInOut,
      transitionBuilder: (widget, animation) => ScaleTransition(
        alignment: Alignment.topCenter,
        scale: animation,
        child: widget,
      ),
      child: status == null
          ? shrinkedSizedBox
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                status,
                style: AppStyles.userPopUpMessageTextStyle,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool emptySeat = userObject.name == null;
    bool isMe = userObject.isMe ?? false;

    int actionTime = Provider.of<ValueNotifier<GameInfoModel>>(
      context,
      listen: false,
    ).value.actionTime;

    return InkWell(
      onTap: emptySeat ? () => onUserTap(seatPos) : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // main user body
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatar(
                    avatarUrl: userObject.avatarUrl,
                    emptySeat: emptySeat,
                  ),
                  _buildPlayerInfo(
                    name: this.userObject.name,
                    chips: this.userObject.stack,
                    emptySeat: emptySeat,
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0.0, 25.0),
                child: _buildUserStatus(
                  emptySeat,
                ),
              ),
            ],
          ),

          // cards
          isMe
              ? Consumer<ValueNotifier<List<CardObject>>>(
                  builder: (_, valueNotifierListOfCards, __) =>
                      _buildVisibleCard(
                    cards: valueNotifierListOfCards.value
                      ..forEach((c) => c.smaller = true),
                  ),
                )
              : emptySeat
                  ? shrinkedSizedBox
                  : _buildHiddenCard(alignment: this.cardsAlignment),

          // show dealer button, if user is a dealer
          userObject.playerType != null &&
                  userObject.playerType == PlayerType.Dealer
              ? _buildDealerButton(
                  alignment: this.cardsAlignment,
                )
              : shrinkedSizedBox,

          /* timer
          * the timer is show to the highlighted user
          * */
          userObject.highlight ?? false
              ? _buildTimer(
                  context: context,
                  time: actionTime,
                )
              : shrinkedSizedBox,

          // TODO: ONLY FOR DEBUGGING
          emptySeat ? shrinkedSizedBox : _buildSeatNoIndicator(),
        ],
      ),
    );
  }
}
