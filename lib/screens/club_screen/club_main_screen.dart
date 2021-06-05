import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_graphics_view.dart';
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

  // List<Widget> _buildActions(String clubCode, BuildContext context) => [
  //       CustomTextButton(
  //         onTap: () => Navigator.pushNamed(
  //           context,
  //           Routes.new_game_settings,
  //           arguments: clubCode,
  //         ),
  //         text: '+ Create Game',
  //       ),
  //     ];

  @override
  Widget build(BuildContext context) => FutureBuilder<ClubHomePageModel>(
        initialData: null,
        future: ClubsService.getClubHomePageData(clubCode),
        builder: (BuildContext context, snapshot) {
          ClubHomePageModel clubModel = snapshot.data;
          bool isOwnerOrManager = false;
          if (clubModel != null) {
            isOwnerOrManager =
                (clubModel.isOwner || clubModel.isManager) ?? false;
          }
          return Scaffold(
            backgroundColor: AppColors.screenBackgroundColor,
            /*  appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.appAccentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title:,
              actions: clubModel == null
                  ? null
                  : _buildActions(
                      clubModel.clubCode,
                      context,
                    ),
              elevation: 0.0,
              backgroundColor: AppColors.screenBackgroundColor,
            ), */
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
                            Container(
                              padding: EdgeInsets.only(left: 8, right: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: AppColors.appAccentColor,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop()),
                                  !isOwnerOrManager
                                      ? Container()
                                      : CustomTextButton(
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            Routes.new_game_settings,
                                            arguments: clubCode,
                                          ),
                                          text: '+ Create Game',
                                        ),
                                ],
                              ),
                            ),
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
