import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/card_back.dart';
import 'package:provider/provider.dart';

const cardWidth = AppDimensions.cardWidth * 3.0;

class AnimatingShuffleCardView extends StatefulWidget {
  @override
  _AnimatingShuffleCardViewState createState() =>
      _AnimatingShuffleCardViewState();
}

class _AnimatingShuffleCardViewState extends State<AnimatingShuffleCardView>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;

  double getXTarget(int i, var randomizer) {
    double multiplier = randomizer.nextDouble() < 0.5 ? -1.0 : 1.0;
    return ((i + 1) * cardWidth / 10 * randomizer.nextDouble()) * multiplier;
  }

  final _noOfCards = 20;
  final List<CardBack> _cards = [];

  void init() {
    String cardBackAssetImage = CardBackAssets.getRandom();

    try {
      cardBackAssetImage = Provider.of<ValueNotifier<String>>(
        context,
        listen: false,
      ).value;
    } catch (e) {
      log('animating_shuffle_card_view.dart : $e');
    }

    var randomizer = math.Random();
    for (int i = 0; i < _noOfCards; i++) {
      _cards.add(
        CardBack(
          cardBackImageAsset: cardBackAssetImage,
          xTarget: getXTarget(i, randomizer),
          yTarget: -i * 1 / 3,
        ),
      );
    }

    AnimationController _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad,
      ),
    );

    /* drive the animation forward */
    _animationController.forward();
    _animationController.addListener(() {
      /* this block is reached only when the forward animation completes */
      if (_animationController.isCompleted &&
          _animationController.value == _animationController.upperBound) {
        _animationController.reverse();
      }

      /* the following block is reached only when the backward animation completes */
      if (_animationController.isDismissed &&
          _animationController.value == _animationController.lowerBound) {
        /* change the xTarget positions of the cards */
        for (int i = 0; i < _cards.length; i++) {
          _cards[i].xTarget = getXTarget(i, randomizer);
        }

        _animationController.forward();
      }
    });
  }

  List<Widget> getWidgets() {
    double e = _animation.value;

    List<Widget> widgets = [];

    for (int i = 0; i < _cards.length; i++) {
      _cards[i].dx = e * _cards[i].xTarget;
      _cards[i].dy = e * _cards[i].yTarget;

      widgets.add(_cards[i].widget);
    }

    return widgets.reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: getWidgets(),
      ),
    );
  }
}
