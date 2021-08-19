import 'package:flutter/material.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';

class LastHandAnalyseBottomSheet extends StatefulWidget {
  final String gameCode;
  final String clubCode;
  final HandResultNew handLog;
  LastHandAnalyseBottomSheet({this.gameCode, this.clubCode, this.handLog});
  @override
  _LastHandAnalyseBottomSheetState createState() =>
      _LastHandAnalyseBottomSheetState();
}

class _LastHandAnalyseBottomSheetState
    extends State<LastHandAnalyseBottomSheet> {
  double height;
  double ratio = 2;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
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
                child: HandLogView(
                  widget.gameCode,
                  -1, // for last hand we pass -1
                  isAppbarWithHandNumber: true,
                  clubCode: widget.clubCode,
                  //handLogModel: handLog,
                  isBottomSheet: true,
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
                    shape: BoxShape.circle,
                    color: theme.accentColor,
                  ),
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
