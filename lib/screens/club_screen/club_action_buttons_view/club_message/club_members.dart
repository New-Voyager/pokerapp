import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/host_message_summary_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:provider/provider.dart';

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

class _ClubMembersState extends State<ClubMembers> with RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_members;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: AppStringsNew.messagesText,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: theme.accentColor,
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
              color: theme.primaryColorWithDark(),
            ),
          ),
          body: FutureBuilder<List<HostMessageSummaryModel>>(
              future:
                  ClubsService.hostMessageSummary(clubCode: widget.clubCode),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressWidget(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        navigatorKey.currentState.pushNamed(
                          Routes.chatScreen,
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        padding: EdgeInsets.only(
                          top: 8,
                          right: 8,
                        ),
                        decoration: AppDecorators.tileDecoration(theme),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                snapshot.data[index].newMessageCount != 0
                                    ? Icon(
                                        Icons.circle,
                                        color: theme.accentColor,
                                        size: 15,
                                      )
                                    : SizedBox(
                                        width: 15,
                                      ),
                                CircleAvatar(
                                  radius: 20,
                                  child: Text(
                                    snapshot.data[index].memberName[0]
                                        .toUpperCase(),
                                    style: AppDecorators.getHeadLine4Style(
                                        theme: theme),
                                  ),
                                  backgroundColor:
                                      theme.secondaryColorWithDark(0.3),
                                ),
                                AppDimensionsNew.getHorizontalSpace(8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index].memberName,
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                          Spacer(),
                                          Text(
                                            DateFormat('d MMM, h:mm a')
                                                .format(DateTime.parse(snapshot
                                                        .data[index]
                                                        .lastMessageTime)
                                                    .toLocal())
                                                .toString(),
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data[index].lastMessageText,
                                        style: AppDecorators.getSubtitle1Style(
                                            theme: theme),
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
                              color: theme.fillInColor,
                              endIndent: 16,
                              indent: 32,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
