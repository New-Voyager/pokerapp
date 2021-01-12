import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/rewards_screen/create_rewards_screen.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class RewardsListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _key,
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Rewards"),
        elevation: 0.0,
        centerTitle: true,
        actions: _buildActions(context),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                "PLO High Hand",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Rewards: 100",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              trailing: IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        itemCount: 3,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.white,
          );
        },
      ),
      // bottomSheet: CreateRewardsScreen(),
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextButton(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => CreateRewardsScreen(),
              //   ),
              // );
              _key.currentState
                  .showBottomSheet((context) => CreateRewardsScreen());
            },
            text: 'New',
          ),
        ),
      ];
}
