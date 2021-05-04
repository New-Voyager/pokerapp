import 'package:flutter/material.dart';

class IconWithBadge extends StatelessWidget {
  final Function onClickFunction;
  final int count;
  final Widget child;

  IconWithBadge({this.child, this.count, this.onClickFunction});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClickFunction,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(5),
            child: child,
          ),
          Visibility(
            // get approval count and check condition > 0
            visible: count > 0,
            child: Positioned(
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Text(
                    // pending approval count
                    "$count",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
                top: 0,
                right: 0),
          ),
        ],
      ),
    );
  }
}
