import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/gif_list_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_result.dart';

import 'package:pokerapp/utils/gif_category_model.dart';
import 'package:pokerapp/utils/utils.dart';

class NewGifWidget extends StatefulWidget {
  final List<String> gifSuggestions;
  final void Function(String) onGifSelect;

  NewGifWidget({
    this.gifSuggestions = const [],
    @required this.onGifSelect,
  }) : assert(gifSuggestions != null);

  @override
  _NewGifWidgetState createState() => _NewGifWidgetState();
}

class _NewGifWidgetState extends State<NewGifWidget> {
  Timer _timer;
  bool showCategories = true;
  bool showCategoryItems = false;
  String selectedCategory = '';
  List<GifCategoryModel> gifCategories = [];
  List<TenorResult> _gifs = [];
  bool loading = false;

  /// SERVICE FUNCTIONS

  _fetchGifCategories() async {
    // if (appState.memeCache != null) {
    //   gifCategories = appState.memeCache;
    //   return;
    // }

    List<TenorResult> favouriteGifs = await GameService.fetchFavouriteGifs();
    if (favouriteGifs.length != 0) {
      gifCategories.add(GifCategoryModel("Favourite", favouriteGifs[0]));
    }
    for (final element in widget.gifSuggestions) {
      try {
        List<TenorResult> gif =
            await TenorService.getGifsWithSearch(element, limit: 1);
        gifCategories.add(GifCategoryModel(element, gif[0]));
      } catch (err) {}
    }
    log('Gif categories: ${gifCategories.length}');
  }

  Future<List<TenorResult>> _fetchGifs({String query}) async {
    setState(() => _gifs = null);

    if (query == null || query.isEmpty) {
      return TenorService.getTrendingGifs();
    }

    // else fetch from search
    return TenorService.getGifsWithSearch(query);
  }

  /// WIDGET BUILDING FUNCTIONS
  _buildTopBarSearchWidget() => Align(
        alignment: Alignment.centerRight,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            style: TextStyle(color: Colors.white),
            onChanged: (String text) {
              if (text.trim().isEmpty) text = 'Poker';

              if (_timer?.isActive ?? false) _timer.cancel();

              if (text.trim() == "Poker") {
                showCategories = true;
              } else {
                showCategories = false;
              }
              /* we should wait before calling the API */
              _timer = Timer(const Duration(milliseconds: 500), () {
                _fetchGifs(query: text.trim()).then(
                  (value) => setState(() {
                    _gifs = value;
                  }),
                );
              });
            },
            // textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesomeIcons.search,
                color: AppColorsNew.yellowAccentColor,
                size: 18.0,
              ),
              hintText: 'Search Tenor',
              hintStyle: TextStyle(color: AppColorsNew.medLightGrayColor),
              border: InputBorder.none,
            ),
          ),
        ),
      );

  _buildCategoryTopBar() => Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                showCategoryItems = false;
                showCategories = true;
              });
            },
            icon: Icon(Icons.navigate_before),
          ),
          Text(selectedCategory),
        ],
      );

  Widget categoryItem(GifCategoryModel category) {
    String imageUrl = category.gif.previewUrl;
    Widget image;
    if (category.gif.cache != null) {
      //imageUrl = 'file://${category.gif.cache}';
      double ratio = 0;
      if (category.gif.size != null) {
        ratio = category.gif.size.width / category.gif.size.height;
      }

      image = Image.file(
        File(category.gif.cache),
        fit: BoxFit.cover,
        height: double.infinity,
      );
    } else {
      image = CachedNetworkImage(
        cacheManager: ImageCacheManager.instance,
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        progressIndicatorBuilder: (_, __, ___) {
          //final dims = category.gif.media.gif.dims;
          double ratio = 0;
          if (category.gif.size != null) {
            ratio = category.gif.size.width / category.gif.size.height;
          }
          return AspectRatio(
            aspectRatio: ratio,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: CupertinoColors.inactiveGray,
            ),
          );
        },
      );
    }
    return InkWell(
      onTap: () {
        showCategoryItems = true;
        _gifs = [];
        selectedCategory = category.category;
        if (category.category == "Favourite") {
          setState(() {
            _gifs = GameService.fetchFavouriteGifs();
          });
        } else {
          _fetchGifs(query: category.category).then(
            (value) => setState(() {
              _gifs = value;
            }),
          );
        }
      },
      child: Stack(
        children: [
          image,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00000000),
                  const Color(0xFF000000),
                ],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.5, 1.0),
                stops: [0.7, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              category.category,
              style: AppStylesNew.gamePlayScreenPlayerName.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                // color: AppColorsNew.labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() => showCategories
      ? Expanded(
          child: GridView.builder(
            itemCount: gifCategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return categoryItem(gifCategories[index]);
            },
          ),
        )
      : Expanded(
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
                      child: GifListWidget(
                        onBookMark: (TenorResult r) async {
                          await GameService.addFavouriteGif(r);
                          setState(() {});
                        },
                        gifs: _gifs,
                        onGifSelect: (String url) {
                          // widget.chatService.sendGiphy(url);
                          this.widget.onGifSelect(url);
                          Navigator.pop(context, url);
                        },
                      ),
                    ),
        );

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    loading = true;
    await _fetchGifCategories();
    log('Gif categories: ${gifCategories.length}');
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsNew.darkGreenShadeColor,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(10.0),
      child: (!showCategoryItems)
          ? Column(
              children: [
                // top bar
                _buildTopBarSearchWidget(),

                // seperator
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Colors.grey),
                ),

                loading
                    ? Center(child: Text('Loading'))
                    :
                    // body
                    _buildBody(),
              ],
            )
          : Column(
              children: [
                _buildCategoryTopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GifListWidget(
                      onBookMark: (TenorResult r) async {
                        await GameService.addFavouriteGif(r);
                        setState(() {});
                      },
                      gifs: _gifs,
                      onGifSelect: (String url) {
                        // widget.chatService.sendGiphy(url);
                        this.widget.onGifSelect(url);
                        Navigator.pop(context, url);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
