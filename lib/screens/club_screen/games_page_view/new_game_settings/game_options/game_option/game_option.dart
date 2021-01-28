import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'seat_change_bottom_sheet.dart';
import 'waiting_list.dart';

class GameOption extends StatefulWidget {
  final String gameCode;

  GameOption({Key key, this.gameCode}) : super(key: key);

  @override
  _GameOptionState createState() => _GameOptionState(gameCode);
}

class _GameOptionState extends State<GameOption> {
  final String gameCode;
  List<OptionItemModel> gameActions = null;
  _GameOptionState(this.gameCode);
  void onLeave() {
    GameService.leaveGame(this.gameCode);

    final snackBar = SnackBar(
      content: Text('You will leave after this hand'),
      duration: Duration(seconds: 15),
      backgroundColor: Colors.black38,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  List<OptionItemModel> gameSecondaryOptions;
  HeaderObject headerObject;
  @override
  void initState() {
    super.initState();
    gameActions = [
      OptionItemModel(
          title: "Leave",
          onTap: (context) {
            this.onLeave();
          }),
      OptionItemModel(title: "Break"),
      OptionItemModel(title: "Reload")
    ];
    gameSecondaryOptions = [
      OptionItemModel(
          title: "Game Stats",
          name: "Analyze your performance",
          image: "assets/images/casino.png",
          backGroundColor: AppColors.gameOption1,
          onTap: (context) {}),
      OptionItemModel(
        title: "Seat Change",
        image: "assets/images/casino.png",
        backGroundColor: AppColors.gameOption2,
        onTap: (context) async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => ChangeNotifierProvider.value(
              value: Provider.of<HeaderObject>(context, listen: false),
              child: SeatChangeBottomSheet(),
            ),
          );
        },
      ),
      OptionItemModel(
          title: "Waiting List",
          image: "assets/images/casino.png",
          backGroundColor: AppColors.gameOption3,
          onTap: (context) async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => ChangeNotifierProvider.value(
                value: Provider.of<HeaderObject>(context, listen: false),
                child: WaitingListBottomSheet(),
              ),
            );
          }),
      OptionItemModel(
        title: "Analyze Last hand",
        image: "assets/images/casino.png",
        backGroundColor: AppColors.gameOption4,
        onTap: (context) {},
      ),
      OptionItemModel(
        title: "Played Hands",
        image: "assets/images/casino.png",
        backGroundColor: AppColors.gameOption5,
        onTap: (context) {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final separator5 = SizedBox(height: 5.0);
    headerObject = Provider.of<HeaderObject>(context, listen: false);

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
                        Text("Elapsed: 3:20",
                            style: AppStyles.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Session: 00:35",
                            style: AppStyles.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Won: 10",
                            style: AppStyles.itemInfoSecondaryTextStyle),
                        separator5,
                        Text("Hands: 50",
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
                  return gameSecondaryOptionItem(
                    gameSecondaryOptions[index],
                    context,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  gameSecondaryOptionItem(
      OptionItemModel optionItemModel, BuildContext context) {
    return GestureDetector(
      onTap: () => optionItemModel.onTap(context),
      child: Container(
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
                                        style: AppStyles
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
                    color: Colors.white,
                    height: 2,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  gameActionItem(OptionItemModel optionItemModel) => GestureDetector(
      onTap: () {
        if (optionItemModel.onTap != null) {
          optionItemModel.onTap(context);
        }
      },
      child: Container(
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
      ));
}
