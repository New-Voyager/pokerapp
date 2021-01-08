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
  final _noOfCards = 52;
  final List<CardBack> _cards = [];

  String cardBackAsset;

  Future<void> _animationWait() => Future.delayed(
        Duration(
          milliseconds: AppConstants.animationDuration.inMilliseconds +
              _cards.length * delayConst,
        ),
      );

  double getXTarget(int i, var randomizer) =>
      (cardWidth / 2 + cardWidth / 2 * randomizer.nextDouble());

  void _animateCards() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animate();
  }

  void _animateCardsReverse() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animateReverse();
  }

  void _animateDispose() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animateDispose();
  }

  /* this method, makes the mixing of cards looks more realistic */
  /* swap the positions of left and right cards, without changing their particular
  order in either left or right sides */
  void _processCards() {
    int leftPtr = 0; // points to a -ve xTargetElement
    int rightPtr = 0; // points to a +ve xTargetElement

    while (leftPtr < _noOfCards && rightPtr < _noOfCards) {
      // leftPtr find a -ve element
      while (leftPtr < _noOfCards) {
        if (_cards[leftPtr].xTarget < 0)
          break;
        else
          leftPtr++;
      }

      if (leftPtr >= _noOfCards) break;

      // rightPtr find a +ve element
      while (rightPtr < _noOfCards) {
        if (_cards[rightPtr].xTarget > 0)
          break;
        else
          rightPtr++;
      }

      if (rightPtr >= _noOfCards) break;

      // swap leftPtr element and rightPtr element
      if (leftPtr < _noOfCards && rightPtr < _noOfCards) {
        var temp = _cards[leftPtr];
        _cards[leftPtr] = _cards[rightPtr];
        _cards[rightPtr] = temp;
      } else {
        break;
      }

      leftPtr++;
      rightPtr++;
    }
  }

  /* this method sorts the cards as per the initial index value */
  /* as delay is in sorted order, the array is thus sorted using delay */
  void _normalizeCards() {
    var randomizer = math.Random();

    _cards.sort((a, b) => a.delay.compareTo(b.delay));

    /* initiate with new xTargetValue */
    for (int i = 0; i < _cards.length; i++) {
      _cards[i].xTarget = getXTarget(i, randomizer);
      if (randomizer.nextBool()) _cards[i].xTarget *= -1;
    }
  }

  Future<void> _playAnimation() async {
    _animateCards();

    // wait till the fist half of animation finishes
    await _animationWait();
    setState(() => _processCards());
    _animateCardsReverse();

    // wait till the second half of animation finishes
    await _animationWait();
    setState(() => _normalizeCards());
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
    await _playAnimation();
    await _playAnimation();
    await _playAnimation();
    await _playAnimation();
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
