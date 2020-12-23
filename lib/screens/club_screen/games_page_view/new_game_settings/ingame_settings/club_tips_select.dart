import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/game_play/new_game_settings_services/new_game_settings_services.dart';
import 'package:provider/provider.dart';

class ClubTipsSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("Club Tips"),
        backgroundColor: AppColors.screenBackgroundColor,
      ),
      body: Consumer<NewGameSettingsServices>(
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
                    "Percentage",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    providerData.percentage.toString() + " %",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
              Slider(
                value: providerData.percentage.toDouble(),
                onChanged: (value) =>
                    providerData.updatePercentage(value.toInt()),
                min: 1,
                max: 100,
                divisions: 100,
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
                    width: 20.0,
                  ),
                  Container(
                    width: 100.0,
                    child: TextField(
                      onChanged: (value) {
                        providerData.updateCap(int.parse(value));
                      },
                      decoration: InputDecoration(
                        hintText: "5",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
