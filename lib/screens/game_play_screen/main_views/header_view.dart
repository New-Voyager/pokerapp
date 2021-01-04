import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

const shrinkedSizedBox = const SizedBox.shrink();

class HeaderView extends StatelessWidget {
  Widget _buildText(String text, {bool whiteColor = true}) => Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Text(
          text,
          style: whiteColor
              ? AppStyles.gamePlayScreenHeaderTextStyle1
              : AppStyles.gamePlayScreenHeaderTextStyle2,
        ),
      );

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
  Widget build(BuildContext context) => Consumer<HeaderObject>(
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
                  _buildText(
                    'GAME CODE: ${obj.gameCode}',
                  ),

                  /* hand num */
                  _buildText(
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

              /* temporary place for end game */
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                    visible: !obj.gameEnded,
                    child: InkWell(
                      onTap: () => endGame(context, obj),
                      child: CustomTextButton(text: 'End Game'),
                    )),
              ),
            ],
          ),
        ),
      );
}
