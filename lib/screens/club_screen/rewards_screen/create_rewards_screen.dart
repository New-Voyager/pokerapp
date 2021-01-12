import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/rewards_screen/rewards_list_screen.dart';
import 'package:pokerapp/services/app/rewards_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class CreateRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("New Reward"),
        elevation: 0.0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextButton(
            text: "Cancel",
            onTap: () async {
              print("started");
              var r = await RewardService.getRewards("CG-N9KTXN");
              print(r);
              print("ended");
            },
          ),
        ),
        leadingWidth: 90.0,
        actions: _buildActions(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              TextField(
                onChanged: (value) {},
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Enter Name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Reward Amount",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                onChanged: (value) {},
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Type",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Schedule",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextButton(
            onTap: () => RewardService.createReward(),
            text: 'Add',
          ),
        ),
      ];
}
