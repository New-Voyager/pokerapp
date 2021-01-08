import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';

class ClubMembersDetailedView extends StatefulWidget {
  //final MemberDetailsModel _memberDetailsModel;
  ClubMembersDetailedView();
  @override
  _ClubMembersDetailedViewState createState() =>
      _ClubMembersDetailedViewState();
}

class _ClubMembersDetailedViewState extends State<ClubMembersDetailedView> {
  _ClubMembersDetailedViewState();

  Color getTextColor(String number) {
    if (number == null || number == '') {
      return Colors.white;
    }

    return int.parse(number) == 0
        ? Colors.white
        : int.parse(number) > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 14,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text(
          "Members",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.appAccentColor,
            fontSize: 14.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Column(
            children: [
              //banner view
              Container(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                      child: ClipOval(
                        child: Icon(AppIcons.user),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Niveda",
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Last Active: 24/11/2020",
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "+13456789034",
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //message
                          Column(
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Icon(
                                  AppIcons.message,
                                  size: 20,
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Message",
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: AppColors.appAccentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //boot
                          Column(
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Boot",
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: AppColors.appAccentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //settle
                          Column(
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Column(
                                  children: [
                                    Icon(
                                      AppIcons.poker_chip,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Settle",
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: AppColors.appAccentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //change credit
                          Column(
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.credit_card,
                                  size: 20,
                                ),
                                padding: EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                shape: CircleBorder(),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Change",
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: AppColors.appAccentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Credit",
                                      style: TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: AppColors.appAccentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.listViewDividerColor,
              ),
              //list view
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.orange,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Balance",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "+450",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: getTextColor("450"),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.cyan,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Auto Approval Limit",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "2000",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Games Played",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "55",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.pink,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Total Buy In",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "22345",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.yellow,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Total Winnings",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "20456",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Rake Paid",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "650",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              AppIcons.poker_chip,
                              color: Colors.indigo,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Club Manager",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "+450",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.listViewDividerColor,
              ),
              //notes view
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.highlight,
                      color: AppColors.appAccentColor,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Text(
                              "Notes",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Text(
                            "The last game was pretty wild",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: AppColors.veryLightGrayColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
