import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/mock_data/mock_club_data.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/text_button.dart';

class ClubItem extends StatelessWidget {
  final MockClubData club;

  ClubItem({
    @required this.club,
  });

  Widget _buildSideAction(MockClubData club) {
    return Column(
      mainAxisAlignment: club.isActive
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: club.isActive
          ? [
              Text(
                'Balance',
                style: AppStyles.itemInfoSecondaryTextStyle,
              ),
              SizedBox(height: 5.0),
              Text(
                club.balance,
                style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
                  color: double.parse(club.balance) > 0
                      ? AppColors.positiveColor
                      : AppColors.negativeColor,
                ),
              ),
            ]
          : club.incomingRequest
              ? [
                  TextButton(
                    text: 'Join',
                    onTap: () {},
                  ),
                  TextButton(
                    text: 'Decline',
                    onTap: () {},
                  ),
                ]
              : club.outgoingRequest
                  ? [
                      Text(
                        'Waiting For Approval',
                        textAlign: TextAlign.center,
                        style: AppStyles.itemInfoTextStyle.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                    ]
                  : [
                      TextButton(
                        text: 'Send Request',
                        split: true,
                        onTap: () {},
                      ),
                    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 10.0);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /*
                        * club name
                        * */

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

                      /*
                        * game type
                        * */

                      Text(
                        "Host: ${club.hostName}",
                        style: AppStyles.clubItemInfoTextStyle,
                      ),

                      /*
                      * just a spacer
                      * */
                      Spacer(),

                      /*
                        * Game ID
                        * */

                      Text(
                        '${club.memberCount} Member${club.memberCount == '0' || club.memberCount == '1' ? '' : 's'}',
                        style: AppStyles.itemInfoTextStyle,
                      ),

                      /* separator */
                      club.outgoingRequest || club.incomingRequest
                          ? SizedBox.shrink()
                          : separator,

                      /*
                        *  for played games -  session time and end time
                        *  for live games - open seats and
                        * */

                      club.outgoingRequest || club.incomingRequest
                          ? SizedBox.shrink()
                          : Text(
                              "Joined at ${club.joinDate}",
                              style: AppStyles.itemInfoTextStyle,
                            ),
                    ],
                  ),
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
