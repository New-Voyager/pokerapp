/*
*
* FLOP CARD VIEW (ANIMATION & FLOP CARDS DISPLAY)
*
* */

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';

class FlopCommunityCards extends StatefulWidget {
  final List<Widget> flopCards;

  FlopCommunityCards({
    @required this.flopCards,
  });

  @override
  _FlopCommunityCardsState createState() => _FlopCommunityCardsState();
}

class _FlopCommunityCardsState extends State<FlopCommunityCards> {
  @override
  void initState() {
    print('\n\n\n\noffset positions:\n'
        '${CommunityCardAttribute.cardOffsets}\n'
        '\n\n\n\n');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.flopCards,
    );
  }
}
