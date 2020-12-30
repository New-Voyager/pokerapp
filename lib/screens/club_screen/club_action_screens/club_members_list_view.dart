import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';

class ClubMembersListView extends StatelessWidget {
  final ClubMemberStatus _membersStatus;
  final List<ClubMembersModel> _membersList;

  ClubMembersListView(this._membersList, this._membersStatus);

  Color getTextColor(String number) {
    return int.parse(number) == 0
        ? Colors.white
        : int.parse(number) > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    List<ClubMembersModel> _filteredList;
    if (_membersStatus == ClubMemberStatus.ALL) {
      _filteredList = _membersList;
    } else {
      _filteredList =
          _membersList.where((i) => i.status == _membersStatus).toList();
    }
    return Container(
      margin: EdgeInsets.all(15),
      child: ListView.separated(
        itemCount: _filteredList.length,
        itemBuilder: (context, index) {
          return Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                    child: ClipOval(
                      child: _filteredList[index].imageUrl == null
                          ? Icon(AppIcons.user)
                          : Image.network(
                              _filteredList[index].imageUrl,
                            ),
                    ),
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
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "(" +
                                    _filteredList[index].countryCode +
                                    " " +
                                    _filteredList[index].contactNumber +
                                    ")",
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
                      Visibility(
                        visible: _filteredList[index].status !=
                            ClubMemberStatus.PENDING,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text(
                                      "Buy In : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      _filteredList[index].buyIn,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: getTextColor(
                                          _filteredList[index].buyIn,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Text(
                                      "Profit : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      _filteredList[index].profit,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: getTextColor(
                                          _filteredList[index].profit,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text(
                                      "Rake : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      _filteredList[index].rake,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: getTextColor(
                                          _filteredList[index].rake,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _filteredList[index].status !=
                            ClubMemberStatus.PENDING,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Last Played : ",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                DateFormat("MM/dd/yyyy").format(
                                  _filteredList[index].lastPlayedDate,
                                ),
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
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            _filteredList[index].balance,
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: getTextColor(
                                _filteredList[index].balance,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(
                                "Boot",
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.appAccentColor,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _filteredList[index].status ==
                                ClubMemberStatus.MANAGERS,
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
                        ],
                      ),
                    )),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return new Divider(
            color: AppColors.listViewDividerColor,
          );
        },
      ),
    );
  }
}
