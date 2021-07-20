import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_actions_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_banner_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_graphics_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_live_games_view.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/pending_approvals.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubMainScreenNew extends StatefulWidget {
  final String clubCode;
  // ClubWeeklyActivityModel weeklyActivity;

  ClubMainScreenNew({
    @required this.clubCode,
  });

  @override
  _ClubMainScreenNewState createState() => _ClubMainScreenNewState();
}

class _ClubMainScreenNewState extends State<ClubMainScreenNew>
    with RouteAware, RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_main;
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

  Widget _buildMainBody(ClubHomePageModel clubModel) => Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60.ph),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.ph),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackArrowWidget(),
                        Visibility(
                          visible: (clubModel.isManager || clubModel.isOwner),
                          child: RoundedColorButton(
                            onTapFunction: () async {
                              final dynamic result = await Navigator.pushNamed(
                                context,
                                Routes.new_game_settings,
                                arguments: widget.clubCode,
                              );

                              if (result != null) {
                                /* show game settings dialog */
                                NewGameSettings2.show(
                                  context,
                                  clubCode: widget.clubCode,
                                  mainGameType: result['gameType'],
                                  subGameTypes: List.from(
                                        result['gameTypes'],
                                      ) ??
                                      [],
                                );
                              }
                            },
                            text: '+ Create Game',
                            backgroundColor: AppColorsNew.yellowAccentColor,
                            textColor: AppColorsNew.darkGreenShadeColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // banner
                  ClubBannerViewNew(
                    clubModel: clubModel,
                  ),

                  // stats view
                  /*  ClubGraphicsViewNew(
                    clubModel.playerBalance ?? 0.0,
                    clubModel.weeklyActivity,
                  ), */

                  // live game
                  ClubLiveGamesView(clubModel),

                  // seperator
                  AppDimensionsNew.getVerticalSizedBox(16.ph),

                  // club actions
                  ClubActionsNew(
                    clubModel,
                    this.widget.clubCode,
                  ),

                  // seperator
                  AppDimensionsNew.getVerticalSizedBox(16.ph),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
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
                          radius: 0.80.pw,
                        ),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: _buildMainBody(clubModel),
                      ),
                    ),
                  );
          },
        ),
      );
}
