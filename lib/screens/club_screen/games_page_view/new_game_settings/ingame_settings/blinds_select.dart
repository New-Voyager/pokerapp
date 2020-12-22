import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/game_play/new_game_settings_services/new_game_settings_services.dart';
import 'package:provider/provider.dart';

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
                    Provider.of<NewGameSettingsServices>(context, listen: false)
                        .updateSmallBlind(int.parse(value));
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
                    Provider.of<NewGameSettingsServices>(context, listen: false)
                        .updateBigBlind(int.parse(value));
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
                    Provider.of<NewGameSettingsServices>(context, listen: false)
                        .updateStraddle(int.parse(value));
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
                    Provider.of<NewGameSettingsServices>(context, listen: false)
                        .updateAnte(int.parse(value));
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
