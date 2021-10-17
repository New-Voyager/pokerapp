import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';

class ClubMembersListView extends StatefulWidget {
  List<ClubMemberModel> _membersList;
  final String clubCode;
  //final Function fetchData;
  final bool viewAsOwner;
  final MemberListOptions option;
  final AppTextScreen appScreenText;

  ClubMembersListView(this.clubCode, this._membersList, this.option,
      this.viewAsOwner, this.appScreenText);

  @override
  _ClubMembersListViewState createState() => _ClubMembersListViewState();

  Future<void> _fetchData() async {
    log('Club member list');
    if (this.option == MemberListOptions.ALL) {
      _membersList = await ClubInteriorService.getClubMembers(
          clubCode, MemberListOptions.ALL);
    } else if (this.option == MemberListOptions.INACTIVE) {
      _membersList = await ClubInteriorService.getClubMembers(
          clubCode, MemberListOptions.INACTIVE);
    } else if (this.option == MemberListOptions.MANAGERS) {
      _membersList = await ClubInteriorService.getClubMembers(
          clubCode, MemberListOptions.MANAGERS);
    } else if (this.option == MemberListOptions.UNSETTLED) {
      _membersList = await ClubInteriorService.getClubMembers(
          clubCode, MemberListOptions.UNSETTLED);
    }
    for (final member in _membersList) {
      log('_fetchData in ClubMemberListView member: ${member.name} status: ${member.status.toString()}');
    }
  }
}

class _ClubMembersListViewState extends State<ClubMembersListView> {
  Color getBalanceColor(double number, AppTheme theme) {
    if (number == null) {
      return Colors.white;
    }

    return number == 0
        ? Colors.white
        : number > 0
            ? theme.secondaryColor
            : theme.negativeOrErrorColor;
  }

  @override
  Widget build(BuildContext context) {
    log('rebuilding club member list. ${widget.option.toString()}');

    for (final member in widget._membersList) {
      log('member: ${member.name} status: ${member.status.toString()}');
    }
    List<ClubMemberModel> _filteredList;
    _filteredList = widget._membersList;
    _filteredList.sort((a, b) {
      return a.status == ClubMemberStatus.PENDING ? 0 : 1;
    });

    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        margin: EdgeInsets.all(15),
        child: ListView.separated(
          itemCount: _filteredList.length,
          itemBuilder: (context, index) {
            final member = widget._membersList[index];
            member.clubCode = this.widget.clubCode;
            final data = ClubMemberModel.copyWith(member);
            //log("-=-=-=-  Manager:${data.isManager} Owner:${data.isOwner} Name:${data.name}");
            return Container(
              decoration: (data.isManager || data.isOwner)
                  ? AppDecorators.tileDecoration(theme)
                  : AppDecorators.tileDecorationWithoutBorder(theme),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.supportingColor.withAlpha(100),
                          child: ClipOval(
                            child: data.imageUrl == null
                                ? Icon(AppIcons.user, color: theme.fillInColor)
                                : Image.network(
                                    data.imageUrl,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        data.name,
                                        textAlign: TextAlign.left,
                                        style: (data.isManager || data.isOwner)
                                            ? AppDecorators.getAccentTextStyle(
                                                    theme: theme)
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal)
                                            : AppDecorators.getSubtitle1Style(
                                                theme: theme),
                                      ),
                                      Text(
                                        data.contactInfo,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 5,
                                  child: Visibility(
                                    visible: (data.isManager || data.isOwner),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration:
                                          AppDecorators.tileDecoration(theme)
                                              .copyWith(),
                                      child: Text(
                                        (data.isManager
                                            ? widget.appScreenText['manager']
                                            : data.isOwner
                                                ? widget.appScreenText['owner']
                                                : ""),
                                        style: AppDecorators.getSubtitle2Style(
                                            theme: theme),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: data.status != ClubMemberStatus.PENDING,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      data.lastPlayedDate,
                                      textAlign: TextAlign.left,
                                      style: AppDecorators.getSubtitle3Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: data.status == ClubMemberStatus.PENDING,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.appScreenText['pendingApproval'],
                                      textAlign: TextAlign.left,
                                      style: AppDecorators.getSubtitle3Style(
                                          theme: theme),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ((data.status != ClubMemberStatus.PENDING) &&
                            (widget.viewAsOwner ?? false)),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.club_member_detail_view,
                              arguments: data,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: theme.accentColor,
                              size: 14.dp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible:
                        _filteredList[index].status == ClubMemberStatus.PENDING,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RoundIconButton(
                            icon: Icons.done,
                            bgColor: Colors.black,
                            iconColor: theme.secondaryColor,
                            borderColor: theme.accentColor,
                            size: 32.pw,
                            onTap: () async {
                              log('approve is clicked');
                              var data =
                                  await ClubInteriorService.approveClubMember(
                                      widget.clubCode, member.playerId);
                              if (data == "ACTIVE") {
                                member.status = ClubMemberStatus.ACTIVE;
                                setState(() {});
                              }
                            },
                          ),
                          SizedBox(
                            width: 10.pw,
                          ),
                          RoundIconButton(
                            icon: Icons.close,
                            bgColor: Colors.black,
                            iconColor: Colors.red,
                            borderColor: theme.accentColor,
                            size: 32.pw,
                            onTap: () async {
                              log('deny is clicked');
                              var data =
                                  await ClubInteriorService.denyClubMember(
                                      widget.clubCode, member.playerId);
                              String removedPlayerId = member.playerId;
                              if (data == "DENIED") {
                                for (int i = 0;
                                    i < widget._membersList.length;
                                    i++) {
                                  final member = widget._membersList[i];
                                  if (member.playerId == removedPlayerId) {
                                    widget._membersList.removeAt(i);
                                    break;
                                  }
                                }
                                setState(() {});
                                //await widget._fetchData();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return AppDimensionsNew.getVerticalSizedBox(8);
          },
        ),
      ),
    );
  }
}
