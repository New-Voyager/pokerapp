import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';

class ClubMembersListView extends StatefulWidget {
  final List<ClubMemberModel> _membersList;
  final String clubCode;
  final Function fetchData;
  ClubMembersListView(this.clubCode, this._membersList, this.fetchData);

  @override
  _ClubMembersListViewState createState() => _ClubMembersListViewState();
}

class _ClubMembersListViewState extends State<ClubMembersListView> {
  Color getBalanceColor(double number) {
    if (number == null) {
      return Colors.white;
    }

    return number == 0
        ? Colors.white
        : number > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    List<ClubMemberModel> _filteredList;
    _filteredList = widget._membersList;
    return Container(
      margin: EdgeInsets.all(15),
      child: ListView.separated(
        itemCount: _filteredList.length,
        itemBuilder: (context, index) {
          final member = widget._membersList[index];
          member.clubCode = this.widget.clubCode;
          final data = ClubMemberModel.copyWith(member);
          return Container(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.club_member_detail_view,
                  arguments: data,
                );

                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClubMembersDetailsView(clubCode, member.playerId)),
                );
                */
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(
                                  (math.Random().nextDouble() * 0xFFFFFF)
                                      .toInt())
                              .withOpacity(1.0),
                          child: ClipOval(
                            child: _filteredList[index].imageUrl == null
                                ? Icon(AppIcons.user)
                                : Image.network(
                                    _filteredList[index].imageUrl,
                                  ),
                          ),
                        ),
                        Visibility(
                          visible: _filteredList[index].isManager ?? false,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Visibility(
                              visible: _filteredList[index].isManager ?? false,
                              child: Text(
                                "Manager",
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.contentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _filteredList[index].name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _filteredList[index].contactInfo,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Visibility(
                        //   visible: _filteredList[index].status !=
                        //       ClubMemberStatus.PENDING,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(top: 5, bottom: 5),
                        //     child: Row(
                        //       children: <Widget>[
                        //         Expanded(
                        //           flex: 3,
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 "Buy In : ",
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   fontFamily: AppAssets.fontFamilyLato,
                        //                   color: Colors.white,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 _filteredList[index].buyIn ?? "",
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   fontFamily: AppAssets.fontFamilyLato,
                        //                   color: getTextColor(
                        //                     _filteredList[index].buyIn,
                        //                   ),
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Expanded(
                        //           flex: 4,
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 "Profit : ",
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   fontFamily: AppAssets.fontFamilyLato,
                        //                   color: Colors.white,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 _filteredList[index].profit ?? "",
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   fontFamily: AppAssets.fontFamilyLato,
                        //                   color: getTextColor(
                        //                     _filteredList[index].profit,
                        //                   ),
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Expanded(
                        //           flex: 3,
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 "Rake : ",
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   fontFamily: AppAssets.fontFamilyLato,
                        //                   color: Colors.white,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 _filteredList[index].rake ?? "",
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   fontFamily: AppAssets.fontFamilyLato,
                        //                   color: getTextColor(
                        //                     _filteredList[index].rake,
                        //                   ),
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Visibility(
                          visible: _filteredList[index].status !=
                              ClubMemberStatus.PENDING,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  _filteredList[index].lastPlayedDate,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _filteredList[index].status ==
                              ClubMemberStatus.PENDING,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "(Pending Approval)",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        _filteredList[index].status == ClubMemberStatus.PENDING,
                    child: Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              var data =
                                  await ClubInteriorService.approveClubMember(
                                      widget.clubCode, member.playerId);
                              if (data == "ACTIVE") {
                                widget.fetchData();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(
                                "Approve",
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.appAccentColor,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var data =
                                  await ClubInteriorService.denyClubMember(
                                      widget.clubCode, member.playerId);
                              if (data == "DENIED") {
                                widget.fetchData();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(
                                "Deny",
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.appAccentColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _filteredList[index].status != ClubMemberStatus.PENDING,
                    child: Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            _filteredList[index].balanceStr,
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: getBalanceColor(
                                _filteredList[index].balance,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Visibility(
                              visible: _filteredList[index].rake != null &&
                                  _filteredList[index].rake != 0,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  _filteredList[index].rakeStr,
                                  style: TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.veryLightGrayColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _filteredList[index].status != ClubMemberStatus.PENDING,
                    child: Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.appAccentColor,
                            size: 10,
                          )
                          // Visibility(
                          //   visible: _filteredList[index].isManager ?? false,
                          //   child: Text(
                          //     "Manager",
                          //     style: TextStyle(
                          //       fontFamily: AppAssets.fontFamilyLato,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //       color: AppColors.contentColor,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: AppColors.listViewDividerColor,
          );
        },
      ),
    );
  }
}
