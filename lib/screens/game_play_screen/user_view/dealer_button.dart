import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

class DealerButtonWidget extends StatelessWidget {
  final int seatPos;
  final bool isMe;
  final GameType gameType;

  DealerButtonWidget(this.seatPos, this.isMe, this.gameType);

  @override
  Widget build(BuildContext context) {
    final attributes = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    );
    final buttonPos = attributes.buttonPos;
    final buttonColor = attributes.buttonColor(gameType);
    final textStyle =
        AppStyles.dealerTextStyle.copyWith(color: buttonColor.item2);
    return Transform.translate(
      offset: buttonPos[seatPos],
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: buttonColor.item1,
          shape: BoxShape.circle,
          border: Border.all(
            color: buttonColor.item1,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              blurRadius: 2.0,
              spreadRadius: 2.0,
            )
          ],
        ),
        child: Text(
          'D',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
