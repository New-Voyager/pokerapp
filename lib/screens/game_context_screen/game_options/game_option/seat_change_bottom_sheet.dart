import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/seat_change_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:provider/provider.dart';

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
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("seatChangeBottomSheet");

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
    final result = await SeatChangeService.listOfSeatChange(widget.gameCode);
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
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        height: height / 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CircleImageButton(
                    icon: Icons.close,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    theme: theme)
              ]),
              isPlaying ? seatChangeButton(theme) : Container(),
              playersInList(theme)
            ],
          ),
        ),
      ),
    );
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
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          AppDimensionsNew.getVerticalSizedBox(5),
          Expanded(
            child: Container(
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: allPlayersWantToChange.length > 0
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: allPlayersWantToChange.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) =>
                          playerItem(allPlayersWantToChange[index], theme),
                    )
                  : Center(
                      child: Text(
                        'No requests',
                        style: AppDecorators.getSubtitle1Style(theme: theme),
                      ),
                    ),
            ),
          ),
        ],
      ),
    ));
  }

  playerItem(SeatChangeModel seatChangeModel, AppTheme theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
              seatChangeModel.name,
              style: AppDecorators.getHeadLine4Style(theme: theme),
            ),
          ),
          AppDimensionsNew.getDivider(theme),
        ],
      ),
    );
  }

  seatChangeButton(AppTheme theme) {
    log('seat change: on/off: $isSeatChange');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      child: SwitchWidget2(
        label: _appScreenText['seatChange'],
        value: isSeatChange,
        onChange: (bool value) async {
          setState(() {
            isSeatChange = value;
          });
          if (isSeatChange) {
            // want to seat change
            await SeatChangeService.requestForSeatChange(widget.gameCode);
          } else {
            // do not want to seat change
            await SeatChangeService.requestForSeatChange(widget.gameCode,
                cancel: true);
          }
          getAllSeatChangePlayers();
        },
      ),
    );
  }
}
