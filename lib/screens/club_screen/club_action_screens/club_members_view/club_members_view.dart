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
  _ClubMembersViewState createState() =>
      _ClubMembersViewState(this._clubHomePageModel);
}

class _ClubMembersViewState extends State<ClubMembersView>
    with SingleTickerProviderStateMixin {
  final ClubHomePageModel _clubHomePageModel;
  TabController _controller;
  List<ClubMemberModel> _all = new List<ClubMemberModel>();
  List<ClubMemberModel> _inactive = new List<ClubMemberModel>();
  List<ClubMemberModel> _managers = new List<ClubMemberModel>();
  List<ClubMemberModel> _unsettled = new List<ClubMemberModel>();

  bool _isLoading = false;
  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  _ClubMembersViewState(this._clubHomePageModel);

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
    _controller = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // data loaded
    if (_clubHomePageModel.isOwner) {
      return Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: height * 0.02,
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
              fontSize: height * 0.02,
              fontFamily: AppAssets.fontFamilyLato,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: width * 0.03,
                top: height * 0.015,
                bottom: height * 0.015,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Members",
                style: TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.white,
                  fontSize: height * 0.037,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: TabBar(
                controller: _controller,
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
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  ClubMembersListView(
                      this._clubHomePageModel.clubCode, _all, _fetchData),
                  ClubMembersListView(
                      this._clubHomePageModel.clubCode, _unsettled, _fetchData),
                  ClubMembersListView(
                      this._clubHomePageModel.clubCode, _managers, _fetchData),
                  ClubMembersListView(
                      this._clubHomePageModel.clubCode, _inactive, _fetchData),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // ListView used for normal club member
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: height * 0.02,
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
              fontSize: height * 0.017,
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
                                  fontSize: height * 0.02,
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
