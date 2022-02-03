import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/widgets/label.dart';
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
  List<ClubMemberModel> _leaders = [];
  List<ClubMemberModel> _myReferrals = [];

  //List<ClubMemberModel> _unsettled = [];

  bool _isLoading = true;

  AppTextScreen _appScreenText;

  _ClubMembersViewState(this._clubHomePageModel);

  _fetchData() async {
    log('Club member list');
    _all = await appState.cacheService.getMembers(_clubHomePageModel.clubCode);
    final now = DateTime.now();
    final currentUser = AuthService.get();

    for (final member in _all) {
      if (member.isManager) {
        _managers.add(member);
      }

      if (member.lastPlayedDate != null) {
        final diff = now.difference(member.lastPlayedDate);
        if (diff.inDays >= 60) {
          _inactive.add(member);
        }
      }

      if (member.isAgent) {
        _leaders.add(member);
      }
      if (member.agentUuid != null && member.agentUuid == currentUser.uuid) {
        // my referral
        _myReferrals.add(member);
      }
    }
    log('Club member list: $_all');
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    _appScreenText = getAppTextScreen("clubMembersView");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(builder: (_, theme, __) {
      Widget body = Container();
      if (_isLoading) {
        body = CircularProgressWidget(
          text: _appScreenText['loadingMembers'],
        );
      } else {
        if (_clubHomePageModel.isOwner) {
          body = getOwnerBody(theme);
        } else {
          body = getPlayerBody(theme);
        }
      }
      return Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['clubMembers'],
            subTitleText: _clubHomePageModel.clubName,
          ),
          body: body,
        ),
      );
    });
  }

  Widget getTitle(AppTheme theme, ClubMemberModel member) {
    bool isVisible = member.isManager || member.isOwner || member.isAgent;
    String titleText = '';
    if (member.isManager) {
      titleText = 'Manager';
    } else if (member.isOwner) {
      titleText = 'Owner';
    } else if (member.isAgent) {
      return Container();
      //titleText = 'Leader';
    }
    return Positioned(
      top: 0,
      right: 5,
      child: Visibility(visible: isVisible, child: Label(titleText, theme)),
    );
  }

  Widget getOwnerBody(AppTheme theme) {
    List<Widget> tabViews = [
      ClubMembersListView(
        this._clubHomePageModel,
        this._clubHomePageModel.clubCode,
        _all,
        MemberListOptions.ALL,
        _clubHomePageModel.isOwner,
        _appScreenText,
        _fetchData,
        allMembers: _all,
        showLabels: true,
      ),
      ClubMembersListView(
        this._clubHomePageModel,
        this._clubHomePageModel.clubCode,
        _managers,
        MemberListOptions.LEADERS,
        _clubHomePageModel.isOwner,
        _appScreenText,
        _fetchData,
        allMembers: _all,
      ),
      ClubMembersListView(
        this._clubHomePageModel,
        this._clubHomePageModel.clubCode,
        _leaders,
        MemberListOptions.MANAGERS,
        _clubHomePageModel.isOwner,
        _appScreenText,
        _fetchData,
        allMembers: _all,
      ),
    ];
    List<Tab> tabs = [
      Tab(
        text: _appScreenText['all'],
      ),
      Tab(
        text: _appScreenText['managers'],
      ),
      Tab(
        text: 'Agents',
      ),
    ];
    if (_myReferrals.length > 0) {
      tabs.add(
        Tab(
          text: 'Referrals',
        ),
      );
      tabViews.add(
        ClubMembersListView(
          this._clubHomePageModel,
          this._clubHomePageModel.clubCode,
          _myReferrals,
          MemberListOptions.MYREFERALS,
          _clubHomePageModel.isOwner,
          _appScreenText,
          _fetchData,
          allMembers: _all,
        ),
      );
    }
    tabs.add(
      Tab(
        text: _appScreenText['inactive'],
      ),
    );
    tabViews.add(
      ClubMembersListView(
        this._clubHomePageModel,
        this._clubHomePageModel.clubCode,
        _inactive,
        MemberListOptions.INACTIVE,
        _clubHomePageModel.isOwner,
        _appScreenText,
        _fetchData,
        allMembers: _all,
      ),
    );

    _controller = new TabController(length: tabViews.length, vsync: this);
    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: TabBar(
            physics: const BouncingScrollPhysics(),
            controller: _controller,
            labelColor: theme.secondaryColorWithLight(),
            indicatorColor: theme.accentColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: theme.secondaryColorWithDark(0.2),
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            children: tabViews,
          ),
        ),
      ],
    );
  }

  Widget getPlayerBody(AppTheme theme) {
    List<Widget> tabViews = [
      ClubMembersListView(
        this._clubHomePageModel,
        this._clubHomePageModel.clubCode,
        _all,
        MemberListOptions.ALL,
        _clubHomePageModel.isOwner,
        _appScreenText,
        _fetchData,
        allMembers: _all,
        showLabels: true,
      ),
    ];
    List<Tab> tabs = [
      Tab(
        text: _appScreenText['all'],
      ),
    ];
    if (_myReferrals.length > 0) {
      tabs.add(
        Tab(
          text: 'Referrals',
        ),
      );
      tabViews.add(
        ClubMembersListView(
          this._clubHomePageModel,
          this._clubHomePageModel.clubCode,
          _myReferrals,
          MemberListOptions.MYREFERALS,
          _clubHomePageModel.isOwner,
          _appScreenText,
          _fetchData,
          allMembers: _all,
        ),
      );
    }
    _controller = new TabController(length: tabViews.length, vsync: this);
    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: TabBar(
            physics: const BouncingScrollPhysics(),
            controller: _controller,
            labelColor: theme.secondaryColorWithLight(),
            indicatorColor: theme.accentColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: theme.secondaryColorWithDark(0.2),
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            children: tabViews,
          ),
        ),
      ],
    );
  }
}
