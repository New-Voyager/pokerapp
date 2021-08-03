import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:provider/provider.dart';

const shrinkedSizedBox = const SizedBox.shrink();

class StackSwitchSeatAnimatingWidget extends StatelessWidget {
  Widget _buildChild(int stack) => Column(
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
          /* show the stack amount */
          Text(
            stack.toString(),
            style: AppStylesNew.gamePlayScreenPlayerChips,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) =>
      Consumer2<ValueNotifier<SeatChangeModel>, BoardAttributesObject>(
        builder: (_, vnModel, boardAttrObj, __) => vnModel.value == null
            ? shrinkedSizedBox
            : TweenAnimationBuilder<Offset>(
                curve: Curves.easeInOut,
                tween: Tween<Offset>(
                  begin: boardAttrObj
                      .seatChangeStackOffsetMapping[vnModel.value.oldSeatNo],
                  end: boardAttrObj
                      .seatChangeStackOffsetMapping[vnModel.value.newSeatNo],
                ),
                child: _buildChild(vnModel.value.stack),
                duration: AppConstants.seatChangeAnimationDuration,
                builder: (_, offset, child) {
                  return Transform.translate(
                    offset: offset,
                    child: child,
                  );
                },
              ),
      );
}
