import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class HandAnalyseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.mic,
                    size: 35,
                    color: AppColors.appAccentColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.volume_up,
                    size: 35,
                    color: AppColors.appAccentColor,
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
