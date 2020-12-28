import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/high_hand/high_hand_widget.dart';

class HighHand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("High Hand Log"),
        bottom: PreferredSize(
          child: Text(
            "Game Code:" + "ABCDE",
            style: TextStyle(color: Colors.white),
          ),
          preferredSize: Size(100.0, 10.0),
        ),
        backgroundColor: AppColors.screenBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          HighHandWidget(),
          HighHandWidget(),
          HighHandWidget(),
          HighHandWidget(),
          HighHandWidget(),
          HighHandWidget(),
          HighHandWidget(),
        ],
      ),
    );
  }
}
