import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
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
  bool _showLoading = false;

  List<GameHistoryModel> _prevGames;

  _toggleLoading() =>
      setState(() {
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

  Widget body() {
    if (_prevGames.length == 0) {
      return Center(
        child: const Text(
          'No Members',
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
      itemBuilder: (_, int index) => GameHistoryItem(
        item: _prevGames[index]
      ),
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
