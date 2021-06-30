import 'package:flutter/material.dart';

enum Flavor { DEV, TEST, PROD }

extension FlavorTypeParsing on Flavor {
  String value() => this.toString().split('.').last;
}

class FlavorConfig extends InheritedWidget {
  FlavorConfig({
    @required this.appName,
    @required this.flavorName,
    @required this.apiBaseUrl,
    @required Widget child,
  }) : super(child: child);

  final String appName;
  final String flavorName;
  final String apiBaseUrl;

  static FlavorConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlavorConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
