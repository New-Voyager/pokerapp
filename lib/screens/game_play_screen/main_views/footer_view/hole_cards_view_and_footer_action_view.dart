import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/result_options_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/straddle_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/widgets/cards/hole_stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'footer_action_view.dart';

class HoleCardsViewAndFooterActionView extends StatelessWidget {
  final PlayerModel playerModel;
  final ValueNotifier<bool> isHoleCardsVisibleVn;

  HoleCardsViewAndFooterActionView({
    @required this.playerModel,
    @required this.isHoleCardsVisibleVn,
  });

  final ValueNotifier<bool> _showDarkBackgroundVn = ValueNotifier(false);

  // bool _showAllCardSelectionButton(bool isInResult) {
  //   return isInResult && (playerModel?.isActive ?? false);
  // }

  Widget _buildHoleCardViewAndStraddleDialog(
    GameState gameState,
    BoardAttributesObject boardAttributes,
  ) {
    return Builder(builder: (context) {
      // List<Widget> children = [];
      final gameState = GameState.getState(context);
      final theme = AppTheme.getTheme(context);

      Widget rankText;
      rankText = Consumer<MyState>(builder: (_, __, ___) {
        return _getRankText(gameState, context, boardAttributes);
      });

      double scale = boardAttributes.holeCardViewScale;
      final offset = boardAttributes.holeCardViewOffset;
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          gameState.customizationMode
              ? BetIconButton(displayBetText: false)
              : Container(),
          gameState.playerLocalConfig.showHandRank
              ? Align(
                  alignment: Alignment.topCenter,
                  child: rankText,
                )
              : Container(),

          // hole card view & rank Text
          Transform.translate(
            offset: offset,
            child: Transform.scale(
              alignment: Alignment.topCenter,
              scale: scale,
              child: Consumer4<StraddlePromptState, HoleCardsState, MyState,
                  MarkedCards>(
                builder: (_, __, ___, ____, markedCards, _____) {
                  // log('Holecard view: rebuild');
                  return _buildHoleCardView(context);
                },
              ),
            ),
          ),
          StraddleWidget(gameState),
        ],
      );
    });
  }

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

  Widget _buildFooterActionView(
      BuildContext context, GameContextObject gco, ActionState actionState) {
    return FooterActionView(
      gameContext: gco,
      isBetWidgetVisible: (bool isBetWidgetVisible) {
        _showDarkBackgroundVn.value = isBetWidgetVisible;
      },
      actionState: actionState,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    final gco = context.read<GameContextObject>();
    final boardAttributes = context.read<BoardAttributesObject>();

    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildHoleCardViewAndStraddleDialog(
              gameState,
              boardAttributes,
            ),
          ),

          /* dark overlay to show in-front of cards, when the bet widget is displayed */
          _buildDarkBackground(),

          // action view (show when it is time for this user to act)
          Align(
            alignment: Alignment.bottomCenter,
            child: Consumer<ActionState>(builder: (context, actionState, __) {
              if (actionState.show || actionState.showCheckFold) {
                return _buildFooterActionView(context, gco, actionState);
              } else {
                return SizedBox.shrink();
              }
            }),
          ),

          // show post result options
          Align(
            alignment: Alignment.bottomCenter,
            child: ResultOptionsWidget(
              gameState: gameState,
              isHoleCardsVisibleVn: isHoleCardsVisibleVn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRankText(
      GameState gameState, BuildContext context, BoardAttributesObject ba) {
    final me = gameState.me;
    final theme = AppTheme.getTheme(context);
    Color borderColor = theme.secondaryColor;
    if (me == null || me.rankText == '') {
      borderColor = Colors.transparent;
    }

    if (me == null || me.playerFolded) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        me.rankText,
        style: AppDecorators.getHeadLine5Style(theme: theme).copyWith(
          fontSize: ba.selfRankTextSize,
        ),
      ),
    );
  }

  Widget _buildHoleCardView(BuildContext context) {
    final gameState = GameState.getState(context);
    final theme = AppTheme.getTheme(context);
    final playerCards = gameState.getHoleCards();
    final boardAttributes = gameState.getBoardAttributes(context);
    // log('Holecards: rebuilding. Hole cards: ${playerCards}');
    bool playerFolded = false;
    if (playerModel != null) {
      playerFolded = playerModel.playerFolded;
    }

    Widget cardsWidget = cards(
      gameState: gameState,
      playerFolded: playerFolded,
      cardsInt: playerCards,
      straddlePrompt: gameState.straddlePrompt,
    );

    if (gameState.straddlePrompt) return cardsWidget;

    Widget shuffleButton = Container();
    if (playerModel != null && playerModel.cards != null) {
      if (playerModel.cards.length > 2 &&
          gameState.playerLocalConfig.showRearrange) {
        Color buttonColor = theme.accentColor;
        shuffleButton = InkWell(
          child: Container(
            padding: EdgeInsets.all(2.pw),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme
                  .primaryColorWithDark(), //.primaryColorWithDark(), //buttonColor,
            ),
            child: Icon(
              Icons.autorenew,
              color: theme.accentColor, //theme.primaryColorWithDark(),
              size: 20.pw,
            ),
          ),
          onTap: () {
            gameState.changeHoleCardOrder();
          },
        );
      }
    }

    return Transform.translate(
      offset: boardAttributes.holeCardOffset,
      child: GestureDetector(
        onTap: () {
          isHoleCardsVisibleVn.value = !isHoleCardsVisibleVn.value;

          // write the final _isCardVisible value to local storage
          gameState.gameHiveStore.setHoleCardsVisibilityState(
            isHoleCardsVisibleVn.value,
          );

          gameState.holeCardsState.notify();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            cardsWidget,
            Visibility(
              visible: isHoleCardsVisibleVn.value,
              child: Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: shuffleButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cards({
    GameState gameState,
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
      valueListenable: isHoleCardsVisibleVn,
      builder: (_, isCardVisible, __) {
        bool cardVisible = isCardVisible;
        if (gameState.customizationMode) {
          cardVisible = true;
        }

        // log('Customize: HoleCards: isCardVisible: $isCardVisible cards: $cards cardsInt: $cardsInt');
        return HoleStackCardView(
          cards: cards,
          deactivated: playerFolded ?? false,
          isCardVisible: straddlePrompt ? false : cardVisible,
        );
      },
    );
  }
}
