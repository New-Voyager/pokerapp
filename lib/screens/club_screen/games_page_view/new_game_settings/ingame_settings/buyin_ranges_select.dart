import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/game_play/new_game_settings_services/new_game_settings_services.dart';
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
                    "Choose Min",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    providerData.minChips.toString() + " BB",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
              Slider(
                value: providerData.minChips.toDouble(),
                onChanged: (value) =>
                    providerData.updateMinChips(value.toInt()),
                min: 20,
                max: 500,
                divisions: 500,
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
                    providerData.maxChips.toString() + " BB",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
              Slider(
                value: providerData.maxChips.toDouble(),
                onChanged: (value) =>
                    providerData.updateMaxChips(value.toInt()),
                min: providerData.minChips.toDouble(),
                max: 1000,
                divisions: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
