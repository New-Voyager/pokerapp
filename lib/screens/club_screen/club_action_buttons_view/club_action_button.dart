import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/routes.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class ClubActionButton extends StatelessWidget {
  final ClubActions _action;
  final String _actionName;
  final Icon _actionIcon;
  final ClubHomePageModel _clubModel;
  final VoidCallback onTap;

  ClubActionButton(
      this._clubModel, this._action, this._actionName, this._actionIcon,
      {this.onTap});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<ClubMemberModel> _sampleList = new List<ClubMemberModel>();

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
              break;
            case ClubActions.ANALYSIS:
              break;
            case ClubActions.ANNOUNCEMETS:
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
            case ClubActions.MANAGE_CHIPS:
              // TODO: Handle this case.
              break;
            case ClubActions.REWARDS:
              this.onTap();
              break;
          }
        },
        child: Card(
          margin: EdgeInsets.all(8.0),
          color: AppColors.cardBackgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    _actionName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.017,
                      fontFamily: AppAssets.fontFamilyLato,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                  height: height * 0.06,
                  child: _actionIcon,
                ),
              ],
            ),
          ),
          elevation: 5.5,
        ),
      ),
    );
  }
}
