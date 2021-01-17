import 'package:flutter/material.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

import 'game_option.dart';
import 'live_game_option.dart';
import 'pending_approvals_option.dart';

class GameOptionsBottomSheet extends StatefulWidget {
  GameOptionsBottomSheet({Key key}) : super(key: key);

  @override
  _GameOptionsState createState() => _GameOptionsState();
}

class _GameOptionsState extends State<GameOptionsBottomSheet> {
  double height, width;
  int selectedOptionIndex = 0;

  List<OptionItemModel> items = [
    OptionItemModel(image: "assets/images/casino.png", title: "Game"),
    OptionItemModel(name: "Live", title: "Live Games"),
    OptionItemModel(
        image: "assets/images/casino.png", title: "Pending Approvals"),
    OptionItemModel(
        image: "assets/images/casino.png", title: "Pending Approvals")
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black,
      height: height / 2,
      child: Column(
        children: [
          Container(
            height: 105,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return optionItem(items[index], index);
              },
            ),
          ),
          Expanded(
            child: selectedOptionIndex == 0
                ? GameOption()
                : selectedOptionIndex == 1
                    ? LiveGameOption()
                    : PendingApprovalsOption(),
          )
        ],
      ),
    );
  }

  optionItem(OptionItemModel optionItem, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOptionIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.screenBackgroundColor,
                  shape: BoxShape.circle,
                  border: index == selectedOptionIndex
                      ? Border.all(color: AppColors.appAccentColor, width: 2)
                      : Border(),
                ),
                child: Center(
                  child: optionItem.image != null
                      ? Image.asset(
                          optionItem.image,
                        )
                      : optionItem.iconData != null
                          ? Icon(
                              optionItem.iconData,
                              size: 35,
                              color: AppColors.appAccentColor,
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.appAccentColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                optionItem.name,
                                style: AppStyles.optionname,
                              ),
                            ),
                )),
            Text(
              optionItem.title,
              style: AppStyles.optionTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
