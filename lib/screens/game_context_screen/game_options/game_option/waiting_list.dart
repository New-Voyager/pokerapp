import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/waiting_list_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:provider/provider.dart';

class WaitingListBottomSheet extends StatefulWidget {
  final String gameCode;
  final String playerUuid;
  WaitingListBottomSheet(this.gameCode, this.playerUuid);
  @override
  _WaitingListBottomSheetState createState() => _WaitingListBottomSheetState();
}

class _WaitingListBottomSheetState extends State<WaitingListBottomSheet> {
  double height, width;
  bool isInWaitingList = false;
  List<WaitingListModel> allWaitingListPlayers = [];
  bool ischanged = false;
  bool isSwitchShow = true;
  @override
  void initState() {
    super.initState();

    getAllCurretlyPlayingPlayer();
    getAllWaitingPlayers();
  }

  getAllCurretlyPlayingPlayer() async {
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(widget.gameCode);
    if (_gameInfoModel == null) {
      return false;
    }
    _gameInfoModel.playersInSeats.forEach((element) {
      if (element.playerUuid == widget.playerUuid) {
        setState(() {
          isSwitchShow = false;
        });
      }
    });
  }

  getAllWaitingPlayers() async {
    final result = await GameService.listOfWaitingPlayer(widget.gameCode);
    print("gameCode ${widget.gameCode}");
    print("gameCode ${widget.playerUuid}");

    if (result != null) {
      setState(() {
        allWaitingListPlayers = result;
        allWaitingListPlayers.forEach((player) {
          if (player.playerUuid == widget.playerUuid) {
            isInWaitingList = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black,
      height: height / 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [header, addRemoveWaitingListButton(), playersInList()],
      ),
    );
  }

  playersInList() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Players in the List",
            style: AppStyles.clubCodeStyle,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.gameOptionBackGroundColor,
                  ),
                  child: ListView.builder(
                    itemCount: allWaitingListPlayers.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) =>
                        playerItem(allWaitingListPlayers[index], index),
                  ))),
        ],
      ),
    ));
  }

  playerItem(WaitingListModel seatChangeModel, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  seatChangeModel.name,
                  style: AppStyles.clubCodeStyle,
                ),
              ),
              Spacer(),
              index != 0
                  ? GestureDetector(
                      onTap: () {
                        ischanged = true;
                        setState(() {
                          WaitingListModel temp;
                          temp = allWaitingListPlayers[index];
                          allWaitingListPlayers[index] =
                              allWaitingListPlayers[index - 1];
                          allWaitingListPlayers[index - 1] = temp;
                        });
                      },
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
              index != 0
                  ? SizedBox(
                      width: 5,
                    )
                  : Container(),
              index != allWaitingListPlayers.length - 1
                  ? GestureDetector(
                      onTap: () {
                        ischanged = true;
                        setState(() {
                          WaitingListModel temp;
                          temp = allWaitingListPlayers[index];
                          allWaitingListPlayers[index] =
                              allWaitingListPlayers[index + 1];
                          allWaitingListPlayers[index + 1] = temp;
                        });
                      },
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    )
                  : SizedBox(
                      width: 25,
                    )
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(.5),
          )
        ],
      ),
    );
  }

  addRemoveWaitingListButton() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.gameOptionBackGroundColor,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gameOption2,
            ),
            padding: EdgeInsets.all(5),
            child: Image.asset(
              "assets/images/casino.png",
              height: 30,
              width: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Add me to waiting list",
            style: AppStyles.clubCodeStyle,
          ),
          Spacer(),
          isSwitchShow
              ? Switch(
                  value: isInWaitingList,
                  activeTrackColor: AppColors.positiveColor,
                  activeColor: Colors.white,
                  onChanged: (bool value) async {
                    setState(() {
                      isInWaitingList = value;
                    });
                    if (isInWaitingList) {
                      bool result =
                          await GameService.addToWaitList(widget.gameCode);
                      print("result dasda $result");
                    } else {
                      bool result =
                          await GameService.removeFromWaitlist(widget.gameCode);
                      print("result check $result");
                    }
                    getAllWaitingPlayers();
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  get header => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.appAccentColor,
                      size: 20,
                    ),
                    Text(
                      "Game",
                      style: AppStyles.optionTitle,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Waiting List",
                style: AppStyles.optionTitleText,
              ),
            ),
            ischanged
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              List<String> uuids = [];
                              allWaitingListPlayers.forEach((element) {
                                uuids.add(element.playerUuid);
                              });
                              setState(() {
                                ischanged = false;
                              });
                              GameService.changeWaitListOrderList(
                                  widget.gameCode, uuids);
                            },
                            child: Text(
                              "Apply",
                              style: AppStyles.subTitleTextStyle,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ischanged = false;
                              });
                              getAllWaitingPlayers();
                            },
                            child: Text(
                              "Cancel",
                              style: AppStyles.subTitleTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      );
}
