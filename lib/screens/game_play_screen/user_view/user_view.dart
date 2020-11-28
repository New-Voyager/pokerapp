import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';

class UserView extends StatelessWidget {
  final UserObject userObject;
  final Alignment cardsAlignment;
  final bool isMe;

  UserView({
    this.userObject,
    this.cardsAlignment = Alignment.centerRight,
    this.isMe = false,
  });

  Widget _buildAvatar({String avatarUrl}) => Opacity(
        opacity: 0.70,
        child: CircleAvatar(
          radius: 28.0,
          /* todo: this needs to be replaced with NetworkImage */
          backgroundImage: AssetImage(avatarUrl ?? 'assets/images/1.png'),
        ),
      );

  Widget _buildPlayerInfo({
    String name,
    int chips,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  name.toUpperCase(),
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
                      chips.toString(),
                      style: AppStyles.itemInfoTextStyleHeavy,
                    ),
                  ],
                ),
              ),
            ],
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
              (userObject.seatPosition + 1).toString(),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // main user body
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(avatarUrl: userObject.avatarUrl),
            _buildPlayerInfo(
              name: this.userObject.name,
              chips: this.userObject.chips,
            ),
          ],
        ),

        // cards
        this.isMe
            ? _buildVisibleCard(
                cards: [
                  CardObject(
                    suit: AppConstants.blackSpade,
                    label: 'A',
                    color: Colors.black,
                    smaller: true,
                  ),
                  CardObject(
                    suit: AppConstants.redHeart,
                    label: '9',
                    color: Colors.red,
                    smaller: true,
                  ),
                ],
              )
            : _buildHiddenCard(alignment: this.cardsAlignment),

        // timer
        this.isMe ? _buildTimer() : SizedBox.shrink(),

        // TODO: ONLY FOR DEBUGGING
        _buildSeatNoIndicator(),
      ],
    );
  }
}
