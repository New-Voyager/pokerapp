import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/high_hand_widget.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';

class HighHandLogView extends StatefulWidget {
  final String gameCode;
  HighHandLogView(this.gameCode);

  @override
  State<StatefulWidget> createState() {
    return _HighHandLogViewState();
  }
}

class _HighHandLogViewState extends State<HighHandLogView> {
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
    return Scaffold(
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
          "Game Details",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.appAccentColor,
            fontSize: 14.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "High Hand Log",
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 5, right: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Game Code: " + widget.gameCode,
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      color: AppColors.lightGrayTextColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return new HighHandWidget(this.hhWinners[index]);
                    },
                    itemCount: hhWinners.length,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
