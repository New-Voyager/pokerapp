import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DealerButtonWidget extends StatelessWidget {
  final SeatPos seatPos;
  final bool isMe;
  final GameType gameType;

  DealerButtonWidget(this.seatPos, this.isMe, this.gameType);

  @override
  Widget build(BuildContext context) {
    final attributes = context.read<BoardAttributesObject>();
    final Map<SeatPos, Offset> buttonPos = attributes.buttonPos();

    //final buttonColor = attributes.buttonColor(gameType);
    final buttonColor = Tuple2<Color, Color>(Colors.white, Colors.black);
    final textStyle = AppStyles.dealerTextStyle.copyWith(
      color: buttonColor.item2,
    );
    return Transform.translate(
      offset: buttonPos[seatPos],
      child: Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: buttonColor.item1,
          shape: BoxShape.circle,
          border: Border.all(
            color: buttonColor.item1,
            width: 2.0,
          ),
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
