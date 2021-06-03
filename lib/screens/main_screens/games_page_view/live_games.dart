import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/app_strings.dart';
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

  Timer _refreshTimer;

  Future<void> _fillLiveGames() async {
    print('fetching live games');
    liveGames = await GameService.getLiveGamesNew();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TestService.isTesting ? _loadTestLiveGames() : _fetchLiveGames();
    });

    // THIS IS A TEMPORARY SOLUTION
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fillLiveGames();
      setState(() {});
    });
  }

  _fetchLiveGames() async {
    ConnectionDialog.show(
      context: context,
      loadingText: AppStringsNew.LoadingGamesText,
    );
    await _fillLiveGames();
    setState(() => _isLoading = false);
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
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.bgDecoration,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Text(
                  AppStringsNew.LiveGamesTitle.toUpperCase(),
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
