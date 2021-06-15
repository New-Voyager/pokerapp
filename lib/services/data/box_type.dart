enum BoxType { EMOJI_BOX }

extension BoxTypeParsing on BoxType {
  String value() => this.toString().split('.').last;
}