import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class GameEndedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("111GAME ENDED CALLED !!");
    return Container(
      height: 150,
      child: Text(
        "Game Ended!",
        style: TextStyle(color: Colors.white),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.cardBackgroundColor,
        border: Border.all(
          color: AppColors.plateBorderColor,
          width: 2,
        ),
      ),
    );
  }
}
