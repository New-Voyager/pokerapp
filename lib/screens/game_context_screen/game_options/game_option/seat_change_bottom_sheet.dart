import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/seat_change_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';

class SeatChangeBottomSheet extends StatefulWidget {
  final String gameCode;
  final String playerUuid;
  final GameState gameState;

  SeatChangeBottomSheet(this.gameState, this.gameCode, this.playerUuid);
  @override
  _SeatChangeBottomSheetState createState() => _SeatChangeBottomSheetState();
}

class _SeatChangeBottomSheetState extends State<SeatChangeBottomSheet> {
  double height, width;
  bool isSeatChange = false;
  List<SeatChangeModel> allPlayersWantToChange = [];
  bool isSwitchShow = false;
  @override
  void initState() {
    super.initState();
    getAllSeatChangePlayers();
    for (final player in widget.gameState.gameInfo.playersInSeats) {
      if (player.playerUuid == widget.playerUuid) {
        isSwitchShow = true;
        break;
      }
      setState(() {});
    }
  }

  getAllSeatChangePlayers() async {
    final result = await GameService.listOfSeatChange(widget.gameCode);
    log('seat change players: $result');
    if (result != null) {
      allPlayersWantToChange = result;
      for (final player in allPlayersWantToChange) {
        if (player.playerUuid == widget.playerUuid) {
          log('seat change is on');
          isSeatChange = true;
          break;
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = widget.gameState.isPlaying;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // print("playerUuid ${widget.playerUuid}");
    // print("gameCode ${widget.gameCode}");
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      height: height / 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          context: context,
          titleText: AppStringsNew.seatChangeTitle,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            isPlaying ? seatChangeButton() : Container(),
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
              child: allPlayersWantToChange.length > 0
                  ? ListView.builder(
                      itemCount: allPlayersWantToChange.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) =>
                          playerItem(allPlayersWantToChange[index]),
                    )
                  : Center(
                      child: Text(AppStringsNew.noSeatChangeRequestsText),
                    ),
            ),
          ),
        ],
      ),
    ));
  }

  playerItem(SeatChangeModel seatChangeModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
              seatChangeModel.name,
              style: AppStyles.clubCodeStyle,
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(.5),
          )
        ],
      ),
    );
  }

  seatChangeButton() {
    log('seat change: on/off: $isSeatChange');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: AppStylesNew.actionRowDecoration,
      child: SwitchWidget(
        label: AppStringsNew.seatChangeTitle,
        value: isSeatChange,
        onChange: (bool value) async {
          setState(() {
            isSeatChange = value;
          });
          if (isSeatChange) {
            // want to seat change
            String result =
                await GameService.requestForSeatChange(widget.gameCode);
            // print("result $result");
          } else {
            // do not want to seat change
            String result = await GameService.requestForSeatChange(
                widget.gameCode,
                cancel: true);
            // print("result $result");
          }
          getAllSeatChangePlayers();
        },
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
                "Seat Change",
                style: AppStyles.optionTitleText,
              ),
            )
          ],
        ),
      );
}
