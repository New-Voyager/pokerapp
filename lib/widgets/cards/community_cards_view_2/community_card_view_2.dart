import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/community_flip_card.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';

class _CardWidget extends StatelessWidget {
  final CardState cardState;

  const _CardWidget({Key key, @required this.cardState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset position = cardState.position;

    if (cardState.startPos != null && cardState.useStartPos) {
      position = cardState.startPos;
    }
    developer.log(
        'CommunityCard: _CardWidget build ${cardState.cardId} position: ${position}');
    Widget widget;
    if (cardState.slide) {
      widget = AnimatedPositioned(
        duration: AppConstants.communityCardAnimationDuration,
        left: position.dx,
        top: position.dy,
        child: CommunityFlipCard(cardState: cardState),
      );
    } else {
      widget = Positioned(
        left: position.dx,
        top: position.dy,
        child: CommunityFlipCard(cardState: cardState),
      );
    }
    cardState.fade = false;
    if (cardState.fade) {
      widget = AnimatedSwitcher(
        switchInCurve: Curves.easeInOutExpo,
        switchOutCurve: Curves.easeInOut,
        duration: Duration.zero,
        reverseDuration: AppConstants.cardThrowAnimationDuration,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (context, child) {
              return Transform.scale(
                alignment: Alignment.topCenter,
                scale: max(animation.value, 0.60),
                child: child,
              );
            },
          ),
        ),
        child: widget,
      );
    }
    return widget;
    // if (PlatformUtils.isWeb) {
    //   return Positioned(
    //     left: position.dx,
    //     top: position.dy,
    //     child: CommunityFlipCard(cardState: cardState),
    //   );
    // }
    // return AnimatedPositioned(
    //   duration: AppConstants.communityCardAnimationDuration,
    //   left: position.dx,
    //   top: position.dy,
    //   child: CommunityFlipCard(cardState: cardState),
    // );
  }
}

class CommunityCardView2 extends StatelessWidget {
  const CommunityCardView2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final gameState = GameState.getState(context);
        final communityCardState = gameState.communityCardState;
        communityCardState.initializeCards(
          Size(constraints.maxWidth, constraints.maxHeight),
        );

        developer.log('Build: CommunityCardView2');
        List<Widget> cards = [];
        int i = 0;
        for (final state in communityCardState.singleBoard) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }
        for (final state in communityCardState.doubleBoard) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        for (final state in communityCardState.ritBoardFlop) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        for (final state in communityCardState.ritBoardFlop1) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        for (final state in communityCardState.ritBoardFlop2) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        for (final state in communityCardState.ritBoardTurn) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        for (final state in communityCardState.ritBoardTurn1) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        for (final state in communityCardState.ritBoardTurn2) {
          Widget stateWidget = getCard(i, state);
          cards.add(stateWidget);
          i++;
        }

        return Stack(alignment: Alignment.center, children: cards);

        return AnimatedBuilder(
          animation: communityCardState,
          builder: (_, __) {
            return AnimatedSwitcher(
              switchInCurve: Curves.easeInOutExpo,
              switchOutCurve: Curves.easeInOut,
              duration: Duration.zero,
              reverseDuration: AppConstants.cardThrowAnimationDuration,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: AnimatedBuilder(
                  animation: animation,
                  child: child,
                  builder: (context, child) {
                    return Transform.scale(
                      alignment: Alignment.topCenter,
                      scale: max(animation.value, 0.60),
                      child: child,
                    );
                  },
                ),
              ),
              child: Stack(alignment: Alignment.center, children: cards),
              // child: communityCardState.cardStates.isEmpty
              //     ? const SizedBox.shrink()
              //     : Stack(
              //         alignment: Alignment.center,
              //         clipBehavior: Clip.none,
              //         children: communityCardState.cardStates
              //             .map((cardState) => DebugBorderWidget(
              //                 child: _CardWidget(cardState: cardState)))
              //             .toList(),
              //       ),
            );
          },
        );
      },
    );
  }

  Widget getCard(int i, CardState state) {
    List<Color> colors = [
      Colors.red,
      Colors.amber,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.white,
      Colors.blueGrey,
      Colors.cyan,
      Colors.pink,
      Colors.indigo,
      Colors.lightBlue,
    ];
    Widget hide = Positioned(
        top: state.position.dy,
        left: state.position.dx,
        child: DebugBorderWidget(
            color: Colors.transparent,
            child: Container(
              width: state.size.width,
              height: state.size.height,
              color: Colors.transparent,
            )));

    Widget stateWidget = ListenableProvider<CardState>(
        create: (_) => state,
        builder: (BuildContext context, _) =>
            Consumer<CardState>(builder: (_, __, ___) {
              developer.log(
                  'CommunityCard: Build state: singleBoard: ${state.cardId} hide: ${state.hide}');
              Widget widget = _CardWidget(cardState: state);

              return widget;
            }));
    return stateWidget;
  }
}
