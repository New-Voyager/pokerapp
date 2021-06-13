enum BoxType { EMOJI_BOX, GAME_SETTINGS }

extension BoxTypeParsing on BoxType {
  String value() => this.toString().split('.').last;
}
