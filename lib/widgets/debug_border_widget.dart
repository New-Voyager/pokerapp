import 'package:flutter/material.dart';
import 'package:pokerapp/services/test/test_service.dart';

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
    if (!TestService.isTesting) return child;

    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2.0),
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
