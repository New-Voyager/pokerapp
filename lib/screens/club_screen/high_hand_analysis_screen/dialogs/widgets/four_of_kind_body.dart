import 'package:flutter/material.dart';

class FourOfKindBody extends StatelessWidget {
  final ValueNotifier<List<int>> cards;

  FourOfKindBody({
    @required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Four of Kind"),
    );
  }
}
