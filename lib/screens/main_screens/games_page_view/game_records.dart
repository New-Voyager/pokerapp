import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/test/mock_data.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';

import '../../game_screens/widgets/back_button.dart';

class GameRecords extends StatefulWidget {
  GameRecords({Key key}) : super(key: key);

  @override
  State<GameRecords> createState() => _GameRecordsState();
}

class _GameRecordsState extends State<GameRecords> {
  @override
  String get routeName => Routes.game_records;
  AppTextScreen _appScreenText;

  bool _isLoading = true;
  bool _isPlayedGamesLoading = true;

  List<GameModel> liveGames = [];
  List<GameHistoryModel> playedGames = [];
  var theme;

  bool closed = false;

  @override
  void initState() {
    super.initState();

    theme = context.read<AppTheme>();
    _appScreenText = getAppTextScreen("bookmarkedHands");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TestService.isTesting ? _loadTestLiveGames() : _fetchPlayedGames();
    });

    if (appState != null) {
      appState.addListener(() async {
        if (appState.newGame || appState.gameEnded) {
          await _fetchPlayedGames();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleGameRefresh(appState);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: AppDecorators.bgImageGradient(theme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: "Game Records",
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isPlayedGamesLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(child: getPlayedGames(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget gameHistoryItem(BuildContext context, int index) {
    final item = playedGames[index];
    return GestureDetector(
      onTap: () {
        GameHistoryDetailModel model =
            GameHistoryDetailModel(item.gameCode, true);
        Navigator.pushNamed(
          context,
          Routes.game_history_detail_view,
          arguments: {'model': model, 'clubCode': item.clubCode},
        );
      },
      child: GameHistoryItemNew(
        game: playedGames[index],
        showClubName: true,
      ),
    );
  }

  Widget getPlayedGames(AppTheme appTheme) {
    return playedGames.isEmpty
        ? Center(
            child: Text(
              _appScreenText['noGames'],
              style: AppDecorators.getAccentTextStyle(theme: appTheme),
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: gameHistoryItem,
            padding: EdgeInsets.only(
              bottom: 64.ph,
              top: 16.ph,
            ),
            separatorBuilder: (
              context,
              index,
            ) =>
                AppDimensionsNew.getVerticalSizedBox(16.ph),
            itemCount: playedGames?.length,
          );
  }

  _loadTestLiveGames() async {
    ConnectionDialog.show(
        context: context, loadingText: _appScreenText['gettingGames']);
    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/livegames.json");
    // log(data);

    final jsonResult = json.decode(data);
    log('${jsonResult}');
    for (var item in jsonResult['liveGames']) {
      liveGames.add(GameModel.fromJson(item));
    }
    log("Size : ${liveGames.length}");
    if (closed) {
      return;
    }

    setState(() {
      _isLoading = false;
      _isPlayedGamesLoading = false;
    });
    ConnectionDialog.dismiss(context: context);
  }

  _fetchPlayedGames() async {
    log('fetching played games');

    if (appState != null && appState.mockScreens) {
      playedGames = await MockData.getPlayedGames();
    } else {
      final updatedPlayedGames = await GameService.getPastGames();
      bool refresh = true;
      if (refresh) {
        // playedGames.clear();
        playedGames = updatedPlayedGames;
        if (closed) {
          return;
        }
      }
    }
    setState(() => _isPlayedGamesLoading = false);
  }

  void _handleGameRefresh(AppState appState) {
    if (!mounted) return;
    final int currentIndex = appState.currentIndex;
    if (currentIndex != 0) return;
    if (appState.newGame || appState.gameEnded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPlayedGames();
      });
    }
  }
}
