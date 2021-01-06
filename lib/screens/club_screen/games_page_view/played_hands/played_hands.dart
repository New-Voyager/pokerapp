import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        body: ListView.builder(
          itemBuilder: (context, index) {
            print(index.toString() + " " + _visible.toString());
            _visible = index == 0 ? false : true;
            c = index == 0 ? 1 : index + 1;
            return getListItem();
          },
          itemCount: 5,
        ));
  }

  getListItem() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 10.0, right: 8.0),
                child: Text("#54", style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          seprator,
                          Text(
                            "Ended at Flop",
                            style: TextStyle(color: Color(0xff848484)),
                          ),
                          seprator,
                          Container(
                              child: ListView.separated(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Winner : Yong",
                                          style: TextStyle(
                                              color: Color(0xff848484)),
                                        ),
                                        seprator,
                                        Text(
                                          "Pot : 210",
                                          style: TextStyle(
                                              color: Color(0xff848484),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        seprator,
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Visibility(
                                      child: getCards(),
                                      visible: _visible,
                                    ),
                                  ),
                                ],
                              );
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
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {},
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      ),
                    ),
                  ],
                ),
              ),
              // Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  getCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.redHeart, label: "B", color: Colors.red)),
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
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "J",
                color: Colors.black)),
      ],
    );
  }
}
