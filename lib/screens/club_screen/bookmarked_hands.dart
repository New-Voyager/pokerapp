import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/utils/alerts.dart';

class BookmarkedHands extends StatefulWidget {
  final String clubCode;

  BookmarkedHands({this.clubCode});
  @override
  _BookmarkedHandsState createState() => _BookmarkedHandsState();
}

class _BookmarkedHandsState extends State<BookmarkedHands> {
  bool loading = true;
  List<BookmarkedHand> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchBookmarkedHands();
    });
  }

  Future<void> _fetchBookmarkedHands() async {
    list.clear();
    final result = await HandService.getBookMarkedHands();
    if (result == null) {
      setState(() {
        loading = false;
      });
      return;
    }

    BookmarkedHandModel model = BookmarkedHandModel.fromJson(result);

    for (var item in model.bookmarkedHands) {
      list.add(item);
    }
    for (var item in list) {
      log("GAME CODES : ${item.handlogData.hand.gameCode}");
    }
    setState(() {
      loading = false;
    });
  }

  _removeBookMark(BookmarkedHand model) async {
    var result = await HandService.removeBookmark(model.id);
    Alerts.showTextNotification(
      text: result
          ? "Hand " +
              model.handlogData.hand.handNum.toString() +
              " removed from bookmarks"
          : "Couldn't remove bookmark",
    );

    if (result) {
      setState(() {
        loading = true;
      });
      await _fetchBookmarkedHands();
    }
  }

  _shareHandWithClub(HandLogModelNew model) async {
    log("IN SHARED HAND : ${widget.clubCode}");
    var result = await HandService.shareHand(
        model.hand.gameCode, model.hand.handNum, widget.clubCode);
    Alerts.showTextNotification(
      text: result
          ? "Hand " +
              model.hand.handNum.toString() +
              " has been shared with the club"
          : "Couldn't share the hand. Please try again later",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Bookmarked hands",
          style: AppStyles.titleBarTextStyle,
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  Expanded(
                    child: list.length == 0
                        ? Center(
                            child: Text(
                              "No bookmarked hands!",
                              style: AppStyles.disabledButtonTextStyle,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: AppStyles.handlogGreyGradient,
                                ),
                                child: Column(
                                  children: [
                                    HandWinnersView(
                                      handLogModel: list[index].handlogData,
                                    ),
                                    Divider(
                                      color: AppColors.veryLightGrayColor,
                                      indent: 8,
                                      endIndent: 8,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Hand #${list[index].handlogData.hand.handNum}",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  await _removeBookMark(
                                                      list[index]);
                                                },
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Icon(
                                                    Icons.star_rate,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () async {
                                                  await _shareHandWithClub(
                                                    list[index].handlogData,
                                                  );
                                                },
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Icon(
                                                    Icons.share,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReplayHandScreen(
                            hand: messageModel.sharedHand.data,
                            playerInfo: playerInfo,
                          ),
                        ),
                      ); */
                                                  // await _shareHandWithClub(context, index);
                                                  toast("Replay hand");
                                                },
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Icon(
                                                    Icons.replay,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
