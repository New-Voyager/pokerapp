import 'dart:convert';
import 'dart:ui';

import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/iphone_attributes.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/screen_attribute_object.dart';

class ScreenAttributes {
  static List<ScreenAttributeObject> allAttribs = [];

  static void buildList() {
    allAttribs = [];
    List<dynamic> decodedJson = jsonDecode(iPhoneAttribs);
    for(final json in decodedJson) {
      final attribs = ScreenAttributeObject(json);
      allAttribs.add(attribs);
    }
  }

  static Map<String, dynamic> getScreenAttribs(
      String modelName, double diagnoalSize, Size screenSize) {
    ScreenAttributeObject screenAttributeObject = null;
    for(final attribs in allAttribs) {
      if (attribs.modelMatches(modelName)) {
        screenAttributeObject = attribs;
        break;
      }
    }

    if (screenAttributeObject == null) {
      for(final attribs in allAttribs) {
        if (attribs.screenSizeMatches(screenSize)) {
          screenAttributeObject = attribs;
          break;
        }
      }
    }

    if (screenAttributeObject == null) {
      for(final attribs in allAttribs) {
        if (attribs.diagonalSizeMatches(diagnoalSize)) {
          screenAttributeObject = attribs;
          break;
        }
      }
    }

    if (screenAttributeObject == null) {
      for(final attribs in allAttribs) {
        if (attribs.defaultAttribs ?? false) {
          screenAttributeObject = attribs;
          break;
        }
      }
    }
    if (screenAttributeObject != null) {
      Map<String, dynamic> attribs = screenAttributeObject.getAttribs();
      Map<String, dynamic> baseAttribs = Map<String, dynamic>();
      if (screenAttributeObject.base != null &&
          screenAttributeObject.base.isNotEmpty) {
        baseAttribs = _getBaseAttribs(screenAttributeObject.base);
        ScreenAttributes.updateMap(baseAttribs, attribs);
        attribs = baseAttribs;
      }
      return attribs;
    } else {
      return null;
    }
  }

  static Map<String, dynamic> _getBaseAttribs(String name) {
    ScreenAttributeObject attribsObject =
        allAttribs.firstWhere((element) => element.name == name);

    Map<String, dynamic> attribs = attribsObject.getAttribs();
    Map<String, dynamic> baseAttribs = Map<String, dynamic>();
    if (attribsObject.base != null && attribsObject.base.isNotEmpty) {
      baseAttribs = _getBaseAttribs(attribsObject.base);
      ScreenAttributes.updateMap(baseAttribs, attribs);
    }
    return attribs;
  }

  static void updateMap(Map<String, dynamic> defaultMap, Map<String, dynamic> updates) {
    for (final key in defaultMap.keys) {
      final val = defaultMap[key];
      if (updates.containsKey(key)) {
        if (val is Map) {
          updateMap(val, updates[key]);
        } else {
          defaultMap[key] = updates[key];
        }
      }
    }
  }  

}
