import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stats_view.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/clubs_page_view.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/live_games.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view_new.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/store_page.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/gif_cache_service.dart';
import 'package:pokerapp/services/app/loadassets_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/data/app_settings.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/services/game_history/game_history_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/notifications/notifications.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/curved_bottom_navigation.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import '../../flavor_banner.dart';
import '../../flavor_config.dart';
import '../../main_helper.dart';
import '../../routes.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
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

    log('Device name: ${DeviceInfo.name} screen size: ${Screen.size} diagonal: ${Screen.diagonalInches}');

    /* cache all the category gifs */
    GifCacheService.cacheGifCategories(
      AppConstants.GIF_CATEGORIES,
    );
    log('device name: ${DeviceInfo.name}');
    await playerState.open();
    await GameHistoryService.init();

    if (!TestService.isTesting) {
      _currentPlayer = await PlayerService.getMyInfo(null);
      playerState.updatePlayerInfo(
        playerId: _currentPlayer.id,
        playerUuid: _currentPlayer.uuid,
        playerName: _currentPlayer.name,
      );
      final natsClient = Provider.of<Nats>(context, listen: false);
      _nats = natsClient;
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

      final clubs = await ClubsService.getMyClubs();
      for (final club in clubs) {
        _nats.subscribeClubMessages(club.clubCode);
      }
      appState.myClubs = clubs;

      // TODO: WHY DO WE NEEDED THE DELAY?
      // Future.delayed(Duration(milliseconds: 100), () async {
      //   await natsClient.init(_currentPlayer.channel);
      // });
    }
    assetLoader.load();

    // read announcments
    final announcements = await GameService.getSystemAnnouncements();

    // if there are announcements marked as important, show in a dialog
    List<AnnouncementModel> important = [];
    int unreadAnnouncements = 0;
    for (final announcement in announcements) {
      if (announcement.createdAt.isAfter(playerState.lastReadSysAnnounceDate)) {
        if (announcement.isImportant) {
          important.add(announcement);
        }
        playerState.updateSysAnnounceReadDate();
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

    AppSettingsStore appSettings = appService.appSettings;
    String gameCode = appSettings.playerInGame;

    if (gameCode != null) {
      GameInfoModel gameInfo = null;
      ConnectionDialog.show(context: context, loadingText: 'Loading last active game...');
      gameInfo = await GameService.getGameInfo(gameCode);
      ConnectionDialog.dismiss(context: context);
      if (gameInfo != null && gameInfo.status == "ACTIVE") {
        Navigator.pushNamed(
          context,
          Routes.game_play,
          arguments: gameCode,
        );
      } else {
        as.playerInGame = null;
      }
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
            child: CurvedBottomNavigation(
              selected: _navPos,
              fabSize: 35.pw,
              navHeight: 50.ph,
              bgColor: theme.navBgColor,
              fabBgColor: theme.secondaryColorWithDark(0.2),
              onItemClick: (i) {
                setState(() => _navPos = i);
                appState.setIndex(i);
              },
              items: [
                CurvedNavItem(
                  iconData: AppIcons.playing_card,
                  title: _appScreenText['games'],
                  selected: _navPos == 0,
                ),
                CurvedNavItem(
                  iconData: null, // AppIcons.users,
                  svgAsset: 'assets/icons/clubs.svg',
                  title: _appScreenText['clubs'],
                  selected: _navPos == 1,
                ),
                CurvedNavItem(
                  iconData: AppIcons.user,
                  title: _appScreenText['profile'],
                  selected: _navPos == 2,
                ),
                CurvedNavItem(
                  iconData: Icons.shopping_cart,
                  title: _appScreenText['store'],
                  selected: _navPos == 3,
                ),
                if (TestService.isTesting)
                  CurvedNavItem(
                    iconData: Icons.money,
                    title: _appScreenText['test'],
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
    this.svgAsset = '',
  });

  final String title;
  final IconData iconData;
  final String svgAsset;
  final bool selected;

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
        icon,
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
