import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class MemberItem extends StatelessWidget {
  final ClubMemberModel member;

  MemberItem({
    @required this.member,
  }) : assert(member != null);

  Widget _buildSideAction() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Balance',
          style: AppStyles.itemInfoSecondaryTextStyle,
        ),
        const SizedBox(height: 5.0),
        Text(
          '200.0',
          style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
            color: double.parse('200.0') > 0
                ? AppColors.positiveColor
                : AppColors.negativeColor,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        CustomTextButton(
          text: 'Boot',
          onTap: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var separator = SizedBox(height: 5.0);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*
          * member avatar
          * */

          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 10.0,
            ),
            child: Image.asset(
              (List.generate(3, (index) => 'assets/images/${index + 1}.png')
                    ..shuffle())
                  .first,
              height: 35.0,
            ),
          ),

          /*
          * main content
          * */

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /* member name */
                      Text(
                        member.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      /* user since */
                      separator,
                      Text(
                        'Member Since: ${DateFormat('dd MMM, yy').format(member.joinedDate)}',
                        style: AppStyles.itemInfoTextStyle,
                      ),

                      // TODO: need total buy in
                      /* total buyIn */
                      separator,
                      Text(
                        'Total BuyIn: 8000.00',
                        style: AppStyles.itemInfoTextStyle,
                      ),

                      // TODO: need profit
                      /* profit */
                      separator,
                      Text(
                        'Profit: -2000.00',
                        style: AppStyles.itemInfoTextStyle,
                      ),

                      /* last played on */
                      separator,
                      Text(
                        member.lastPlayedDate != null
                            ? 'Last Played on ${member.lastPlayedDate}'
                            : 'Never Played',
                        style: AppStyles.itemInfoTextStyle,
                      ),
                    ],
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
            child: _buildSideAction(),
          ),
        ],
      ),
    );
  }
}
