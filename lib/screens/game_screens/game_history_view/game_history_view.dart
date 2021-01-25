import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/game_history_detail_view.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:provider/provider.dart';

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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider<GameHistoryDetailModel>(
                    create: (_) => model,
                    builder: (BuildContext context, _) =>
                        Consumer<GameHistoryDetailModel>(
                            builder: (_, GameHistoryDetailModel data, __) =>
                                GameHistoryDetailView(data))),
              ));
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
    return _prevGames == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: AppColors.screenBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 14,
                  color: AppColors.appAccentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleSpacing: 0,
              elevation: 0.0,
              backgroundColor: AppColors.screenBackgroundColor,
              title: Text(
                "Club",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.appAccentColor,
                  fontSize: 14.0,
                  fontFamily: AppAssets.fontFamilyLato,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Container(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Game History",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: body(),
                  ),
                ],
              ),
            ),
            //body(),
          );
  }
}
