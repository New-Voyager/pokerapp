import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_styles.dart';
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

  @override
  Widget build(BuildContext context) => Consumer<HeaderObject>(
        builder: (_, HeaderObject obj, __) => Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Column(
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
        ),
      );
}
