import 'package:flutter/material.dart';

class ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3CD89), Color(0xFF877950), Color(0xFF555145)],
    stops: [0, 0.6, 1],
  );

  LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAF0D2),
      Color(0xFF726746),
    ],
    stops: [0, 1],
  );

  TextStyle textStyle = TextStyle(
    color: Color(0xFFFFF6DF),
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 5.0,
        color: Color.fromARGB(180, 0, 0, 0),
      ),
    ],
  );

  Color iconColor = Color(0xFFFFF6D7);
}

class GoldButtonStyle extends ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3CD89), Color(0xFF877950), Color(0xFF555145)],
    stops: [0, 0.6, 1],
  );

  LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAF0D2),
      Color(0xFF726746),
    ],
    stops: [0, 1],
  );

  TextStyle textStyle = TextStyle(
    color: Color(0xFFFFF6DF),
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 5.0,
        color: Color.fromARGB(180, 0, 0, 0),
      ),
    ],
  );

  Color iconColor = Color(0xFFFFF6D7);
}

class GreenButtonStyle extends ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF65AD54), Color(0xFF416C38), Color(0xFF3F7D34)],
    stops: [0, 0.6, 1],
  );

  LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF97D07C),
      Color(0xFF2B4B20),
    ],
    stops: [0, 1],
  );

  TextStyle textStyle = TextStyle(
    color: Color(0xFFEDFFDF),
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 5.0,
        color: Color.fromARGB(180, 0, 0, 0),
      ),
    ],
  );

  Color iconColor = Color(0xFFEDFFDF);
}
