import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';

import 'game_history_widget.dart';

class GameHistoryView extends StatefulWidget {
  final String clubCode;
  GameHistoryView(this.clubCode);

  @override
  _GameHistoryViewState createState() => _GameHistoryViewState(clubCode);
}

class _GameHistoryViewState extends State<GameHistoryView> {
  final String clubCode;
  _GameHistoryViewState(this.clubCode);

  bool _isOwner = false;
  bool _loadingData = true;

  List<GameHistoryModel> _prevGames;

  _fetchData() async {
    _prevGames = await ClubInteriorService.getGameHistory(clubCode);
    _loadingData = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget gameHistoryItem(BuildContext context, int index) {
    final item = this._prevGames[index];
    return GestureDetector(
        onTap: () {
          GameHistoryDetailModel model =
              GameHistoryDetailModel(item.gameCode, true);
          Navigator.pushNamed(
            context,
            Routes.game_history_detail_view,
            arguments: {'model': model, 'clubCode': clubCode},
          );
        },
        child: GameHistoryItem(item: _prevGames[index]));
  }

  Widget body() {
    if (_loadingData) {
      return Center(
        child: const Text(
          'No games played',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      );
    }

    // TODO: we need to make this dynamic list
    // build game history list
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      itemBuilder: gameHistoryItem,
      itemCount: _prevGames.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.screenBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.screenBackgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppColors.appAccentColor,
              ),
              Text(
                "Club",
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: AppColors.appAccentColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        middle: Column(
          children: [
            Text(
              "Game History",
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Club code: " + widget.clubCode,
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: AppColors.lightGrayTextColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: _prevGames == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: body(),
              ),
      ),
      // child: _prevGames == null
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Expanded(
      //         child: body(),
      //       ),
    );
  }
}
