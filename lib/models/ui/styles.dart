import 'package:flutter/material.dart';

class ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFC9A13B), Color(0xFFEDCA70), Color(0xFF755605)],
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
    // shadows: <Shadow>[
    //   Shadow(
    //     offset: Offset(0, 0),
    //     blurRadius: 5.0,
    //     color: Color.fromARGB(180, 0, 0, 0),
    //   ),
    // ],
  );

  Color iconColor = Color(0xFFFFF6D7);
}

class GoldButtonStyle extends ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFC9A13B), Color(0xFFEDCA70), Color(0xFF755605)],
    stops: [0, 0.6, 1],
  );

  LinearGradient disabledGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF87806E), Color(0xFF24211A)],
    stops: [0, 1],
  );

  LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFC9A13B),
      Color(0xFF755605),
    ],
    stops: [0, 1],
  );

  LinearGradient disabledBorderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF87806E),
      Color(0xFF3B3830),
    ],
    stops: [0, 1],
  );

  TextStyle textStyle = TextStyle(
    color: Color(0xFF544523),
    fontWeight: FontWeight.bold,
    // shadows: <Shadow>[
    //   Shadow(
    //     offset: Offset(0, 0),
    //     blurRadius: 5.0,
    //     color: Color.fromARGB(180, 0, 0, 0),
    //   ),
    // ],
  );

  Color iconColor = Color(0xFF544523);
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

class BlueButtonStyle extends ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF69C2DE), Color(0xFF3D8AB6)],
    stops: [0, 1],
  );

  LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFA3E9FF),
      Color(0xFF174D6B),
    ],
    stops: [0, 1],
  );

  TextStyle textStyle = TextStyle(
    color: Color(0xFFEDFFDF),
    fontWeight: FontWeight.bold,
    // shadows: <Shadow>[
    //   Shadow(
    //     offset: Offset(0, 0),
    //     blurRadius: 5.0,
    //     color: Color.fromARGB(180, 0, 0, 0),
    //   ),
    // ],
  );

  Color iconColor = Color(0xFFFFFAEF);

  LinearGradient disabledGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF6E8387), Color(0xFF1A2024)],
    stops: [0, 1],
  );

  LinearGradient disabledBorderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6E8387),
      Color(0xFF30393B),
    ],
    stops: [0, 1],
  );
}

class OrangeButtonStyle extends ThemedButtonStyle {
  LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF8D4E), Color(0xFFA33A0E)],
    stops: [0, 1],
  );

  LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFC2A0),
      Color(0xFFA33A0E),
    ],
    stops: [0, 1],
  );

  TextStyle textStyle = TextStyle(
    color: Color(0xFFEDFFDF),
    fontWeight: FontWeight.bold,
    // shadows: <Shadow>[
    //   Shadow(
    //     offset: Offset(0, 0),
    //     blurRadius: 5.0,
    //     color: Color.fromARGB(180, 0, 0, 0),
    //   ),
    // ],
  );

  Color iconColor = Color(0xFFFFFAEF);
}
