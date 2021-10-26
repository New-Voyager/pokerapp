import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/grouped_list_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class HighHandLogView extends StatefulWidget {
  final String gameCode;
  final String clubCode;
  final bool bottomsheet;
  HighHandLogView(
    this.gameCode, {
    this.clubCode,
    this.bottomsheet = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _HighHandLogViewState();
  }
}

class _HighHandLogViewState extends State<HighHandLogView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.high_hand_log;

  List<HighHandWinner> hhWinners;
  final SizedBox seprator = SizedBox(
    height: 20.0,
  );
  bool loadingDone = false;
  _HighHandLogViewState();
  AppTextScreen _appScreenText;
  void _fetchData() async {
    this.hhWinners = await GameService.getHighHandLog(widget.gameCode);
    loadingDone = true;
    setState(() {});
  }

  @override
  void initState() {
    _appScreenText = getAppTextScreen("highHandLogView");

    super.initState();
    _fetchData();
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
            titleText: _appScreenText['highHandLog'],
            subTitleText: "${_appScreenText['gameCode']}: ${widget.gameCode}",
            context: context,
            showBackButton: !(widget.bottomsheet ?? false),
          ),
          body: Material(
            type: MaterialType.transparency,
            child: !loadingDone
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: (hhWinners?.length ?? 0) == 0
                            ? Center(
                                child: Text("No Data available"),
                              )
                            : GroupedHandLogListView(
                                winners: this.hhWinners,
                                clubCode: widget.clubCode,
                              ),

                        // : ListView.separated(
                        //     physics: BouncingScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       this.hhWinners[index].gameCode =
                        //           widget.gameCode;
                        //       return HighhandWidget(
                        //         this.hhWinners[index],
                        //         clubCode: widget.clubCode,
                        //       );
                        //     },
                        //     itemCount: hhWinners?.length ?? 0,
                        //     separatorBuilder: (context, index) {
                        //       return Divider();
                        //     },
                        //   ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
