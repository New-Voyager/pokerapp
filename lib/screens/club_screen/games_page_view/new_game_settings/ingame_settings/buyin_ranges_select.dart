import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:provider/provider.dart';

class BuyInRangesSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("BuyIn Ranges"),
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      body: Consumer<NewGameModelProvider>(
        builder: (context, providerData, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Text(
                    "Choose Min",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    providerData.buyInMin.toString() + " BB",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
              Slider(
                value: providerData.buyInMin.toDouble(),
                onChanged: (value) => providerData.buyInMin = value.toInt(),
                min: 20,
                max: 500,
                divisions: 96,
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Text(
                    "Choose Max",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    providerData.buyInMax.toString() + " BB",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
              Slider(
                value: providerData.buyInMax.toDouble(),
                onChanged: (value) => providerData.buyInMax = value.toInt(),
                min: providerData.buyInMin.toDouble(),
                max: 1000,
                divisions: (1000 - providerData.buyInMin) ~/ 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
