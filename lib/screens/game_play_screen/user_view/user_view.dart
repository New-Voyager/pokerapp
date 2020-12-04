import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:provider/provider.dart';

const shrinkedSizedBox = const SizedBox.shrink();

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
        duration: AppConstants.userOpacityAnimationDuration,
        opacity: emptySeat ? 0.0 : 0.70,
        child: CircleAvatar(
          radius: 28.0,
          /* todo: this needs to be replaced with NetworkImage */
          backgroundImage: AssetImage(avatarUrl ?? 'assets/images/1.png'),
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
          ),
          child: AnimatedOpacity(
            duration: AppConstants.userOpacityAnimationDuration,
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

  Widget _buildTimer({int time = 10}) => Positioned(
        top: 0,
        right: 0,
        child: Transform.translate(
          offset: const Offset(15.0, -15.0),
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
              time.toString(),
              style: AppStyles.itemInfoTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget _buildUserStatus(bool emptySeat) {
    if (emptySeat) return shrinkedSizedBox;

    String status = userObject.status;

    if (status == AppConstants.WAIT_FOR_BUYIN)
      status = 'Waiting for Buy In';
    else if (userObject.buyIn != null)
      status = 'Buy In ${userObject.buyIn} amount';
    else
      status = null;

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

    return InkWell(
      onTap: emptySeat ? () => onUserTap(seatPos) : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // main user body
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
              _buildUserStatus(
                emptySeat,
              ),
            ],
          ),

          // cards
          isMe
              ? Consumer<ValueNotifier<List<CardObject>>>(
                  builder: (_, valueNotifierListOfCards, __) =>
                      _buildVisibleCard(
                    cards: valueNotifierListOfCards.value,
                  ),
                )
              : emptySeat
                  ? shrinkedSizedBox
                  : _buildHiddenCard(alignment: this.cardsAlignment),

          // timer
          isMe ? _buildTimer() : shrinkedSizedBox,

          // TODO: ONLY FOR DEBUGGING
          emptySeat ? shrinkedSizedBox : _buildSeatNoIndicator(),
        ],
      ),
    );
  }
}
