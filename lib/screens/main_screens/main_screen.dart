import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/clubs_screen.dart';
import 'package:pokerapp/screens/games_screen/games_screen.dart';
import 'package:pokerapp/screens/main_screens/widgets/tab_bar_item.dart';
import 'package:pokerapp/screens/profile_screen.dart';

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
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: <Widget>[
                  GamesScreen(),
                  ClubsScreen(),
                  ProfileScreen(),
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
    );
  }
}
