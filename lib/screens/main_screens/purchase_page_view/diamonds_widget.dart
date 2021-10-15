import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class DiamondWidget extends StatefulWidget {
  final int diamonds;
  final int addeddiamonds;
  final bool animate;
  DiamondWidget(this.diamonds, this.addeddiamonds, this.animate) {
    //log('diamonds: constructor animate: $animate');
  }

  @override
  _DiamondWidgetState createState() {
    //log('diamonds: createState animate: $animate');
    final state = _DiamondWidgetState(animate);
    return state;
  }
}

class _DiamondWidgetState extends State<DiamondWidget> {
  // bool animate = false;
  // int diamonds = 0;
  // int addeddiamonds = 0;
  Tween<double> tween = Tween<double>(begin: 0, end: 1);
  _DiamondWidgetState(bool animate);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //log('diamonds: animate: ${widget.animate}');
    List<Widget> children = [];
    AppTheme theme = AppTheme.getTheme(context);
    // if no time left in the bank return empty container

    // if (widget.diamonds <= 0) {
    //   return Container();
    // }

    final Widget coin = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: SvgPicture.asset(
            'assets/images/diamond.svg',
            height: 24.pw,
            width: 24.pw,
            color: Colors.cyan,
          ),
        ),
        Text(widget.diamonds.toString()),
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
          String symbol = '+';
          if (widget.addeddiamonds < 0) {
            symbol = '-';
          }
          //log('diamonds: animating time: value: $v');
          return Opacity(
            opacity: 1 - v,
            child: Transform.translate(
              offset: Offset(-35.pw, -v * 10.ph),
              child: Text(
                symbol + widget.addeddiamonds.toString(),
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
