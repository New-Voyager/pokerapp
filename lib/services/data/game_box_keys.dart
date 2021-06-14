enum GameBoxKeys { GAME_SETTINGS, HAND1, HAND2 }

extension BoxTypeParsing on GameBoxKeys {
  String value() => this.toString().split('.').last;
}
