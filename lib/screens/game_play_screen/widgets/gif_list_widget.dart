import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tenor/tenor.dart';

class GifListWidget extends StatelessWidget {
  final List<TenorResult> gifs;
  final onGifSelect;

  GifListWidget({
    @required this.gifs,
    @required void this.onGifSelect(String _),
  });

  @override
  Widget build(BuildContext context) => StaggeredGridView.countBuilder(
        itemCount: gifs.length,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        staggeredTileBuilder: (_) => StaggeredTile.fit(
          2,
        ),
        itemBuilder: (_, int index) {
          final TenorResult gif = gifs[index];

          if (gif.media.gif == null) return const SizedBox.shrink();

          final String url = gif.media.gif.url;

          /* the preview URL can be a local one: from cache */
          final String previewUrl = gif.media.tinygif.url;

          final bool isLocal = !previewUrl.startsWith('https');

          /* we use this dimension to show the placeholder */
          final Size gifSize = Size(
            gif.media.gif.dims[0].toDouble(),
            gif.media.gif.dims[1].toDouble(),
          );

          print("tiny gif size: ${gif.media.tinygif.size}");
          print("normal gif size: ${gif.media.gif.size}");
          print('size: $gifSize');
          print('$url $previewUrl');

          return GestureDetector(
            onTap: () => onGifSelect(url),
            child: isLocal
                ? Image.file(File(previewUrl))
                : CachedNetworkImage(
                    imageUrl: previewUrl,
                    progressIndicatorBuilder: (
                      context,
                      url,
                      downloadProgress,
                    ) =>
                        AspectRatio(
                      aspectRatio: gifSize.width / gifSize.height,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                  ),
          );
        },
      );
}
