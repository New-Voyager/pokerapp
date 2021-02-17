import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/resources/app_assets.dart';

class BackgroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.barBookshelfBackground,
      fit: BoxFit.contain,
    );
  }
}
