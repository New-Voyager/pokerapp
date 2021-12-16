import 'dart:ui';

class ScreenAttributeObject {
  String base;
  String name;
  List<String> models;
  double diagonalMinSize;
  double diagonalMaxSize;
  Size screenSize;
  bool defaultAttribs;

  Map<String, dynamic> attribs;

  ScreenAttributeObject(Map<String, dynamic> map) {
    this.base = map['base'];
    this.name = map['name'];
    this.models = map['models'] != null ? map['models'].cast<String>() : null;
    this.diagonalMinSize = map['diagonalMinSize'];
    this.diagonalMaxSize = map['diagonalMaxSize'];
    String screenSizeStr = map['screenSize'];
    this.screenSize = Size(double.parse(screenSizeStr.split(",")[0].trim()),
        double.parse(screenSizeStr.split(",")[1].trim()));
    this.defaultAttribs = map['defaultAttribs'];

    this.attribs = map;
  }

  Map<String, dynamic> getAttribs() {
    return attribs;
  }

  bool modelMatches(String model) {
    if (models != null && models.contains(model)) {
      return true;
    }

    return false;
  }

  bool screenSizeMatches(Size size) {
    if (screenSize != null && screenSize == size) {
      return true;
    }
    return false;
  }

  bool diagonalSizeMatches(double size) {
    if (diagonalMinSize != null &&
        diagonalMaxSize != null &&
        size >= diagonalMinSize &&
        size <= diagonalMaxSize) {
      return true;
    }
    return false;
  }
}
