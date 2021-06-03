import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view_util_widgets.dart';
import 'package:provider/provider.dart';

class HeaderView extends StatelessWidget {
  final String gameCode;

  HeaderView({
    @required this.gameCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
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
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /* main content view */
                  Column(
                    children: [
                      /* game code */
                      HeaderViewUtilWidgets.buildText('Game Code: $gameCode'),

                      /* game title */
                      HeaderViewUtilWidgets.buildText(title),

                      /* hand num */
                      HeaderViewUtilWidgets.buildText(handNum),
                    ],
                  ),

                  /* back button */
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  /* fixme: temporary place for end game */

                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (ctx) => GameOptionsBottomSheet(
                                  GameState.getState(ctx)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey,
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.more_horiz,
                              color: AppColors.appAccentColor,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
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
