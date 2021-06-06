import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_graphics_view.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/pending_approvals.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';
import 'club_games_page_view.dart';

class ClubMainScreen extends StatefulWidget {
  final String clubCode;
  // ClubWeeklyActivityModel weeklyActivity;

  ClubMainScreen({
    @required this.clubCode,
  });

  @override
  _ClubMainScreenState createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen> with RouteAware {
  void refreshClubMainScreen() {
    log('refresh club main screen');
    setState(() {});
  }

  @override
  void didPopNext() {
    super.didPopNext();
    refreshClubMainScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    context.read<ClubsUpdateState>().addListener(() {
      final state = Provider.of<ClubsUpdateState>(context, listen: false);
      if (state.updatedClubCode == widget.clubCode) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('rebuilding ClubMainScreen');
    return FutureBuilder<ClubHomePageModel>(
        initialData: null,
        future: ClubsService.getClubHomePageData(widget.clubCode),
        builder: (BuildContext context, snapshot) {
          ClubHomePageModel clubModel = snapshot.data;
          bool isOwnerOrManager = false;
          if (clubModel != null) {
            isOwnerOrManager =
                (clubModel.isOwner || clubModel.isManager) ?? false;
          }
          return Scaffold(
            backgroundColor: AppColors.screenBackgroundColor,
            appBar: CustomAppBar(
              context: context,
            ),
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  !isOwnerOrManager
                                      ? Container()
                                      : CustomTextButton(
                                          onTap: () async {
                                            final dynamic result =
                                                await Navigator.pushNamed(
                                              context,
                                              Routes.new_game_settings,
                                              arguments: widget.clubCode,
                                            );
                                            log("$result");

                                            if (result != null) {
                                              /* show game settings dialog */
                                             NewGameSettings2.show(
                                                context,
                                                clubCode: widget.clubCode,
                                                mainGameType:
                                                    result['gameType'],
                                                subGameTypes: List.from(
                                                        result['gameTypes']) ??
                                                    [],
                                              );
                                            }
                                          },
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
                            ClubActionButtonsView(
                              clubModel,
                              this.widget.clubCode,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      );
  }
}
