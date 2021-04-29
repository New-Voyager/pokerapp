import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:tenor/tenor.dart';

import 'add_favourite_giphy.dart';

class GameGiphies extends StatefulWidget {
  final GameMessagingService chatService;
  GameGiphies(this.chatService);
  @override
  _GameGiphiesState createState() => _GameGiphiesState();
}

class _GameGiphiesState extends State<GameGiphies> {
  List<TenorResult> _gifs;
  Timer _timer;
  bool isFavourite = true;
  String currentSelectedTab = '';
  List<String> tabBarItems = ['All-in', "Donkey", "Fish", "HAHA"];
  List<String> favouriteGiphies;
  bool _expandSearchBar = false;
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
    getfavouriteGiphy();
    _fetchGifs().then(
      (value) => setState(() {
        _gifs = value;
      }),
    );
    super.initState();
  }

  getfavouriteGiphy() {
    GameService.favouriteGiphies().then((value) {
      setState(() {
        favouriteGiphies = value;
        _expandSearchBar = false;
      });
    });
  }

  getGiphies(String text) {
    _fetchGifs(query: text.trim()).then(
      (value) => setState(() {
        _gifs = value;
        _expandSearchBar = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackgroundColor,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          /* tab bar */

          Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSelectedTab = '';
                        isFavourite = true;
                        _expandSearchBar = false;
                      });
                    },
                    child: Icon(
                      isFavourite ? Icons.star : Icons.star_border,
                      color:
                          isFavourite ? AppColors.appAccentColor : Colors.grey,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ...tabBarItems
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              currentSelectedTab = e;
                              isFavourite = false;
                              getGiphies(e);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e,
                              style: currentSelectedTab == e
                                  ? AppStyles.footerResultTextStyle2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.appAccentColor,
                                    )
                                  : AppStyles.footerResultTextStyle2.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Positioned(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: _expandSearchBar
                      ? MediaQuery.of(context).size.width / 2
                      : 40,
                  // height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.contentColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: AppColors.lightGrayColor,
                    ),
                    onTap: () {
                      setState(() {
                        _expandSearchBar = !_expandSearchBar;
                      });
                    },
                    onChanged: (String text) {
                      if (text.trim().isEmpty) return;

                      if (_timer?.isActive ?? false) _timer.cancel();

                      _timer = Timer(const Duration(milliseconds: 0), () {
                        setState(() {
                          currentSelectedTab = '';
                          isFavourite = false;
                        });
                        _fetchGifs(query: text.trim()).then(
                          (value) => setState(() {
                            _gifs = value;
                          }),
                        );
                      });
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        FontAwesomeIcons.search,
                        color: AppColors.lightGrayColor,
                        size: 18.0,
                      ),
                      hintText: '',
                      hintStyle: TextStyle(
                        color: AppColors.lightGrayColor,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                right: 8,
                top: 0,
                bottom: 0,
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 8,
          ),
          /* GIFs */
          isFavourite
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          child: GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor:
                                      AppColors.screenBackgroundColor,
                                  content: AddFavouriteGiphy(),
                                ),
                              );
                              getfavouriteGiphy();
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 30,
                              color: AppColors.appAccentColor,
                            ),
                          ),
                          alignment: Alignment.topRight,
                        ),
                        favouriteGiphies != null
                            ? Wrap(
                                children: [
                                  ...favouriteGiphies
                                      .map(
                                        (e) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              widget.chatService.sendText(e);
                                              Navigator.pop(context, e);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.contentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.all(10.0),
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              e,
                                              style: AppStyles
                                                  .footerResultTextStyle2,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              )
                      ],
                    ),
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
                              child: GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                children: _gifs.map((TenorResult gif) {
                                  print("${gif.url}");
                                  return GestureDetector(
                                    onTap: () {
                                      widget.chatService
                                          .sendGiphy(gif.media.gif.url);
                                      Navigator.pop(context, gif.media.gif.url);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: gif.media.tinygif.url,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                        backgroundColor:
                                            AppColors.cardBackgroundColor,
                                        value: downloadProgress.progress,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                          AppColors.appAccentColor,
                                        ),
                                      )),
                                      // placeholder: (_, __) => Center(
                                      //     child: CircularProgressIndicator(
                                      //   backgroundColor:
                                      //       AppColors.cardBackgroundColor,
                                      //   valueColor:
                                      //       new AlwaysStoppedAnimation<Color>(
                                      //     AppColors.appAccentColor,
                                      //   ),
                                      // )),
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
