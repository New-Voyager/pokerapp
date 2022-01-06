import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

class AttributedGifWidget extends StatelessWidget {
  final String url;

  AttributedGifWidget({
    @required this.url,
  });

  @override
  Widget build(BuildContext context) => url != null
      ? Stack(
          alignment: Alignment.topLeft,
          children: [
            // image
            CachedNetworkImage(
              width: 160,
              height: 120,
              imageUrl: url,
              placeholder: (_, __) => Center(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(),
                ),
              ),
              fit: BoxFit.scaleDown,
            ),

            // attribution
            IntrinsicWidth(
              child: Container(
                color: Colors.white70,
                padding: EdgeInsets.all(5.0),
                child: Image.asset(
                  AppAssets.tenorAttributionImage,
                  width: 20.0,
                ),
              ),
            ),
          ],
        )
      : Container();
}
