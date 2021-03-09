import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/rewards_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/club_screen_icons_icons.dart';
import 'package:pokerapp/screens/club_screen/rewards_screen/create_rewards_screen.dart';
import 'package:pokerapp/services/app/rewards_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class RewardsListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _key,
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ClubScreenIcons.reward,
              color: Colors.yellow,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text("Rewards"),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: _buildActions(context),
      ),
      body: Consumer<RewardsModelProvider>(
        builder: (context, data, child) => data.rewards != null
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        data.rewards[index].name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Rewards: ${data.rewards[index].amount}",
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
                itemCount: data.rewards.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white,
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
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
                  .showBottomSheet((context) => ChangeNotifierProvider.value(
                        value: Provider.of<RewardsModelProvider>(context),
                        child: CreateRewardsScreen(),
                      ));
            },
            text: 'New',
          ),
        ),
      ];
}
