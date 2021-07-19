import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HeaderView extends StatelessWidget {
  final GameState gameState;

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

  Widget _buildMainContent() {
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
                style: TextStyle(
                  color: AppColorsNew.newTextColor,
                ),
              ),
            ),

            /* hand number */
            RichText(
              text: TextSpan(
                text: "Hand ",
                style: TextStyle(
                  color: AppColorsNew.newTextColor,
                ),
                children: [
                  TextSpan(
                    text: "#${his.handNum}",
                    style: TextStyle(
                      color: AppColorsNew.yellowAccentColor,
                      fontSize: 8.dp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          child: SvgPicture.asset(
            'assets/images/backarrow.svg',
            color: AppColorsNew.newGreenButtonColor,
            width: 24.pw,
            height: 24.ph,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(24.pw),
          onTap: () => Navigator.of(context).pop(),
        ),
      );

  void _onGameMenuNavButtonPress(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        builder: (_) => GameOptionsBottomSheet(GameState.getState(context)),
      );

  Widget _buildGameMenuNavButton(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () => _onGameMenuNavButtonPress(context),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColorsNew.newGreenButtonColor,
                width: 2,
              ),
            ),
            // padding: EdgeInsets.all(5),
            child: Icon(
              Icons.more_vert,
              color: AppColorsNew.newGreenButtonColor,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsNew.newBackgroundBlackColor.withOpacity(0.7),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /* main content */
            _buildMainContent(),

            /* back button */
            _buildBackButton(context),

            /* game menu */
            Consumer<HandInfoState>(builder: (_, his, __) {
              return Visibility(
                  child: _buildGameMenuNavButton(context),
                  visible: !gameState.ended);
            }),
          ],
        ),
      ),
    );
  }
}
