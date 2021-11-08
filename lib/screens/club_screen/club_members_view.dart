import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:provider/provider.dart';

import '../../../../main_helper.dart';
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

  AppTextScreen _appScreenText;

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
    _appScreenText = getAppTextScreen("clubMembersView");

    _controller = new TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['clubMembers'],
            subTitleText: _clubHomePageModel.clubName,
          ),
          body: _isLoading
              ? CircularProgressWidget(
                  text: _appScreenText['loadigMembers'],
                )
              : _clubHomePageModel.isOwner
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: TabBar(
                            physics: const BouncingScrollPhysics(),
                            controller: _controller,
                            labelColor: theme.secondaryColorWithLight(),
                            indicatorColor: theme.accentColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            unselectedLabelColor:
                                theme.secondaryColorWithDark(0.2),
                            isScrollable: true,
                            tabs: [
                              Tab(
                                text: _appScreenText['all'],
                              ),
                              // Tab(
                              //   text: 'Unsettled',
                              // ),
                              Tab(
                                text: _appScreenText['managers'],
                              ),
                              Tab(
                                text: _appScreenText['inactive'],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: BouncingScrollPhysics(),
                            controller: _controller,
                            children: <Widget>[
                              ClubMembersListView(
                                  this._clubHomePageModel.clubCode,
                                  _all,
                                  MemberListOptions.ALL,
                                  _clubHomePageModel.isOwner,
                                  _appScreenText,
                                  _fetchData),
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
                                _appScreenText,
                                _fetchData,
                              ),
                              ClubMembersListView(
                                this._clubHomePageModel.clubCode,
                                _inactive,
                                MemberListOptions.INACTIVE,
                                _clubHomePageModel.isOwner,
                                _appScreenText,
                                _fetchData,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: AppColorsNew.screenBackgroundColor,
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
                                      backgroundColor: theme.fillInColor,
                                      child: ClipOval(
                                        child: _all[index].imageUrl == null
                                            ? Icon(
                                                AppIcons.user,
                                                color: theme.supportingColor,
                                              )
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
                              color: AppColorsNew.listViewDividerColor,
                            );
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
