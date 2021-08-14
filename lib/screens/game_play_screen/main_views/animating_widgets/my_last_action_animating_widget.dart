import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class MyLastActionAnimatingWidget extends StatelessWidget {
  final PlayerActedState myAction;

  MyLastActionAnimatingWidget({
    @required this.myAction,
  });

  /*
  Call: 55DF00, shadow: DFE7E4
  Check: 55DF00, shadow: DFE7E4
  Bet: CE3A3B, shadow: 865750
  Raise: CE3A3B, shadow: 865750
  Fold: F4F4F4, shadow: 00FFB1
  All In: F6E014, shadow: DAE886 
  */

  /* returns <text, color, shadow> */
  Map _getTextAndStyles(PlayerActedState action) {
    String text = action.action.toString().split('.').last;
    Color textColor;
    Color shadowColor;

    switch (action.action) {
      case HandActions.CALL:
        textColor = const Color(0xff55DF00);
        shadowColor = const Color(0xffDFE7E4);
        break;

      case HandActions.CHECK:
        textColor = const Color(0xff55DF00);
        shadowColor = const Color(0xffDFE7E4);
        break;

      case HandActions.BET:
        textColor = const Color(0xffCE3A3B);
        shadowColor = const Color(0xff865750);
        break;

      case HandActions.RAISE:
        textColor = const Color(0xffCE3A3B);
        shadowColor = const Color(0xff865750);
        break;

      case HandActions.FOLD:
        textColor = const Color(0xffF4F4F4);
        shadowColor = const Color(0xff00FFB1);
        break;

      case HandActions.ALLIN:
        text = 'ALL IN';
        textColor = const Color(0xffF6E014);
        shadowColor = const Color(0xffDAE886);
        break;

      default:
        return null;
    }

    return {
      'text': text,
      'color': textColor,
      'shadow': shadowColor,
    };
  }

  Widget _buildText(PlayerActedState action) {
    final textColorShadow = _getTextAndStyles(action);
    if (textColorShadow == null) return const SizedBox.shrink();

    return Text(
      textColorShadow['text'],
      style: TextStyle(
        color: textColorShadow['color'],
        fontSize: 20.dp,
        fontWeight: FontWeight.w900,
        shadows: [
          Shadow(
            offset: Offset(3.0, 3.0),
            blurRadius: 2.pw,
            color: textColorShadow['shadow'],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (myAction == null) return const SizedBox.shrink();

    // show animating view
    return Align(
      child: TweenAnimationBuilder(
        key: UniqueKey(),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        child: _buildText(myAction),
        builder: (_, anim, child) => Transform.translate(
          offset: Offset(0, -100.pw * anim),
          child: Opacity(opacity: 1 - anim, child: child),
        ),
      ),
    );
  }
}
