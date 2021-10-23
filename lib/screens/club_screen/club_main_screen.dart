import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_actions_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_banner_new.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_live_games_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/coin_update.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/pending_approvals.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubMainScreenNew extends StatefulWidget {
  final String clubCode;

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
                Stack(children: [
                  Positioned(top: 5.ph, left: 5.pw, child: BackArrowWidget()),
                  Positioned(
                      top: 5.ph,
                      right: 10.pw,
                      child: Transform.scale(
                          scale: 1.5,
                          child: CoinWidget(clubModel.clubCoins, 0, false))),

                  // banner
                  Transform.translate(
                      offset: Offset(0, 5.ph),
                      child: ClubBannerViewNew(
                        clubModel: clubModel,
                        appScreenText: _appScreenText,
                      )),
                ]),

                // live game
                ClubLiveGamesView(
                    clubModel, clubModel.liveGames, _appScreenText),

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

  Future<ClubHomePageModel> fetchData() async {
    // if the current user is manager or club owner, get club coins
    final clubData = await ClubsService.getClubHomePageData(widget.clubCode);
    if (clubData.isManager || clubData.isOwner) {
      clubData.clubCoins = await ClubsService.getClubCoins(widget.clubCode);
      ;
    }

    return clubData;
  }

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
            future: fetchData(),
            builder: (BuildContext context, snapshot) {
              ClubHomePageModel clubModel = snapshot.data;
              // log("0-0-0- ${snapshot.connectionState}");
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
