import 'dart:math' as math;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';

import '../../../../main.dart';
import '../../../../routes.dart';
import 'club_members_list_view.dart';

class ClubMembersView extends StatefulWidget {
  final ClubHomePageModel _clubHomePageModel;

  ClubMembersView(this._clubHomePageModel);

  @override
  _ClubMembersViewState createState() =>
      _ClubMembersViewState(this._clubHomePageModel);
}

class _ClubMembersViewState extends State<ClubMembersView>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_members_view;

  final ClubHomePageModel _clubHomePageModel;
  TabController _controller;
  List<ClubMemberModel> _all = [];
  List<ClubMemberModel> _inactive = [];
  List<ClubMemberModel> _managers = [];
  //List<ClubMemberModel> _unsettled = [];

  bool _isLoading = true;

  _ClubMembersViewState(this._clubHomePageModel);

  _fetchData() async {
    log('Club member list');
    _all = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.ALL);
    log('Club member list: $_all');
    _inactive = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.INACTIVE);
    _managers = await ClubInteriorService.getClubMembers(
        _clubHomePageModel.clubCode, MemberListOptions.MANAGERS);
    // _unsettled = await ClubInteriorService.getClubMembers(
    //     _clubHomePageModel.clubCode, MemberListOptions.UNSETTLED);
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          context: context,
          titleText: AppStringsNew.clubMembersTitle,
          subTitleText: _clubHomePageModel.clubName,
        ),
        body: _isLoading
            ? CircularProgressWidget(
                text: "Loadig members",
              )
            : _clubHomePageModel.isOwner
                ? Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TabBar(
                          controller: _controller,
                          labelColor: AppColorsNew.newGreenButtonColor,
                          indicatorColor: AppColorsNew.yellowAccentColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: AppColorsNew.newTextColor,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              text: 'All',
                            ),
                            // Tab(
                            //   text: 'Unsettled',
                            // ),
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
                              this._clubHomePageModel.clubCode,
                              _all,
                              MemberListOptions.ALL,
                              _clubHomePageModel.isOwner,
                            ),
                            // ClubMembersListView(
                            //   this._clubHomePageModel.clubCode,
                            //   _unsettled,
                            //   MemberListOptions.UNSETTLED,
                            //   _clubHomePageModel.isOwner,
                            // ),
                            ClubMembersListView(
                              this._clubHomePageModel.clubCode,
                              _managers,
                              MemberListOptions.MANAGERS,
                              _clubHomePageModel.isOwner,
                            ),
                            ClubMembersListView(
                              this._clubHomePageModel.clubCode,
                              _inactive,
                              MemberListOptions.INACTIVE,
                              _clubHomePageModel.isOwner,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
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
                                            (math.Random().nextDouble() *
                                                    0xFFFFFF)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
      ),
    );
  }
}
