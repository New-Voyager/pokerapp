import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/coin_update.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HeaderView extends StatelessWidget {
  final GameState gameState;
  AppTextScreen _appScreenText;

  HeaderView({
    @required this.gameState,
  });

  String _getTitleText(HandInfoState his) {
    if (his != null) {
      String smallBlind = his.smallBlind.toString().replaceAll('.0', '');

      String bigBlind = his.bigBlind.toString().replaceAll('.0', '');

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
              "${gameTypeStr(gameTypeFromStr(gameState.gameInfo.gameType))}  ${gameState.gameInfo.smallBlind}/${gameState.gameInfo.bigBlind}";
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
                text: _appScreenText['hand'],
                style: AppDecorators.getHeadLine4Style(theme: theme).copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: " #${his.handNum}",
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
    final gameContextObj = context.read<GameContextObject>();
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
            gameContextObj: gameContextObj,
            gameState: GameState.getState(context)),
      ),
    );
  }

  Widget _buildGameMenuNavButton(BuildContext context, AppTheme theme) {
    IconData iconData = Icons.more_vert;
    final gameState = GameState.getState(context);
    if (gameState.customizationMode) {
      iconData = Icons.edit_rounded;
    }

    return Transform.scale(
      scale: 1.2,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.pw),
        child: InkWell(
            child: Container(
              width: 32.pw,
              height: 32.pw,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.secondaryColor,
                  width: 2,
                ),
              ),
              // padding: EdgeInsets.all(5),
              child: Icon(
                iconData,
                color: theme.secondaryColor,
              ),
            ),
            borderRadius: BorderRadius.circular(32.pw),
            onTap: () {
              _onGameMenuNavButtonPress(context);
            }),
      ),
    );

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
