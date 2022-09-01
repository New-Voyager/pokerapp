import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stats_view.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/new_clubs_page_view.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/new_live_games.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/new_profile_page_view_new.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/store_page.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/gif_cache_service.dart';
import 'package:pokerapp/services/app/loadassets_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/app/quick_game_navigation_service.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/services/game_history/game_history_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/notifications/notifications.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import '../../flavor_banner.dart';
import '../../flavor_config.dart';
import '../../main_helper.dart';
import '../../routes.dart';

class NewMainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<NewMainScreen>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  @override
  String get routeName => Routes.main;

  AppTextScreen _appScreenText;

  //TabController _controller;
  PlayerInfo _currentPlayer;
  int _navPos = 0;
  Nats _nats;
  // NetworkChangeListener _networkChangeListener;

  Future<void> _init() async {
    log('Initialize main screen');

    // initialize device
    await DeviceInfo.init();
    Screen.init(context);
    appService.initScreenAttribs();
    await appService.appSettings.loadCardBack();

    log('Device name: ${DeviceInfo.name} screen size: ${Screen.size} diagonal: ${Screen.diagonalInches}');

    /* cache all the category gifs */
    GifCacheService.cacheGifCategories(
      AppConstants.GIF_CATEGORIES + AppConstants.GIF_CATEGORIES_CLUB,
    );

    // ConnectionDialog.show(
    //   context: context,
    //   loadingText: "Initializing the app.",
    // );

    log('device name: ${DeviceInfo.name}');
    //await playerState.open();
    await GameHistoryService.init();

    if (!TestService.isTesting) {
      await playerState.open();
      _currentPlayer = await PlayerService.getMyInfo(null);
      playerState.updatePlayerInfo(
        playerId: _currentPlayer.id,
        playerUuid: _currentPlayer.uuid,
        playerName: _currentPlayer.name,
      );
      final natsClient = Provider.of<Nats>(context, listen: false);
      _nats = natsClient;
      appService.natsClient = natsClient;
      log('main_screen :: _currentPlayer.channel : ${_currentPlayer.channel}');
      await natsClient.init(_currentPlayer.channel);
      log('\n\n*********** Player UUID: ${_currentPlayer.uuid} ***********\n\n');

      // _networkChangeListener =
      //     Provider.of<NetworkChangeListener>(context, listen: false);
      // _networkChangeListener.startListening();
      final clubUpdateState = context.read<ClubsUpdateState>();
      // register for notification service
      await notificationHandler.register(clubUpdateState);
      _nats.playerNotifications = notificationHandler.playerNotifications;
      _nats.clubNotifications = notificationHandler.clubNotifications;

      // cache app data
      await appState.cacheData();
      final clubs = await appState.cacheService.getMyClubs();
      for (final club in clubs) {
        _nats.subscribeClubMessages(club.clubCode);
      }
      appState.myClubs = clubs;
    }
    assetLoader.load();

    // ConnectionDialog.dismiss(context: context);

    // check for active game and if there, redirect
    QuickGameNavigationService.handle(context: context);

    // read announcments
    final announcements = await GameService.getSystemAnnouncements();

    // if there are announcements marked as important, show in a dialog
    List<AnnouncementModel> important = [];
    int unreadAnnouncements = 0;
    for (final announcement in announcements) {
      if (playerState.lastReadSysAnnounceDate == null ||
          announcement.createdAt.isAfter(playerState.lastReadSysAnnounceDate)) {
        if (announcement.isImportant) {
          important.add(announcement);
        }
        // playerState.updateSysAnnounceReadDate();
        unreadAnnouncements++;
      }
    }
    playerState.unreadAnnouncements = unreadAnnouncements;
    if (important.length > 0) {
      String importantAnnouncements =
          important.map((e) => e.text).toList().join("\n");
      showErrorDialog(context, 'Announcement', importantAnnouncements,
          info: true);
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("mainScreen");

    _init();
    // _controller = TabController(
    //   vsync: this,
    //   length: 4,
    // );
  }

  @override
  void dispose() {
    super.dispose();

    if (playerState != null) {
      playerState.close();
    }

    // if (_networkChangeListener != null) {
    //   _networkChangeListener.dispose();
    // }

    if (_nats != null) {
      _nats.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    List<Widget> widgets = [];
    widgets.addAll([
      LiveGamesScreen(),
      ClubsPageView(),
      ProfilePageNew(),
      StorePage(),
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.3, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                color: Colors.black.withAlpha(100),
                padding: EdgeInsets.only(top: 4),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  selectedLabelStyle: TextStyle(
                      color: Color(0xFFFFF6DF), fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(color: Color(0xFF979387)),
                  selectedItemColor: Color(0xFFFFF6DF),
                  unselectedItemColor: Color(0xFF979387),
                  onTap: (i) {
                    setState(() => _navPos = i);
                    appState.setIndex(i);
                  },
                  elevation: 0,
                  currentIndex: _navPos,
                  items: [
                    BottomNavigationBarItem(
                      icon: getBottomNavIcon(
                        icon: 'assets/icons/main_games.svg',
                        selected: _navPos == 0,
                      ),
                      label: _appScreenText['games'].toUpperCase(),
                    ),
                    BottomNavigationBarItem(
                      icon: getBottomNavIcon(
                        icon: 'assets/icons/main_clubs.svg',
                        selected: _navPos == 1,
                      ),
                      label: _appScreenText['clubs'].toUpperCase(),
                    ),
                    BottomNavigationBarItem(
                      icon: getBottomNavIcon(
                        icon: 'assets/icons/main_profile.svg',
                        selected: _navPos == 2,
                      ),
                      label: _appScreenText['profile'].toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (appState.isProd) {
      return scaffold;
    }

    return FlavorBanner(
        child: scaffold,
        bannerConfig: BannerConfig(Flavor.DEV.value(), Colors.deepOrange));
  }

  Widget getBottomNavIcon({@required String icon, @required bool selected}) {
    final theme = AppTheme.getTheme(context);
    return Container(
      height: 46,
      width: 46,
      margin: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        gradient: selected
            ? theme.blueButton.borderGradient
            : theme.blueButton.disabledBorderGradient,
        borderRadius: BorderRadius.circular(23),
      ),
      padding: EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: selected
              ? theme.blueButton.gradient
              : theme.blueButton.disabledGradient,
          borderRadius: BorderRadius.circular(19),
        ),
        padding: EdgeInsets.all(4),
        child: SvgPicture.asset(
          icon,
          color: selected ? Color(0xFFFFFAEF) : Color(0xFF979387),
        ),
      ),
    );
  }
}

class CurvedNavItem extends StatelessWidget {
  CurvedNavItem({
    @required this.title,
    @required this.iconData,
    @required this.selected,
    this.svgAsset = '',
    this.showBadge = false,
  });

  final String title;
  final IconData iconData;
  final String svgAsset;
  final bool selected;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    Widget icon;
    if (iconData != null) {
      icon = Icon(
        iconData,
        size: 15.0.pw,
        color: selected
            ? theme.supportingColor
            : theme.supportingColor.withAlpha(150),
      );
    } else {
      icon = SvgPicture.asset(svgAsset,
          width: 15.pw,
          height: 15.pw,
          color: selected
              ? theme.supportingColor
              : theme.supportingColor.withAlpha(150));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Badge(
            animationType: BadgeAnimationType.scale,
            showBadge: showBadge,
            badgeContent: Text(''),
            child: icon),
        selected
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 4.ph),
                child: Text(
                  title, //.toUpperCase() ?? 'Title'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppDecorators.getSubtitle1Style(theme: theme),
                ),
              ),
      ],
    );
  }
}
