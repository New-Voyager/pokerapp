import 'package:flutter/material.dart';
import 'package:pokerapp/screens/game_play_screen/board_view.dart';

/*
* This is the screen which will have contact with the NATS server
* Every sub view of this screen will update according to the data fetched from the NATS
* */

class GamePlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: _screenBackgroundDecoration,
          child: Column(
            children: [
              // header section
              Container(height: 50.0),

              // main board view
              Expanded(child: BoardView()),

              // footer section
              Container(height: 150.0),
            ],
          ),
        ),
      ),
    );
  }
}

/* design constants */
const _screenBackgroundDecoration = const BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xff353535),
      const Color(0xff464646),
      Colors.black,
    ],
  ),
);
