import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/coin_update.dart';
import 'package:pokerapp/utils/formatter.dart';
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

  Widget _buildMainContent(AppTheme theme) {
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
            RichText(
              text: TextSpan(
                text: titleText,
                style: AppDecorators.getHeadLine4Style(theme: theme),
              ),
            ),

            /* hand number */
            RichText(
              text: TextSpan(
                text: his.handNum == 0 ? 'Code: ' : _appScreenText['hand'],
                style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: his.handNum == 0
                        ? '${gameState.gameInfo.gameCode}'
                        : " #${his.handNum}",
                    style: AppDecorators.getAccentTextStyle(theme: theme),
                  )
                ],
              ),
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
        child:
            Consumer<PendingApprovalsState>(builder: (context, value, child) {
          log('PendingApprovalsState: rebuild approvals.length: ${value.approvalList.length}');
          return IconWithBadge(
              count: value.approvalList.length,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16.pw),
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
                      )),
                    ),

                    ///borderRadius: BorderRadius.circular(32.pw),
                    onTap: () {
                      _onGameMenuNavButtonPress(context);
                    }),
              ));
        }));

    // return Align(
    //   alignment: Alignment.centerRight,
    //   child: InkWell(
    //     onTap: () => _onGameMenuNavButtonPress(context),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //         border: Border.all(
    //           color: theme.secondaryColor,
    //           width: 2,
    //         ),
    //       ),
    //       // padding: EdgeInsets.all(5),
    //       child: Icon(
    //         iconData,
    //         color: theme.secondaryColor,
    //       ),
    //     ),
    //   ),
    // );
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
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /* main content */
                _buildMainContent(theme),

                /* back button */
                Positioned(top: 5.ph, left: 5.ph, child: BackArrowWidget()),

                /* game menu */
                Positioned(
                    right: 10.pw,
                    top: 5.ph,
                    child: Consumer<HandInfoState>(builder: (_, his, __) {
                      return Visibility(
                          child: _buildGameMenuNavButton(context, theme),
                          visible: !gameState.ended);
                    })),
              ],
            ),
          ),
        );
      },
    );
  }
}
