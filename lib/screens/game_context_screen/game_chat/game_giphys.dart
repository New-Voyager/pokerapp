import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/gif_list_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/tenor_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:tenor/tenor.dart';

import 'add_favourite_giphy.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class GameChatBottomSheet extends StatefulWidget {
  final GameMessagingService chatService;
  GameChatBottomSheet(this.chatService);
  @override
  _GameChatBottomSheetState createState() => _GameChatBottomSheetState();
}

class _GameChatBottomSheetState extends State<GameChatBottomSheet> {
  List<TenorResult> _gifs;
  Timer _timer;
  bool isFavourite = true;
  String currentSelectedTab = '';
  List<String> favouriteGiphies;
  bool _expandSearchBar = false;
  Future<List<TenorResult>> _fetchGifs({String query}) async {
    setState(() => _gifs = null);

    if (query == null || query.isEmpty) return TenorService.getTrendingGifs();

    // else fetch from search
    return TenorService.getGifsWithSearch(query);
  }

  @override
  void initState() {
    getFavouriteGiphy();
    _fetchGifs().then(
      (value) => setState(() {
        _gifs = value;
      }),
    );
    super.initState();
  }

  getFavouriteGiphy() {
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

  Widget _buildButton(context, text) => InkWell(
        onTap: () {
          widget.chatService.sendText(text);
          Navigator.pop(context);
        },
        child: Container(
          // height: 32.ph,
          // width: 80.pw,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: AppColorsNew.newGreenButtonColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppStyles.clubItemInfoTextStyle.copyWith(
              fontSize: 15.0,
              color: AppColorsNew.newGreenButtonColor,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsNew.darkGreenShadeColor,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          /* tab bar */
          Stack(
            children: [
              Row(
                children: [
                  // sep
                  SizedBox(width: 10),

                  // tab
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
                      color: isFavourite
                          ? AppColorsNew.yellowAccentColor
                          : Colors.grey,
                      size: 25,
                    ),
                  ),

                  // sep
                  SizedBox(width: 10),

                  // gifs
                  ...AppConstants.GIF_CATEGORIES
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
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColorsNew.yellowAccentColor,
                                    )
                                  : AppStyles.footerResultTextStyle2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  // sep
                  SizedBox(width: 10),
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
                      setState(() => _expandSearchBar = !_expandSearchBar);
                    },
                    onChanged: (String text) {
                      if (text.trim().isEmpty) return;

                      if (_timer?.isActive ?? false) _timer.cancel();

                      /* we should wait before calling the API */
                      _timer = Timer(const Duration(milliseconds: 500), () {
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
                      hintText: 'Search Tenor',
                      hintStyle: TextStyle(
                        color: AppColors.medLightGrayColor,
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

          /* divider */
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.grey),
          ),

          /* Favourites OR GIFs */
          isFavourite
              ? Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // add button
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
                              getFavouriteGiphy();
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 25,
                              color: AppColorsNew.yellowAccentColor,
                            ),
                          ),
                          alignment: Alignment.topRight,
                        ),

                        // favourite lists
                        favouriteGiphies != null
                            ? Wrap(
                                children: [
                                  ...favouriteGiphies
                                      .map((text) => _buildButton(
                                            context,
                                            text,
                                          ))
                                      .toList(),
                                ],
                              )
                            : Center(
                                child: Text('Empty'),
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
                              child: GifListWidget(
                                gifs: _gifs,
                                onGifSelect: (String url) {
                                  widget.chatService.sendGiphy(url);
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
