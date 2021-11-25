import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/handlog_bottomsheet.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:provider/provider.dart';

final _separator = SizedBox(
  height: 5.0,
);

class PlayedHandsScreen extends StatefulWidget {
  final List<HandHistoryItem> history;
  final ChipUnit chipUnit;
  final String gameCode;
  final String clubCode;
  final bool isInBottomSheet;
  final AuthModel currentPlayer;
  final bool liveGame;
  PlayedHandsScreen(this.chipUnit, this.gameCode, this.history, this.clubCode,
      this.currentPlayer,
      {this.isInBottomSheet = false, this.liveGame = false});

  @override
  _PlayedHandsScreenState createState() => _PlayedHandsScreenState();
}

class _PlayedHandsScreenState extends State<PlayedHandsScreen> {
  var _tapPosition;
  List<BookmarkedHand> list = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchBookmarksForGame(widget.gameCode);
    });
    super.initState();
  }

  _fetchBookmarksForGame(String gameCode) async {
    list.clear();
    var result = await HandService.getBookmarkedHandsForGame(widget.gameCode);
    BookmarkedHandModel model = BookmarkedHandModel.fromJson(result);

    for (var item in model.bookmarkedHands) {
      list.add(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Column(
        children: [
          SizedBox(
            height: 16,
          ),
          //   getHeader(),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return getListItem(
                  context,
                  index,
                  _isTheHandBookmarked(widget.history[index].handNum),
                  theme,
                );
              },
              itemCount: widget.history.length,
              separatorBuilder: (context, index) =>
                  AppDimensionsNew.getVerticalSizedBox(8),
            ),
          ),
        ],
      ),
    );
  }

  getHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        right: 2.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: Container(
        height: 50.0,
        // decoration: BoxDecoration(
        //   color: Color(0xff313235),
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(AppDimensions.cardRadius),
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Text(
                "Hand",
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Text("Winner",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          )),
                    ),
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: Text(
                        "Community",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onHistoryItemTapped(context, int index) async {
    if (widget.isInBottomSheet) {
      showBottomSheet(
        context: context,

        //isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => HandlogBottomSheet(
          gameCode: this.widget.gameCode,
          handNum: widget.history[index].handNum,
          clubCode: widget.clubCode,
          liveGame: widget.liveGame,
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        Routes.hand_log_view,
        arguments: {
          "gameCode": this.widget.gameCode,
          "handNum": widget.history[index].handNum,
          "clubCode": widget.clubCode,
        },
      );
    }
  }

  _storeTapPosition(TapDownDetails tapDownDetails) {
    _tapPosition = tapDownDetails.globalPosition;
  }

  _bookmarkdHand(int index) async {
    var result = await HandService.bookMarkHand(
        widget.gameCode, widget.history[index].handNum);
    Alerts.showNotification(
      titleText: result ? "SUCCESS" : "FAILED",
      subTitleText: result
          ? "Hand " +
              widget.history[index].handNum.toString() +
              " has been bookmarked"
          : "Couldn't bookmark the hand. Please try again later",
    );
    if (result) {
      await _fetchBookmarksForGame(widget.gameCode);
    }
  }

  _removeBookmark(int index) async {
    var hand = list.firstWhere(
        (element) => element.handNum == widget.history[index].handNum,
        orElse: null);
    if (hand != null) {
      var result = await HandService.removeBookmark(hand.id);
      Alerts.showNotification(
        titleText: result ? "SUCCESS" : "FAILED",
        subTitleText: result
            ? "Hand " +
                widget.history[index].handNum.toString() +
                " removed from bookmarks"
            : "Couldn't remove bookmark. Please try again later",
      );
      if (result) {
        await _fetchBookmarksForGame(widget.gameCode);
      }
    } else {
      Alerts.showNotification(
        titleText: "Couldn't remove bookmark. Please try again later",
      );
    }
  }

  _shareHandWithClub(int index) async {
    var result = await HandService.shareHand(
        widget.gameCode, widget.history[index].handNum, widget.clubCode);

    Alerts.showNotification(
      titleText: result ? "SUCCESS" : "FAILED",
      subTitleText: result
          ? "Hand " +
              widget.history[index].handNum.toString() +
              " has been shared with the club"
          : "Couldn't share the hand. Please try again later",
    );
  }

  _replayHand(int index) async {
    final item = widget.history[index];

    // get handNumber and gameCode
    final handNum = item.handNum;
    final gameCode = widget.gameCode;

    // show replay dialog
    ReplayHandDialog.show(
      context: context,
      playerID: widget.currentPlayer.playerId,
      handNumber: handNum,
      gameCode: gameCode,
    );
  }

  showCustomMenu(context, int index, AppTheme theme) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Bookmark Hand",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  Icon(
                    Icons.star_border_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
              Divider(
                color: theme.fillInColor,
              ),
            ],
          ),
        ),
        if (widget.clubCode != null)
          PopupMenuItem(
            value: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Share Hand with club",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    Icon(
                      Icons.ios_share,
                      color: Colors.white,
                    ),
                  ],
                ),
                Divider(
                  color: theme.fillInColor,
                ),
              ],
            ),
          )
      ],
    ).then<void>((delta) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)
      if (delta == null) {
        return;
      } else {
        switch (delta) {
          case 0:
            _bookmarkdHand(index);
            break;
          case 1:
            _shareHandWithClub(index);
            break;
        }
      }
    });
  }

  getListItem(BuildContext context, int index, bool isTheHandBookmarked,
      AppTheme theme) {
    WinnerWidget winnerWidget = new WinnerWidget(
        item: widget.history[index], chipUnit: widget.chipUnit);
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTapDown: _storeTapPosition,
          //onLongPress: () => {showCustomMenu(context, index)},
          onTap: () => onHistoryItemTapped(context, index),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: AppDecorators.tileDecoration(theme),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //handNumWidget(history[index].handNum),
                      SizedBox(
                        width: 8,
                      ),
                      winnerWidget,
                    ],
                  ),
                  Divider(
                    color: theme.fillInColor,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${widget.history[index].handTimeInDate}')
                          ])),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hand #${widget.history[index].handNum}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (isTheHandBookmarked) {
                                  await _removeBookmark(index);
                                } else {
                                  await _bookmarkdHand(index);
                                }
                              },
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  isTheHandBookmarked
                                      ? Icons.star
                                      : Icons.star_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            (widget.clubCode == null || widget.clubCode == '')
                                ? Container()
                                : InkWell(
                                    onTap: () async {
                                      await _shareHandWithClub(index);
                                    },
                                    child: Container(
                                      alignment: Alignment.bottomRight,
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
                                _replayHand(index);
                              },
                              child: Icon(
                                Icons.replay,
                                color: Colors.white,
                                size: 20,
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
          ),
        );
      },
    );
  }

  // Widget handNumWidget(int handNum) {
  //   return Padding(
  //       padding: const EdgeInsets.only(left: 4.0, top: 10.0, right: 6.0),
  //       child: Container(
  //         width: 30,
  //         child: Text(
  //           handNum.toString(),
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 14.0,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ));
  // }

  bool _isTheHandBookmarked(int handNum) {
    // log("HAND UNDER TEST : $handNum");
    final index = list.indexWhere((element) => element.handNum == handNum);
    if (index < 0) return false;
    return true;
  }
}

