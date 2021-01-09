import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';

class PlayedHandsScreen extends StatelessWidget {
  final seprator = SizedBox(
    height: 10.0,
  );

  bool _visible;
  int c;

  List<Map<String, String>> winnerCards = [
    {"name": "B", "label": AppConstants.redHeart},
    {"name": "9", "label": AppConstants.redHeart},
    {"name": "A", "label": AppConstants.blackClub},
    {"name": "J", "label": AppConstants.blackClub},
  ];

  List<Map<String, String>> communityCards = [
    {"name": "B", "label": AppConstants.redHeart},
    {"name": "9", "label": AppConstants.redHeart},
    {"name": "A", "label": AppConstants.blackClub},
    {"name": "J", "label": AppConstants.blackClub},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          leadingWidth: 100.0,
          backgroundColor: AppColors.screenBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
                Text(
                  "Game",
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
          centerTitle: true,
          title: Text("Played Hands"),
        ),
        body: Column(
          children: [
            getHeader(),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  print(index.toString() + " " + _visible.toString());
                  _visible = index == 0 ? false : true;
                  c = index == 0 ? 1 : index + 1;
                  return getListItem();
                },
                itemCount: 5,
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
        left: 8.0,
        right: 8.0,
      ),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Text("Hand",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  )),
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
                      child: Text("Community",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          )),
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

  getListItem() {
    return Padding(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSerialNumber(),
              getWinnerRow(),
            ],
          ),
        ),
      ),
    );
  }

  getSerialNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 10.0, right: 6.0),
      child: Text("#54", style: TextStyle(color: Colors.white)),
    );
  }

  getWinnerRow() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      seprator,
                      Container(
                          child: ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return getWinnerWidget(
                              name: "Yong", cards: winnerCards, pot: 210);
                        },
                        itemCount: c,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20.0,
                          );
                        },
                      )),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                      margin: EdgeInsets.only(top: 30.0), child: getCards()),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  getWinnerWidget({String name, List<Map<String, String>> cards, double pot}) {
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
                "Winner : $name",
                style: TextStyle(color: Color(0xff848484)),
              ),
              seprator,
              getSmallCards(cards),
              seprator,
              Text(
                "Pot : $pot",
                style: TextStyle(
                    color: Color(0xff848484), fontWeight: FontWeight.w600),
              ),
              seprator,
            ],
          ),
        ),
      ],
    );
  }

  getSmallCards(List<Map<String, String>> cards) {
    return Row(
      children: [
        VisibleCardView(
            grayOut: cards.asMap().containsKey(0) ? false : true,
            width: 0.8,
            card: CardObject(
              suit: cards.asMap().containsKey(0) ? cards[0]['label'] : " ",
              label: cards.asMap().containsKey(0) ? cards[0]['name'] : " ",
              color: Colors.red,
              smaller: true,
            )),
        VisibleCardView(
            grayOut: cards.asMap().containsKey(1) ? false : true,
            width: 0.8,
            card: CardObject(
              suit: cards.asMap().containsKey(1) ? cards[1]['label'] : " ",
              label: cards.asMap().containsKey(1) ? cards[1]['name'] : " ",
              color: Colors.red,
              smaller: true,
            )),
        VisibleCardView(
            grayOut: cards.asMap().containsKey(2) ? false : true,
            width: 0.8,
            card: CardObject(
              suit: cards.asMap().containsKey(2) ? cards[2]['label'] : " ",
              label: cards.asMap().containsKey(2) ? cards[2]['name'] : " ",
              color: Colors.red,
              smaller: true,
            )),
        VisibleCardView(
            grayOut: cards.asMap().containsKey(3) ? false : true,
            width: 0.8,
            card: CardObject(
              suit: cards.asMap().containsKey(3) ? cards[3]['label'] : " ",
              label: cards.asMap().containsKey(3) ? cards[3]['name'] : " ",
              color: Colors.red,
              smaller: true,
            )),
        VisibleCardView(
            grayOut: cards.asMap().containsKey(4) ? false : true,
            width: 0.8,
            card: CardObject(
              suit: cards.asMap().containsKey(4) ? cards[0]['label'] : " ",
              label: cards.asMap().containsKey(4) ? cards[0]['name'] : " ",
              color: Colors.red,
              smaller: true,
            )),
      ],
    );

    // return Expanded(
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     physics: ClampingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     itemCount: 5,
    //     itemBuilder: (context, index) {
    //       return VisibleCardView(
    //           width: 1.0,
    //           card: CardObject(
    //             suit: AppConstants.redHeart,
    //             label: "B",
    //             color: Colors.red,
    //             smaller: true,
    //           ));
    //     },
    //   ),
    // );
  }

  getCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        VisibleCardView(
            card: CardObject(
          suit: AppConstants.redHeart,
          label: "B",
          color: Colors.red,
          smaller: false,
        )),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.redHeart, label: "9", color: Colors.red)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "A",
                color: Colors.black)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "J",
                color: Colors.black)),
        VisibleCardView(
            grayOut: true,
            card: CardObject(
              suit: "  ",
              label: " ",
              color: Colors.white,
            )),
      ],
    );
  }
}
