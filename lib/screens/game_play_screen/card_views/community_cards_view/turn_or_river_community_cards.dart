/*
*
* RIVER / TURN CARD ANIMATIONS & DISPLAY
*
* */
import 'package:flutter/material.dart';

class TurnOrRiverCommunityCards extends StatefulWidget {
  final List<Widget> riverOrTurnCards;

  TurnOrRiverCommunityCards({
    Key key,
    @required this.riverOrTurnCards,
  }) : super(key: key);

  @override
  _TurnOrRiverCommunityCardsState createState() =>
      _TurnOrRiverCommunityCardsState();
}

class _TurnOrRiverCommunityCardsState extends State<TurnOrRiverCommunityCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.riverOrTurnCards,
    );
  }
}
