import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_action_button_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubActionsNew extends StatelessWidget {
  final ClubHomePageModel _clubHomePageModel;
  final String clubCode;

  ClubActionsNew(this._clubHomePageModel, this.clubCode);

  ClubActionButtonNew getChat() {
    Widget chatBadgeContent;
    if (_clubHomePageModel.unreadMessageCount > 0) {
      chatBadgeContent = Text(
        _clubHomePageModel.unreadMessageCount.toString(),
      );
    }
    Widget chat = ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.CHAT,
      "Chat",
      SvgPicture.asset("assets/images/club/chat.svg"),
      badgeContent: chatBadgeContent,
    );
    return chat;
  }

  ClubActionButtonNew getMembers() {
    Widget badgeContent;

    // TODO: Only club owner can see pending members
    if (_clubHomePageModel.isOwner &&
        _clubHomePageModel.pendingMemberCount > 0) {
      badgeContent = Text(
        _clubHomePageModel.pendingMemberCount.toString(),
        style: TextStyle(color: Colors.white),
      );
    }

    return ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.MEMBERS,
      "Members",
      SvgPicture.asset("assets/images/club/member.svg"),
      badgeContent: badgeContent,
    );
  }

  ClubActionButtonNew getHostMemberChatWidget() {
    Widget badgeContent;

    if (_clubHomePageModel.isOwner) {
      if (_clubHomePageModel.hostUnreadMessageCount > 0) {
        badgeContent = Text(
          _clubHomePageModel.hostUnreadMessageCount.toString(),
          style: TextStyle(color: Colors.white),
        );
      }
    } else {
      if (_clubHomePageModel.memberUnreadMessageCount > 0) {
        badgeContent = Text(
          _clubHomePageModel.memberUnreadMessageCount.toString(),
          style: TextStyle(color: Colors.white),
        );
      }
    }
    return ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.MESSAGE_HOST,
      "Message Host",
      SvgPicture.asset("assets/images/club/message_host.svg"),
      badgeContent: badgeContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClubActionButtonNew(
                this._clubHomePageModel,
                ClubActions.GAME_HISTORY,
                "Game History",
                SvgPicture.asset("assets/images/club/game_history.svg"),
              ),
            ),
            Expanded(
              child: getMembers(),
            ),
            Expanded(
              child: getChat(),
            ),
          ],
        ),
        AppDimensionsNew.getVerticalSizedBox(16.ph),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ClubActionButtonNew(
                this._clubHomePageModel,
                ClubActions.BOOKMARKED_HANDS,
                "Bookmarked Hands",
                SvgPicture.asset("assets/images/club/bookmarks.svg"),
              ),
            ),
            Expanded(
              flex: 3,
              child: ClubActionButtonNew(
                this._clubHomePageModel,
                ClubActions.ANALYSIS,
                "Analysis",
                SvgPicture.asset("assets/images/club/analysis.svg"),
              ),
            ),
            Expanded(
              flex: 3,
              child: ClubActionButtonNew(
                this._clubHomePageModel,
                ClubActions.ANNOUNCEMETS,
                "Announcements",
                SvgPicture.asset("assets/images/club/announcements.svg"),
              ),
            ),
          ],
        ),
        AppDimensionsNew.getVerticalSizedBox(16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: getHostMemberChatWidget(),
            ),
            // Expanded(
            //   flex: 3,
            //   child: ClubActionButtonNew(
            //     this._clubHomePageModel,
            //     ClubActions.MANAGE_CHIPS,
            //     "Manage Chips",
            //     SvgPicture.asset("assets/images/club/manage_chips.svg"),
            //   ),
            // ),
            // Expanded(
            //   flex: 3,
            //   child: ClubActionButtonNew(
            //     this._clubHomePageModel,
            //     ClubActions.REWARDS,
            //     "Rewards",
            //     SvgPicture.asset("assets/images/club/rewards.svg"),
            //     onTap: () {
            //       Navigator.pushNamed(
            //         context,
            //         Routes.rewards_list_screen,
            //         arguments: this.clubCode,
            //       );
            //     },
            //   ),
            // ),
            // Expanded(
            //   flex: 3,
            //   child: Container(),
            // ),
          ],
        ),
        AppDimensionsNew.getVerticalSizedBox(16),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ClubActionButtonNew(
                  this._clubHomePageModel,
                  ClubActions.BOTSCRIPTS,
                  "BOT Scripts",
                  SvgPicture.asset("assets/images/club/rewards.svg"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
