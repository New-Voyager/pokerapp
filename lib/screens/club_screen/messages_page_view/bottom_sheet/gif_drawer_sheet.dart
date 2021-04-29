import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:tenor/tenor.dart';

// FIXME : is it duplicate of game_giphies.dart?
class GifDrawerSheet extends StatefulWidget {
  @override
  _GifDrawerSheetState createState() => _GifDrawerSheetState();
}

class _GifDrawerSheetState extends State<GifDrawerSheet> {
  List<TenorResult> _gifs;
  Timer _timer;

  Future<List<TenorResult>> _fetchGifs({String query}) async {
    setState(() {
      _gifs = null;
    });

    if (query == null || query.isEmpty) return TenorService.getTrendingGifs();

    // else fetch from search
    return TenorService.getGifsWithSearch(query);
  }

  @override
  void initState() {
    _fetchGifs().then(
      (value) => setState(() {
        _gifs = value;
      }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackgroundColor,
      height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          /* search bar */

          Container(
            decoration: BoxDecoration(
              color: AppColors.contentColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              style: TextStyle(
                color: AppColors.lightGrayColor,
              ),
              onChanged: (String text) {
                if (text.trim().isEmpty) return;

                if (_timer?.isActive ?? false) _timer.cancel();

                _timer = Timer(const Duration(milliseconds: 800), () {
                  _fetchGifs(query: text.trim()).then(
                    (value) => setState(() {
                      _gifs = value;
                    }),
                  );
                });
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.search,
                  color: AppColors.lightGrayColor,
                  size: 18.0,
                ),
                hintText: 'Search GIFs via Giphy',
                hintStyle: TextStyle(
                  color: AppColors.lightGrayColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          /* GIFs */
          Expanded(
            child: _gifs == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _gifs.isEmpty
                    ? Center(
                        child: Text('Nothing Found'),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          children: _gifs.map((TenorResult gif) {
                            return GestureDetector(
                              onTap: () => Navigator.pop(context, gif.url),
                              child: CachedNetworkImage(
                                imageUrl: gif.media.gif.url,
                                placeholder: (_, __) => Icon(
                                  FontAwesomeIcons.image,
                                  size: 50.0,
                                  color: AppColors.lightGrayColor,
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
