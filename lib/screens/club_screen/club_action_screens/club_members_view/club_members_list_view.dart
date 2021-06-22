import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/widgets/custom_icon_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubMembersListView extends StatefulWidget {
  final List<ClubMemberModel> _membersList;
  final String clubCode;
  final Function fetchData;
  final bool viewAsOwner;
  ClubMembersListView(
      this.clubCode, this._membersList, this.fetchData, this.viewAsOwner);

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
            ? AppColorsNew.newGreenButtonColor
            : AppColorsNew.newRedButtonColor;
  }

  @override
  Widget build(BuildContext context) {
    List<ClubMemberModel> _filteredList;
    _filteredList = widget._membersList;
    _filteredList.sort((a, b) {
      return a.status == ClubMemberStatus.PENDING ? 0 : 1;
    });

    return Container(
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
                ? AppStylesNew.gradientBorderBoxDecoration
                : AppStylesNew.actionRowDecoration,
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
                        backgroundColor: Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.5),
                        child: ClipOval(
                          child: data.imageUrl == null
                              ? Icon(AppIcons.user)
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
                                          ? AppStylesNew.accentTextStyle
                                          : AppStylesNew.stageNameTextStyle,
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
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade600,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      (data.isManager
                                          ? "Manager"
                                          : data.isOwner
                                              ? "Owner"
                                              : ""),
                                      style: TextStyle(
                                        fontSize: 7.dp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                            visible: data.status != ClubMemberStatus.PENDING,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    data.lastPlayedDate,
                                    textAlign: TextAlign.left,
                                    style: AppStylesNew.labelTextStyle,
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
                                    "[Pending Approval]",
                                    textAlign: TextAlign.left,
                                    style: AppStylesNew.labelTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*   Visibility(
                      visible: data.status != ClubMemberStatus.PENDING,
                      child: (data.isManager || data.isOwner)
                          ? Text(
                              data.isManager
                                  ? "Manager"
                                  : data.isOwner
                                      ? "Owner"
                                      : "",
                            )
                          : Column(
                              children: [
                                Text(
                                  data.balanceStr,
                                  style: TextStyle(
                                    color: getBalanceColor(
                                      data.balance,
                                    ),
                                    fontSize: 12.dp,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      data.rake != null && data.rake != 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        data.rakeStr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          backgroundColor:
                                              Colors.transparent,
                                          fontSize: 10.dp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3),
                                        color: AppColors.veryLightGrayColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                   */
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
                            color: AppColorsNew.newGreenButtonColor,
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
                        IconTextButton(
                          text: "Approve",
                          buttonColor: AppColorsNew.newSelectedGreenColor,
                          icon: Icons.done,
                          onTap: () async {
                            log('approve is clicked');
                            var data =
                                await ClubInteriorService.approveClubMember(
                                    widget.clubCode, member.playerId);
                            if (data == "ACTIVE") {
                              widget.fetchData();
                              setState(() {});
                            }
                          },
                        ),
                        AppDimensionsNew.getHorizontalSpace(16),
                        IconTextButton(
                          text: "Deny",
                          buttonColor: AppColorsNew.newRedButtonColor,
                          icon: Icons.close,
                          onTap: () async {
                            log('deny is clicked');
                            var data = await ClubInteriorService.denyClubMember(
                                widget.clubCode, member.playerId);
                            if (data == "DENIED") {
                              widget.fetchData();
                            }
                          },
                        ),
                        AppDimensionsNew.getHorizontalSpace(8),
                        /*   GestureDetector(
                          onTap: () async {
                            log('approve is clicked');
                            var data = await ClubInteriorService
                                .approveClubMember(
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
                       */ /* GestureDetector(
                          onTap: () async {
                            log('deny is clicked');
                            var data = await ClubInteriorService
                                .denyClubMember(
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
                        ), */
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
    );
  }
}
