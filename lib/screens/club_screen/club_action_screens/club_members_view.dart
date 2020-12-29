import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

import 'club_members_list_view.dart';

class ClubMembersView extends StatelessWidget {
  final List<ClubMembersModel> _membersList;
  final bool _isOwner;

  ClubMembersView(this._isOwner, this._membersList);

  @override
  Widget build(BuildContext context) {
    if (_isOwner) {
      return DefaultTabController(
        length: 4,
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
                  text: 'Unsettled',
                ),
                Tab(
                  text: 'Managers',
                ),
                Tab(
                  text: 'Inactive',
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
              ClubMembersListView(ClubMemberStatus.UNSETTLED),
              ClubMembersListView(ClubMemberStatus.MANAGERS),
              ClubMembersListView(ClubMemberStatus.INACTIVE),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          backgroundColor: AppColors.screenBackgroundColor,
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
        body: Container(
          color: AppColors.screenBackgroundColor,
          child: Center(
            child: ListView.builder(
              itemCount: _membersList.length,
              itemBuilder: (context, index) {
                return Text("Member Item");
              },
            ),
          ),
        ),
      );
    }
  }
}
