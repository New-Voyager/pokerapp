import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_icons.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/club_games_page_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/new_game_settings.dart';
import 'package:pokerapp/screens/club_screen/info_page_view/info_page_view.dart';
import 'package:pokerapp/screens/club_screen/members_page_view/members_page_view.dart';
import 'package:pokerapp/screens/club_screen/messages_page_view/messages_page_view.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/tab_bar_item.dart';
import 'package:provider/provider.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClubBannerView(),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Card(
                  color: AppColors.cardBackgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          "Outstanding Chips Balance",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: AppAssets.fontFamilyLato,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          "+400",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.negativeColor,
                            fontSize: 14.0,
                            fontFamily: AppAssets.fontFamilyLato,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  elevation: 5.5,
                ),
              ),
              ClubGamesPageView(),
              ClubActionButtonsView()
            ],
          ),
        ),
      ),
    );
  }
}
