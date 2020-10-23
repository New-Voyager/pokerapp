import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/enums.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/game_item.dart';
import 'package:pokerapp/services/app/user_games_service.dart';

class GamesPageView extends StatefulWidget {
  @override
  _GamesPageViewState createState() => _GamesPageViewState();
}

class _GamesPageViewState extends State<GamesPageView> {
  List<GameModel> _playedGames = [];
  List<GameModel> _liveGames = [];

  bool _isLoading = false;
  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  Widget _buildTitleTextWidget(String title) => Text(
        title,
        style: const TextStyle(
          fontFamily: AppAssets.fontFamilyLato,
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w900,
        ),
      );

  Widget _buildEmptyGameListWidget(String title) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: _buildTitleTextWidget(title),
        ),
      );

  Widget _buildGameList(LiveOrPlayedGames liveOrPlayedGames) =>
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shrinkWrap: true,
        itemBuilder: (_, int index) => GameItem(
          game: liveOrPlayedGames == LiveOrPlayedGames.LiveGames
              ? _liveGames[index]
              : _playedGames[index],
          gameStatus: liveOrPlayedGames,
        ),
        separatorBuilder: (_, __) => SizedBox(height: 10.0),
        itemCount: liveOrPlayedGames == LiveOrPlayedGames.LiveGames
            ? _liveGames.length
            : _playedGames.length,
      );

  void _fetchGameDetails() async {
    _toggleLoading();

    _liveGames = await UserGamesService.fetchLiveGames();
    _playedGames = await UserGamesService.fetchPlayedGames();

    print(_liveGames);
    print(_playedGames);

    _toggleLoading();
  }

  @override
  void initState() {
    super.initState();
    _fetchGameDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: AppDimensions.kMainPaddingHorizontal,
                right: AppDimensions.kMainPaddingHorizontal,
              ),
              children: <Widget>[
                /* live games */
                _buildTitleTextWidget(AppStrings.liveGamesText),
                _liveGames.isEmpty
                    ? _buildEmptyGameListWidget('No Live Games')
                    : _buildGameList(LiveOrPlayedGames.LiveGames),

                /* played games */
                _buildTitleTextWidget(AppStrings.playerGamesText),
                _playedGames.isEmpty
                    ? _buildEmptyGameListWidget('No Played Games')
                    : _buildGameList(LiveOrPlayedGames.PlayedGames),
              ],
            ),
    );
  }
}
