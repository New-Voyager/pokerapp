import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
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
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
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

  Widget _buildholeCardViewAndStraddleDialog(
    GameState gameState,
    BoardAttributesObject boardAttributes,
  ) {
    return Builder(builder: (context) {
      List<Widget> children = [];
      final gameState = GameState.getState(context);

      children.addAll([
        // // main hole card view
        Consumer4<StraddlePromptState, HoleCardsState, MyState, MarkedCards>(
            builder: (_, __, ___, ____, markedCards, _____) {
          log('Holecard view: rebuild');
          return _buildHoleCardView(context);
        }),
      ]);
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          gameState.customizationMode
              ? BetIconButton(displayBetText: false)
              : Container(),
          // hole card view
          Transform.translate(
            offset: boardAttributes.holeCardViewOffset,
            child: Transform.scale(
              scale: boardAttributes.holeCardViewScale,
              child: Stack(
                alignment: Alignment.bottomCenter,
                // mainAxisSize: MainAxisSize.min,
                children: children,
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

  Widget _buildFooterActionView(BuildContext context, GameContextObject gco,
          ActionState actionState) =>
      FooterActionView(
        gameContext: gco,
        isBetWidgetVisible: (bool isBetWidgetVisible) =>
            _showDarkBackgroundVn.value = isBetWidgetVisible,
        actionState: actionState,
      );

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    final gco = context.read<GameContextObject>();
    final boardAttributes = context.read<BoardAttributesObject>();

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: _buildholeCardViewAndStraddleDialog(
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
                isHoleCardsVisibleVn: isHoleCardsVisibleVn)),
      ],
    );
  }

  Widget _getRankText(GameState gameState, BuildContext context) {
    final me = gameState.me;
    final theme = AppTheme.getTheme(context);
    Color borderColor = theme.secondaryColor;
    if (me == null || me.rankText == '') {
      borderColor = Colors.transparent;
    }

    Widget rankText = me == null
        ? const SizedBox.shrink()
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.pw,
              vertical: 2.ph,
            ),
            child: Text(
              me.rankText,
              style: AppDecorators.getHeadLine6Style(theme: theme),
            ),
          );
    return rankText;
  }

  Widget _buildHoleCardView(BuildContext context) {
    final gameState = GameState.getState(context);
    final theme = AppTheme.getTheme(context);
    final playerCards = gameState.getHoleCards();
    final boardAttributes = gameState.getBoardAttributes(context);
    log('Holecards: rebuilding. Hole cards: ${playerCards}');

    Widget cardsWidget = cards(
      playerFolded: playerModel.playerFolded,
      cardsInt: playerCards,
      straddlePrompt: gameState.straddlePrompt,
    );
    if (gameState.straddlePrompt) return cardsWidget;
    Widget shuffleButton = Container();
    if (playerModel != null && playerModel.cards != null) {
      if (playerModel.cards.length > 2) {
        Color buttonColor = theme.accentColor;
        shuffleButton = InkWell(
          child: Container(
            padding: EdgeInsets.all(2.pw),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: buttonColor,
            ),
            child: Icon(Icons.autorenew, color: theme.primaryColorWithDark()),
          ),
          onTap: () {
            gameState.changeHoleCardOrder();
          },
        );
      }
    }

    Widget rankText;
    rankText = _getRankText(gameState, context);

    return GestureDetector(
      onTap: () {
        isHoleCardsVisibleVn.value = !isHoleCardsVisibleVn.value;

        // write the final _isCardVisible value to local storage
        gameState.gameHiveStore.setHoleCardsVisibilityState(
          isHoleCardsVisibleVn.value,
        );
      },
      child: Transform.translate(
          offset: Offset(0, boardAttributes.holeCardOffset),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            rankText,
            SizedBox(
              height: 10.ph,
            ),
            Column(children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  cardsWidget,
                ],
              ),
              shuffleButton,
            ]),
            //shuffleButton,
          ])),
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
      valueListenable: isHoleCardsVisibleVn,
      builder: (_, isCardVisible, __) {
        //
        log('HoleCards: isCardVisible: $isCardVisible cards: $cards cardsInt: $cardsInt');
        return HoleStackCardView(
          cards: cards,
          deactivated: playerFolded ?? false,
          isCardVisible: straddlePrompt ? false : isCardVisible,
        );
      },
    );
  }
}
