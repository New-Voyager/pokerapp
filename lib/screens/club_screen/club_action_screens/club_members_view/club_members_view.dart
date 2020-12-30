import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_icons.dart';

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
            bottom: TabBar(
              labelColor: AppColors.appAccentColor,
              unselectedLabelColor: Colors.white,
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
                color: AppColors.appAccentColor,
                fontSize: 14.0,
                fontFamily: AppAssets.fontFamilyLato,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ClubMembersListView(_membersList, ClubMemberStatus.ALL),
              ClubMembersListView(_membersList, ClubMemberStatus.UNSETTLED),
              ClubMembersListView(_membersList, ClubMemberStatus.MANAGERS),
              ClubMembersListView(_membersList, ClubMemberStatus.INACTIVE),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 14.0,
              color: AppColors.appAccentColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          elevation: 0.0,
          backgroundColor: AppColors.screenBackgroundColor,
          title: Text(
            "Boston University Poker Club",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.appAccentColor,
              fontSize: 14.0,
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          color: AppColors.screenBackgroundColor,
          child: Container(
            margin: EdgeInsets.all(15),
            child: ListView.separated(
              itemCount: _membersList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(
                                  (math.Random().nextDouble() * 0xFFFFFF)
                                      .toInt())
                              .withOpacity(1.0),
                          child: ClipOval(
                            child: _membersList[index].imageUrl == null
                                ? Icon(AppIcons.user)
                                : Image.network(
                                    _membersList[index].imageUrl,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _membersList[index].name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
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
                return Divider(
                  color: AppColors.listViewDividerColor,
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
