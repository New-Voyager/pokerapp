import 'dart:developer';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:timer_count_down/timer_count_down.dart';

class StatusOptionsWidget extends StatelessWidget {
  final GameState gameState;
  const StatusOptionsWidget({Key key, this.gameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("seatChangeConfirmWidget");
    final mySeat = gameState.mySeat;
    final theme = AppTheme.getTheme(context);
    final width = MediaQuery.of(context).size.width;

    List<Widget> children = [];
    // if i am not in the waitlist
    if (mySeat == null) {
      if (gameState.gameInfo.playerGameStatus != AppConstants.IN_QUEUE) {
        if (gameState.gameInfo.status != AppConstants.GAME_CONFIGURED &&
            gameState.gameInfo.status != AppConstants.GAME_ENDED) {
          if (gameState.gameInfo.waitlistAllowed) {
            if (gameState.isTableFull) {
              children.add(getWaitListButton(_appScreenText, theme, context));
            }
          }
        }
      }
    } else {
      final buttonCountdownSpace = 10.ph;
      final countDownFontSize = 14;
      if (mySeat.player != null) {
        if (mySeat.player.status == AppConstants.WAIT_FOR_BUYIN ||
            mySeat.player.status == AppConstants.WAIT_FOR_BUYIN_APPROVAL) {
          children.add(getBuyinButton(_appScreenText, theme, context));
          children.add(SizedBox(height: buttonCountdownSpace));
          children.add(getCountdown(mySeat.player.buyInTimeExpAt,
              fontSize: countDownFontSize));
        }
        if (mySeat.player.inBreak) {
          children.add(getSitbackButton(_appScreenText, theme, context));
          children.add(SizedBox(height: buttonCountdownSpace));
          children.add(getCountdown(mySeat.player.breakTimeExpAt,
              fontSize: countDownFontSize));
        } else {
          if (mySeat.player.status == AppConstants.PLAYING) {
            if (mySeat.player.missedBlind && !mySeat.player.postedBlind) {
              children.add(getPostBlindButton(_appScreenText, theme, context));
            }
          }
        }
      }
    }

    if (children.isEmpty) {
      return SizedBox(width: width);
    }

    children.insert(0, SizedBox(height: 10.ph));

    return Stack(alignment: Alignment.center, children: [
      SizedBox(width: width),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: children)
    ]);

    // return Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start, children: children));
  }

  Widget getWaitListButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundRectButton(
      onTap: () {
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
      theme: theme,
      fontSize: 16.dp,
    );
  }

  Future<void> onBuyin(
      AppTextScreen appScreenText, BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    gameState.buyInKeyboardShown = true;
    String title = '${appScreenText['buyInEntry']} (${DataFormatter.chipsFormat(gameInfo.buyInMin)} - ${DataFormatter.chipsFormat(gameInfo.buyInMax)})';
    /* use numeric keyboard to get buyin */
    double value = await NumericKeyboard2.show(context,
        title: title,
        min: gameInfo.buyInMin.toDouble(),
        max: gameInfo.buyInMax.toDouble(),
        decimalAllowed: gameInfo.chipUnit == ChipUnit.CENT);
    gameState.buyInKeyboardShown = false;

    if (value == null) return;

    // buy chips
    await GameService.buyIn(
      gameInfo.gameCode,
      value,
    );
  }

  Widget getBuyinButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundRectButton(
      fontSize: 16.dp,
      onTap: () async {
        await onBuyin(appScreenText, context);
      },
      text: "Buyin",
      theme: theme,
    );
  }

  Widget getCountdown(DateTime expiresAt,
      {Function onFinished, int fontSize = 14}) {
    var remainingDuration = expiresAt?.difference(DateTime.now());
    if (remainingDuration == null || remainingDuration.isNegative) {
      remainingDuration = Duration.zero;
    }
    return Countdown(
        seconds: remainingDuration.inSeconds,
        onFinished: () {
          if (onFinished != null) {
            onFinished();
          }
        },
        build: (_, remainingSec) {
          if (remainingSec <= 10) {
            return BlinkText(
                printDuration(Duration(seconds: remainingSec.toInt())),
                style: AppStylesNew.itemInfoTextStyle.copyWith(
                  fontSize: fontSize.dp,
                  color: Colors.white,
                ),
                beginColor: Colors.white,
                endColor: Colors.orange,
                times: remainingSec.toInt(),
                duration: Duration(seconds: 1));
          } else {
            return Text(
              printDuration(Duration(seconds: remainingSec.toInt())),
              style: AppStylesNew.itemInfoTextStyle.copyWith(
                fontSize: fontSize.dp,
                color: Colors.white,
              ),
            );
          }
        });
  }

  Future<SitBackResponse> onSitBack(BuildContext context) async {
    log('Sitback: onSitBack');
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    //sit back in the seat
    SitBackResponse resp;
    try {
      resp = await GameService.sitBack(gameInfo.gameCode,
          location: gameState.currentLocation);
    } catch (e) {
      if (e.code != null && e.code == 'LOC_PROXMITY_ERROR') {
        showErrorDialog(context, 'Error',
            'GPS check is enabled in this game. You are close to another player.');
      } else {
        showErrorDialog(context, 'Error', e.message);
      }
      return null;
    }

    // update player model and notify my state
    final me = gameState.mySeat;
    if (me != null && me.player != null && resp != null) {
      me.player.status = resp.status;
      me.player.missedBlind = resp.missedBlind ?? false;
      me.player.inBreak = false;
      me.player.resetSeatAction();
      log('Sitback: missed blind: ${me.player.missedBlind} status: ${me.player.status}');
      final myState = gameState.myState;
      if (myState != null) {
        myState.notify();
      }
    }
    return resp;
  }

  Widget getSitbackButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundRectButton(
      fontSize: 16.dp,
      onTap: () async {
        await onSitBack(context);
      },
      text: "Sit Back",
      theme: theme,
    );
  }

  Future<void> onPostBlind(BuildContext context) async {
    final gameState = GameState.getState(context);
    final gameInfo = gameState.gameInfo;
    // post blind
    await GameService.postBlinds(gameInfo.gameCode);

    // update player model and notify my state
    final me = gameState.mySeat;
    if (me != null && me.player != null) {
      me.player.postedBlind = true;
      final myState = gameState.myState;
      if (myState != null) {
        myState.notify();
      }
    }
  }

  Widget getPostBlindButton(
      AppTextScreen appScreenText, AppTheme theme, BuildContext context) {
    return RoundRectButton(
      fontSize: 16.dp,
      onTap: () async {
        await onPostBlind(context);
      },
      text: "Post Blind",
      theme: theme,
    );
  }
}
