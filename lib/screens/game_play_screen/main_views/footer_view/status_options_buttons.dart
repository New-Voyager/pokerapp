import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class StatusOptionsWidget extends StatelessWidget {
  final GameState gameState;
  const StatusOptionsWidget({Key key, this.gameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("seatChangeConfirmWidget");
    final mySeat = gameState.mySeat(context);
    final myState = gameState.myState;
    final theme = AppTheme.getTheme(context);
    final width = MediaQuery.of(context).size.width;

    List<Widget> children = [];
    // if i am not in the waitlist
    if (mySeat == null && myState.status != PlayerStatus.IN_QUEUE) {
      if (gameState.gameInfo.waitlistAllowed) {
        children.add(getWaitListButton(_appScreenText, theme, context));
      }
    } else {
      if (myState.status == PlayerStatus.WAIT_FOR_BUYIN ||
          myState.status == PlayerStatus.WAIT_FOR_BUYIN_APPROVAL) {
        children.add(getBuyinButton(_appScreenText, theme, context));
      }
      if (mySeat.player.inBreak) {
        children.add(getSitbackButton(_appScreenText, theme, context));
      }      
    }

    if (children.isEmpty) {
      return SizedBox(width: width);
    }

    children.insert(0, SizedBox(height: 10.ph));

    return Align(
        alignment: Alignment.topCenter,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start, children: children));
  }

  Widget getWaitListButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundedColorButton(
      onTapFunction: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          builder: (_) => ListenableProvider.value(
            value: context.read<GameContextObject>(),
            child: GameOptionsBottomSheet(
                gameState: GameState.getState(context), focusWaitingList: true),
          ),
        );
      },
      text: "Join Waitlist",
      fontSize: 16.dp,
      backgroundColor: theme.accentColor,
      textColor: theme.primaryColorWithDark(),
    );
  }

  Future<void> onBuyin(
      AppTextScreen appScreenText, BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    gameState.buyInKeyboardShown = true;
    /* use numeric keyboard to get buyin */
    double value = await NumericKeyboard2.show(
      context,
      title:
          '${appScreenText['buyInEntry']} (${gameInfo.buyInMin} - ${gameInfo.buyInMax})',
      min: gameInfo.buyInMin.toDouble(),
      max: gameInfo.buyInMax.toDouble(),
    );
    gameState.buyInKeyboardShown = false;

    if (value == null) return;

    // buy chips
    await GameService.buyIn(
      gameInfo.gameCode,
      value.toInt(),
    );
  }

  Widget getBuyinButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundedColorButton(
      fontSize: 16.dp,
      onTapFunction: () async {
        await onBuyin(appScreenText, context);
      },
      text: "Buyin",
      backgroundColor: theme.accentColor,
      textColor: theme.primaryColorWithDark(),
    );
  }

  Future<SitBackResponse> onSitBack(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    //sit back in the seat
    final resp = await GameService.sitBack(gameInfo.gameCode);

    // update player model and notify my state
    final me = gameState.mySeat(context);
    if (me != null && me.player != null) {
      me.player.status = resp.status;
      me.player.missedBlind = resp.missedBlind ?? false;
      final myState = gameState.myState;
      if (myState != null) {
        myState.notify();
      }
    }
    return resp;
  }

  Widget getSitbackButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundedColorButton(
      fontSize: 16.dp,
      onTapFunction: () async {
        await onSitBack(context);
      },
      text: "Sit Back",
      backgroundColor: theme.accentColor,
      textColor: theme.primaryColorWithDark(),
    );
  }
}
