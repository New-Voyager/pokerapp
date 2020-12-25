import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/game/new_game_model.dart';

class BlindsSelect extends StatelessWidget {
  final TextEditingController sb = new TextEditingController();
  final TextEditingController bb = new TextEditingController();
  final TextEditingController straddle = new TextEditingController();
  final TextEditingController ante = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Blinds blinds = Provider.of<NewGameModelProvider>(context).blinds;
    sb.value = new TextEditingValue(text: blinds.smallBlind.toString());
    bb.value = new TextEditingValue(text: blinds.bigBlind.toString());
    straddle.value = new TextEditingValue(text: blinds.straddle.toString());
    ante.value = new TextEditingValue(text: blinds.ante.toString());

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: new AppBar(
        title: Text("Blinds"),
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      body: Column(
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
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.white),
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
                  controller: bb,
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.white),
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
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.white),
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
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
