import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hole_stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

import 'footer_action_view.dart';

// MyCardView represent the player who has hole cards
// The cards may be active or dead/folded
//
class HoleCardsView extends StatefulWidget {
  final PlayerModel playerModel;
  //final FooterStatus footerStatus;
  final bool showActionWidget;

  const HoleCardsView({Key key, this.playerModel, this.showActionWidget})
      : super(key: key);

  @override
  _HoleCardsViewState createState() => _HoleCardsViewState();
}

class _HoleCardsViewState extends State<HoleCardsView> {
  bool isCardVisible = false;

  @override
  Widget build(BuildContext context) {
    final boardAttributes =
        Provider.of<BoardAttributesObject>(context, listen: false);
    final Size footerSize = boardAttributes.footerSize;
    final height = footerSize.height / 2;
    final width = footerSize.width;
    final screen = boardAttributes.getScreen(context);
    log('footer size: $footerSize width: $width, height: $height diagonal: ${screen.diagonalInches()}');

    return Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: width,
          height: height,
          child: GestureDetector(
            onLongPress: () {
              setState(() => isCardVisible = true);
            },
            onLongPressEnd: (_) {
              setState(() => isCardVisible = false);
            },
            child: InkWell(
              highlightColor: Colors.black,
              focusColor: Colors.black,
              splashColor: Colors.black,
              onTap: () {
                log('card is tapped');
                setState(() {
                  isCardVisible = !isCardVisible;
                });
                //debugPrint("HoleCardsView : Container");
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: cards(
                  playerFolded: widget.playerModel.playerFolded,
                  cards: widget.playerModel?.cards?.map(
                        (int c) {
                          CardObject card = CardHelper.getCard(c);
                          card.smaller = true;
                          card.cardFace = CardFace.FRONT;

                          return card;
                        },
                      )?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ),
      ),

      // action view (show when it is time for this user to act)
      Positioned(
        width: MediaQuery.of(context).size.width,
        bottom: 0,
        child: widget.showActionWidget ?? false
            ? FooterActionView()
            : SizedBox(
                height: 0,
              ),
      )
    ]);
  }

  Widget cards({
    List<CardObject> cards,
    @required playerFolded,
  }) {
    return HoleStackCardView(
      cards: cards,
      deactivated: playerFolded ?? false,
      isCardVisible: isCardVisible,
    );
  }
}
