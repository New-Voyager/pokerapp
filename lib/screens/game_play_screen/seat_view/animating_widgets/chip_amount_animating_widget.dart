import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:provider/provider.dart';

class ChipAmountAnimatingWidgetOld extends StatelessWidget {
  final int seatPos;
  final Widget child;
  final bool reverse;

  ChipAmountAnimatingWidgetOld({
    this.seatPos,
    this.child,
    this.reverse,
  });

  @override
  Widget build(BuildContext context) => Consumer<BoardAttributesObject>(
        builder: (_, boardAttrObj, __) => TweenAnimationBuilder<Offset>(
          curve: Curves.easeInOut,
          tween: (reverse ?? false)
              ? Tween<Offset>(
                  begin: boardAttrObj.chipAmountAnimationOffsetMapping[seatPos],
                  end: Offset(0, 0),
                )
              : Tween<Offset>(
                  begin: Offset(0, 0),
                  end: boardAttrObj.chipAmountAnimationOffsetMapping[seatPos],
                ),
          child: child,
          duration: AppConstants.animationDuration,
          builder: (_, offset, child) {
            double offsetPercentageLeft;
            if (reverse ?? false)
              offsetPercentageLeft = 1;
            else
              offsetPercentageLeft = 1 -
                  (offset.dy /
                      boardAttrObj
                          .chipAmountAnimationOffsetMapping[seatPos].dy);

            return Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: offsetPercentageLeft,
                child: child,
              ),
            );
          },
        ),
      );
}

class ChipAmountAnimatingWidget extends StatefulWidget {
  final int seatPos;
  final Widget child;
  final bool reverse;

  ChipAmountAnimatingWidget({
    this.seatPos,
    this.child,
    this.reverse,
  });

  @override
  _ChipAmountAnimatingWidgetState createState() =>
      _ChipAmountAnimatingWidgetState();
}

class _ChipAmountAnimatingWidgetState extends State<ChipAmountAnimatingWidget>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<Offset> animation;
  @override
  void initState() {
    /* calling animate in init state */
    animate();

    super.initState();
  }

  void animate() async {
    animationController = new AnimationController(
      vsync: this,
      //duration: Duration(seconds: 10),
      duration: AppConstants.animationDuration
    );

    final gameState = GameState.getState(context);
    final seat = gameState.getSeat(context, widget.seatPos);
    final boardAttributes = gameState.getBoardAttributes(context);
    Offset pos =boardAttributes.chipAmountWidgetOffsetMapping[widget.seatPos];
    Offset end = seat.seatBet.potViewPos;
    end = Offset(seat.seatBet.potViewPos.dx-pos.dx, seat.seatBet.potViewPos.dy-pos.dy);
    log('Animating chips movement ${widget.seatPos}, end: $end potPos: ${seat.seatBet.potViewPos} chip offset: $pos done');
    animation = Tween<Offset>(
      begin: Offset.zero,
      end: end,
    ).animate(animationController);

    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //log('Animating bet amount');
    /* if animation is NULL do nothing */
    if (animation == null) return Container();

    // return widget.child;

    // if (!animationStarted) {
    //   log('Start animation');
    //   Future.delayed(Duration.zero, () => {this.animate(context)});
    // }
    // if (animationStarted) {
    //   log('Building ${widget.seatPos} dx: ${animation.value.dx}, top: ${animation.value.dy}');
    // }

    // return SlideTransition(
    //   position: animation,
    //   child: widget.child,
    // );

    return Transform.translate(
      offset: animation.value,
      //child: Container(width: 20, height: 20, color: Colors.red,),
      child: widget.child,
    );
    //
    // return Positioned(
    //   left: animation.value.dx,
    //   top: animation.value.dy,
    //   child: widget.child,
    // );

    // return Consumer<BoardAttributesObject>(
    //     builder: (_, boardAttrObj, __) => TweenAnimationBuilder<Offset>(
    //       curve: Curves.easeInOut,
    //       tween: (widget.reverse ?? false)
    //           ? Tween<Offset>(
    //               begin: boardAttrObj.chipAmountAnimationOffsetMapping[widget.seatPos],
    //               end: Offset(0, 0),
    //             )
    //           : Tween<Offset>(
    //               begin: Offset(0, 0),
    //               end: boardAttrObj.chipAmountAnimationOffsetMapping[widget.seatPos],
    //             ),
    //       child: widget.child,
    //       duration:  Duration(seconds: 1), //AppConstants.animationDuration,
    //       builder: (_, offset, child) {
    //         double offsetPercentageLeft;
    //         if (widget.reverse ?? false)
    //           offsetPercentageLeft = 1;
    //         else
    //           offsetPercentageLeft = 1 -
    //               (offset.dy /
    //                   boardAttrObj
    //                       .chipAmountAnimationOffsetMapping[widget.seatPos].dy);

    //         return Transform.translate(
    //           offset: offset,
    //           child: Opacity(
    //             opacity: offsetPercentageLeft,
    //             child: child,
    //           ),
    //         );
    //       },
    //     ),
    //   );
  }
}
