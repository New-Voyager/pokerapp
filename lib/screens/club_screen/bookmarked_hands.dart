import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../routes.dart';

class BookmarkedHands extends StatefulWidget {
  final String clubCode;

  BookmarkedHands({this.clubCode});
  @override
  _BookmarkedHandsState createState() => _BookmarkedHandsState();
}

class _BookmarkedHandsState extends State<BookmarkedHands>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.bookmarked_hands;
  bool loading = true;
  List<BookmarkedHand> list = [];
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("bookmarkedHands");

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
    Alerts.showNotification(
      titleText: result ? _appScreenText["SUCCESS"] : _appScreenText["FAILED"],
      subTitleText: result
          ? "${_appScreenText['HAND']} " +
              model.handlogData.hand.handNum.toString() +
              " ${_appScreenText['REMOVEDFROMBOOKMARKS']}"
          : "${_appScreenText['COULDNOTREMOVEBOOKMARK']}",
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
    Alerts.showNotification(
      titleText: result ? _appScreenText["SUCCESS"] : _appScreenText["FAILED"],
      subTitleText: result
          ? "${_appScreenText['HAND']} " +
              model.hand.handNum.toString() +
              " ${_appScreenText['HASBEENSHAREDWITHTHECLUB']}"
          : "${_appScreenText['COULDNOTSHARETHEHAND']}",
      leadingIcon: Icons.share_rounded,
    );
  }

  _replayHand(HandLogModelNew model) async {
    final handNum = model.hand.handNum;
    final gameCode = model.hand.gameCode;
    Future.delayed(Duration(milliseconds: 10), () async {
      try {
        ConnectionDialog.show(
            context: context, loadingText: "${_appScreenText['LOADINGHAND']}");
        final handLogModel = await HandService.getHandLog(gameCode, handNum);
        Navigator.pop(context);

        // ReplayHandDialog.show(
        //   context: context,
        //   hand: jsonDecode(handLogModel.handData),
        //   playerID: handLogModel.myInfo.id,
        // );
      } catch (err) {
        // ignore the error
        log('error: ${err.toString()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              theme: theme,
              context: context,
              titleText: _appScreenText['BOOKMARKEDHANDS'],
            ),
            body: loading
                ? Center(
                    child: CircularProgressWidget(
                    text: AppStringsNew.loadingBookmarksText,
                  ))
                : Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: list.length == 0
                              ? Center(
                                  child: Text(
                                    _appScreenText['NOBOOKMARKEDHANDS'],
                                    style: AppDecorators.getSubtitle3Style(
                                        theme: theme),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    BookmarkedHand hand = list[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            Routes.hand_log_view,
                                            arguments: {
                                              "gameCode": hand.gameCode,
                                              "handNum": hand.handNum,
                                              "clubCode": widget.clubCode,
                                            });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        padding: EdgeInsets.only(
                                          top: 8,
                                        ),
                                        decoration: AppDecorators
                                            .tileDecorationWithoutBorder(theme),
                                        child: Column(
                                          children: [
                                            HandWinnersView(
                                              handLogModel:
                                                  list[index].handlogData,
                                            ),
                                            Divider(
                                              color: theme.fillInColor,
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 16,
                                                  left: 8,
                                                  right: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${_appScreenText['HAND']} #${list[index].handlogData.hand.handNum}",
                                                    style: AppDecorators
                                                        .getSubtitle3Style(
                                                            theme: theme),
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
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Icon(
                                                            Icons.star_rate,
                                                            color: theme
                                                                .accentColor,
                                                            size: 14.dp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      InkWell(
                                                        onTap: () async {
                                                          await _replayHand(
                                                            list[index]
                                                                .handlogData,
                                                          );
                                                        },
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Icon(
                                                            Icons.replay,
                                                            color: theme
                                                                .accentColor,
                                                            size: 14.dp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Visibility(
                                                        visible: ((widget
                                                                    .clubCode !=
                                                                null) &&
                                                            (widget.clubCode
                                                                .isNotEmpty)),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await _shareHandWithClub(
                                                              list[index]
                                                                  .handlogData,
                                                            );
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Icon(
                                                              Icons.share,
                                                              color: theme
                                                                  .accentColor,
                                                              size: 14.dp,
                                                            ),
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
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
