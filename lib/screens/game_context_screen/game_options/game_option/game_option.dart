import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';
import 'package:pokerapp/screens/game_screens/hand_history/hand_history.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'seat_change_bottom_sheet.dart';
import 'waiting_list.dart';

class GameOption extends StatefulWidget {
  final String gameCode;
  final String playerUuid;
  final bool isAdmin;
  GameOption(this.gameCode, this.playerUuid, this.isAdmin);

  @override
  _GameOptionState createState() => _GameOptionState(gameCode);
}

class _GameOptionState extends State<GameOption> {
  final String gameCode;
  List<OptionItemModel> gameActions;
  double height;

  _GameOptionState(this.gameCode);

  void onLeave() {
    GameService.leaveGame(this.gameCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You will leave after this hand'),
        duration: Duration(seconds: 15),
        backgroundColor: Colors.black38,
      ),
    );
  }

  void onEndGame() { 
    showSimpleNotification(
      Text('The game will end after this hand'),
      position: NotificationPosition.top,
      duration: Duration(seconds: 10),
    );
    // We need to broadcast to all the players
    GameService.endGame(this.gameCode);

   

   /*  ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
      SnackBar(
        content: const Text('The game will end after this hand'),
        duration: Duration(seconds: 15),
        backgroundColor: Colors.black38,
      ),
    ); */
  }

  void onPause() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Game will be paused after this hand'),
        duration: Duration(seconds: 15),
        backgroundColor: Colors.black38,
      ),
    );

    GameService.pauseGame(this.gameCode);
  }

  void onResume() {
    // final snackBar = SnackBar(
    //   content: Text('Resume game is not implemented'),
    //   duration: Duration(seconds: 30),
    //   backgroundColor: Colors.black38,
    // );
    // Scaffold.of(context).showSnackBar(snackBar);

    //GameService.resumeGame(this.gameCode);
  }

  List<OptionItemModel> gameSecondaryOptions;
  @override
  void initState() {
    super.initState();
    gameActions = [
      OptionItemModel(
          title: "Leave",
          iconData: Icons.exit_to_app_sharp,
          onTap: (context) {
            this.onLeave();
          }),
      OptionItemModel(title: "Break"),
      OptionItemModel(title: "Reload"),
    ];

    if (widget.isAdmin) {
      gameActions.add(OptionItemModel(
          title: "Pause",
          iconData: Icons.pause,
          onTap: (context) {
            this.onPause();
          }));
      // OptionItemModel(
      //     title: "Resume",
      //     iconData: Icons.play_circle_outline,
      //     onTap: (context) {
      //       this.onResume();
      //     }),
      gameActions.add(OptionItemModel(
          title: "Terminate",
          iconData: Icons.cancel_outlined,
          onTap: (context) {
            this.onEndGame();
          }));
    }
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
            builder: (ctx) {
              return SeatChangeBottomSheet(widget.gameCode, widget.playerUuid);
            },
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
                builder: (ctx) {
                  return WaitingListBottomSheet(
                      widget.gameCode, widget.playerUuid);
                });
          }),
      OptionItemModel(
        title: "Last Hand",
        image: "assets/images/casino.png",
        backGroundColor: AppColors.gameOption4,
        onTap: (context) async {
          HandLogModel handLogModel = HandLogModel(widget.gameCode, -1);
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => Container(
              height: height / 2,
              child: HandLogView(handLogModel),
            ),
          );
        },
      ),
      OptionItemModel(
        title: "Hand History",
        image: "assets/images/casino.png",
        backGroundColor: AppColors.gameOption5,
        onTap: (context) async {
          // todo: true need to change with isOwner actual value
          final model = HandHistoryListModel(widget.gameCode, true);
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return Container(
                    height: height / 2,
                    child: HandHistoryListView(
                      model,
                      // todo: club code need to get
                      null,
                      isInBottomSheet: true,
                    ));
              });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    final separator5 = SizedBox(height: 5.0);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gameOptionBackGroundColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Elapsed: 3:20",
                          style: AppStyles.itemInfoSecondaryTextStyle),
                      Text("Hands: 50",
                          style: AppStyles.itemInfoSecondaryTextStyle)
                    ],
                  ),
                  separator5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Session: 00:35",
                          style: AppStyles.itemInfoSecondaryTextStyle),
                      Text("Won: 10",
                          style: AppStyles.itemInfoSecondaryTextStyle),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...gameActions.map((e) => gameActionItem(e)).toList(),
                    ],
                  )
                ],
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gameSecondaryOptions.length,
                itemBuilder: (context, index) {
                  return gameSecondaryOptionItem(
                    gameSecondaryOptions[index],
                    context,
                  );
                },
                separatorBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /*  gameSecondaryOptionItem(
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
 */
  gameSecondaryOptionItem(
      OptionItemModel optionItemModel, BuildContext context) {
    return ListTile(
      onTap: () => optionItemModel.onTap(context),
      title: Text(
        optionItemModel.title,
        style: AppStyles.credentialsTextStyle,
      ),
      leading: Container(
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
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      subtitle: optionItemModel.name != null
          ? Text(
              optionItemModel.name,
              style: AppStyles.itemInfoSecondaryTextStyle,
            )
          : Container(),
    );
  }

  gameActionItem(OptionItemModel optionItemModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          if (optionItemModel.onTap != null) {
            optionItemModel.onTap(context);
          }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                optionItemModel.iconData ?? Icons.message,
                size: 20,
                color: AppColors.appAccentColor,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                optionItemModel.title,
                style: TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: AppColors.appAccentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
