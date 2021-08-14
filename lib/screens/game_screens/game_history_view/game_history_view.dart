import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:provider/provider.dart';

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
  AppTextScreen _appScreenText;

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
    _appScreenText = getAppTextScreen("gameHistoryView");
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

  Widget body(AppTheme theme) {
    if (_loadingData) {
      return Center(
        child: Text(
          _appScreenText['NOGAMESPLAYED'],
          style: AppDecorators.getCenterTextTextstyle(appTheme: theme),
        ),
      );
    }

    // build game history list
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: gameHistoryItem,
      itemCount: _prevGames.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppStylesNew.BgGreenRadialGradient,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            titleText: AppStringsNew.GameHistoryTitle,
            subTitleText: "${_appScreenText['CLUBCODE']}: ${widget.clubCode}",
            context: context,
          ),
          body: _prevGames == null
              ? Center(
                  child: CircularProgressWidget(),
                )
              : SafeArea(child: body(theme)),
          // child: _prevGames == null
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : Expanded(
          //         child: body(),
          //       ),
        ),
      ),
    );
  }
}
