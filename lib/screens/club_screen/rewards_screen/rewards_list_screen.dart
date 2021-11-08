import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/rewards_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:provider/provider.dart';

class RewardsListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppTextScreen _appScreenText = getAppTextScreen("rewards");

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, theme, __) => Scaffold(
        //      resizeToAvoidBottomPadding: true,
        key: _key,
        backgroundColor: AppColorsNew.screenBackgroundColor,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: _appScreenText['rewards'],
        ),
        /* AppBar(
          backgroundColor: AppColorsNew.screenBackgroundColor,
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
        ), */
        body: Consumer<RewardsModelProvider>(
          builder: (context, data, child) => data.rewards != null
              ? ListView.separated(
                  physics: BouncingScrollPhysics(),
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
      ),
    );
  }
}
