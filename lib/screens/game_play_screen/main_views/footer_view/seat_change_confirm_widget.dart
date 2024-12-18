import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

class SeatChangeConfirmWidget extends StatelessWidget {
  final String gameCode;
  const SeatChangeConfirmWidget({Key key, this.gameCode}) : super(key: key);

  onCancel(context) async {
    Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    )
      ..updateSeatChangeHost(0)
      ..updateSeatChangeInProgress(false);
    final gameState = GameState.getState(context);
    gameState.hostSeatChangeInProgress = false;
    await SeatChangeService.hostSeatChangeEnd(this.gameCode, cancel: true);
  }

  onConfirmChanges(context) async {
    Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    )
      ..updateSeatChangeHost(0)
      ..updateSeatChangeInProgress(false);
    final gameState = GameState.getState(context);
    gameState.hostSeatChangeInProgress = false;
    await SeatChangeService.hostSeatChangeEnd(this.gameCode, cancel: false);
  }

  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("seatChangeConfirmWidget");

    return Container(
      padding: EdgeInsets.all(16),
      decoration: AppStylesNew.resumeBgDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Text(_appScreenText['applySeatChanges'],
                style: AppStylesNew.cardHeaderTextStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconAndTitleWidget(
                onTap: () => onConfirmChanges(context),
                child: SvgPicture.asset(AppAssetsNew.doneImagePath,
                    height: 64.ph, width: 64.pw),
                text: "",
              ),
              AppDimensionsNew.getHorizontalSpace(16),
              IconAndTitleWidget(
                onTap: () => onCancel(context),
                child: SvgPicture.asset(AppAssetsNew.terminateImagePath,
                    height: 64.ph, width: 64.pw),
                text: "",
              ),
              // GestureDetector(
              //   onTap: () => onConfirmChanges(context),
              //   child: Container(
              //     width: 130,
              //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //     color: Colors.brown[700],
              //     child: Text(
              //       "Confirm\nRearrangement",
              //       style: AppStylesNew.footerResultTextStyle2,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: 20,
              // ),
              // GestureDetector(
              //   onTap: () => onCancel(context),
              //   child: Container(
              //     width: 130,
              //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //     color: Colors.brown[700],
              //     child: Text(
              //       "Cancel\nChanges",
              //       style: AppStylesNew.footerResultTextStyle2,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
