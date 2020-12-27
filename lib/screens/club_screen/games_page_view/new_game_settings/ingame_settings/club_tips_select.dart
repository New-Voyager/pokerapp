import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_colors.dart';
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
                    "Percentage",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    providerData.rakePercentage.toString() + " %",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
                ],
              ),
              Slider(
                value: providerData.rakePercentage.toDouble(),
                onChanged: (value) =>
                    providerData.rakePercentage = value.toDouble(),
                min: 0,
                max: 40,
                divisions: 40,
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
                        providerData.rakeCap = int.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: providerData.rakeCap.toString(),
                        hintStyle: TextStyle(color: Colors.grey),
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
