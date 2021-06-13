import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view_util_widgets.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HeaderView extends StatelessWidget {
  final String gameCode;

  HeaderView({
    @required this.gameCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsNew.newBackgroundBlackColor.withOpacity(0.7),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /* general header view */
          Consumer<HandInfoState>(builder: (_, HandInfoState obj, __) {
            String title = '';
            String handNum = '';
            if (obj != null) {
              String smallBlind = obj.smallBlind.toString();
              smallBlind = smallBlind.replaceAll('.0', '');

              String bigBlind = obj.bigBlind.toString();
              bigBlind = bigBlind.replaceAll('.0', '');

              title = '${obj.gameType} $smallBlind/$bigBlind';
              handNum = 'Hand: #${obj.handNum}';
            }

            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /* main content view */
                  Column(
                    children: [
                      // RichText(
                      //   text: TextSpan(
                      //     text: "Game code ",
                      //     style: TextStyle(
                      //       color: AppColorsNew.newTextColor,
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //           text: "$gameCode",
                      //           style: TextStyle(
                      //             color: AppColorsNew.yellowAccentColor,
                      //             fontSize: 12.dp,
                      //             fontWeight: FontWeight.w500,
                      //           ))
                      //     ],
                      //   ),
                      // ),
                      RichText(
                        text: TextSpan(
                          text: "$title",
                          style: TextStyle(
                            color: AppColorsNew.newTextColor,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Hand ",
                          style: TextStyle(
                            color: AppColorsNew.newTextColor,
                          ),
                          children: [
                            TextSpan(
                                text: "#${obj.handNum}",
                                style: TextStyle(
                                  color: AppColorsNew.yellowAccentColor,
                                  fontSize: 8.dp,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        ),
                      ),
                      // /* game code */
                      // HeaderViewUtilWidgets.buildText('Game Code: $gameCode'),

                      // /* game title */
                      // HeaderViewUtilWidgets.buildText(title),

                      // /* hand num */
                      // HeaderViewUtilWidgets.buildText(handNum),
                    ],
                  ),

                  /* back button */
                  Align(
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
                  ),

                  /* fixme: temporary place for end game */

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => GameOptionsBottomSheet(
                            GameState.getState(context),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColorsNew.newGreenButtonColor,
                              width: 2,
                            )),
                        // padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.more_vert,
                          color: AppColorsNew.newGreenButtonColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
