import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/club_games_page_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/new_game_settings.dart';
import 'package:provider/provider.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';

class ClubMainScreen extends StatefulWidget {
  @override
  _ClubMainScreenState createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen> {
  @override
  void initState() {
    super.initState();
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
        actions: [
          TextButton(
            onPressed: () {
              NewGameModelProvider data =
                  new NewGameModelProvider(clubModel.clubCode);

              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => data,
                    child: NewGameSettings(),
                    lazy: false,
                  ),
                ),
              );
            },
            child: Text(
              '+ Create Game',
              style: TextStyle(
                color: AppColors.appAccentColor,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
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
