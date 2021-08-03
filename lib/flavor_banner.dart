import 'package:flutter/material.dart';

import 'flavor_config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  final BannerConfig bannerConfig;
  FlavorBanner({@required this.child, @required this.bannerConfig});
  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.of(context).flavorName == Flavor.PROD.toString())
      return child;
    return Stack(
      children: <Widget>[child, _buildBanner(context)],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
            message: bannerConfig.bannerName,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: bannerConfig.bannerColor),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;

  BannerConfig(this.bannerName, this.bannerColor);
}
