import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/clubs_page_view.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/games_page_view.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/firebase/push_notification_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/widgets/tab_bar_item.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Nats _nats;
  PlayerInfo _currentPlayer;
  Future<void> _init() async {
    log('Initialize main screen');
    //_nats = Nats();
    _currentPlayer = await PlayerService.getMyInfo(null);

    // Get the token each time the application loads
    String token = await FirebaseMessaging.instance.getToken();
    await saveFirebaseToken(token);
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveFirebaseToken);
    registerPushNotifications();   
  }

  @override
  void initState() {
    super.initState();
    _init();
    _controller = TabController(
      vsync: this,
      length: 3,
    );
  }

  @override
  void dispose() {
    log('Dispose main screen');
    if (_nats != null) {
      _nats.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Build main screen');
    this._nats = Provider.of<Nats>(context, listen: false);

    if (!this._nats.initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (this._nats != null && this._currentPlayer != null) {
          this._nats.init(this._currentPlayer.channel);
          log('NATS is initialized');
        }      
      });
    }

    return 
     Scaffold(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    
  }
}
