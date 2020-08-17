import 'package:flutter/material.dart';
import 'package:pokerapp/mock_data/mock_game_data.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/enums.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/game_item.dart';

class GamesPageView extends StatefulWidget {
  @override
  _GamesPageViewState createState() => _GamesPageViewState();
}

class _GamesPageViewState extends State<GamesPageView> {
  static final _totalPlayedGames = 9;
  static final _totalLiveGames = 3;

  var _playedGames = MockGameData.get(_totalPlayedGames);
  var _liveGames = MockGameData.get(_totalLiveGames);

  Text _getTitleTextWidget(title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: AppAssets.fontFamilyLato,
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: AppDimensions.kMainPaddingHorizontal,
          right: AppDimensions.kMainPaddingHorizontal,
        ),
        children: <Widget>[
          /*
          * Live Games
          * */

          _getTitleTextWidget(AppStrings.liveGamesText),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              var game = _liveGames[index];
              return GameItem(
                game: game,
                gameStatus: GameStatus.LiveGames,
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.0),
            itemCount: _totalLiveGames,
          ),

          /*
         *Played Games
         */

          _getTitleTextWidget(AppStrings.playerGamesText),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              var game = _playedGames[index];
              return GameItem(game: game);
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.0),
            itemCount: _totalPlayedGames,
          ),
        ],
      ),
    );
  }
}
