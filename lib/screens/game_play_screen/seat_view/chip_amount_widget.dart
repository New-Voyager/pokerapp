import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

class ChipAmountWidget extends StatelessWidget {
  final Seat seat;

  ChipAmountWidget({
    Key key,
    @required this.seat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BoardAttributesObject>(
        builder: (_, boardAttrObj, __) => Transform.translate(
          offset: boardAttrObj.chipAmountWidgetOffsetMapping[seat.serverSeatPos],
          //offset: Offset(0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* show the coin svg */
              Container(
                height: 20,
                width: 20.0,
                child: SvgPicture.asset(
                  AppAssets.coinsImages,
                ),
              ),
              const SizedBox(height: 5.0),

              /* show the coin amount */
              Text(
                seat.player?.coinAmount.toString(),
                style: AppStyles.gamePlayScreenPlayerChips,
              ),
            ],
          ),
        ),
      );
}