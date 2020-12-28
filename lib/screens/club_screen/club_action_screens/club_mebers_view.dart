import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

import 'club_members_list_view.dart';

class ClubMembersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          backgroundColor: AppColors.screenBackgroundColor,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Active',
              ),
              Tab(
                text: 'Inactive',
              ),
              Tab(
                text: 'Outstanding',
              ),
              Tab(
                text: 'Managers',
              ),
            ],
          ),
          title: Text(
            "Boston University Poker Club",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ClubMembersListView(ClubMemberStatus.ALL),
            ClubMembersListView(ClubMemberStatus.ACTIVE),
            ClubMembersListView(ClubMemberStatus.INACTIVE),
            ClubMembersListView(ClubMemberStatus.OUTSTANDING),
            ClubMembersListView(ClubMemberStatus.MANAGERS),
          ],
        ),
      ),
    );
  }
}
