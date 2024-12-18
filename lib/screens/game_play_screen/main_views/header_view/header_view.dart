import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/poker_dialog_box.dart';
import 'package:pokerapp/widgets/text_widgets/header/header_game_code_text.dart';
import 'package:pokerapp/widgets/text_widgets/header/header_title_text.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HeaderView extends StatelessWidget {
  final GameState gameState;
  final GlobalKey<ScaffoldState> scaffoldKey;
  AppTextScreen _appScreenText;

  HeaderView({
    @required this.gameState,
    this.scaffoldKey,
  });

  String _getTitleText(HandInfoState his) {
    if (his != null) {
      String smallBlind = DataFormatter.chipsFormat(his.smallBlind);

      String bigBlind = DataFormatter.chipsFormat(his.bigBlind);

      return '${his.gameType} $smallBlind/$bigBlind';
    }

    return '';
  }

  Widget _buildMainContent() {
    if (!gameState.boardAttributes.isOrientationHorizontal) {
      return SizedBox.shrink();
    }
    return Consumer<HandInfoState>(
      builder: (_, his, __) {
        String titleText = "";
        if (his.handNum == 0) {
          titleText =
              "${gameTypeStr(gameTypeFromStr(gameState.gameInfo.gameType))}  ${DataFormatter.chipsFormat(gameState.gameInfo.smallBlind)}/${DataFormatter.chipsFormat(gameState.gameInfo.bigBlind)}";
        } else {
          titleText = _getTitleText(his);
        }
        return Column(
          children: [
            /* title text */
            // game type and bet coins
            HeaderTitleText(titleText),

            // game code
            HeaderGameCodeText(
              his.handNum == 0 ? 'Code: ' : _appScreenText['hand'],
              his.handNum == 0
                  ? '${gameState.gameInfo.gameCode}'
                  : ' #${his.handNum}',
            ),
          ],
        );
      },
    );
  }

  void _onGameMenuNavButtonPress(BuildContext context) {
    final gameState = GameState.getState(context);
    if (gameState.customizationMode) {
      // show backdrop options
      return;
    }
    // Open drawer with game options with scaffoldkey
    if (scaffoldKey != null) {
      if (scaffoldKey.currentState.isEndDrawerOpen) {
        scaffoldKey.currentState.openDrawer();
      } else {
        scaffoldKey.currentState.openEndDrawer();
      }
    }
  }

  Widget _buildGameMenuNavButton(BuildContext context, AppTheme theme) {
    IconData iconData = Icons.menu;
    final gameState = GameState.getState(context);
    if (gameState.customizationMode) {
      iconData = Icons.edit_rounded;
    }

    return Transform.scale(
      scale: 1.2,
      child: Consumer<PendingApprovalsState>(
        builder: (context, value, child) {
          log('PendingApprovalsState: rebuild approvals.length: ${value.approvalList.length}');
          return IconWithBadge(
            count: value.approvalList.length,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 16.pw),
              child: InkWell(
                child: Container(
                  width: 24.pw,
                  height: 24.pw,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.secondaryColor,
                      width: 2,
                    ),
                  ),
                  // padding: EdgeInsets.all(5),
                  child: Center(
                    child: Icon(
                      iconData,
                      color: theme.secondaryColor,
                      size: 18,
                    ),
                  ),
                ),

                ///borderRadius: BorderRadius.circular(32.pw),
                onTap: () {
                  _onGameMenuNavButtonPress(context);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _appScreenText = getAppTextScreen("global");

    final gameState = GameState.getState(context);

    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          color: theme.primaryColorWithDark().withOpacity(0.8),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Container(
            // margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // back button
                BackArrowWidget(
                  onBackHandle: () {
                    if (gameState.tableState.gameStatus != 'ENDED' &&
                        gameState.tableState.tableStatus != 'ENDED' &&
                        gameState.isPlaying) {
                      PokerDialogBox.show(
                        context,
                        message: "Are you leaving the game?",
                        buttonOneText: "Yes",
                        buttonOneAction: () {
                          GameService.leaveGame(gameState.gameCode, true);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        buttonTwoText: "Cancel",
                        buttonTwoAction: () {
                          Navigator.pop(context);
                        },
                        buttonThreeText: "Will be Back",
                        buttonThreeAction: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),

                // center title
                Expanded(child: _buildMainContent()),

                // game menu
                Consumer<HandInfoState>(
                  builder: (_, his, __) {
                    return Visibility(
                      child: _buildGameMenuNavButton(context, theme),
                      visible: !gameState.ended,
                    );
                  },
                ),
              ],
            ),
            // child: Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     /* main content */
            //     _buildMainContent(theme),

            //     /* back button */
            //     Positioned(top: 5.ph, left: 5.ph, child: BackArrowWidget()),

            //     /* game menu */
            //     Positioned(
            //         right: 10.pw,
            //         top: 5.ph,
            //         child: Consumer<HandInfoState>(builder: (_, his, __) {
            //           return Visibility(
            //               child: _buildGameMenuNavButton(context, theme),
            //               visible: !gameState.ended);
            //         })),
            //   ],
            // ),
          ),
        );
      },
    );
  }
}
