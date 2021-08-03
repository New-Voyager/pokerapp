import 'package:flutter/material.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

// TODO : Can be deleted. Not used anywhere
class GameOptionOld extends StatelessWidget {
  GameOptionOld({Key key}) : super(key: key);

  final List<OptionItemModel> gameActions = [
    OptionItemModel(title: "LEAVE"),
    OptionItemModel(title: "BREAK"),
    OptionItemModel(title: "RELOAD CHIPS")
  ];

  final List<OptionItemModel> gameSecondaryOptions = [
    OptionItemModel(
      title: "Seat Change",
      image: "assets/images/casino.png",
      backGroundColor: AppColorsNew.gameOption2,
    ),
    OptionItemModel(
      title: "Waiting List",
      image: "assets/images/casino.png",
      backGroundColor: AppColorsNew.gameOption3,
    ),
    OptionItemModel(
      title: "Analyze Last hand",
      image: "assets/images/casino.png",
      backGroundColor: AppColorsNew.gameOption4,
    ),
    OptionItemModel(
      title: "Played Hands",
      image: "assets/images/casino.png",
      backGroundColor: AppColorsNew.gameOption5,
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
                color: AppColorsNew.gameOptionBackGroundColor,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Runtime: 3:20",
                            style: AppStylesNew.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Session Time: 00:35",
                            style: AppStylesNew.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Number of winning hands: 10",
                            style: AppStylesNew.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Total hands played: 50",
                            style: AppStylesNew.itemInfoSecondaryTextStyle)
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
                  color: AppColorsNew.gameOptionBackGroundColor,
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
                            style: AppStylesNew.credentialsTextStyle,
                          ),
                          optionItemModel.name != null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      optionItemModel.name,
                                      style: AppStylesNew
                                          .itemInfoSecondaryTextStyle,
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
                  color: Colors.white, //AppColorsNew.chatOthersColor,
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
            border: Border.all(color: AppColorsNew.appAccentColor, width: 2)),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              optionItemModel.title,
              style: AppStylesNew.clubItemInfoTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
