import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_result.dart';
import 'package:pokerapp/utils/utils.dart';

class GifListWidget extends StatelessWidget {
  final List<TenorResult> gifs;
  final onGifSelect;
  final void Function(TenorResult) onBookMark;
  final void Function(TenorResult) onRemoveBookMark;

  GifListWidget({
    @required this.gifs,
    @required void this.onGifSelect(String _),
    this.onBookMark,
    this.onRemoveBookMark,
  });

  @override
  Widget build(BuildContext context) => gifs?.isEmpty ?? true
      ? Center(child: Text('No Gifs'))
      : StaggeredGridView.countBuilder(
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
            /* the preview URL can be a local one: from cache */
            final String previewUrl = gif.previewUrl;

            /* we use this dimension to show the placeholder */
            Size gifSize = gif.size;
            if (gifSize == null) {
              gifSize = Size(50, 50);
            }

            Widget image;
            if (gif.cache != null) {
              image = Image.file(File(gif.cache));
            } else {
              image = CachedNetworkImage(
                imageUrl: previewUrl,
                cacheManager: ImageCacheManager.instance,
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
              );
            }

            Widget mainGifWidget = GestureDetector(
                // WE SEND BACK THE PREVIEW URL AS WE DONT CARE ABOUT
                // GOOD QUALITY GIFS
                onTap: () {
                  onGifSelect(previewUrl);
                },
                child: image);

            if (onRemoveBookMark != null)
              return Stack(
                children: [
                  // main gif widget
                  mainGifWidget,

                  // bookmark widget
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () => onRemoveBookMark?.call(gif),
                      child: Icon(Icons.bookmark_remove_rounded),
                    ),
                  ),
                ],
              );

            if (onBookMark != null)
              return Stack(
                children: [
                  // main gif widget
                  mainGifWidget,

                  // bookmark widget
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () => onBookMark?.call(gif),
                      child: Icon(
                        GameService.isGifFavourite(gif)
                            ? Icons.bookmark_added_rounded
                            : Icons.bookmark_add_outlined,
                      ),
                    ),
                  ),
                ],
              );

            // if there is no callback registered, build the main widget only
            return mainGifWidget;
          },
        );
}

/*
 /* attribution */
                IntrinsicWidth(
                  child: Container(
                    color: Colors.white60,
                    padding: EdgeInsets.all(5.0),
                    child: Image.asset(
                      AppAssets.tenorAttributionImage,
                      width: 50.0,
                    ),
                  ),
                ),
*/
