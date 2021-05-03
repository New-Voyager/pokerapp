import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hole_stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hole_stack_card_view_2.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

import 'footer_action_view.dart';

// MyCardView represent the player who has hole cards
// The cards may be active or dead/folded
//
class HoleCardsViewAndFooterActionView extends StatefulWidget {
  final PlayerModel playerModel;
  //final FooterStatus footerStatus;
  final bool showActionWidget;
  final GameContextObject gameContext;

  const HoleCardsViewAndFooterActionView({
    Key key,
    this.playerModel,
    this.gameContext,
    this.showActionWidget,
  }) : super(key: key);

  @override
  _HoleCardsViewAndFooterActionViewState createState() =>
      _HoleCardsViewAndFooterActionViewState();
}

class _HoleCardsViewAndFooterActionViewState
    extends State<HoleCardsViewAndFooterActionView> {
  bool isCardVisible = false;

  @override
  Widget build(BuildContext context) {
    final boardAttributes = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    );

    // final Size footerSize = boardAttributes.footerSize;
    // final screen = boardAttributes.getScreen(context);
    // double height, width;
    // if (footerSize != null) {
    //   height = footerSize.height / 1.5;
    //   width = footerSize.width / 2;
    // } else {
    //   height = screen.height() / 2;
    //   width = screen.width() - 100;
    // }
    // log('footer size: $footerSize width: $width, height: $height diagonal: ${screen.diagonalInches()}');
    // log('rebuilding action view');

    // return Column(
    //   children: [
    //     /* hole card view - shows the user's cards */
    //     Transform.translate(
    //       offset: boardAttributes.holeCardViewOffset,
    //       child: Transform.scale(
    //         scale: boardAttributes.holeCardViewScale,
    //         child: holeCardView(context),
    //       ),
    //     ),
    //     Spacer(),
    //
    //     widget.showActionWidget ?? false
    //         ? Transform.scale(
    //             // TODO: FIX THE SCALING OF THIS WIDGET FOR DIFFERENT SCREEN SIZES
    //             scale: boardAttributes.footerActionViewScale,
    //             child: FooterActionView(widget.gameContext),
    //           )
    //         : const SizedBox.shrink(),
    //   ],
    // );

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: boardAttributes.holeCardViewOffset,
            child: Transform.scale(
              scale: boardAttributes.holeCardViewScale,
              child: holeCardView(context),
            ),
          ),
        ),

        // action view (show when it is time for this user to act)
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.showActionWidget ?? false
              ? Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: boardAttributes.footerActionViewScale,
                  child: FooterActionView(widget.gameContext),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget holeCardView(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() => isCardVisible = !isCardVisible);
        },
        onLongPress: () {
          setState(() => isCardVisible = true);
        },
        onLongPressEnd: (_) {
          setState(() => isCardVisible = false);
        },
        child: cards(
          playerFolded: widget.playerModel.playerFolded,
          cardsInt: widget.playerModel?.cards,
        ),
      );

  Widget cards({
    List<int> cardsInt,
    @required playerFolded,
  }) {
    final List<CardObject> cards = cardsInt?.map(
          (int c) {
            CardObject card = CardHelper.getCard(c);
            card.smaller = true;
            card.cardFace = CardFace.FRONT;
            return card;
          },
        )?.toList() ??
        [];

    return HoleStackCardView2(
      cards: cards,
      deactivated: playerFolded ?? false,
      isCardVisible: isCardVisible,
    );
  }
}
