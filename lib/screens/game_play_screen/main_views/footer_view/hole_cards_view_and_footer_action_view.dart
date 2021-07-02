import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
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

  bool _showAllCardSelectionButton(var vnfs) {
    final bool isInResult = vnfs.value == FooterStatus.Result;
    return isInResult && (widget.playerModel?.playerFolded ?? false);
  }

  void _markAllCardsAsSelected() {
    // flip all the cards to front, if not already
    setState(() => _isCardVisible = true);

    // mark all the cards for revealing
    context.read<MarkedCards>().markAll(widget.playerModel.cardObjects);
  }

  Widget _buildAllHoleCardSelectionButton() =>
      Consumer<ValueNotifier<FooterStatus>>(
        builder: (_, vnfs, __) => _showAllCardSelectionButton(vnfs)
            ? InkWell(
                onTap: _markAllCardsAsSelected,
                child: Icon(Icons.visibility_rounded),
              )
            : const SizedBox.shrink(),
      );

  Widget _buildholeCardViewAndStraddleDialog(
    GameState gameState,
    BoardAttributesObject boardAttributes,
    bool straddlePrompt,
  ) =>
      Builder(
        builder: (context) => Stack(
          alignment: Alignment.topCenter,
          children: [
            // hole card view
            Transform.translate(
              offset: boardAttributes.holeCardViewOffset,
              child: Transform.scale(
                scale: boardAttributes.holeCardViewScale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // main hole card view
                    holeCardView(context),

                    // all hole card selection button
                    _buildAllHoleCardSelectionButton(),
                  ],
                ),
              ),
            ),

            Align(
              child: Transform.scale(
                scale: 0.80,
                child: StraddleDialog(
                  straddlePrompt: straddlePrompt,
                  onSelect: (List<bool> optionAutoValue) {
                    print(optionAutoValue);

                    final straddleOption = optionAutoValue[0];
                    final autoStraddle = optionAutoValue[1];
                    final straddleChoice = optionAutoValue[2];
                    if (straddleChoice != null) {
                      gameState.straddlePrompt = false;
                      final straddlePromptState =
                          gameState.straddlePromptState(context);
                      straddlePromptState.notify();

                      if (straddleChoice == true) {
                        // act now
                        log('Player wants to straddle');
                        HandActionService.takeAction(
                          context: context,
                          action: AppConstants.STRADDLE,
                          amount: 2 * gameState.gameInfo.bigBlind,
                        );
                      } else {
                        log('Player does not want to straddle');
                        // show action buttons
                        gameState.showAction(context, true);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    final boardAttributes = context.read<BoardAttributesObject>();

    return ListenableProvider(
      create: (_) => ValueNotifier<bool>(false),
      builder: (BuildContext context, __) => Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildholeCardViewAndStraddleDialog(
                gameState, boardAttributes, gameState.straddlePrompt),
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

  Widget holeCardView(BuildContext context) {
    final gameState = GameState.getState(context);

    Widget cardsWidget = cards(
      playerFolded: widget.playerModel.playerFolded,
      cardsInt: widget.playerModel?.cards,
      straddlePrompt: gameState.straddlePrompt,
    );

    if (gameState.straddlePrompt) {
      return cardsWidget;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isCardVisible = !_isCardVisible;
          print('i am here');
        });
      },
      // onLongPress: () {
      //   setState(() => _isCardVisible = true);
      // },
      // onLongPressEnd: (_) {
      //   setState(() => _isCardVisible = false);
      // },
      child: cardsWidget,
    );
  }

  Widget cards({
    List<int> cardsInt,
    @required playerFolded,
    bool straddlePrompt,
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

    bool cardVisible = _isCardVisible;

    if (straddlePrompt) {
      cardVisible = false;
    }

    return HoleStackCardView(
      cards: cards,
      deactivated: playerFolded ?? false,
      isCardVisible: cardVisible,
    );
  }
}
