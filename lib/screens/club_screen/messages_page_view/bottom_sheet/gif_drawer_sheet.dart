import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/gif_list_widget.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:tenor/tenor.dart';

// FIXME : is it duplicate of game_giphies.dart?
class GifDrawerSheet extends StatefulWidget {
  @override
  _GifDrawerSheetState createState() => _GifDrawerSheetState();
}

class _GifDrawerSheetState extends State<GifDrawerSheet> {
  List<TenorResult> _gifs = [];
  Timer _timer;
  bool _isLoading = false;

  _fetchGifs({String query}) async {
    setState(() {
      _isLoading = true;
    });

    _gifs.clear();
    List<TenorResult> list = [];
    if (query == null || query.isEmpty) {
      list = await TenorService.getTrendingGifs();
    }

    // else fetch from search
    list = await TenorService.getGifsWithSearch(query);

    setState(() {
      _gifs.addAll(list);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchGifs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackgroundColor,
      height: MediaQuery.of(context).size.height * 0.75,
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

                _timer = Timer(const Duration(milliseconds: 800), () async {
                  await _fetchGifs(query: text.trim());
                });
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.search,
                  color: AppColors.lightGrayColor,
                  size: 18.0,
                ),
                hintText: 'Search Tenor Gifs',
                hintStyle: TextStyle(
                  color: AppColors.lightGrayColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          /* divider */
          const SizedBox(
            height: 10.0,
          ),

          /* GIFs */
          Expanded(
            child: _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GifListWidget(
                    gifs: _gifs,
                    onGifSelect: (String gifUrl) => Navigator.pop(
                      context,
                      gifUrl,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
