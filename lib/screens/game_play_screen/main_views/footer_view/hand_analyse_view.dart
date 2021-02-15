import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';
import 'hand_history_bottomsheet.dart';
import 'last_hand_analyse_bottomsheet.dart';

class HandAnalyseView extends StatefulWidget {
  final String gameCode;
  final String clubCode;
  HandAnalyseView(this.gameCode, this.clubCode);

  @override
  _HandAnalyseViewState createState() => _HandAnalyseViewState();
}

class _HandAnalyseViewState extends State<HandAnalyseView> {
  double height;
  double bottomSheetHeight;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    bottomSheetHeight = height / 3;
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    HandLogModel handLogModel =
                        HandLogModel(widget.gameCode, -1);
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => LastHandAnalyseBottomSheet(
                        handLogModel: handLogModel,
                        clubCode: widget.clubCode,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.asset(AppAssets.cardsImage,
                        height: 35, color: AppColors.appAccentColor),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // todo: true need to change with isOwner actual value
                    final model = HandHistoryListModel(widget.gameCode, true);
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) {
                        return HandHistoryAnalyseBottomSheet(
                          model: model,
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.asset(AppAssets.cardsImage,
                        height: 35, color: AppColors.appAccentColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
