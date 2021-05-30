import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';

class LiveGamesScreen extends StatefulWidget {
  @override
  _LiveGamesScreenState createState() => _LiveGamesScreenState();
}

class _LiveGamesScreenState extends State<LiveGamesScreen> {
  bool _isLoading = true;
  List<GameModelNew> liveGames = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TestService.isTesting ? _loadTestLiveGames() : _fetchLiveGames();
    });
    super.initState();
  }

  _fetchLiveGames() async {
    // Load actual games from server graphql
    liveGames.clear();
    ConnectionDialog.show(
        context: context, loadingText: AppStringsNew.LoadingGamesText);
    liveGames.addAll(await GameService.getLiveGamesNew());
    setState(() {
      _isLoading = false;
    });
    ConnectionDialog.dismiss(context: context);
  }

  _loadTestLiveGames() async {
    ConnectionDialog.show(
        context: context, loadingText: AppStringsNew.LoadingGamesText);
    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/livegames.json");
    // log(data);

    final jsonResult = json.decode(data);

    for (var item in jsonResult['liveGames']) {
      liveGames.add(GameModelNew.fromJson(item));
    }
    log("Size : ${liveGames.length}");
    setState(() {
      _isLoading = false;
    });
    ConnectionDialog.dismiss(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsNew.newBackgroundBlackColor,
        image: DecorationImage(
          image: AssetImage(
            AppAssetsNew.pathBackgroundImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  AppStrings.liveGamesText.toUpperCase(),
                  style: AppStylesNew.TitleTextStyle,
                ),
              ),
              _isLoading
                  ? Container()
                  : liveGames.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              AppStringsNew.NoGamesText,
                              style: AppStylesNew.TitleTextStyle,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return LiveGameItem(
                                  game: liveGames[index],
                                  onTapFunction: () async {
                                    await Navigator.of(context).pushNamed(
                                        Routes.game_play,
                                        arguments: liveGames[index].gameCode);
                                    // Refreshes livegames again
                                    TestService.isTesting
                                        ? _loadTestLiveGames()
                                        : _fetchLiveGames();
                                  });
                            },
                            padding: EdgeInsets.only(bottom: 64, top: 16),
                            separatorBuilder: (context, index) =>
                                AppDimensionsNew.getVerticalSizedBox(16),
                            itemCount: liveGames.length,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
