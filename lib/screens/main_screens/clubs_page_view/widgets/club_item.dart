import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

import '../../../../utils/color_generator.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubItemView extends StatelessWidget {
  final ClubModel club;
  ClubItemView(this.club);

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 10.0);
    Widget clubName = Text(
      club.clubName,
      style: AppStylesNew.cardHeaderTextStyle.copyWith(
        fontSize: 14.dp,
        color: AppColorsNew.yellowAccentColor,
      ),
    );

    if (club.hostUnreadMessageCount != 0 ||
        club.memberUnreadMessageCount != 0 ||
        club.pendingMemberCount != 0 ||
        club.unreadMessageCount != 0) {
      clubName = Badge(
          position: BadgePosition.topEnd(top: -5),
          badgeContent: null,
          child: clubName);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(flex: 6, child: clubName),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(right: 16, left: 8),
                child: Text(
                  club.balance == '0' ? '' : club.balance,
                  textAlign: TextAlign.end,
                  style: AppStylesNew.valueTextStyle.copyWith(
                    color: double.parse(club.balance) > 0
                        ? AppColors.positiveColor
                        : AppColors.negativeColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        separator,
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStringsNew.clubCodeLabel,
                    style: AppStylesNew.labelTextStyle,
                  ),
                  Text(
                    "${club.clubCode}",
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStringsNew.hostedBy,
                    style: AppStylesNew.labelTextStyle,
                  ),
                  Text(
                    club.isOwner ? "You" : "${club.hostName}",
                  ),
                ],
              ),
            ],
          ),
        ),
        separator,
        Divider(
          height: 8,
          endIndent: 16,
          color: AppColorsNew.newBackgroundBlackColor,
        ),
        Padding(
          padding: EdgeInsets.only(right: 16, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   AppStringsNew.memberCountLabel,
                  //   style: AppStylesNew.labelTextStyle,
                  // ),
                  Text(
                    '${club.memberCount} Member${club.memberCount == 0 || club.memberCount == 1 ? '' : 's'}',
                    style: AppStylesNew.appBarSubTitleTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Text(
        //   '${club.memberCount} Member${club.memberCount == 0 || club.memberCount == 1 ? '' : 's'}',
        //   style: AppStyles.itemInfoTextStyle,
        // ),

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
    /* if (club.memberStatus == 'ACTIVE') {
      children = [
        club.balance == '0'
            ? SizedBox(
                height: 0,
              )
            : Text(
                club.balance,
                style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
                  color: double.parse(club.balance) > 0
                      ? AppColors.positiveColor
                      : AppColors.negativeColor,
                ),
              ),
      ];
    } else */
    /*  if (club.memberStatus == 'INVITED') {
      children = [
        RoundedColorButton(
          text: 'Join',
          onTapFunction: () {},
          backgroundColor: AppColorsNew.newGreenButtonColor,
          textColor: AppColorsNew.darkGreenShadeColor,
        ),
        AppDimensionsNew.getHorizontalSpace(32),
        RoundedColorButton(
          text: 'Decline',
          onTapFunction: () {},
          backgroundColor: AppColorsNew.newRedButtonColor,
        ),
      ];
    } else  */
    if (club.memberStatus == 'PENDING') {
      children = [
        CircularProgressWidget(
          showText: false,
          height: 16,
        ),
        AppDimensionsNew.getHorizontalSpace(8),
        Text(
          'Waiting For Approval',
          textAlign: TextAlign.center,
        ),
      ];
    }

    if (children.length == 0) {
      return SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: club.isActive
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: <Widget>[
            /*
            * color
            * */

            // Container(
            //   width: 16.0,
            //   constraints: BoxConstraints(minHeight: 100),
            //   decoration: BoxDecoration(
            //     color: generateColorFor(club.clubCode),
            //     borderRadius: BorderRadius.horizontal(
            //       left: Radius.circular(AppDimensions.cardRadius),
            //     ),
            //   ),
            // ),

            /*
            * main content
            * */

            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 12, top: 8.0, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: <Widget>[
                    ClubItemView(club),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: Text(
                    //     club.isActive
                    //         ? 'Active'
                    //         : club.incomingRequest
                    //             ? 'Invited on ${club.invitationDate}'
                    //             : '',
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            /*
            * action button or status
            * */
          ],
        ),
        Visibility(
          visible: (club.memberStatus == 'PENDING'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: AppColorsNew.actionRowBgColor,
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimensions.cardRadius),
              ),
              boxShadow: AppStyles.cardBoxShadowMedium,
            ),
            child: _buildSideAction(club),
          ),
        ),
      ],
    );
  }
}
