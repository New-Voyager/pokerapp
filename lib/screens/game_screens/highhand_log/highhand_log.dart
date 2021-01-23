import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/models/game_history_model.dart';
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
        title: Text("High Hand Log"),
        bottom: PreferredSize(
          child: Text(
            "Game Code:" + widget.gameCode,
            style: TextStyle(color: Colors.white),
          ),
          preferredSize: Size(100.0, 10.0),
        ),
        backgroundColor: AppColors.screenBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 5.0,
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
