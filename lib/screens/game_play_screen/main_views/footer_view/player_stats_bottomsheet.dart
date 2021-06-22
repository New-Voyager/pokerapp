import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/stack_details_view.dart';

class PlayerStatsBottomSheet extends StatefulWidget {
  final String gameCode;
  PlayerStatsBottomSheet({this.gameCode});
  @override
  _PlayerStatsBottomSheetState createState() => _PlayerStatsBottomSheetState();
}

class _PlayerStatsBottomSheetState extends State<PlayerStatsBottomSheet> {
  double height;
  double ratio = 2;
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
                child: PointsLineChart(
                  gameCode: widget.gameCode,
                  showBackButton: false,
                  liveGame: true,
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
                    color: AppColorsNew.newGreenButtonColor,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    ratio == 2 ? Icons.arrow_upward : Icons.arrow_downward,
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
