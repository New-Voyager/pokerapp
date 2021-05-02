import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
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
  final GameContextObject gameContext;

  const HoleCardsView(
      {Key key, this.playerModel, this.gameContext, this.showActionWidget})
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
    double height = 0.0, width = 0.0;
    final screen = boardAttributes.getScreen(context);

    if (footerSize != null) {
      height = footerSize.height / 1.5;
      width = footerSize.width / 2;
    } else {
      height = screen.height() / 2;
      width = screen.width() - 100;
    }
    // log('footer size: $footerSize width: $width, height: $height diagonal: ${screen.diagonalInches()}');
    // log('rebuilding action view');
    return Stack(children: [
      Align(
        //top: 0, left: 0,
        alignment: Alignment.topCenter,
        child: Transform.translate(
            offset: Offset(-10, 40),
            child: Transform.scale(scale: 1.5, child: holeCardView(context))),
      ),

      // action view (show when it is time for this user to act)
      Positioned(
        width: MediaQuery.of(context).size.width,
        bottom: 0,
        child: widget.showActionWidget ?? false
            ? Transform.translate(
                offset: Offset(-50, 30),
                child: Transform.scale(
                    scale: 0.80, child: FooterActionView(widget.gameContext)))
            : SizedBox(
                height: 0,
              ),
      )
    ]);
  }

  Widget holeCardView(BuildContext context) {
    return Container(
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
    );
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
