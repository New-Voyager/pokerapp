import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game/lobby_game_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';

class LobbyGamesScreen extends StatefulWidget {
  const LobbyGamesScreen({Key key}) : super(key: key);

  @override
  State<LobbyGamesScreen> createState() => _LobbyGamesScreenState();
}

class _LobbyGamesScreenState extends State<LobbyGamesScreen> {
  final List<LobbyGameModel> _lobbyGames = [];
  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getLobbyGames();
    });
    super.initState();
  }

  _getLobbyGames() async {
    setState(() {
      _isLoading = true;
    });

    final result = await GameService.fetchLobbyGames();

    if (result != null) {
      _lobbyGames.addAll(result);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          showBackButton: false,
          titleText: "Lobby Games",
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressWidget(),
              )
            : _lobbyGames.isEmpty
                ? Center(
                    child: Text(
                      "No games available",
                    ),
                  )

                // else show grid view of games with two columns
                : Container(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 32, right: 32),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 16,
                      children: _lobbyGames.map((game) {
                        return InkWell(
                          onTap: () {
                            _handleLobbyGameTap(game);
                          },
                          child: LobbyGameCard(
                            game: game,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
      ),
    );
  }

  _handleLobbyGameTap(LobbyGameModel game) {
    navigatorKey.currentState.pushNamed(
      Routes.game_play,
      arguments: game.gameCode,
    );
  }
}

class ChipsWidget extends StatelessWidget {
  const ChipsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 32,
      decoration:
          AppDecorators.accentBorderDecoration(AppTheme.getTheme(context)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssetsNew.chipImagePath,
            height: 20,
            width: 20,
          ),
        ],
      ),
    );
  }
}

class LobbyGameCard extends StatelessWidget {
  final LobbyGameModel game;
  const LobbyGameCard({Key key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: AppColorsNew.yellowAccentColor,
              ),
              bottom: BorderSide(
                color: AppColorsNew.yellowAccentColor,
              ),
            ),
            gradient: RadialGradient(
                radius: 2,
                center: Alignment.bottomRight,
                colors: [
                  AppColorsNew.yellowAccentColor.withOpacity(0.5),
                  Colors.transparent,
                ]),
          ),
        ),
        Positioned(
          child: Image.asset(
            GameModel.getGameTypeImageAsset(game.gameType),
            height: 64,
            width: 64,
          ),
          top: 0,
          left: 0,
        ),
        Positioned(
          left: 16,
          top: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColorsNew.actionRowBgColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 10,
                        color: Colors.transparent),
                  ],
                ),
                child: Text(
                  gameTypeShortStr2(gameTypeFromStr(game.gameType)),
                  style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
                      color: AppColorsNew.newTextColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
              AppDimensionsNew.getVerticalSizedBox(4),
              // Text(
              //   game.title,
              //   style: AppDecorators.getHeadLine5Style(theme: theme),
              // ),
              AppDimensionsNew.getDivider(theme),
              Text(
                "${game.smallBlind}/${game.bigBlind}",
                style: AppDecorators.getSubtitle1Style(theme: theme)
                    .copyWith(color: AppColorsNew.yellowAccentColor),
              ),
              AppDimensionsNew.getDivider(theme),
              Row(
                children: [
                  Image.asset(
                    AppAssetsNew.chipImagePath,
                    height: 16,
                    width: 16,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    " ${game.buyInMin} - ${game.buyInMax}",
                    style:
                        AppDecorators.getSubtitle3Style(theme: theme).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                  Text(
                    " ${game.activePlayers}/${game.maxPlayers}",
                    style:
                        AppDecorators.getSubtitle3Style(theme: theme).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // User count
        Positioned(
          child: Row(
            children: [
              Icon(
                Icons.circle,
                color: game.status == "ACTIVE" ? Colors.green : Colors.red,
                size: 16,
              ),
              Text(
                " ${game.status}",
                style: AppDecorators.getSubtitle4Style(theme: theme),
              ),
            ],
          ),
          right: 0,
          top: 0,
        )
      ],
    );
  }
}
