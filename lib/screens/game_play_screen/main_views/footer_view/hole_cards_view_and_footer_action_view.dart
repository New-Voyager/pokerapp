import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/hole_stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/straddle_dialog.dart';
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
  bool _isCardVisible = false;

  Widget _buildholeCardViewAndStraddleDialog(boardAttributes) => Builder(
        builder: (context) => Stack(
          alignment: Alignment.topCenter,
          children: [
            // hole card view
            Transform.translate(
              offset: boardAttributes.holeCardViewOffset,
              child: Transform.scale(
                scale: boardAttributes.holeCardViewScale,
                child: holeCardView(context),
              ),
            ),

            Align(
              child: Transform.scale(
                scale: 0.80,
                child: StraddleDialog(
                  // TODO: ALL YOU WOULD CARE ABOUT IS THIS VALUE TO HIDE / SHOW THIS WIDGET
                  straddlePrompt: true,

                  // TODO: THIS CALLBACK WILL CONTAIN A LIST OF 3 ITEMS
                  onSelect: (List<bool> optionAutoValue) {
                    print(optionAutoValue);

                    // TODO: here you can change the value of straddlePrompt to hide this widget
                  },
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final boardAttributes = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    );

    return ListenableProvider(
      create: (_) => ValueNotifier<bool>(false),
      builder: (BuildContext context, __) => Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildholeCardViewAndStraddleDialog(boardAttributes),
          ),

          /* dark overlay to show in-front of cards, when the bet widget is displayed */
          Consumer<ValueNotifier<bool>>(
            builder: (_, vnIsBetWidgetVisible, __) => AnimatedSwitcher(
              duration: AppConstants.fastAnimationDuration,
              reverseDuration: AppConstants.fastAnimationDuration,
              child: vnIsBetWidgetVisible.value
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.80),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // action view (show when it is time for this user to act)
          Align(
            alignment: Alignment.bottomCenter,
            child: widget.showActionWidget ?? false
                ? FooterActionView(
                    gameContext: widget.gameContext,
                    isBetWidgetVisible: (bool isBetWidgetVisible) =>
                        Provider.of<ValueNotifier<bool>>(
                      context,
                      listen: false,
                    ).value = isBetWidgetVisible,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget holeCardView(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() => _isCardVisible = !_isCardVisible);
        },
        onLongPress: () {
          setState(() => _isCardVisible = true);
        },
        onLongPressEnd: (_) {
          setState(() => _isCardVisible = false);
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
            card.cardType = CardType.HoleCard;
            card.cardFace = CardFace.FRONT;
            return card;
          },
        )?.toList() ??
        [];

    return HoleStackCardView(
      cards: cards,
      deactivated: playerFolded ?? false,
      isCardVisible: _isCardVisible,
    );
  }
}
