import 'package:flutter/material.dart';

/// derived from the original width & height
/// width: 100
/// height: 80
/// aspect ratio: 5/4 = 1.25
const _aspectRatio = 1.25;

abstract class NamePlateWidgetParent {
  /// this will be the default width, if setWidth is never called
  static double _width = 100;

  /// sets width for a given screen size
  /// Instead of using scale, use setWidth method
  /// The default width is 100
  static void setWidth(double newWidth) {
    assert(newWidth != null);
    _width = newWidth;
  }

  /// returns the current size of name plate widget
  static Size get namePlateSize => Size(_width, _width / _aspectRatio);

  static double get topWidgetOffset => namePlateSize.height * 0.10;

  static Widget build({
    @required Widget child,
    @required BoxDecoration decoration,
    EdgeInsets padding,
  }) {
    return _NamePlateWidgetParent(
      child: child,
      size: namePlateSize,
      decoration: decoration,
      padding: padding,
    );
  }
}

class _NamePlateWidgetParent extends StatelessWidget {
  final Widget child;
  final Size size;
  final BoxDecoration decoration;
  final EdgeInsets padding;

  const _NamePlateWidgetParent({
    Key key,
    @required this.child,
    @required this.size,
    @required this.decoration,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}
