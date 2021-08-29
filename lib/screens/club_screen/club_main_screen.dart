import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_actions_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_banner_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_live_games_view.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
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
  AppTextScreen _appScreenText;

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
    _appScreenText = getAppTextScreen("clubMainScreenNew");
    context.read<ClubsUpdateState>().addListener(listener);
    super.initState();
  }

  Widget _buildMainBody(ClubHomePageModel clubModel, AppTheme theme) => Stack(
        children: [
          SingleChildScrollView(
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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
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
                            text: _appScreenText['CREATEGAME'],
                            backgroundColor: theme.accentColor,
                            textColor: theme.primaryColorWithDark(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // banner
                ClubBannerViewNew(
                  clubModel: clubModel,
                  appScreenText: _appScreenText,
                ),

                // stats view
                /*  ClubGraphicsViewNew(
                  clubModel.playerBalance ?? 0.0,
                  clubModel.weeklyActivity,
                ), */

                // live game
                ClubLiveGamesView(clubModel.liveGames, _appScreenText),

                // seperator
                AppDimensionsNew.getVerticalSizedBox(16.ph),

                // club actions
                ClubActionsNew(clubModel, this.widget.clubCode, _appScreenText),

                // seperator
                AppDimensionsNew.getVerticalSizedBox(16.ph),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Consumer<AppTheme>(
        builder: (_, theme, __) => WillPopScope(
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
              log("0-0-0- ${snapshot.connectionState}");
              return Container(
                decoration: AppDecorators.bgRadialGradient(theme),
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: clubModel == null
                        ? Center(
                            child: CircularProgressWidget(),
                          )
                        : ListenableProvider<ClubHomePageModel>(
                            create: (_) => clubModel,
                            child: _buildMainBody(clubModel, theme),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
