import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';

import 'debug_view.dart';

class DebugLogBottomSheet extends StatefulWidget {
  final gameCode;

  const DebugLogBottomSheet({Key key, this.gameCode}) : super(key: key);

  @override
  _DebugLogBottomSheetState createState() => _DebugLogBottomSheetState();
}

class _DebugLogBottomSheetState extends State<DebugLogBottomSheet> {
  double height;
  double ratio = 2;

  @override
  void initState() {
    super.initState();
  }

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
                child: DebugLogView(
                  gameCode: widget.gameCode,
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