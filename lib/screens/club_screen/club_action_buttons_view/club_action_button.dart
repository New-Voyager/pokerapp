import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_action_screens/club_members_view/club_members_view.dart';
import 'package:pokerapp/screens/club_screen/rewards_screen/rewards_list_screen.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_view.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/messages_page_view.dart';
import 'package:pokerapp/screens/game_screens/table_result/table_result.dart';
import 'package:provider/provider.dart';

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
    List<ClubMemberModel> _sampleList = new List<ClubMemberModel>();

    return Consumer<ClubHomePageModel>(
      builder: (_, ClubHomePageModel clubModel, __) => GestureDetector(
        onTap: () {
          switch (_action) {
            case ClubActions.GAME_HISTORY:
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameHistoryView(clubModel.clubCode),
                ),
              );
              break;

            case ClubActions.MEMBERS:
              return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClubMembersView(this._clubModel)),
              );

            case ClubActions.CHAT:
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MessagesPageView(clubCode: clubModel.clubCode),
                ),
              );
            case ClubActions.BOOKMARKED_HANDS:
              // TODO: Temporary place to show high hand.
              // TODO: Handle this case.
              break;
            case ClubActions.ANALYSIS:
              // TODO: Handle this case.
              break;
            case ClubActions.ANNOUNCEMETS:
              // TODO: Handle this case.
              break;
            case ClubActions.MESSAGE_HOST:
              // TODO: Handle this case.
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
                      fontSize: 14.0,
                      fontFamily: AppAssets.fontFamilyLato,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
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
