import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view_util_widgets.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

import '../../game_play_screen_util_methods.dart';

class HeaderView extends StatelessWidget {
  final GameComService _gameComService;
  HeaderView(this._gameComService);

  void endGame(BuildContext context, GameContextObject obj) {
    GameService.endGame(obj.gameCode);
    obj.gameEnded = true;
    final snackBar = SnackBar(
      content: Text('Game will end after this hand'),
      duration: Duration(seconds: 15),
      backgroundColor: Colors.black38,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void chatText(BuildContext context, GameContextObject obj) {
    final chat = _gameComService.chat;
    chat.sendText("Got lucky");
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /* general header view */
            Consumer<GameContextObject>(
              builder: (_, GameContextObject obj, __) => Container(
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
                        HeaderViewUtilWidgets.buildText(
                          'GAME CODE: ${obj.gameCode}',
                        ),

                        /* hand num */
                        HeaderViewUtilWidgets.buildText(
                          obj.currentHandNum == null
                              ? ''
                              : 'Hand: #${obj.currentHandNum}',
                          whiteColor: false,
                        ),
                      ],
                    ),

                    /* back button */
                    Align(
                      alignment: Alignment.centerLeft,
                      // child: IconButton(
                      //   icon: Icon(
                      //     FontAwesomeIcons.chevronLeft,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
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
                          /*Visibility(
                            visible: !obj.gameEnded,
                            child: CustomTextButton(
                              text: 'End Game',
                              onTap: () => endGame(context, obj),
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextButton(
                            text: 'start',
                            onTap: () => GamePlayScreenUtilMethods.startGame(
                              obj.gameCode,
                            ),
                          ),*/
                          GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (ctx) => GameOptionsBottomSheet(
                                    obj.gameCode,
                                    _gameComService.currentPlayer.uuid),
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
              ),
            ),
          ],
        ),
      );
}
