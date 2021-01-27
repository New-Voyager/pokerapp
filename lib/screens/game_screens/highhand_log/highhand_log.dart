import 'package:flutter/cupertino.dart';
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
                "Game",
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
              "High Hand Log",
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Game code: " + widget.gameCode,
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
        child: !loadingDone
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
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
      ),
    );
  }
}
