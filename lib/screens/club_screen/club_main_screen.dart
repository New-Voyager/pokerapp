import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/clubs_games_page_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/new_game_settings.dart';
import 'package:pokerapp/screens/club_screen/info_page_view/info_page_view.dart';
import 'package:pokerapp/screens/club_screen/members_page_view/members_page_view.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/messages_page_view.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/tab_bar_item.dart';
import 'package:provider/provider.dart';

class ClubMainScreen extends StatefulWidget {
  @override
  _ClubMainScreenState createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      initialIndex: 1,
      vsync: this,
      length: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final clubModel = Provider.of<ClubModel>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomTextButton(
                text: "+create game",
                onTap: () {
                  NewGameModelProvider data = new NewGameModelProvider(clubModel.clubCode);
                  print(data);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (_) => data,
                                child: NewGameSettings(),
                                lazy: false,
                              )));
                }),
          )
        ],
        title: Text(
          clubModel.clubName,
        ),
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: <Widget>[
                  MessagesPageView(
                    clubCode: clubModel.clubCode,
                  ),
                  ClubsGamePageView(),
                  MembersPageView(),
                  InfoPageView(),
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
                    iconData: AppIcons.message,
                    title: 'Messages',
                  ),
                  TabBarItem(
                    iconData: AppIcons.playing_card,
                    title: 'Games',
                  ),
                  TabBarItem(
                    iconData: AppIcons.membership,
                    title: 'Members',
                  ),
                  TabBarItem(
                    iconData: Icons.info,
                    title: 'Info',
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
