import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:provider/provider.dart';

class ClubLiveGamesView extends StatelessWidget {
  final List<GameModelNew> liveGames;
  final AppTextScreen appScreenText;

  ClubLiveGamesView(this.liveGames, this.appScreenText);

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
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                appScreenText['liveGames'],
                style: AppDecorators.getSubtitle2Style(theme: theme),
              ),
            ),
            liveGames.length == 0
                ? Container(
                    height: 150,
                    child: Center(
                      child: Text(appScreenText['noLiveGames'],
                          style: AppStylesNew.labelTextStyle),
                    ),
                  )
                : ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: liveGames.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return LiveGameItem(
                        game: liveGames[index],
                        onTapFunction: () async {
                          await Navigator.of(context).pushNamed(
                            Routes.game_play,
                            arguments: liveGames[index].gameCode,
                          );
                          // Refreshes livegames again
                        },
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
