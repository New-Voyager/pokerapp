import 'package:flutter/material.dart';

class DebugBorderWidget extends StatelessWidget {
  final Widget child;
  final Color color;

  const DebugBorderWidget({
    Key key,
    this.child,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: color, width: 2.0),
                  color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
