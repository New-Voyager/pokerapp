import 'package:flutter/material.dart';
import 'package:pokerapp/mock_data/mock_played_games.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/screens/games_screen/widgets/played_game_item.dart';

class GamesScreen extends StatefulWidget {
  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  var playedGames = MockPlayedGames.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 10.0,
          right: 10.0,
        ),
        children: <Widget>[
          const Text(
            AppStrings.playerGamesText,
            style: const TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              var game = playedGames[index];
              return PlayedGameItem(game: game);
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.0),
            itemCount: MockPlayedGames.numberOfGames,
          ),
        ],
      ),
    );
  }
}
