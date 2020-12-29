import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/club_games_page_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/new_game_settings.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';

class ClubMainScreen extends StatelessWidget {
  final String clubCode;

  ClubMainScreen({
    @required this.clubCode,
  });

  List<Widget> _buildActions(String clubCode, BuildContext context) => [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextButton(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewGameSettings(
                  clubCode: clubCode,
                ),
              ),
            ),
            text: '+ Create Game',
          ),
        ),
      ];

  Widget _buildOutstandingBalanceWidget(ClubHomePageModel data) => Container(
        margin: EdgeInsets.all(8.0),
        child: Card(
          color: AppColors.cardBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                  "Outstanding Chips",
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
                  data.playerBalance == null
                      ? '0.0'
                      : data.playerBalance.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    // todo: change color as per balance value
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
      );

  @override
  Widget build(BuildContext context) => FutureBuilder<ClubHomePageModel>(
        initialData: null,
        future: ClubsService.getClubHomePageData(clubCode),
        builder: (BuildContext context, snapshot) {
          ClubHomePageModel clubModel = snapshot.data;

          return Scaffold(
            backgroundColor: AppColors.screenBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: clubModel == null
                  ? null
                  : _buildActions(
                      clubModel.clubCode,
                      context,
                    ),
              elevation: 0.0,
              backgroundColor: AppColors.screenBackgroundColor,
            ),
            body: clubModel == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListenableProvider<ClubHomePageModel>(
                    create: (_) => clubModel,
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClubBannerView(
                              clubModel: clubModel,
                            ),
                            _buildOutstandingBalanceWidget(clubModel),
                            ClubGamesPageView(clubModel),
                            ClubActionButtonsView()
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      );
}
