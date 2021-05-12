import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/card_view_old.dart';

final _separator = SizedBox(
  height: 10.0,
);

class PlayedHandsScreen extends StatelessWidget {
  final List<HandHistoryItem> history;
  final String gameCode;
  var _tapPosition;
  final String clubCode;
  final bool isInBottomSheet;

  PlayedHandsScreen(this.gameCode, this.history, this.clubCode,
      {this.isInBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: Column(
          children: [
            getHeader(),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return getListItem(context, index);
                },
                itemCount: history.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ));
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
    if (isInBottomSheet) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => Container(
          height: MediaQuery.of(context).size.height / 2,
          child: HandLogView(this.gameCode, history[index].handNum),
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        Routes.hand_log_view,
        arguments: {
          "gameCode": this.gameCode,
          "handNum": history[index].handNum
        },
      );
    }
  }

  _storeTapPosition(TapDownDetails tapDownDetails) {
    _tapPosition = tapDownDetails.globalPosition;
  }

  _saveStarredHand(BuildContext context, int index) async {
    var result = await HandService.saveStarredHand(
        gameCode, history[index].handNum.toString());
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? "Hand " +
                  history[index].handNum.toString() +
                  " has been bookmarked"
              : "Couldn't bookmark the hand. Please try again later",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  _shareHandWithClub(BuildContext context, int index) async {
    var result =
        await HandService.shareHand(gameCode, history[index].handNum, clubCode);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? "Hand " +
                  history[index].handNum.toString() +
                  " has been shared with the club"
              : "Couldn't share the hand. Please try again later",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  showCustomMenu(context, int index) {
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
                color: AppColors.listViewDividerColor,
              ),
            ],
          ),
        ),
        if (clubCode != null)
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
                  color: AppColors.listViewDividerColor,
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
            _saveStarredHand(context, index);
            break;
          case 1:
            _shareHandWithClub(context, index);
            break;
        }
      }
    });
  }

  getListItem(BuildContext context, int index) {
    WinnerWidget widget = new WinnerWidget(history[index]);
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: AppColors.popUpMenuColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTapDown: _storeTapPosition,
            onLongPress: () => {showCustomMenu(context, index)},
            onTap: () => onHistoryItemTapped(context, index),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff313235),
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimensions.cardRadius),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          handNumWidget(history[index].handNum),
                          widget,
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              await _shareHandWithClub(context, index);
                            },
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.share,
                                color: Color(0xff319ffe),
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.star_outline,
                                color: Color(0xff319ffe),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget handNumWidget(int handNum) {
    return Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 10.0, right: 6.0),
        child: Container(
          width: 30,
          child: Text(
            handNum.toString(),
            style: const TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }
}

class WinnerWidget extends StatelessWidget {
  HandHistoryItem item;

  WinnerWidget(HandHistoryItem item) {
    this.item = item;
  }

  List<Widget> getCommunityCards() {
    List<Widget> communityCards = [
      NonGameScreenCommunityCardWidget(
        cards: item.community,
        show: true,
      ),
      SizedBox(
        height: 5,
      ),
    ];
    if (item.community1 != null && item.community1.length > 0) {
      communityCards.add(
        NonGameScreenCommunityCardWidget(
          cards: item.community,
          show: true,
        ),
      );
    }
    return communityCards;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _separator,
                      Container(child: getWinnersView()),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
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
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: AppColors.lightGrayTextColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Column(
            children: [
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.appAccentColor,
                size: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getWinnersView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final winner = this.item.winners[index];
        return getWinnerWidget(
            name: winner.name,
            cards: winner.cards,
            pot: winner.amount,
            showCards: winner.showCards);
      },
      itemCount: this.item.winners.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 20.0,
        );
      },
    );
  }

  Widget getWinnerWidget(
      {String name, List<int> cards, double pot, bool showCards}) {
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
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.orangeAccent,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              _separator,
              CardsView(cards: cards, show: showCards),
              _separator,
              Row(children: [
                Text(
                  'Received: ',
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: AppColors.lightGrayTextColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _separator,
                Text(
                  DataFormatter.chipsFormat(pot),
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.lightGreenAccent,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
              _separator,
            ],
          ),
        ),
      ],
    );
  }
}
