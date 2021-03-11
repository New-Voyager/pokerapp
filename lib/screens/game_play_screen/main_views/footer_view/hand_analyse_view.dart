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


  Future<void> onClickViewHand() async {
    HandLogModel handLogModel = HandLogModel(widget.gameCode, -1);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LastHandAnalyseBottomSheet(
        handLogModel: handLogModel,
        clubCode: widget.clubCode,
      ),
    );

  }


  Future<void> onClickViewHandAnalysis() async {

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
  }


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
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: Colors.black,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HandAnalysisCardView(onClickHandler: onClickViewHand,),
                HandAnalysisCardView(onClickHandler: onClickViewHandAnalysis,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HandAnalysisCardView extends StatelessWidget {

  final VoidCallback onClickHandler;

  const HandAnalysisCardView({Key key,
    @required this.onClickHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClickHandler,
      child: Container(padding: EdgeInsets.all(5),
        child: Image.asset(AppAssets.cardsImage, height: 35, color: AppColors.appAccentColor),),
    );
  }
}

