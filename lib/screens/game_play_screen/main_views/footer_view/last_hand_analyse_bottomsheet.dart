import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';

class LastHandAnalyseBottomSheet extends StatefulWidget {
  final HandLogModel handLogModel;
  final String clubCode;
  LastHandAnalyseBottomSheet({this.handLogModel, this.clubCode});
  @override
  _LastHandAnalyseBottomSheetState createState() =>
      _LastHandAnalyseBottomSheetState();
}

class _LastHandAnalyseBottomSheetState
    extends State<LastHandAnalyseBottomSheet> {
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
                child: HandLogView(
                  widget.handLogModel,
                  isAppbarWithHandNumber: true,
                  clubCode: widget.clubCode,
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
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    ratio == 3 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: AppColors.appAccentColor,
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
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.appAccentColor,
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
