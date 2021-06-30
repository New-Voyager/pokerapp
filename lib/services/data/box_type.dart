enum BoxType { EMOJI_BOX, USER_SETTINGS_BOX, FAV_GIF_BOX, PROFILE_BOX }

extension BoxTypeParsing on BoxType {
  String value() => this.toString().split('.').last;
}
