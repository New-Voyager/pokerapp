import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';

import 'club_members_list_view.dart';

class ClubMembersView extends StatefulWidget {
  final ClubHomePageModel _clubHomePageModel;
  ClubMembersView(this._clubHomePageModel);
  @override
  _ClubMembersView createState() => _ClubMembersView(this._clubHomePageModel);
}

class _ClubMembersView extends State<ClubMembersView> {
  final ClubHomePageModel _clubHomePageModel;
  List<ClubMemberModel> _all = new List<ClubMemberModel>();
  List<ClubMemberModel> _inactive = new List<ClubMemberModel>();
  List<ClubMemberModel> _managers = new List<ClubMemberModel>();
  List<ClubMemberModel> _unsettled = new List<ClubMemberModel>();

  bool _isLoading = false;
  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  _ClubMembersView(this._clubHomePageModel);

  void _fetchData() async {
    _toggleLoading();
    _all = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.ALL);
    _inactive = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.INACTIVE);
    _managers = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.MANAGERS);
    _unsettled = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.UNSETTLED);
    _toggleLoading();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // data loaded
    if (_clubHomePageModel.isOwner) {
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
              _clubHomePageModel.clubName,
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
              ClubMembersListView(_all),
              ClubMembersListView(_unsettled),
              ClubMembersListView(_managers),
              ClubMembersListView(_inactive),
            ],
          ),
        ),
      );
    } else {
      // ListView used for normal club member
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
            _clubHomePageModel.clubName,
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
              itemCount: _all.length,
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
                            child: _all[index].imageUrl == null
                                ? Icon(AppIcons.user)
                                : Image.network(
                                    _all[index].imageUrl,
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
                                _all[index].name,
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
