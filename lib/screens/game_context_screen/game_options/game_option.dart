import 'package:flutter/material.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

class GameOption extends StatelessWidget {
  GameOption({Key key}) : super(key: key);

  final List<OptionItemModel> gameActions = [
    OptionItemModel(title: "LEAVE"),
    OptionItemModel(title: "BREAK"),
    OptionItemModel(title: "RELOAD CHIPS")
  ];

  final List<OptionItemModel> gameSecondaryOptions = [
    OptionItemModel(
        title: "Game Stats",
        name: "Analyze your performance",
        image: "assets/images/casino.png",
        backGroundColor: AppColors.gameOption1),
    OptionItemModel(
      title: "Seat Change",
      image: "assets/images/casino.png",
      backGroundColor: AppColors.gameOption2,
    ),
    OptionItemModel(
      title: "Waiting List",
      image: "assets/images/casino.png",
      backGroundColor: AppColors.gameOption3,
    ),
    OptionItemModel(
      title: "Analyze Last hand",
      image: "assets/images/casino.png",
      backGroundColor: AppColors.gameOption4,
    ),
    OptionItemModel(
      title: "Played Hands",
      image: "assets/images/casino.png",
      backGroundColor: AppColors.gameOption5,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final separator5 = SizedBox(height: 5.0);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gameOptionBackGroundColor,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Runtime: 3:20",
                            style: AppStyles.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Session Time: 00:35",
                            style: AppStyles.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Number of winning hands: 10",
                            style: AppStyles.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Total hands played: 50",
                            style: AppStyles.itemInfoSecondaryTextStyle)
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ...gameActions.map((e) => gameActionItem(e)).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.gameOptionBackGroundColor,
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gameSecondaryOptions.length,
                itemBuilder: (context, index) {
                  return gameSecondaryOptionItem(gameSecondaryOptions[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  gameSecondaryOptionItem(OptionItemModel optionItemModel) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: optionItemModel.backGroundColor,
                ),
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  optionItemModel.image,
                  height: 40,
                  width: 40,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            optionItemModel.title,
                            style: AppStyles.credentialsTextStyle,
                          ),
                          optionItemModel.name != null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      optionItemModel.name,
                                      style:
                                          AppStyles.itemInfoSecondaryTextStyle,
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
          Spacer(),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Divider(
                  color: Colors.white, //AppColors.chatOthersColor,
                  height: 2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  gameActionItem(OptionItemModel optionItemModel) => Container(
        height: 70,
        width: 70,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.appAccentColor, width: 2)),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              optionItemModel.title,
              style: AppStyles.clubItemInfoTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}

/*
 Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Runtime: 3:20",
                          style: AppStyles.itemInfoSecondaryTextStyle),
                      separator5,
                      Text("Session Time: 00:35",
                          style: AppStyles.itemInfoSecondaryTextStyle),
                      separator5,
                      Text("Number of winning hands: 10",
                          style: AppStyles.itemInfoSecondaryTextStyle),
                      separator5,
                      Text("Total hands played: 50",
                          style: AppStyles.itemInfoSecondaryTextStyle)
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: gameActions.length,
                        itemBuilder: (context, index) => gameActionItem(
                          gameActions[index],
                        ),
                      ),
                    ),
                  )
*/
