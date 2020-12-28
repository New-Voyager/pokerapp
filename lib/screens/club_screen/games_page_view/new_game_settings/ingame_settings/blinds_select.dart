import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/game/new_game_model.dart';

class BlindsSelect extends StatelessWidget {
  final TextEditingController sb = new TextEditingController();
  final TextEditingController bb = new TextEditingController();
  final TextEditingController straddle = new TextEditingController();
  final TextEditingController ante = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: new AppBar(
        title: Text("Blinds"),
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      body: Consumer<NewGameModelProvider>(
        builder: (context, providerData, child) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  child: Text(
                    "Small Blind",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 100.0,
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<NewGameModelProvider>(context, listen: false)
                          .smallBlind = double.parse(value);
                    },
                    controller: sb,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: providerData.blinds.smallBlind.toString(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  child: Text(
                    "Big Blind",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 100.0,
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<NewGameModelProvider>(context, listen: false)
                          .bigBlind = double.parse(value);
                    },
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    controller: bb,
                    decoration: InputDecoration(
                      hintText: providerData.blinds.bigBlind.toString(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  child: Text(
                    "Straddle",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 100.0,
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<NewGameModelProvider>(context, listen: false)
                          .straddleBet = double.parse(value);
                    },
                    controller: straddle,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: providerData.blinds.straddle.toString(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  child: Text(
                    "Ante",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 100.0,
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<NewGameModelProvider>(context, listen: false)
                          .ante = double.parse(value);
                    },
                    controller: ante,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: providerData.blinds.ante.toString(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
