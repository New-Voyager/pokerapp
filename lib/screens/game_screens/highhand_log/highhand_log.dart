import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/high_hand_widget.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';

import '../../../routes.dart';

class HighHandLogView extends StatefulWidget {
  final String gameCode;
  HighHandLogView(this.gameCode);

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

  void _fetchData() async {
    this.hhWinners = await GameService.getHighHandLog(widget.gameCode);
    loadingDone = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          titleText: AppStringsNew.HighHandlogTitle,
          subTitleText: "Game code: ${widget.gameCode}",
          context: context,
        ),
        body: Material(
          type: MaterialType.transparency,
          child: !loadingDone
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return new HighhandWidget(this.hhWinners[index]);
                        },
                        itemCount: hhWinners.length,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
