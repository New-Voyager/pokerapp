import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/color_generator.dart';

import '../../../../main.dart';

class ListOfClubMemberBottomSheet extends StatelessWidget {
  final String clubCode;
  const ListOfClubMemberBottomSheet({
    Key key,
    @required this.clubCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.screenBackgroundColor,
      height: 3 * MediaQuery.of(context).size.height / 4,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Choose a Member",
              style: AppStyles.optionTitleText,
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
                          padding:
                              EdgeInsets.only(bottom: 5, top: 10, left: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: CircleAvatar(
                                      backgroundColor: generateColorFor(
                                          snapshot.data[index].playerId),
                                      radius: 25,
                                      child: Text(
                                        snapshot.data[index].name[0]
                                            .toUpperCase(),
                                        style: AppStyles.titleTextStyle,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[index].name,
                                    style: AppStyles.notificationTitleTextStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                color: AppColors.contentColor,
                              )
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
