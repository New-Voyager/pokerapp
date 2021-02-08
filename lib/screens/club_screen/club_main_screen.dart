import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_graphics_view.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';
import 'club_games_page_view.dart';

class ClubMainScreen extends StatelessWidget {
  final String clubCode;
  ClubWeeklyActivityModel weeklyActivity;

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
                  clubCode,
                ),
              ),
            ),
            text: '+ Create Game',
          ),
        ),
      ];

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
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.appAccentColor,
                ),
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
                            IntrinsicHeight(
                              child: ClubGraphicsView(
                                  clubModel.playerBalance ?? 0.0,
                                  clubModel.weeklyActivity),
                            ),
                            ClubGamesPageView(clubModel.liveGames),
                            ClubActionButtonsView(clubModel, this.clubCode)
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      );
}
