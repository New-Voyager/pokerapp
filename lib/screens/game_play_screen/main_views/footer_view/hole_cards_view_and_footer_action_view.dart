import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/widgets/cards/hole_stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:pokerapp/widgets/straddle_dialog.dart';
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

  bool _showAllCardSelectionButton(BuildContext context, var vnfs) {
    final bool isInResult = vnfs.value == FooterStatus.Result;
    return isInResult && (playerModel?.isActive ?? false);
  }

  void _markAllCardsAsSelected(BuildContext context) {
    // flip all the cards to front, if not already
    isHoleCardsVisibleVn.value = true;

    // mark all the cards for revealing
    context.read<MarkedCards>().markAll(playerModel.cardObjects);
  }

  void onRabbitTap(RabbitState rs, BuildContext context) async {
    // reveal button tap
    void _onRevealButtonTap(ValueNotifier<bool> vnIsRevealed) async {
      // deduct two diamonds
      final bool deducted =
          await context.read<GameState>().gameHiveStore.deductDiamonds();

      // show community cards - only if deduction was possible
      if (deducted) vnIsRevealed.value = true;
    }

    // share button tap
    void _onShareButtonTap() {
      // collect all the necessary data and send in the game chat channel
      context.read<GameState>().gameComService.chat.sendRabbitHunt(rs);

      // pop out the dialog
      Navigator.pop(context);
    }

    Widget _buildDiamond() => SvgPicture.asset(
          AppAssets.diamond,
          width: 20.0,
          color: Colors.cyan,
        );

    Widget _buildRevealButton(
        ValueNotifier<bool> vnIsRevealed, AppTheme theme) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // diamond icons
          _buildDiamond(),
          _buildDiamond(),

          // sep
          const SizedBox(width: 10.0),

          // visible button
          GestureDetector(
            onTap: () => _onRevealButtonTap(vnIsRevealed),
            child: Icon(
              Icons.visibility_outlined,
              color: theme.accentColor,
              size: 30.0,
            ),
          ),
        ],
      );
    }

    Widget _buildShareButton(AppTheme theme) {
      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: _onShareButtonTap,
          child: Icon(
            Icons.share_rounded,
            color: theme.accentColor,
            size: 30.0,
          ),
        ),
      );
    }

    List<int> _getHiddenCards() {
      List<int> cards = List.of(rs.communityCards);

      if (rs.revealedCards.length == 2) {
        cards[3] = cards[4] = 0;
      } else {
        cards[4] = 0;
      }

      return cards;
    }

    Widget _buildCommunityCardWidget(bool isRevealed) {
      return isRevealed
          ? StackCardView00(
              cards: rs.communityCards,
            )
          : StackCardView00(
              cards: _getHiddenCards(),
            );
    }

    // show a popup
    await showDialog(
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        return ListenableProvider.value(
          // pass down the cards back string asset to the new dialog
          value: context.read<ValueNotifier<String>>(),
          child: ListenableProvider(
            create: (_) {
              return ValueNotifier<bool>(false);
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.70,
                decoration: BoxDecoration(
                  color: theme.accentColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* hand number */
                    Text('Hand #${rs.handNo}'),

                    // sep
                    const SizedBox(height: 15.0),

                    /* your cards */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Your cards:'),
                        const SizedBox(width: 10.0),
                        StackCardView00(
                          cards: rs.myCards,
                        ),
                      ],
                    ),

                    // sep
                    const SizedBox(height: 15.0),

                    // diamond widget
                    Provider.value(
                      value: context.read<GameState>(),
                      child: Consumer<ValueNotifier<bool>>(
                        builder: (_, __, ___) => NumDiamondWidget(),
                      ),
                    ),

                    // sep
                    const SizedBox(height: 15.0),

                    // show REVEAL button / share button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Consumer<ValueNotifier<bool>>(
                        builder: (_, vnIsRevealed, __) => vnIsRevealed.value
                            ? _buildShareButton(theme)
                            : _buildRevealButton(vnIsRevealed, theme),
                      ),
                    ),

                    // sep
                    const SizedBox(height: 15.0),

                    // finally show here the community cards
                    Consumer<ValueNotifier<bool>>(
                      builder: (_, vnIsRevealed, __) => Transform.scale(
                        scale: 1.2,
                        child: _buildCommunityCardWidget(vnIsRevealed.value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // as soon as the dialog is closed, nullify the result
    context.read<RabbitState>().putResult(null);
  }

  Widget _buildAllHoleCardAndRabbitHuntSelectionButton(context) {
    final bool isRabbitHuntAllowed = Provider.of<GameState>(
      context,
      listen: false,
    ).gameInfo.allowRabbitHunt;

    return Consumer2<ValueNotifier<FooterStatus>, RabbitState>(
      builder: (context, vnfs, rb, __) {
        final bool _showEye = _showAllCardSelectionButton(context, vnfs);
        final bool _showRabbit = rb.show && isRabbitHuntAllowed;

        return Visibility(
          // if in result and (a reason to show), we show the bar
          visible:
              vnfs.value == FooterStatus.Result && (_showEye || _showRabbit),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black.withOpacity(0.70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // hole card selection button and rabbit hunt button
              children: [
                // hole card selection button
                _showEye
                    ? GameCircleButton(
                        iconData: Icons.visibility_rounded,
                        onClickHandler: () => _markAllCardsAsSelected(context),
                      )
                    : const SizedBox.shrink(),

                // rabbit hunt button
                _showRabbit
                    ? GameCircleButton(
                        onClickHandler: () => onRabbitTap(rb.copy(), context),
                        imagePath: AppAssets.rabbit,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildholeCardViewAndStraddleDialog(
    GameState gameState,
    BoardAttributesObject boardAttributes,
  ) {
    return Builder(builder: (context) {
      List<Widget> children = [];
      final gameState = GameState.getState(context);
      // if (gameState.customizationMode) {
      //   children.add(BetIconButton());
      // }

      children.addAll([
        // // main hole card view
        Consumer3<StraddlePromptState, HoleCardsState, MyState>(
          builder: (_, __, ___, ____, _____) => _buildHoleCardView(context),
        ),

        // all hole card selection button
        _buildAllHoleCardAndRabbitHuntSelectionButton(context),
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

          Consumer<StraddlePromptState>(builder: (_, straddlePromptState, ___) {
            final gameState = GameState.getState(context);
            if (gameState.customizationMode) {
              return Container();
            }
            return Align(
              child: Transform.scale(
                scale: 0.80,
                child: StraddleDialog(
                  straddlePrompt: gameState.straddlePrompt,
                  gameState: gameState,
                  onSelect: (List<bool> optionAutoValue) {
                    final straddleOption = optionAutoValue[0];
                    final autoStraddle = optionAutoValue[1];
                    final straddleChoice = optionAutoValue[2];

                    // put the settings in the game state settings
                    gameState.settings.straddleOption = straddleOption;
                    gameState.settings.autoStraddle = autoStraddle;

                    if (straddleChoice != null) {
                      gameState.straddlePrompt = false;
                      straddlePromptState.notify();

                      if (straddleChoice == true) {
                        // act now
                        log('Player wants to straddle');
                        HandActionProtoService.takeAction(
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
            );
          }),
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

  Widget _buildFooterActionView(BuildContext context, GameContextObject gco) =>
      FooterActionView(
        gameContext: gco,
        isBetWidgetVisible: (bool isBetWidgetVisible) =>
            _showDarkBackgroundVn.value = isBetWidgetVisible,
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
          child: Consumer<ActionState>(
            builder: (context, actionState, __) => actionState.show
                ? _buildFooterActionView(context, gco)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _getRankText(GameState gameState, BuildContext context) {
    final me = gameState.me(context);
    final theme = AppTheme.getTheme(context);
    Color borderColor = theme.accentColorWithDark();
    if (me == null || me.rankText == '') {
      borderColor = Colors.transparent;
    }

    Widget rankText = me == null
        ? const SizedBox.shrink()
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.pw,
              vertical: 3.ph,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.pw),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              me.rankText,
              style: AppDecorators.getHeadLine5Style(theme: theme),
            ),
          );
    return rankText;
  }

  Widget _buildHoleCardView(BuildContext context) {
    log('HoleCards: rebuilding');
    final gameState = GameState.getState(context);
    final theme = AppTheme.getTheme(context);
    final playerCards = gameState.getHoleCards();
    final boardAttributes = gameState.getBoardAttributes(context);

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
            gameState.changeHoleCardOrder(context);
          },
        );
      }
    }
    Widget rankText = _getRankText(gameState, context);
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
        log('HoleCards: isCardVisible: $isCardVisible');
        return HoleStackCardView(
          cards: cards,
          deactivated: playerFolded ?? false,
          isCardVisible: straddlePrompt ? false : isCardVisible,
        );
      },
    );
  }
}
