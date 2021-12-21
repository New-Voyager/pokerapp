enum BoxType {
  EMOJI_BOX,
  USER_SETTINGS_BOX,
  FAV_GIF_BOX,
  PROFILE_BOX,
  GAME_SETTINGS_BOX,
  GAME_HISTORY_BOX,
  GAME_TEMPLATE_BOX,
  CACHE_GIF_BOX,
}

extension BoxTypeParsing on BoxType {
  String value() => this.toString().split('.').last;
}
