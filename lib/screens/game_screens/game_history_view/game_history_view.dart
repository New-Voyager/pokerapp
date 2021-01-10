import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
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
  bool _showLoading = false;

  List<GameHistoryModel> _prevGames;

  _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  _fetchData() async {
    _toggleLoading();
    _prevGames = await ClubInteriorService.getGameHistory(clubCode);
    _toggleLoading();
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
    if (_prevGames == null && _prevGames.length == 0) {
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
              title: Text("Game History"),
              backgroundColor: AppColors.screenBackgroundColor,
              elevation: 0.0,
              centerTitle: true,
            ),
            body: body(),
          );
  }
}
