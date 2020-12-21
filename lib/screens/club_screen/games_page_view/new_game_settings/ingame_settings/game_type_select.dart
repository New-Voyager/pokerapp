import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/select_from_list_IOS_look.dart';

class GameTypeSelect extends StatelessWidget {
  final List<String> gameTypes = [
    "No Limit Heldom",
    "PLO",
    "PLO(Hi-Lo)",
    "5 Card PLO",
    "5 Card PLO(Hi-Lo)",
    "ROE(NLH, PLO)",
    "ROE(NLH, PLO, PLO Hi-Lo)",
    "ROE(PLO, PLO Hi-Lo)",
    "ROE(5 Card PLO, 5 Card PLO Hi-Lo)"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: new AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Game Type"),
        elevation: 0.0,
      ),
      body: IOSLikeCheckList(
        list: gameTypes,
        selectedIndex: 0,
      ),
    );
  }
}
