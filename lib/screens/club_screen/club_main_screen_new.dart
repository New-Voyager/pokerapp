import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_graphics_view.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_actions_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_banner_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_graphics_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_live_games_view.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/pending_approvals.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';
import 'club_games_page_view.dart';

class ClubMainScreenNew extends StatefulWidget {
  final String clubCode;
  // ClubWeeklyActivityModel weeklyActivity;

  ClubMainScreenNew({
    @required this.clubCode,
  });

  @override
  _ClubMainScreenNewState createState() => _ClubMainScreenNewState();
}

class _ClubMainScreenNewState extends State<ClubMainScreenNew> with RouteAware {
  void refreshClubMainScreen() {
    //  log('refresh club main screen');
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

  void listener() {
    if (!mounted) return;

    final state = context.read<ClubsUpdateState>();
    if (state.updatedClubCode == widget.clubCode) {
      setState(() {});
    }
  }

  @override
  void initState() {
    context.read<ClubsUpdateState>().addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //log('rebuilding ClubMainScreen');
    return WillPopScope(
      onWillPop: () async {
        context.read<ClubsUpdateState>().removeListener(listener);
        routeObserver.unsubscribe(this);
        return true;
      },
      child: FutureBuilder<ClubHomePageModel>(
        initialData: null,
        future: ClubsService.getClubHomePageData(widget.clubCode),
        builder: (BuildContext context, snapshot) {
          ClubHomePageModel clubModel = snapshot.data;
          bool isOwnerOrManager = false;
          if (clubModel != null) {
            isOwnerOrManager =
                (clubModel.isOwner || clubModel.isManager) ?? false;
          }
          return clubModel == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListenableProvider<ClubHomePageModel>(
                  create: (_) => clubModel,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          AppColorsNew.newGreenRadialStartColor,
                          AppColorsNew.newBackgroundBlackColor,
                        ],
                        center: Alignment.topLeft,
                        radius: 1.5,
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: CustomAppBar(
                        context: context,
                        actionsList: [
                          !isOwnerOrManager
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(
                                      top: 16, right: 16, bottom: 16),
                                  child: CustomTextButton(
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
                                          mainGameType: result['gameType'],
                                          subGameTypes:
                                              List.from(result['gameTypes']) ??
                                                  [],
                                        );
                                      }
                                    },
                                    text: '+ Create Game',
                                  ),
                                ),
                        ],
                      ),
                      body: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 60),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClubBannerViewNew(
                                    clubModel: clubModel,
                                  ),
                                  ClubGraphicsViewNew(
                                      clubModel.playerBalance ?? 0.0,
                                      clubModel.weeklyActivity),
                                  ClubLiveGamesView(clubModel.liveGames),
                                  AppDimensionsNew.getVerticalSizedBox(16),
                                  ClubActionsNew(
                                    clubModel,
                                    this.widget.clubCode,
                                  ),
                                  AppDimensionsNew.getVerticalSizedBox(16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
