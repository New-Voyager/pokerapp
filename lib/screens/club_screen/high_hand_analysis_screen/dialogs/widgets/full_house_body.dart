import 'package:flutter/material.dart';

class FullHouseBody extends StatelessWidget {
  final ValueNotifier<List<int>> cards;

  FullHouseBody({
    @required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Full House Body"),
    );
  }
}
