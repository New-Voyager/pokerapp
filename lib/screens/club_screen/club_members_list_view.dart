import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/label.dart';
import 'package:provider/provider.dart';

class ClubMembersListView extends StatefulWidget {
  final List<ClubMemberModel> allMembers;
  final List<ClubMemberModel> _membersList;
  final String clubCode;
  final ClubHomePageModel club;
  final Function fetchData;
  final bool viewAsOwner;
  final MemberListOptions option;
  final AppTextScreen appScreenText;
  final bool chooseMember;
  final Function onChooseMember;
  final bool showLabels;

  ClubMembersListView(this.club, this.clubCode, this._membersList, this.option,
      this.viewAsOwner, this.appScreenText, this.fetchData,
      {this.chooseMember = false,
      this.onChooseMember = null,
      this.allMembers,
      this.showLabels = false});

  @override
  _ClubMembersListViewState createState() => _ClubMembersListViewState();
}

class _ClubMembersListViewState extends State<ClubMembersListView> {
  TextEditingController searchTextController = TextEditingController();
  List<ClubMemberModel> memberList = [];

  @override
  void initState() {
    super.initState();
    if (widget._membersList != null) {
      memberList.addAll(widget._membersList);
    }
  }

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
    String searchText = searchTextController.text;
    log('rebuilding club member list. ${widget.option.toString()} search: $searchText');

    for (final member in widget._membersList) {
      log('member: ${member.name} status: ${member.status.toString()}');
    }
    List<ClubMemberModel> _filteredList;
    _filteredList = memberList;
    _filteredList.sort((a, b) {
      return b.name.toLowerCase().compareTo(a.name.toLowerCase());
    });
    _filteredList.sort((a, b) {
      return a.status == ClubMemberStatus.PENDING ? 0 : 1;
    });

    // removed unmatched items
    if (searchText.isNotEmpty) {
      List<ClubMemberModel> list = [];
      String searchStr = searchText.toLowerCase();
      for (final item in _filteredList) {
        if (item.name.toLowerCase().startsWith(searchStr)) {
          list.add(item);
        }
      }
      _filteredList = list;
    }

    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        margin: EdgeInsets.all(15),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: _filteredList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                width: double.infinity,
                height: 40,
                //color: Colors.white,
                child: Center(
                  child: TextField(
                    controller: searchTextController,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                    onChanged: (String text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: theme.accentColor)),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: theme.accentColor),
                      ),
                      prefixIcon: Icon(Icons.search, color: theme.accentColor),
                    ),
                  ),
                ),
              );
            }
            index--;
            final member = _filteredList[index];
            member.clubCode = this.widget.clubCode;
            final data = ClubMemberModel.copyWith(member);
            data.creditTracking = this.widget.club.trackMemberCredit;
            //log("-=-=-=-  Manager:${data.isManager} Owner:${data.isOwner} Name:${data.name}");
            return Container(
              decoration: (data.isManager || data.isOwner)
                  ? AppDecorators.tileDecoration(theme)
                  : AppDecorators.tileDecorationWithoutBorder(theme),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (!widget.viewAsOwner) {
                        return;
                      }
                      bool updated = await Navigator.pushNamed(
                        context,
                        Routes.club_member_detail_view,
                        arguments: {
                          "clubCode": data.clubCode,
                          "playerId": data.playerId,
                          "currentOwner": widget.viewAsOwner,
                          "club": widget.club,
                          "member": data,
                          "allMembers": widget.allMembers,
                        },
                      ) as bool;
                      await appState.cacheService
                          .getClubHomePageData(data.clubCode);
                      final allMembers =
                          await appState.cacheService.getMembers(data.clubCode);

                      memberList = [];
                      DateTime now = DateTime.now();
                      for (final member in allMembers) {
                        if (widget.option == MemberListOptions.MANAGERS) {
                          if (member.isManager) {
                            memberList.add(member);
                          }
                        } else if (widget.option == MemberListOptions.LEADERS) {
                          if (member.isAgent) {
                            memberList.add(member);
                          }
                        } else if (widget.option ==
                            MemberListOptions.INACTIVE) {
                          if (member.lastPlayedDate != null) {
                            final diff = now.difference(member.lastPlayedDate);
                            if (diff.inDays >= 60) {
                              memberList.add(member);
                            }
                          }
                        } else {
                          memberList.add(member);
                        }
                      }

                      setState(() {});
                      // if (updated ?? false) {
                      //   if (widget.fetchData != null) {
                      //     await widget.fetchData();
                      //   }
                      //   setState(() {});
                      // }
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                theme.supportingColor.withAlpha(100),
                            child: ClipOval(
                              child: data.imageUrl == null
                                  ? Icon(AppIcons.user,
                                      color: theme.fillInColor)
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
                                          style: (data.isManager ||
                                                  data.isOwner)
                                              ? AppDecorators
                                                      .getAccentTextStyle(
                                                          theme: theme)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal)
                                              : AppDecorators.getSubtitle1Style(
                                                  theme: theme),
                                        ),
                                      ],
                                    ),
                                  ),
                                  getTitle(theme, data),
                                ],
                              ),
                              Visibility(
                                visible:
                                    data.status != ClubMemberStatus.PENDING,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        data.lastPlayedDateStr,
                                        textAlign: TextAlign.left,
                                        style: AppDecorators.getSubtitle3Style(
                                            theme: theme),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    data.status == ClubMemberStatus.PENDING,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Pending Approval',
                                        //widget.appScreenText['pendingApproval'],
                                        textAlign: TextAlign.left,
                                        style: AppDecorators.getSubtitle3Style(
                                            theme: theme),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    data.status == ClubMemberStatus.PENDING &&
                                        data.requestMessage != null &&
                                        data.requestMessage.isNotEmpty,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        data.requestMessage,
                                        //widget.appScreenText['pendingApproval'],
                                        textAlign: TextAlign.left,
                                        style: AppDecorators.getHeadLine5Style(
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
                          visible: (!(widget.chooseMember ?? false)) &&
                              ((data.status != ClubMemberStatus.PENDING) &&
                                  (widget.viewAsOwner ?? false)),
                          child: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: theme.accentColor,
                              size: 14.dp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        _filteredList[index].status == ClubMemberStatus.PENDING,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CircleImageButton(
                            icon: Icons.done,
                            theme: theme,
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
                          CircleImageButton(
                            icon: Icons.close,
                            theme: theme,
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

  Widget getTitle(AppTheme theme, ClubMemberModel member) {
    if (!widget.showLabels) {
      return Container();
    }

    if (widget.chooseMember ?? false) {
      return Container();
    }
    bool isVisible = (member.isManager ?? false) ||
        (member.isOwner ?? false) ||
        (member.isAgent ?? false);
    String titleText = '';
    List<Widget> labels = [];
    if (member.isManager ?? false) {
      titleText = 'Manager';
      labels.add(SizedBox(width: 5));
      labels.add(Label(titleText, theme));
    }
    if (member.isOwner ?? false) {
      titleText = 'Owner';
      labels.add(SizedBox(width: 5));
      labels.add(Label(titleText, theme));
    }
    if (member.isAgent ?? false) {
      titleText = 'Agent';
      if (widget.viewAsOwner) {
        labels.add(SizedBox(width: 5));
        labels.add(Label(titleText, theme));
      }
    }

    return Positioned(
      top: 10,
      right: 20,
      child: Visibility(
        visible: isVisible,
        child: Row(children: labels),
      ),
    );
  }
}
