import 'package:flutter/material.dart';
import 'package:pokerapp/models/rewards_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/club_screen_icons_icons.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class CreateRewardsScreen extends StatelessWidget {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AppTextScreen _appScreenText = getAppTextScreen("rewards");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsNew.screenBackgroundColor,
      child: Column(
        children: [
          AppBar(
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
                Text(_appScreenText['newReward']),
              ],
            ),
            elevation: 0.0,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextButton(
                text: _appScreenText['cancel'],
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            leadingWidth: 90.0,
            actions: _buildActions(context),
          ),
          SizedBox(
            height: 30.0,
          ),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: TextFormField(
                    onChanged: (value) {},
                    validator: (text) {
                      if (text == null) {
                        return _appScreenText['enterSomething'];
                      } else if (text.isEmpty) {
                        return _appScreenText['nameCanntEmpty'];
                      }
                      return null;
                    },
                    controller: _name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: _appScreenText['enterName'],
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: TextFormField(
                    onChanged: (value) {},
                    validator: (text) {
                      if (text.isEmpty) {
                        return _appScreenText['enterAmount'];
                      } else if (int.parse(text) < 0) {
                        return _appScreenText['amountEmptyError'];
                      }
                      return null;
                    },
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: _appScreenText['rewardAmount'],
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                // TextFormField(
                //   onChanged: (value) {},
                //   keyboardType: TextInputType.name,
                //   decoration: InputDecoration(
                //     hintText: "Type",
                //     hintStyle: TextStyle(color: Colors.grey),
                //   ),
                //   style: TextStyle(color: Colors.white),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _appScreenText['type'],
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                      _appScreenText['highHand'],
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _appScreenText['track'],
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        _appScreenText['entireGame'],
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                    ],
                  ),
                ),
                // TextFormField(
                //   onChanged: (value) {},
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     hintText: "Schedule",
                //     hintStyle: TextStyle(color: Colors.grey),
                //   ),
                //   style: TextStyle(color: Colors.white),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextButton(
            onTap: () {
              Provider.of<RewardsModelProvider>(context, listen: false)
                  .createRewards(_name.text, "ENTIRE_GAME",
                      int.parse(_amount.text), "HIGH_HAND");
              Navigator.pop(context);
            },
            text: _appScreenText['save'],
          ),
        ),
      ];
}
