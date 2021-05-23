import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/club_screen_icons_icons.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/club_action_buttons_view/club_action_button.dart';

class ClubActionButtonsView extends StatelessWidget {
  final ClubHomePageModel _clubHomePageModel;
  final String clubCode;

  ClubActionButtonsView(this._clubHomePageModel, this.clubCode);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.GAME_HISTORY,
                    "Game History",
                    Icon(
                      ClubScreenIcons.history,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.MEMBERS,
                    "Members",
                    Icon(
                      ClubScreenIcons.membership,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.CHAT,
                    "Chat",
                    Icon(
                      Icons.access_alarm,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.BOOKMARKED_HANDS,
                    "Bookmarked Hands",
                    Icon(
                      ClubScreenIcons.bookmark,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.ANALYSIS,
                    "Analysis",
                    Icon(
                      ClubScreenIcons.pie_chart,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.ANNOUNCEMETS,
                    "Announcements",
                    Icon(
                      ClubScreenIcons.announcements,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.MESSAGE_HOST,
                    "Message Host",
                    Icon(
                      ClubScreenIcons.message,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.MANAGE_CHIPS,
                    "Manage Chips",
                    Icon(
                      ClubScreenIcons.coin_stack,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.REWARDS,
                    "Rewards",
                    Icon(
                      ClubScreenIcons.reward,
                      color: AppColors.appAccentColor,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.rewards_list_screen,
                        arguments: this.clubCode,
                      );
                    },
                  ),
                ),
                // Expanded(
                //   flex: 3,
                //   child: Container(),
                // ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClubActionButton(
                    this._clubHomePageModel,
                    ClubActions.BOTSCRIPTS,
                    "BOT Scripts",
                    Icon(
                      ClubScreenIcons.announcements,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
