import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view_util_widgets.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class HeaderView extends StatelessWidget {
  void endGame(BuildContext context, HeaderObject obj) {
    GameService.endGame(obj.gameCode);
    obj.gameEnded = true;
    final snackBar = SnackBar(
      content: Text('Game will end after this hand'),
      duration: Duration(seconds: 15),
      backgroundColor: Colors.black38,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /* general header view */
            Consumer<HeaderObject>(
              builder: (_, HeaderObject obj, __) => Container(
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
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    /* fixme: temporary place for end game */
                    Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: !obj.gameEnded,
                        child: CustomTextButton(
                          text: 'End Game',
                          onTap: () => endGame(context, obj),
                        ),
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