class WinnerWidget extends StatelessWidget {
  final HandHistoryItem item;
  final ChipUnit chipUnit;

  WinnerWidget({this.item, this.chipUnit});

  List<Widget> getCommunityCards() {
    List<Widget> communityCards = [
      SizedBox(
        height: 16,
      ),
      StackCardView02(
        cards: item.community,
        show: true,
      ),
      SizedBox(
        height: 5,
      ),
    ];
    if (item.community1 != null && item.community1.length > 0) {
      communityCards.add(
        StackCardView02(
          cards: item.community,
          show: true,
        ),
      );
    }
    return communityCards;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _separator,
                        Container(child: getWinnersView(theme)),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: getCommunityCards(),
                          ),
                          Container(
                            child: Text(
                              this.item.handTime,
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Icon(
                Icons.arrow_forward_ios,
                color: theme.accentColor,
                size: 12.ph,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWinnersView(AppTheme theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final winner = this.item.winners[index];
        return getWinnerWidget(
            name: winner.name,
            cards: winner.cards,
            pot: winner.amount,
            showCards: winner.showCards,
            theme: theme);
      },
      itemCount: this.item.winners.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.fillInColor,
        );
      },
    );
  }

  Widget getWinnerWidget(
      {String name,
      List<int> cards,
      double pot,
      bool showCards,
      AppTheme theme}) {
    // log("IN WINNER : ${cards} ${showCards}");
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 10.dp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              _separator,
              StackCardView00(
                cards: cards,
                show: showCards,
              ),
              _separator,
              Row(
                children: [
                  Text(
                    'Received: ',
                    style: AppDecorators.getSubtitle3Style(theme: theme),
                  ),
                  _separator,
                  Text(
                    DataFormatter.chipsFormat(pot, chipUnit: ChipUnit.CENT),
                    style: AppDecorators.getSubtitle2Style(theme: theme),
                  ),
                ],
              ),
              // _separator,
            ],
          ),
        ),
      ],
    );
  }
}
