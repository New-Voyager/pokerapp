import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/gif_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/app/gifhy_service.dart';

class GifDrawerSheet extends StatefulWidget {
  @override
  _GifDrawerSheetState createState() => _GifDrawerSheetState();
}

class _GifDrawerSheetState extends State<GifDrawerSheet> {
  List<GifModel> _gifs;
  Timer _timer;

  Future<List<GifModel>> _fetchGifs({String query}) async {
    setState(() {
      _gifs = null;
    });

    if (query == null || query.isEmpty) return GiphyService.fetchTrending();

    // else fetch from search
    return GiphyService.fetchQuery(query);
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
      height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text('Powered by Giphy'),
          const SizedBox(height: 10.0),

          /* search bar */

          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGrayColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
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
                  color: Colors.black,
                  size: 18.0,
                ),
                hintText: 'Search GIFs',
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
                          children: _gifs
                              .map((GifModel gif) => GestureDetector(
                                    onTap: () =>
                                        Navigator.pop(context, gif.url),
                                    child: CachedNetworkImage(
                                      imageUrl: gif.previewUrl,
                                      placeholder: (_, __) => Icon(
                                        FontAwesomeIcons.image,
                                        size: 50.0,
                                        color: AppColors.lightGrayColor,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
