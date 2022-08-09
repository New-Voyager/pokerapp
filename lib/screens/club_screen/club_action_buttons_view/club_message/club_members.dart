import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/host_message_summary_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/chat_model.dart';
import 'package:pokerapp/screens/chat_screen/utils.dart';
import 'package:pokerapp/screens/chat_screen/widgets/chat_list_widget.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:provider/provider.dart';

import '../../../../main_helper.dart';
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
  AppTextScreen _appScreenText;

  @override
  Widget build(BuildContext context) {
    _appScreenText = getAppTextScreen("clubMembers");

    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgImageGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['messages'],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: theme.accentColor,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => ListOfClubMemberBottomSheet(
                  clubCode: widget.clubCode,
                  appScreenText: _appScreenText,
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
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return MemberMessagePreview(
                      clubCode: widget.clubCode,
                      model: snapshot.data[index],
                      theme: theme,
                      onTap: () {
                        setState(() {
                          snapshot.data[index].newMessageCount = 0;
                        });
                      },
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}

class MemberMessagePreview extends StatelessWidget {
  final String clubCode;
  final HostMessageSummaryModel model;
  final Function onTap;
  final AppTheme theme;

  const MemberMessagePreview(
      {Key key, this.clubCode, this.model, this.onTap, this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      model.lastMessageText,
      style: AppDecorators.getSubtitle1Style(theme: theme),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
    String text = model.lastMessageText;
    if (text.startsWith("{") && text.endsWith("}")) {
      // json message
      // {"type":"CT","sub-type":"ADD","notes":"received via cashapp","amount":200,"credits":0}
      var ret = jsonDecode(text);
      if (ret != null) {
        CreditUpdateType updateType = CreditUpdateType.adjust;
        double amount = double.parse(ret["amount"].toString());
        if (ret["sub-type"] == "ADD") {
          updateType = CreditUpdateType.add;
        } else if (ret["sub-type"] == "DEDUCT") {
          updateType = CreditUpdateType.deduct;
          amount = -amount;
        } else if (ret["sub-type"] == "REWARD") {
          updateType = CreditUpdateType.reward;
        } else if (ret["sub-type"] == "ADJUST") {
          updateType = CreditUpdateType.adjust;
        } else if (ret["sub-type"] == "FEE_CREDIT") {
          updateType = CreditUpdateType.fee_credit;
        } else if (ret["sub-type"] == "HH") {
          updateType = CreditUpdateType.hh;
        } else if (ret["sub-type"] == "SET") {
          updateType = CreditUpdateType.set;
        } else if (ret["sub-type"] == "CHANGE") {
          updateType = CreditUpdateType.set;
        }
        double oldCredits;
        if (ret["oldCredits"] != null) {
          oldCredits = double.parse(ret["oldCredits"].toString());
        }
        final creditUpdate = CreditUpdateChatModel(
          amount: amount,
          type: updateType,
          text: ret["notes"],
          credits: double.parse(ret["credits"].toString()),
          date: toDateTime(model.lastMessageTime),
          oldCredits: oldCredits,
        );
        var chat = ChatModel(
          id: 0,
        );

        content = CreditUpdateChatWidget(
          chatAdjustmentModel: creditUpdate,
          message: chat,
          decorator: false,
        );
        ;
      }
    }
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState.pushNamed(
          Routes.chatScreen,
          arguments: {
            'clubCode': clubCode,
            'player': model.playerId,
            'name': model.memberName,
          },
        ).then((value) {
          onTap(model);
          // setState(() {
          //   model.newMessageCount = 0;
          // });
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: EdgeInsets.only(
          top: 8,
          right: 8,
        ),
        decoration: AppDecorators.tileDecoration(theme),
        child: Column(
          children: [
            Row(
              children: [
                model.newMessageCount != 0
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
                    model.memberName[0].toUpperCase(),
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                  backgroundColor: theme.secondaryColorWithDark(0.3),
                ),
                AppDimensionsNew.getHorizontalSpace(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            model.memberName,
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          ),
                          Spacer(),
                          Text(
                            DateFormat('d MMM, h:mm a')
                                .format(DateTime.parse(model.lastMessageTime)
                                    .toLocal())
                                .toString(),
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
                          ),
                        ],
                      ),
                      content
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
  }
}
