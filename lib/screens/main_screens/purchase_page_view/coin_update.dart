import 'dart:developer';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class CoinWidget extends StatefulWidget {
  final int coins;
  final int addedCoins;
  final bool animate;
  CoinWidget(this.coins, this.addedCoins, this.animate) {
    //log('Coins: constructor animate: $animate');
  }

  @override
  _CoinWidgetState createState() {
    //log('Coins: createState animate: $animate');
    final state = _CoinWidgetState(animate);
    return state;
  }
}

class _CoinWidgetState extends State<CoinWidget> {
  // bool animate = false;
  // int coins = 0;
  // int addedCoins = 0;
  Tween<double> tween = Tween<double>(begin: 0, end: 1);
  _CoinWidgetState(bool animate);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //log('Coins: animate: ${widget.animate}');
    List<Widget> children = [];
    AppTheme theme = AppTheme.getTheme(context);
    // if no time left in the bank return empty container

    if (widget.coins <= 0) {
      return Container();
    }

    final Widget coin = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Image.asset(
            'assets/images/appcoin.png',
            height: 24.pw,
            width: 24.pw,
          ),
        ),
        Text(widget.coins.toString()),
      ],
    );

    children.add(coin);

    Widget appCoin = Container(
      key: UniqueKey(),
      child: Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.white.withOpacity(0.50),
        child: coin,
      ),
    );
    children.add(appCoin);

    if (widget.animate) {
      TweenAnimationBuilder animation = TweenAnimationBuilder<double>(
        tween: tween,
        onEnd: () {
          //tween.end = 0;
          //widget.animate = false;
          setState(() {});
        },
        duration: const Duration(milliseconds: 1000),
        builder: (BuildContext context, double v, Widget child) {
          //log('Coins: animating time: value: $v');
          return Opacity(
            opacity: 1 - v,
            child: Transform.translate(
              offset: Offset(-35.pw, -v * 10.ph),
              child: Text(
                '+' + widget.addedCoins.toString(),
                style: TextStyle(
                  fontSize: 10.dp,
                  color: theme.accentColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        },
      );
      children.add(animation);
    }
    return Stack(
      alignment: Alignment.center,
      children: children,
    );
  }
}
