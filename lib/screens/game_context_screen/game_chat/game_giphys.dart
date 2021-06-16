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

class GameChatBottomSheet extends StatefulWidget {
  final GameMessagingService chatService;
  GameChatBottomSheet(this.chatService);
  @override
  _GameChatBottomSheetState createState() => _GameChatBottomSheetState();
}

class _GameChatBottomSheetState extends State<GameChatBottomSheet> {
  List<TenorResult> _gifs;
  Timer _timer;
  bool isFavouriteText = true;
  bool isFavouriteGif = false;
  String currentSelectedTab = '';
  List<String> _favouriteTexts;
  bool _expandSearchBar = false;

  Future<List<TenorResult>> _fetchGifs({String query}) async {
    setState(() => _gifs = null);

    if (query == null || query.isEmpty) return TenorService.getTrendingGifs();

    // else fetch from search
    return TenorService.getGifsWithSearch(query);
  }

  @override
  void initState() {
    _fetchFavouriteTexts();
    _fetchGifs().then(
      (value) => setState(() {
        _gifs = value;
      }),
    );
    super.initState();
  }

  _fetchFavouriteTexts() async {
    final value = await GameService.getPresetTexts();
    setState(() => _favouriteTexts = value);
  }

  getGiphies(String text) {
    _fetchGifs(query: text.trim()).then(
      (value) => setState(() {
        _gifs = value;
        _expandSearchBar = false;
      }),
    );
  }

  // bool, string <isLocal, cleaned text>
  List _cleanTextIfLocal(String text) {
    final List<String> tmp = text.split(GameService.LOCAL_KEY);

    if (tmp.length == 1 || tmp.first.isNotEmpty) {
      return [false, text];
    }

    tmp.removeAt(0);

    return [true, tmp.join('')];
  }

  Widget _buildButton(context, text) {
    final ct = _cleanTextIfLocal(text);

    final bool isLocal = ct[0];
    final String cleanedText = ct[1];

    return InkWell(
      onTap: () {
        widget.chatService.sendText(text);
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          /* main body */
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: AppColorsNew.newGreenButtonColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              cleanedText,
              textAlign: TextAlign.center,
              style: AppStyles.clubItemInfoTextStyle.copyWith(
                fontSize: 15.0,
                color: AppColorsNew.newGreenButtonColor,
              ),
            ),
          ),

          /* cross button, in case of local */
          isLocal
              ? Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: InkWell(
                      onTap: () async {
                        await GameService.removePresetText(text);
                        _fetchFavouriteTexts();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 17.0,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

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
            alignment: Alignment.center,
            children: [
              // main row - TAB,
              Row(
                children: [
                  // sep
                  SizedBox(width: 10),

                  // favourite texts
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSelectedTab = '';
                        isFavouriteGif = false;
                        isFavouriteText = true;
                        _expandSearchBar = false;
                      });
                    },
                    child: Icon(
                      isFavouriteText ? Icons.star : Icons.star_border,
                      color: isFavouriteText
                          ? AppColorsNew.yellowAccentColor
                          : Colors.grey,
                      size: 25,
                    ),
                  ),

                  // sep
                  SizedBox(width: 10),

                  // fav gifs
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSelectedTab = 'fav-gif';
                        isFavouriteGif = true;
                        isFavouriteText = false;
                        _expandSearchBar = false;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFavouriteGif ? Icons.star : Icons.star_border,
                          color: isFavouriteGif
                              ? AppColorsNew.yellowAccentColor
                              : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 1.0),
                        Text(
                          'GIF',
                          style: isFavouriteGif
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
                      ],
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
                              isFavouriteText = false;
                              isFavouriteGif = false;
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

              // right centered - for searching GIFs
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  width: _expandSearchBar
                      ? MediaQuery.of(context).size.width / 2
                      : 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (String text) {
                      if (text.trim().isEmpty) text = 'Poker';

                      if (_timer?.isActive ?? false) _timer.cancel();

                      /* we should wait before calling the API */
                      _timer = Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          currentSelectedTab = '';
                          isFavouriteText = false;
                          isFavouriteGif = false;
                        });

                        _fetchGifs(query: text.trim()).then(
                          (value) => setState(() {
                            _gifs = value;
                          }),
                        );
                      });
                    },
                    // textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() => _expandSearchBar = !_expandSearchBar);
                        },
                        child: Icon(
                          FontAwesomeIcons.search,
                          color: _expandSearchBar
                              ? AppColorsNew.yellowAccentColor
                              : Colors.white,
                          size: 18.0,
                        ),
                      ),
                      hintText: 'Search Tenor',
                      hintStyle: TextStyle(color: AppColors.medLightGrayColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /* divider */
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.grey),
          ),

          /* Favourites OR GIFs */
          isFavouriteText
              ? Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // add button
                        Align(
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor:
                                      AppColorsNew.darkGreenShadeColor,
                                  content: AddFavouriteGiphy(),
                                ),
                              );
                              _fetchFavouriteTexts();
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
                        _favouriteTexts != null
                            ? Wrap(
                                children: [
                                  ..._favouriteTexts
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
              : isFavouriteGif
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GifListWidget(
                          onRemoveBookMark: (TenorResult r) async {
                            await GameService.removeFavouriteGif(r);
                            setState(() {});
                          },
                          gifs: GameService.fetchFavouriteGifs(),
                          onGifSelect: (String url) {
                            widget.chatService.sendGiphy(url);
                            Navigator.pop(context, url);
                          },
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
                                    onBookMark: (TenorResult r) async {
                                      await GameService.addFavouriteGif(r);
                                      setState(() {});
                                    },
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
