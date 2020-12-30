import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_actions.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_action_screens/club_members_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/high_hand/high_hand.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/messages_page_view.dart';
import 'package:provider/provider.dart';

class ClubActionButton extends StatelessWidget {
  final ClubActions _action;
  final String _actionName;
  final Icon _actionIcon;

  ClubActionButton(
    this._action,
    this._actionName,
    this._actionIcon,
  );
  @override
  Widget build(BuildContext context) {
    List<ClubMembersModel> _sampleList = new List<ClubMembersModel>();
    _sampleList.add(new ClubMembersModel(
        ClubMemberStatus.ACTIVE,
        "Niveda",
        "+91",
        "345-657-9786",
        "23303",
        "-2020",
        "500",
        new DateTime.now(),
        "0",
        null));
    _sampleList.add(new ClubMembersModel(
        ClubMemberStatus.INACTIVE,
        "Soma",
        "+1",
        "678-345-0098",
        "54678",
        "5600",
        "235",
        new DateTime.now(),
        "230",
        "https://www.bsn.eu/wp-content/uploads/2016/12/user-icon-image-placeholder.jpg"));
    _sampleList.add(new ClubMembersModel(
        ClubMemberStatus.MANAGERS,
        "Jyoti Paul",
        "+91",
        "878-006-4567",
        "12345",
        "789",
        "346",
        new DateTime.now(),
        "-100",
        "https://www.bsn.eu/wp-content/uploads/2016/12/user-icon-image-placeholder.jpg"));
    _sampleList.add(new ClubMembersModel(
        ClubMemberStatus.UNSETTLED,
        "Yong",
        "+1",
        "355-897-1257",
        "34532",
        "900",
        "-200",
        new DateTime.now(),
        "230",
        null));
    _sampleList.add(new ClubMembersModel(
        ClubMemberStatus.PENDING,
        "Akash",
        "+91",
        "908-345-2345",
        "7685",
        "1000",
        "0",
        new DateTime.now(),
        "80",
        "https://www.bsn.eu/wp-content/uploads/2016/12/user-icon-image-placeholder.jpg"));

    return Consumer<ClubHomePageModel>(
      builder: (_, ClubHomePageModel clubModel, __) => GestureDetector(
        onTap: () {
          switch (_action) {
            case ClubActions.GAME_HISTORY:
              break;

            case ClubActions.MEMBERS:
              return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClubMembersView(true, _sampleList)),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HighHand()));
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
