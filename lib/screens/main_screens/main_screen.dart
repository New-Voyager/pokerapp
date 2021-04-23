import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/clubs_page_view.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/games_page_view.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view.dart';
import 'package:pokerapp/services/firebase/push_notification_service.dart';
import 'package:pokerapp/widgets/tab_bar_item.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;


  Future<void> _init() async {
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
