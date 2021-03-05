import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/host_message_summary_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/clubs_service.dart';

import '../../../../main.dart';
import 'list_of_club_member_bottomsheet.dart';

class ClubMembers extends StatefulWidget {
  ClubMembers({
    @required this.clubCode,
  });

  final String clubCode;
  @override
  _ClubMembersState createState() => _ClubMembersState();
}

class _ClubMembersState extends State<ClubMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Messages",
          style: AppStyles.credentialsTextStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white24,
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => ListOfClubMemberBottomSheet(
              clubCode: widget.clubCode,
            ),
          ).then((value) {
            setState(() {
              // doing set state to get new updated list of chat with member
            });
          });
        },
        child: Icon(
          Icons.message,
          color: AppColors.appAccentColor,
        ),
      ),
      body: FutureBuilder<List<HostMessageSummaryModel>>(
          future: ClubsService.hostMessageSummary(clubCode: widget.clubCode),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    navigatorKey.currentState.pushNamed(
                      Routes.club_host_messagng,
                      arguments: {
                        'clubCode': widget.clubCode,
                        'player': snapshot.data[index].playerId,
                        'name': snapshot.data[index].memberName,
                      },
                    ).then((value) {
                      setState(() {
                        snapshot.data[index].newMessageCount = 0;
                      });
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            snapshot.data[index].newMessageCount != 0
                                ? Icon(
                                    Icons.circle,
                                    color: AppColors.appAccentColor,
                                    size: 15,
                                  )
                                : SizedBox(
                                    width: 15,
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 25,
                                child: Text(
                                  snapshot.data[index].memberName[0]
                                      .toUpperCase(),
                                  style: AppStyles.titleTextStyle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data[index].memberName,
                                        style: AppStyles
                                            .notificationTitleTextStyle,
                                      ),
                                      Spacer(),
                                      Text(
                                        DateFormat('d MMM, h:mm a')
                                            .format(DateTime.parse(snapshot
                                                .data[index].lastMessageTime))
                                            .toString(),
                                        style: AppStyles
                                            .itemInfoSecondaryTextStyle,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data[index].lastMessageText,
                                    style: AppStyles.itemInfoSecondaryTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
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
    );
  }
}
