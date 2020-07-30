import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TabBarItem extends StatelessWidget {
  TabBarItem({
    @required this.title,
    @required this.iconData,
  });

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(iconData),
        SizedBox(height: 5.0),
        Text(
          title ?? 'Title',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
