import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_screens/hand_history/hand_history.dart';

class HandHistoryAnalyseBottomSheet extends StatefulWidget {
  final HandHistoryListModel model;
  final String clubCode;
  HandHistoryAnalyseBottomSheet({this.model, this.clubCode});
  @override
  _HandHistoryAnalyseBottomSheetState createState() =>
      _HandHistoryAnalyseBottomSheetState();
}

class _HandHistoryAnalyseBottomSheetState
    extends State<HandHistoryAnalyseBottomSheet> {
  double height;
  double ratio = 3;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Container(
      height: height / ratio,
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 13,
              ),
              Expanded(
                child: HandHistoryListView(
                  widget.model,
                  widget.clubCode,
                  isInBottomSheet: true,
                  isLeadingBackIconShow: false,
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (ratio == 2) {
                      ratio = 3;
                    } else {
                      ratio = 1.5;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorsNew.newGreenButtonColor,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    ratio == 3 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: AppColorsNew.darkGreenShadeColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorsNew.newGreenButtonColor,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColorsNew.darkGreenShadeColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
