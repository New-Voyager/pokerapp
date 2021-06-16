enum BoxType {
  EMOJI_BOX,
  USER_SETTINGS_BOX,
}

extension BoxTypeParsing on BoxType {
  String value() => this.toString().split('.').last;
}
