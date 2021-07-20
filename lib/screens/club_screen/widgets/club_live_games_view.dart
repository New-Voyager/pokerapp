import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/widgets/club_game_item_new.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/services/app/game_service.dart';

class ClubLiveGamesView extends StatefulWidget {
  final ClubHomePageModel clubModel;
  ClubLiveGamesView(this.clubModel);

  @override
  _ClubLiveGamesViewState createState() => _ClubLiveGamesViewState();
}

class _ClubLiveGamesViewState extends State<ClubLiveGamesView> {
  List<GameModelNew> liveGames = [];
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchLiveGames();
    });
    super.initState();
  }

  _fetchLiveGames() async {
    liveGames.clear();
    final List<GameModelNew> list = await GameService.getLiveGamesNew();
    for (GameModelNew game in list) {
      if (game.clubCode == widget.clubModel.clubCode) {
        liveGames.add(game);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 16.0,
        left: 8,
        right: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Live Games",
            style: AppStylesNew.cardHeaderTextStyle,
          ),
          loading
              ? Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressWidget(
                      text: AppStringsNew.fetchLiveGamesText,
                    ),
                  ),
                )
              : liveGames.length == 0
                  ? Container(
                      height: 150,
                      child: Center(
                        child: Text(AppStringsNew.noLiveGamesText,
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
                        );
                      },
                      separatorBuilder: (context, index) =>
                          AppDimensionsNew.getVerticalSizedBox(8),
                    ),
        ],
      ),
    );
  }
}
