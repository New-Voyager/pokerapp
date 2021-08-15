import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
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
  double ratio = 2;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    final theme = AppTheme.getTheme(context);
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
                      ratio = 1.5;
                    } else {
                      ratio = 2;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    ratio == 2 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: theme.primaryColorWithDark(),
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
                      shape: BoxShape.circle, color: theme.accentColor),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: theme.primaryColorWithDark(),
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
