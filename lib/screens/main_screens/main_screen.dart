import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/clubs_page_view.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/games_page_view.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view.dart';
import 'package:pokerapp/widgets/tab_bar_item.dart';

// todo: debug
const bool SKIP_TO_GAME_SCREEN = false;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      vsync: this,
      length: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SKIP_TO_GAME_SCREEN
        ? GamePlayScreen()
        : Scaffold(
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
