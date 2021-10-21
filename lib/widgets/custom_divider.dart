import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: 16,
      indent: 16,
      color: Colors.grey.withOpacity(0.5),
    );
  }
}
