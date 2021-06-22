import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/waiting_list_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:provider/provider.dart';

class WaitingListBottomSheet extends StatefulWidget {
  final String gameCode;
  final String playerUuid;
  final GameState gameState;

  WaitingListBottomSheet(this.gameState, this.gameCode, this.playerUuid);

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
    log('waiting list: build');

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      height: height / 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          context: context,
          titleText: AppStringsNew.waitingListTitle,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            addRemoveWaitingListButton(),
            this.header,
            playersInList()
          ],
        ),
      ),
    );
  }

  playersInList() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStringsNew.playersInWaitingListText,
            style: AppStylesNew.labelTextStyle,
          ),
          AppDimensionsNew.getVerticalSizedBox(10),
          Expanded(
            child: Container(
              decoration: AppStylesNew.actionRowDecoration,
              child: allWaitingListPlayers.length > 0
                  ? ListView.builder(
                      itemCount: allWaitingListPlayers.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) =>
                          playerItem(allWaitingListPlayers[index], index),
                    )
                  : Center(
                      child: Text(AppStringsNew.noWaitingListText),
                    ),
            ),
          ),
        ],
      ),
    ));
  }

  playerItem(WaitingListModel seatChangeModel, int index) {
    bool isAdmin = widget.gameState.currentPlayer.isAdmin();

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
                      child: isAdmin
                          ? Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            )
                          : Container(),
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
                      child: isAdmin
                          ? Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            )
                          : Container(),
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
    if (widget.gameState.getSeatByPlayer(widget.gameState.currentPlayerId) ==
        null) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: AppStylesNew.actionRowDecoration,
          child: SwitchWidget(
            label: AppStringsNew.addMeToWaitingListText,
            value: isInWaitingList,
            onChange: (bool value) async {
              setState(() {
                isInWaitingList = value;
              });
              if (isInWaitingList) {
                bool result = await GameService.addToWaitList(widget.gameCode);
                print("result = $result");
              } else {
                bool result =
                    await GameService.removeFromWaitlist(widget.gameCode);
                print("result check $result");
              }
              getAllWaitingPlayers();
            },
          ));
    } else {
      return SizedBox();
    }
  }

  get header {
    log('waiting list: header');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        children: [
          ischanged
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoundRectButton(
                          text: 'Apply',
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
                        ),

                        // Text(
                        //   "Apply",
                        //   style: AppStyles.subTitleTextStyle,
                        // ),
                        //),
                        SizedBox(
                          width: 15,
                        ),

                        RoundRectButton(
                          text: 'Cancel',
                          onTap: () {
                            setState(() {
                              ischanged = false;
                            });
                            getAllWaitingPlayers();
                          },
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
}
