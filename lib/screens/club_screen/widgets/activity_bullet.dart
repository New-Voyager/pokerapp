import 'package:flutter/material.dart';

class ActivityBulletWidget extends StatelessWidget {
  final String type;
  final String columnType;
  const ActivityBulletWidget({Key key, this.type, this.columnType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColor(),
      ),
      height: 16,
    );
  }

  getColor() {
    Color color = Colors.transparent;
    if (columnType == type) {
      switch (type) {
        case 'BUYIN':
          color = Colors.yellow;
          break;
        // STACK
        case 'GAME_RESULT':
          color = Colors.blue;
          break;
      }
    } else if (columnType == 'ADJUSTMENT') {
      switch (type) {
        case 'ADD':
          color = Colors.green;
          break;
        case 'DEDUCT':
          color = Colors.red;
          break;
        case 'CHANGE':
          color = Colors.grey;
          break;
        default:
          break;
      }
    }
    return color;
  }
}
