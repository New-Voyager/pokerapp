import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_action_button_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

class ClubActionsNew extends StatelessWidget {
  final ClubHomePageModel _clubHomePageModel;
  final String clubCode;
  final AppTextScreen appScreenText;

  ClubActionsNew(this._clubHomePageModel, this.clubCode, this.appScreenText);

  ClubActionButtonNew getChat(AppTheme theme) {
    Widget chatBadgeContent;
    if (_clubHomePageModel.unreadMessageCount > 0) {
      chatBadgeContent = Text(
        _clubHomePageModel.unreadMessageCount.toString(),
        style: TextStyle(color: theme.supportingColor),
      );
    }
    Widget chat = ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.CHAT,
      appScreenText['chat'],
      SvgPicture.asset("assets/icons/chat.svg", color: theme.accentColor),
      badgeContent: chatBadgeContent,
    );
    return chat;
  }

  ClubActionButtonNew getMembers(AppTheme theme) {
    Widget badgeContent;

    // TODO: Only club owner can see pending members
    if (_clubHomePageModel.isOwner &&
        _clubHomePageModel.pendingMemberCount > 0) {
      badgeContent = Text(
        _clubHomePageModel.pendingMemberCount.toString(),
        style: TextStyle(color: theme.supportingColor),
      );
    }

    return ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.MEMBERS,
      appScreenText['members'],
      SvgPicture.asset(
        "assets/images/club/member.svg",
        color: theme.accentColor,
      ),
      badgeContent: badgeContent,
    );
  }

  ClubActionButtonNew getHostMemberChatWidget(AppTheme theme) {
    Widget badgeContent;

    if (_clubHomePageModel.isOwner) {
      if (_clubHomePageModel.hostUnreadMessageCount > 0) {
        badgeContent = Text(
          _clubHomePageModel.hostUnreadMessageCount.toString(),
          style: TextStyle(color: theme.supportingColor),
        );
      }
    } else {
      if (_clubHomePageModel.memberUnreadMessageCount > 0) {
        badgeContent = Text(
          _clubHomePageModel.memberUnreadMessageCount.toString(),
          style: TextStyle(color: theme.supportingColor),
        );
      }
    }
    return ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.MESSAGE_HOST,
      this._clubHomePageModel.isOwner
          ? appScreenText['messageMembers']
          : appScreenText['messageHost'],
      SvgPicture.asset(
        "assets/icons/contacthost.svg",
        color: theme.accentColor,
      ),
      badgeContent: badgeContent,
    );
  }

  ClubActionButtonNew getSettingsWidget(AppTheme theme) {
    return ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.SETTINGS,
      appScreenText['settings'],
      Transform.scale(
          scale: 2.0,
          child: Icon(
            Icons.settings_outlined,
            color: theme.accentColor,
          )),
    );
  }

  ClubActionButtonNew getActivitiesWidget(AppTheme theme) {
    return ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.ACTIVITIES,
      'Activities',
      Transform.scale(
          scale: 2.0,
          child: Icon(
            Icons.list_alt_outlined,
            color: theme.accentColor,
          )),
    );
  }

  ClubActionButtonNew getMemberActivitiesWidget(AppTheme theme) {
    return ClubActionButtonNew(
        this._clubHomePageModel,
        ClubActions.MEMBER_ACTIVITIES,
        'Players Report',
        SvgPicture.asset('assets/images/game/memberactivities.svg',
            color: theme.accentColor));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(builder: (_, theme, __) {
      List<Widget> clubWidgets = getClubButtons(theme);
      return Column(children: clubWidgets);
    });
  }

  List<Widget> getClubButtons(AppTheme theme) {
    List<Widget> buttons = [];
    buttons.add(ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.GAME_HISTORY,
      appScreenText['gameHistory'],
      SvgPicture.asset(
        "assets/images/club/game_history.svg",
        color: theme.accentColor,
      ),
    ));
    buttons.add(getMembers(theme));
    buttons.add(ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.BOOKMARKED_HANDS,
      appScreenText['bookmarkedHands'],
      SvgPicture.asset(
        "assets/images/club/bookmarks.svg",
        color: theme.accentColor,
      ),
    ));
    buttons.add(getChat(theme));

    // shared hands
    buttons.add(
      ClubActionButtonNew(
        this._clubHomePageModel,
        ClubActions.SHARED_HANDS,
        appScreenText['shared_hands'],
        SvgPicture.asset("assets/images/club/sharedhands.svg",
            color: theme.accentColor),
      ),
    );

    buttons.add(getHostMemberChatWidget(theme));

    buttons.add(ClubActionButtonNew(
      this._clubHomePageModel,
      ClubActions.ANNOUNCEMETS,
      appScreenText['announcements'],
      SvgPicture.asset(
        "assets/images/club/announcements.svg",
        color: theme.accentColor,
      ),
    ));

    buttons.add(getSettingsWidget(theme));

    if (_clubHomePageModel.trackMemberCredit) {
      buttons.add(getActivitiesWidget(theme));
    }

    if (_clubHomePageModel.trackMemberCredit &&
        (_clubHomePageModel.isOwner ||
            (_clubHomePageModel.isManager &&
                _clubHomePageModel.role.viewMemberActivities))) {
      buttons.add(getMemberActivitiesWidget(theme));
    }

    if (_clubHomePageModel.isManager || _clubHomePageModel.isOwner) {
      buttons.add(ClubActionButtonNew(
        this._clubHomePageModel,
        ClubActions.HIGH_RANK_ANALYSIS,
        'Hand Rank\nAnalysis',
        // TODO: ADD TO APP SCREEN TEXT
        // appScreenText['botScripts'],
        SvgPicture.asset(
          "assets/images/club/rewards.svg",
          color: theme.accentColor,
        ),
      ));
    }
    // buttons.add(ClubActionButtonNew(
    //   this._clubHomePageModel,
    //   ClubActions.BOTSCRIPTS,
    //   appScreenText['botScripts'],
    //   SvgPicture.asset(
    //     "assets/images/club/rewards.svg",
    //     color: theme.accentColor,
    //   ),
    // ));

    List<Widget> rows = [];
    List<Widget> rowChildren = [];
    for (int i = 0; i < buttons.length; i++) {
      if (i % 3 == 0) {
        rowChildren = [];
        rows.add(AppDimensionsNew.getVerticalSizedBox(16));
        rows.add(Row(children: rowChildren));
      }
      rowChildren.add(Expanded(child: buttons[i]));
    }
    return rows;
  }
}
