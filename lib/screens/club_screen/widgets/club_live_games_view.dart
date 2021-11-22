import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubLiveGamesView extends StatelessWidget {
  final List<GameModelNew> liveGames;
  final AppTextScreen appScreenText;
  final ClubHomePageModel clubModel;
  final VoidCallback onRefreshClubMainScreen;

  ClubLiveGamesView({
    @required this.clubModel,
    @required this.liveGames,
    @required this.appScreenText,
    @required this.onRefreshClubMainScreen,
  });

  void onLiveGameTap({
    @required final BuildContext context,
    @required final int index,
  }) async {
    // show connection dialog
    ConnectionDialog.show(context: context, loadingText: "Fetching Games...");

    // fetch game info
    final GameInfoModel gameInfo = await GameService.getGameInfo(
      liveGames[index].gameCode,
    );

    // dismiss dialog after fetched
    ConnectionDialog.dismiss(context: context);

    if (gameInfo == null || gameInfo.status == AppConstants.GAME_ENDED) {
      // refresh the club live games screen
      onRefreshClubMainScreen();

      // show a dialog displaying that the game has ended
      showErrorDialog(context, 'Error', 'Game has ended');
    } else {
      // else we navigate to the game play screen
      Navigator.of(context).pushNamed(
        Routes.game_play,
        arguments: {
          'gameCode': liveGames[index].gameCode,
          'gameInfo': gameInfo,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        margin: EdgeInsets.only(
          top: 16.0,
          left: 8,
          right: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDimensionsNew.getVerticalSizedBox(8),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: (clubModel.isManager || clubModel.isOwner),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RoundRectButton(
                    onTap: () async {
                      // get this value from API
                      int minCoinsNeeded = 10;
                      // if the player does not have enough coins
                      // don't host the game
                      if (clubModel.clubCoins < 10) {
                        showErrorDialog(context, 'Error',
                            'Not enough coins to host a game. $minCoinsNeeded required to host a game');
                        return;
                      }

                      final dynamic result = await Navigator.pushNamed(
                        context,
                        Routes.new_game_settings,
                        arguments: this.clubModel.clubCode,
                      );

                      if (result != null) {
                        /* show game settings dialog */
                        NewGameSettings2.show(
                          context,
                          clubCode: this.clubModel.clubCode,
                          mainGameType: result['gameType'],
                          subGameTypes: List.from(
                                result['gameTypes'],
                              ) ??
                              [],
                        );
                      }
                    },
                    text: 'Host Game', //_appScreenText['hostGame'],
                    theme: theme,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.ph),
            Visibility(
              visible: liveGames.length > 0,
              child: Container(
                margin: EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  appScreenText['liveGames'],
                  style: AppDecorators.getSubtitle2Style(theme: theme),
                ),
              ),
            ),
            liveGames.length == 0
                ? SizedBox(width: 0, height: 0)
                : ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: liveGames.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return LiveGameItem(
                        game: liveGames[index],
                        onTapFunction: () => onLiveGameTap(
                          context: context,
                          index: index,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        AppDimensionsNew.getVerticalSizedBox(8),
                  ),
          ],
        ),
      ),
    );
  }
}
