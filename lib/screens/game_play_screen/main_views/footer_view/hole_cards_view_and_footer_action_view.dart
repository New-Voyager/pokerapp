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

class HoleCardsViewAndFooterActionView extends StatelessWidget {
  final PlayerModel playerModel;

  HoleCardsViewAndFooterActionView({this.playerModel});

  final ValueNotifier<bool> _showDarkBackgroundVn = ValueNotifier(false);
  final ValueNotifier<bool> _isCardVisibleVn = ValueNotifier(false);

  bool _showAllCardSelectionButton(var vnfs) {
    final bool isInResult = vnfs.value == FooterStatus.Result;
    return isInResult && (playerModel?.playerFolded ?? false);
  }

  void _markAllCardsAsSelected(BuildContext context) {
    // flip all the cards to front, if not already
    _isCardVisibleVn.value = true;

    // mark all the cards for revealing
    context.read<MarkedCards>().markAll(playerModel.cardObjects);
  }

  Widget _buildAllHoleCardSelectionButton() =>
      Consumer<ValueNotifier<FooterStatus>>(
        builder: (context, vnfs, __) {
          bool _showEye = _showAllCardSelectionButton(vnfs);
          return Opacity(
            opacity: _showEye ? 1.0 : 0.0,
            child: InkWell(
              onTap: _showEye ? () => _markAllCardsAsSelected(context) : null,
              child: Icon(Icons.visibility_rounded),
            ),
          );
        },
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
                    _buildHoleCardView(context),

                    // all hole card selection button
                    _buildAllHoleCardSelectionButton(),
                  ],
                ),
              ),
            ),

            Consumer<StraddlePromptState>(
              builder: (_, __, ___) => Align(
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
            ),
          ],
        ),
      );

  Widget _buildDarkBackground() => ValueListenableBuilder<bool>(
        valueListenable: _showDarkBackgroundVn,
        builder: (_, showDarkBg, __) => AnimatedSwitcher(
          duration: AppConstants.fastAnimationDuration,
          reverseDuration: AppConstants.fastAnimationDuration,
          child: showDarkBg
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.80),
                )
              : const SizedBox.shrink(),
        ),
      );

  Widget _buildFooterActionView(BuildContext context) => FooterActionView(
        gameContext: context.read<GameContextObject>(),
        isBetWidgetVisible: (bool isBetWidgetVisible) =>
            _showDarkBackgroundVn.value = isBetWidgetVisible,
      );

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    final boardAttributes = context.read<BoardAttributesObject>();

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: _buildholeCardViewAndStraddleDialog(
            gameState,
            boardAttributes,
            gameState.straddlePrompt,
          ),
        ),

        /* dark overlay to show in-front of cards, when the bet widget is displayed */
        _buildDarkBackground(),

        // action view (show when it is time for this user to act)
        Align(
          alignment: Alignment.bottomCenter,
          child: Consumer<ActionState>(
            builder: (context, actionState, __) => actionState.show
                ? _buildFooterActionView(context)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildHoleCardView(BuildContext context) {
    final gameState = GameState.getState(context);

    Widget cardsWidget = cards(
      playerFolded: playerModel.playerFolded,
      cardsInt: playerModel?.cards,
      straddlePrompt: gameState.straddlePrompt,
    );

    if (gameState.straddlePrompt) return cardsWidget;

    return GestureDetector(
      onTap: () => _isCardVisibleVn.value = !_isCardVisibleVn.value,
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

    return ValueListenableBuilder<bool>(
      valueListenable: _isCardVisibleVn,
      builder: (_, isCardVisible, __) => HoleStackCardView(
        cards: cards,
        deactivated: playerFolded ?? false,
        isCardVisible: straddlePrompt ? false : isCardVisible,
      ),
    );
  }
}
