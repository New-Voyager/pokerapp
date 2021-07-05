import 'dart:developer';

import 'package:curved_bottom_navigation/curved_bottom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/voice_text_widget.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stats_view.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/clubs_page_view.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/live_games.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view_new.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/purchase_page_view.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/gif_cache_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/firebase/push_notification_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/utils.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../flavor_banner.dart';
import '../../flavor_config.dart';
import '../../main.dart';
import '../../routes.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  @override
  String get routeName => Routes.main;

  TabController _controller;
  PlayerInfo _currentPlayer;
  int _navPos = 0;
  Nats _nats;

  Future<void> _init() async {
    log('Initialize main screen');

    // initialize device
    await DeviceInfo.init();
    Screen.init(context);

    log('Device name: ${DeviceInfo.name} screen size: ${Screen.size} diagonal: ${Screen.diagonalInches}');

    /* cache all the category gifs */
    GifCacheService.cacheGifCategories(
      AppConstants.GIF_CATEGORIES,
    );
    log('device name: ${DeviceInfo.name}');

    if (!TestService.isTesting) {
      _currentPlayer = await PlayerService.getMyInfo(null);
      final natsClient = Provider.of<Nats>(context, listen: false);
      _nats = natsClient;
      await natsClient.init(_currentPlayer.channel);
      log('\n\n*********** Player UUID: ${_currentPlayer.uuid} ***********\n\n');

      // Get the token each time the application loads
      String token = await FirebaseMessaging.instance.getToken();
      await saveFirebaseToken(token);
      // Any time the token refreshes, store this in the database too.
      FirebaseMessaging.instance.onTokenRefresh.listen(saveFirebaseToken);
      registerPushNotifications();

      final clubs = await ClubsService.getMyClubs();
      for (final club in clubs) {
        _nats.subscribeClubMessages(club.clubCode);
      }

      // TODO: WHY DO WE NEEDED THE DELAY?
      // Future.delayed(Duration(milliseconds: 100), () async {
      //   await natsClient.init(_currentPlayer.channel);
      // });
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }

  @override
  void initState() {
    super.initState();
    _init();
    _controller = TabController(
      vsync: this,
      length: 4,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_nats != null) {
      _nats.close();
    }
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: <Widget>[
                    GamesPageView(),
                    ClubsPageView(),
                    ProfilePageView(),
                    PurchasePageView()
                  ],
                ),
              ),
              Container(
                color: AppColors.widgetBackgroundColor,
                child: TabBar(
                  isScrollable: false,
                  controller: _controller,
                  indicatorColor: Colors.transparent,
                  labelColor: AppColors.appAccentColor,
                  unselectedLabelColor: AppColors.unselectedColor,
                  labelPadding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  tabs: <Widget>[
                    TabBarItem(
                      iconData: AppIcons.playing_card,
                      title: 'Games',
                    ),
                    TabBarItem(
                      iconData: AppIcons.users,
                      title: 'Clubs',
                    ),
                    TabBarItem(
                      iconData: AppIcons.user,
                      title: 'My Profile',
                    ),
                    TabBarItem(
                      iconData: Icons.money,
                      title: 'Purchase',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

 */

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.addAll([
      LiveGamesScreen(),
      ClubsPageView(),
      ProfilePageNew(),
      PurchasePageView()
    ]);

    if (TestService.isTesting) widgets.add(HandStatsView());
    var scaffold = Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _navPos,
            children: [...widgets],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CurvedBottomNavigation(
              selected: _navPos,
              fabSize: 35.pw,
              navHeight: 50.ph,
              bgColor: AppColorsNew.newNavBarColor,
              fabBgColor: AppColorsNew.newNavBarColor,
              onItemClick: (i) {
                setState(() => _navPos = i);
              },
              items: [
                CurvedNavItem(
                  iconData: AppIcons.playing_card,
                  title: 'Games',
                  selected: _navPos == 0,
                ),
                CurvedNavItem(
                  iconData: AppIcons.users,
                  title: 'Clubs',
                  selected: _navPos == 1,
                ),
                CurvedNavItem(
                  iconData: AppIcons.user,
                  title: 'Profile',
                  selected: _navPos == 2,
                ),
                CurvedNavItem(
                  iconData: Icons.money,
                  title: 'Purchase',
                  selected: _navPos == 3,
                ),
                if (TestService.isTesting)
                  CurvedNavItem(
                    iconData: Icons.money,
                    title: 'Test',
                    selected: _navPos == 4,
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return FlavorBanner(
        child: scaffold,
        bannerConfig: BannerConfig(Flavor.DEV.value(), Colors.deepOrange));
  }
}

class CurvedNavItem extends StatelessWidget {
  CurvedNavItem({
    @required this.title,
    @required this.iconData,
    @required this.selected,
  });

  final String title;
  final IconData iconData;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          iconData,
          size: 15.0.pw,
          color: selected
              ? AppColorsNew.newTextGreenColor
              : AppColorsNew.newNavBarInactiveItemColor,
        ),
        selected
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 4.ph),
                child: Text(
                  title.toUpperCase() ?? 'Title'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColorsNew.newTextColor,
                    fontSize: 10.dp,
                    letterSpacing: 0.7.dp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
      ],
    );
  }
}