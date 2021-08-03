import 'package:flutter/widgets.dart';

class Theme extends ChangeNotifier {
  // main color that the app is based on
  // todo: we can have multiple shades of the main color
  Color primaryColor;

  // color that is used on buttons or other highlighting places
  Color secondaryColor;

  // accent color that works with the main color in the app
  // todo: we may have multiple shades of the accent color
  Color accentColor;

  // color that is used for filling inside text fields, or cards views
  Color fillInColor;

  // supporting color: color that is used to create constrast with main color and accent color
  // todo: we may have different shades of the supporting color
  Color supportingColor;
}
