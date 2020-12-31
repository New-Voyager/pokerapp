import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/count_down_timer.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

const shrinkedSizedBox = const SizedBox.shrink();
const highlightColor = const Color(0xfff2a365);

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

  Widget _buildAvatarAndLastAction({
    String avatarUrl,
    bool emptySeat,
  }) =>
      Stack(
        alignment: Alignment.center,
        children: [
          /* displaying the avatar view */
          Consumer<ValueNotifier<FooterStatus>>(
            builder: (_, valueNotifierFooterStatus, __) {
              bool showDown =
                  valueNotifierFooterStatus.value == FooterStatus.Result;

              Widget avatarWidget = AnimatedOpacity(
                duration: AppConstants.animationDuration,
                curve: Curves.bounceInOut,
                opacity: emptySeat ? 0.0 : 0.90,
                child: AnimatedContainer(
                  duration: AppConstants.fastAnimationDuration,
                  curve: Curves.bounceInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                      color: userObject.highlight ?? false
                          ? highlightColor
                          : Colors.transparent,
                    ),
                    boxShadow: userObject.highlight ?? false
                        ? [
                            BoxShadow(
                              color: highlightColor.withAlpha(120),
                              blurRadius: 20.0,
                              spreadRadius: 20.0,
                            ),
                          ]
                        : [],
                  ),
                  child: CircleAvatar(
                    radius: 19.50,
                    /* todo: this needs to be replaced with NetworkImage */
                    backgroundImage:
                        AssetImage(avatarUrl ?? 'assets/images/2.png'),
                  ),
                ),
              );

              return Container(
                height: 19.50 * 3,
                child: AnimatedSwitcher(
                  duration: AppConstants.fastAnimationDuration,
                  child: showDown
                      ? (userObject?.isMe ?? false)
                          ? avatarWidget
                          : Transform.scale(
                              scale: 0.70,
                              child: StackCardView(
                                center: true,
                                cards: userObject.cards?.map((int c) {
                                      List<int> highlightedCards =
                                          userObject.highlightCards;
                                      CardObject card = CardHelper.getCard(c);

                                      card.smaller = true;
                                      if (highlightedCards?.contains(c) ??
                                          false) card.highlight = true;

                                      return card;
                                    })?.toList() ??
                                    [],
                              ),
                            )
                      : avatarWidget,
                ),
              );
            },
          ),

          /* showing the user last action */
          // showing user status
          Transform.translate(
            offset: Offset(
              cardsAlignment == Alignment.centerRight ? 45 : -45,
              5.0,
            ),
            child: _buildUserStatus(emptySeat),
          ),
        ],
      );

  Widget _buildPlayerInfo({
    String name,
    int chips,
    bool emptySeat,
  }) {
    /* changing background color as per last action
    * check/call -> green
    * raise/bet -> shade of yellow / blue might b? */

    Color statusColor = const Color(0xff474747); // default color

    String status = userObject.status;
    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }

    return Transform.translate(
      offset: Offset(0.0, -10.0),
      child: Container(
        // FIXME: the animation is causing to crash
//          duration: AppConstants.fastAnimationDuration,
//          curve: Curves.bounceInOut,
        width: 70.0,
        padding: (emptySeat && !isPresent)
            ? const EdgeInsets.all(10.0)
            : const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 5.0,
              ),
        decoration: BoxDecoration(
          borderRadius: emptySeat ? null : BorderRadius.circular(5.0),
          shape: emptySeat ? BoxShape.circle : BoxShape.rectangle,
          color: statusColor,
          border: Border.all(
            color: userObject.highlight ?? false
                ? highlightColor
                : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: (userObject.winner ?? false)
              ? [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 50.0,
                    spreadRadius: 20.0,
                  ),
                ]
              : userObject.highlight ?? false
                  ? [
                      BoxShadow(
                        color: highlightColor.withAlpha(120),
                        blurRadius: 20.0,
                        spreadRadius: 20.0,
                      ),
                    ]
                  : [],
        ),
        child: AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          reverseDuration: AppConstants.animationDuration,
          child: (emptySeat && !isPresent)
              ? Container(
            child: InkWell(
                  child: Text(
                    'Open',
                    style: AppStyles.openSeatTextStyle,
                  ),
                ))
              : AnimatedOpacity(
                  duration: AppConstants.animationDuration,
                  opacity: emptySeat ? 0.0 : 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        child: Text(
                          name?.toUpperCase() ?? 'name',
                          style: AppStyles.gamePlayScreenPlayerName,
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
                              height: 13.0,
                            ),

                            const SizedBox(width: 5.0),

                            Text(
                              chips?.toString() ?? 'XX',
                              style: AppStyles.gamePlayScreenPlayerChips,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /* if the footer status becomes footer result
  * then we need to show the user cards
  * as it's a show down time */

  Widget _buildHiddenCard({
    Alignment alignment,
    bool emptySeat = true,
  }) =>
      Consumer2<ValueNotifier<FooterStatus>, ValueNotifier<int>>(
        builder: (_, valueNotifierFooterStatus, valueNotifierCardNo, __) {
          bool showDown =
              valueNotifierFooterStatus.value == FooterStatus.Result;

          double shiftMultiplier = 1.0;
          int cardNo = valueNotifierCardNo.value;

          if (cardNo == 5) shiftMultiplier = 1.7;
          if (cardNo == 4) shiftMultiplier = 1.45;
          if (cardNo == 3) shiftMultiplier = 1.25;

          double xOffset;
          if (showDown)
            xOffset = (alignment == Alignment.centerLeft ? 1 : -1) *
                25.0 *
                (userObject.cards?.length ?? 0.0);
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
                child: (userObject.playerFolded ?? false)
                    ? const SizedBox.shrink(
                        key: ValueKey('one'),
                      )
                    : showDown
                        ? const SizedBox.shrink(
                            key: ValueKey('two'),
                          )
                        : HiddenCardView(),
              ),
            ),
          );
        },
      );

  // the following two widgets are only built for the current active player
  Widget _buildVisibleCard({
    List<CardObject> cards,
  }) =>
      Transform.translate(
        offset: Offset(
          -40.0,
          0.0,
        ),
        child: StackCardView(
          cards: cards,
          deactivated: userObject.playerFolded ?? false,
        ),
      );

  // this widget is only shown to the dealer
  Widget _buildDealerButton({
    Alignment alignment,
    bool isMe,
  }) =>
      Transform.translate(
        offset: Offset(
          alignment == Alignment.centerRight ? 50.0 : -50.0,
          18.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(5.0),
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
      child: AnimatedSwitcher(
        duration: AppConstants.fastAnimationDuration,
        reverseDuration: AppConstants.fastAnimationDuration,
        switchOutCurve: Curves.bounceInOut,
        switchInCurve: Curves.bounceInOut,
        child: userObject.highlight ?? false
            ? Transform.translate(
                offset: const Offset(0.0, -15.0),
                child: Transform.scale(
                  scale: 0.80,
                  child: CountDownTimer(
                    remainingTime: remainingTime,
                  ),
                ),
              )
            : shrinkedSizedBox,
      ),
    );
  }

  Widget _buildUserStatus(bool emptySeat) {
    /* The status message is not shown, if
    * 1. The seat is empty - nothing to show
    * 2. The current user is to act - the current user is highlighted */
    if (emptySeat || userObject.highlight) return shrinkedSizedBox;

    String status;

    if (userObject.status != null && userObject.status.isNotEmpty)
      status = userObject.status;

    if (userObject.status == AppConstants.WAIT_FOR_BUYIN)
      status = 'Waiting for Buy In';

    if (userObject.buyIn != null) status = 'Buy In ${userObject.buyIn} amount';

    if (userObject.status == AppConstants.PLAYING) status = null;

    // decide color from the status message
    // raise, bet -> red
    // check, call -> green
    Color statusColor = Colors.white; // default color be white

    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }

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
          : Text(
              status,
              style: AppStyles.userPopUpMessageTextStyle.copyWith(
                color: statusColor,
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
                  _buildAvatarAndLastAction(
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
            ],
          ),

          // cards
          isMe
              ? _buildVisibleCard(
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
                  : _buildHiddenCard(
                      alignment: this.cardsAlignment,
                      emptySeat: emptySeat,
                    ),

          // show dealer button, if user is a dealer
          userObject.playerType != null &&
                  userObject.playerType == PlayerType.Dealer
              ? _buildDealerButton(
                  alignment: this.cardsAlignment,
                  isMe: isMe,
                )
              : shrinkedSizedBox,

          /* timer
          * the timer is show to the highlighted user
          * */
          _buildTimer(
            context: context,
            time: actionTime,
          ),
        ],
      ),
    );
  }
}
