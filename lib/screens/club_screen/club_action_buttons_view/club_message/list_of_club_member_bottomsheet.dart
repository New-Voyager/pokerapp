import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/color_generator.dart';

import '../../../../main.dart';

class ListOfClubMemberBottomSheet extends StatelessWidget {
  final String clubCode;
  final AppTextScreen appScreenText;

  const ListOfClubMemberBottomSheet(
      {Key key, @required this.clubCode, @required this.appScreenText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      height: 3 * MediaQuery.of(context).size.height / 4,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              appScreenText['CHOOSEAMEMBER'],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ClubMemberModel>>(
                future: ClubInteriorService.getMembers(clubCode),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  print(snapshot.data);
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].isOwner) {
                        return SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: () async {
                          await navigatorKey.currentState.pushNamed(
                            Routes.chatScreen,
                            arguments: {
                              'clubCode': clubCode,
                              'player': snapshot.data[index].playerId,
                              'name': snapshot.data[index].name,
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: AppStylesNew.actionRowDecoration,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: CircleAvatar(
                                  backgroundColor: generateColorFor(
                                      snapshot.data[index].playerId),
                                  radius: 20,
                                  child: Text(
                                    snapshot.data[index].name[0].toUpperCase(),
                                  ),
                                ),
                              ),
                              Text(
                                snapshot.data[index].name,
                                style: AppStylesNew.notificationTitleTextStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
