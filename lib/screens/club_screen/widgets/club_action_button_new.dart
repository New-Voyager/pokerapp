import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/routes.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../../main.dart';

class ClubActionButtonNew extends StatelessWidget {
  final ClubActions _action;
  final String _actionName;
  final Widget _actionIcon;
  final ClubHomePageModel _clubModel;
  final VoidCallback onTap;
  final Widget badgeContent;

  ClubActionButtonNew(
    this._clubModel,
    this._action,
    this._actionName,
    this._actionIcon, {
    this.onTap,
    this.badgeContent,
  });
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    Widget card = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 60.pw,
          height: 60.pw,
          child: _actionIcon,
        ),
        Padding(
          padding: EdgeInsets.all(5.0.pw),
          child: Text(
            _actionName,
            style: AppDecorators.getSubtitle1Style(theme: theme),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    if (badgeContent != null) {
      card = Badge(
        position: BadgePosition.topEnd(top: 0, end: 3.dp),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: badgeContent,
        child: card,
      );
    }

    return Consumer<ClubHomePageModel>(
      builder: (_, ClubHomePageModel clubModel, __) => GestureDetector(
        onTap: () {
          switch (_action) {
            case ClubActions.GAME_HISTORY:
              return Navigator.pushNamed(
                context,
                Routes.game_history,
                arguments: clubModel.clubCode,
              );
              break;

            case ClubActions.MEMBERS:
              return Navigator.pushNamed(
                context,
                Routes.club_members_view,
                arguments: this._clubModel,
              );

            case ClubActions.CHAT:
              return navigatorKey.currentState.pushNamed(
                Routes.message_page,
                arguments: clubModel.clubCode,
              );
            case ClubActions.BOOKMARKED_HANDS:
              return navigatorKey.currentState.pushNamed(
                Routes.bookmarked_hands,
                arguments: clubModel.clubCode,
              );
              break;
            case ClubActions.ANALYSIS:
              Navigator.pushNamed(
                context,
                Routes.club_statistics,
                arguments: clubModel.clubCode,
              );
              break;
            case ClubActions.ANNOUNCEMETS:
              Navigator.pushNamed(
                context,
                Routes.announcements,
                arguments: this._clubModel,
              );
              break;
            case ClubActions.MESSAGE_HOST:
              if (_clubModel.isOwner) {
                Navigator.pushNamed(
                  context,
                  Routes.club_members,
                  arguments: clubModel.clubCode,
                );
              } else {
                navigatorKey.currentState.pushNamed(
                  Routes.chatScreen,
                  arguments: {
                    'clubCode': clubModel.clubCode,
                  },
                );
              }
              break;
               case ClubActions.SETTINGS:
              Navigator.pushNamed(
                context,
                Routes.club_settings,
                arguments: this._clubModel,
              );
              break;
            case ClubActions.REWARDS:
              this.onTap();
              break;

            case ClubActions.BOTSCRIPTS:
              Navigator.pushNamed(
                context,
                Routes.bot_scripts,
                arguments: clubModel,
              );
              break;
          }
        },
        child: card,
      ),
    );
  }
}
