import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class ClubItemView extends StatelessWidget {
  final ClubModel club;
  ClubItemView(this.club);

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 10.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          club.clubName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w700,
          ),
        ),
        separator,

        Text(
          "Code: ${club.clubCode}",
          style: AppStyles.clubCodeStyle,
        ),

        Text(
          club.isOwner ? "Host: You" : "Host: ${club.hostName}",
          style: AppStyles.clubItemInfoTextStyle,
        ),

        Spacer(),

        Text(
          '${club.memberCount} Member${club.memberCount == 0 || club.memberCount == 1 ? '' : 's'}',
          style: AppStyles.itemInfoTextStyle,
        ),

        /* separator */
        club.outgoingRequest || club.incomingRequest
            ? SizedBox.shrink()
            : separator,

        club.outgoingRequest || club.incomingRequest
            ? SizedBox.shrink()
            : Text(
          "Joined at ${club.joinDate}",
          style: AppStyles.itemInfoTextStyle,
        ),
      ],
    );
  }
}

class ClubItem extends StatelessWidget {
  final ClubModel club;

  ClubItem({
    @required this.club,
  }) {
    club.incomingRequest = false;
    club.outgoingRequest = true;
    club.isActive = false;
    club.hasJoined = false;
  }

  Widget _buildSideAction(ClubModel club) {
    List<Widget> children = [];
    if (club.memberStatus == 'ACTIVE') {
      children = [
        club.balance == '0' ? SizedBox(height: 0,) :
        Text(
          club.balance,
          style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
            color: double.parse(club.balance) > 0
                ? AppColors.positiveColor
                : AppColors.negativeColor,
          ),
        ),
      ];
    } else if(club.memberStatus == 'INVITED') {
      children = [
        CustomTextButton(
          text: 'Join',
          onTap: () {},
        ),
        CustomTextButton(
          text: 'Decline',
          onTap: () {},
        ),
      ];
    } else if(club.memberStatus == 'PENDING') {
      children = [
        Text(
          'Waiting For Approval',
          textAlign: TextAlign.center,
          style: AppStyles.itemInfoTextStyle.copyWith(
            fontSize: 16.0,
          ),
        ),
      ];
    }

    return Column(
      mainAxisAlignment: club.isActive
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 135.0,
      decoration: const BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
        boxShadow: AppStyles.cardBoxShadow,
      ),
      child: Row(
        children: <Widget>[
          /*
          * color
          * */

          Container(
            width: 16.0,
            height: double.infinity,
            decoration: BoxDecoration(
              color: ([
                Color(0xffef9712),
                Color(0xff12efc2),
                Color(0xffef1229),
              ]..shuffle())
                  .first,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
          ),

          /*
          * main content
          * */

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Stack(
                children: <Widget>[
                  ClubItemView(club),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      club.isActive
                          ? 'Active'
                          : club.incomingRequest
                              ? 'Invited on ${club.invitationDate}'
                              : '',
                      style: AppStyles.itemInfoTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*
          * action button or status
          * */

          Container(
            width: 120.0,
            decoration: const BoxDecoration(
              color: AppColors.cardBackgroundColor,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(AppDimensions.cardRadius),
              ),
              boxShadow: AppStyles.cardBoxShadowMedium,
            ),
            child: _buildSideAction(club),
          ),
        ],
      ),
    );
  }
}
