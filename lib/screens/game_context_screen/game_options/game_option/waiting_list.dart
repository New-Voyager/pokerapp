import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/waiting_list_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/game_play/graphql/waitlist_service.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
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
  AppTextScreen _appScreenText;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    loading = true;
    await getAllCurrentlyPlayingPlayer();
    await getAllWaitingPlayers();
    loading = false;
    setState(() {});
  }

  getAllCurrentlyPlayingPlayer() async {
    GameInfoModel _gameInfoModel = widget.gameState.gameInfo;
    if (_gameInfoModel == null) {
      return false;
    }
    _gameInfoModel.playersInSeats.forEach((element) {
      if (element.playerUuid == widget.playerUuid) {
        isSwitchShow = false;
      }
    });
  }

  getAllWaitingPlayers() async {
    final result = await WaitlistService.listOfWaitingPlayer(widget.gameCode);
    print("gameCode ${widget.gameCode}");
    print("gameCode ${widget.playerUuid}");

    if (result != null) {
      allWaitingListPlayers = result;
      allWaitingListPlayers.forEach((player) {
        if (player.playerUuid == widget.playerUuid) {
          isInWaitingList = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log('waiting list: build');
    _appScreenText = getAppTextScreen("waitingListBottomSheet");

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<AppTheme>(
        builder: (_, theme, __) => Container(
              decoration: AppDecorators.bgRadialGradient(theme),
              height: height / 2,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                // appBar: CustomAppBar(
                //   theme: theme,
                //   context: context,
                //   titleText: _appScreenText['waitingList'],
                // ),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    addRemoveWaitingListButton(theme),
                    header(theme),
                    playersInList(theme)
                  ],
                ),
              ),
            ));
  }

  playersInList(AppTheme theme) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _appScreenText['playersInTheList'],
            style: AppDecorators.getSubtitle3Style(theme: theme),
          ),
          AppDimensionsNew.getVerticalSizedBox(10),
          Expanded(
            child: Container(
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: allWaitingListPlayers.length > 0
                  ? ListView.builder(
                      itemCount: allWaitingListPlayers.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) => playerItem(
                          allWaitingListPlayers[index], index, theme),
                    )
                  : Center(
                      child: Text(
                        _appScreenText['waitingListIsEmpty'],
                        style: AppDecorators.getSubtitle3Style(theme: theme),
                      ),
                    ),
            ),
          ),
        ],
      ),
    ));
  }

  playerItem(WaitingListModel seatChangeModel, int index, AppTheme theme) {
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
                  style: AppDecorators.getHeadLine4Style(theme: theme),
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

  addRemoveWaitingListButton(AppTheme theme) {
    if (widget.gameState.getSeatByPlayer(widget.gameState.currentPlayerId) ==
        null) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: AppDecorators.tileDecorationWithoutBorder(theme),
          child: SwitchWidget(
            label: _appScreenText['addMeToWaitingList'],
            value: isInWaitingList,
            onChange: (bool value) async {
              setState(() {
                isInWaitingList = value;
              });
              if (isInWaitingList) {
                widget.gameState.gameInfo.playerGameStatus =
                    AppConstants.IN_QUEUE;
                bool result =
                    await WaitlistService.addToWaitList(widget.gameCode);
                widget.gameState.redrawFooter();
                print("result = $result");
              } else {
                widget.gameState.gameInfo.playerGameStatus =
                    AppConstants.NOT_PLAYING;
                bool result =
                    await WaitlistService.removeFromWaitlist(widget.gameCode);
                widget.gameState.redrawFooter();
                print("result check $result");
              }
              getAllWaitingPlayers();
            },
          ));
    } else {
      return SizedBox();
    }
  }

  header(AppTheme theme) {
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
                        RoundedColorButton(
                          text: _appScreenText['apply'],
                          textColor: theme.primaryColorWithDark(),
                          backgroundColor: theme.accentColor,
                          onTapFunction: () {
                            List<String> uuids = [];
                            allWaitingListPlayers.forEach((element) {
                              uuids.add(element.playerUuid);
                            });
                            setState(() {
                              ischanged = false;
                            });
                            WaitlistService.changeWaitListOrderList(
                                widget.gameCode, uuids);
                          },
                        ),

                        // Text(
                        //   "Apply",
                        //   style: AppStylesNew.subTitleTextStyle,
                        // ),
                        //),
                        SizedBox(
                          width: 15,
                        ),

                        RoundedColorButton(
                          text: _appScreenText['cancel'],
                          textColor: theme.accentColor,
                          borderColor: theme.accentColor,
                          onTapFunction: () {
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
