import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/card_back.dart';
import 'package:provider/provider.dart';

const cardWidth = AppDimensions.cardWidth * 3.0;
const delayConst = 10;

class AnimatingShuffleCardView extends StatefulWidget {
  @override
  _AnimatingShuffleCardViewState createState() =>
      _AnimatingShuffleCardViewState();
}

class _AnimatingShuffleCardViewState extends State<AnimatingShuffleCardView> {
  String cardBackAsset;

  double getXTarget(int i, var randomizer) =>
      (cardWidth / 2 + cardWidth * randomizer.nextDouble());

  final _noOfCards = 52;
  final List<CardBack> _cards = [];

  void _animateCards() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animate();
  }

  void _animateCardsReverse() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animateReverse();
  }

  void _animateDispose() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animateDispose();
  }

  Future<void> _playAnimation() async {
    _animateCards();

    // wait till the fist half of animation finishes
    await Future.delayed(AppConstants.animationDuration);

    setState(() {
      var tmp = _cards.reversed.toList();
      _cards.clear();
      _cards.addAll(tmp);
    });

    _animateCardsReverse();

    // wait till the second half of animation finishes
    await Future.delayed(AppConstants.animationDuration);

    setState(() {
      var tmp = _cards.reversed.toList();
      _cards.clear();
      _cards.addAll(tmp);
    });
  }

  void _initAnimate() async {
    var randomizer = math.Random();

    for (int i = 0; i < _noOfCards; i++) {
      CardBack card = CardBack(
        cardBackImageAsset: cardBackAsset,
        dx: 0,
        dy: 0,
        xTarget: getXTarget(i, randomizer),
        yTarget: 0,
        delay: delayConst * i,
      );

      if (randomizer.nextBool()) {
        card.xTarget *= -1;
      } else {}

      _cards.add(card);
    }

    /* wait for a brief moment before starting animation */
    await Future.delayed(AppConstants.animationDuration);

    await _playAnimation();
  }

  void init() async {
    String cardBackAssetImage = CardBackAssets.getRandom();

    try {
      cardBackAssetImage = Provider.of<ValueNotifier<String>>(
        context,
        listen: false,
      ).value;
    } catch (e) {}

    cardBackAsset = cardBackAssetImage;

    _initAnimate();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();

    _animateDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _cards.map((c) => c.widget).toList(),
    );
  }
}
