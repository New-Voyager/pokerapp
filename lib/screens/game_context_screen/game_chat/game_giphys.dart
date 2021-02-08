import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/models/gif_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/gifhy_service.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';

import 'add_favourite_giphy.dart';

class GameGiphies extends StatefulWidget {
  final GameChatService chatService;
  GameGiphies(this.chatService);
  @override
  _GameGiphiesState createState() => _GameGiphiesState();
}

class _GameGiphiesState extends State<GameGiphies> {
  List<GifModel> _gifs;
  Timer _timer;
  bool isFavourite = true;
  String currentSelectedTab = '';
  List<String> tabBarItems = ['All-in', "Donkey", "Fish", "HAHA"];
  List<String> favouriteGiphies;
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
      });
    });
  }

  getGiphies(String text) {
    _fetchGifs(query: text.trim()).then(
      (value) => setState(() {
        _gifs = value;
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
                  });
                },
                child: Icon(
                  Icons.star_border,
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
                              ? AppStyles.footerResultTextStyle2
                                  .copyWith(fontWeight: FontWeight.bold)
                              : AppStyles.footerResultTextStyle2,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
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
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: Colors.black,
              thickness: 2,
            ),
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
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                children: _gifs
                                    .map((GifModel gif) => GestureDetector(
                                          onTap: () {
                                            widget.chatService
                                                .sendGiphy(gif.url);
                                            Navigator.pop(context, gif.url);
                                          },
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
