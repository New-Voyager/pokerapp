import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';

class GameHistoryView extends StatefulWidget {
  final String clubCode;
  GameHistoryView(this.clubCode);

  @override
  _GameHistoryViewState createState() => _GameHistoryViewState(clubCode);
}

class _GameHistoryViewState extends State<GameHistoryView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.game_history;

  final String clubCode;
  _GameHistoryViewState(this.clubCode);

  bool _loadingData = true;

  List<GameHistoryModel> _prevGames;

  _fetchData() async {
    _prevGames = await ClubInteriorService.getGameHistory(clubCode);
    _loadingData = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // method call
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
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
        child: GameHistoryItemNew(game: _prevGames[index]));
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

    // build game history list
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      shrinkWrap: true,
      itemBuilder: gameHistoryItem,
      itemCount: _prevGames.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          titleText: AppStringsNew.GameHistoryTitle,
          subTitleText: "Club code: ${widget.clubCode}",
          context: context,
        ),
        body: _prevGames == null
            ? Center(
                child: CircularProgressWidget(),
              )
            : SafeArea(child: body()),
        // child: _prevGames == null
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : Expanded(
        //         child: body(),
        //       ),
      ),
    );
  }
}
