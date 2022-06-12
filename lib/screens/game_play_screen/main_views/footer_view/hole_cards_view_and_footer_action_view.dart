import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pokerapp/main.dart';
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
import 'package:pokerapp/screens/game_play_screen/widgets/help_text.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/cards/hole_stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'footer_action_view.dart';
import 'footer_game_options.dart';

class HoleCardsViewAndFooterActionView extends StatefulWidget {
  final PlayerModel playerModel;
  final ValueNotifier<bool> isHoleCardsVisibleVn;

  HoleCardsViewAndFooterActionView({
    @required this.playerModel,
    @required this.isHoleCardsVisibleVn,
  });

  @override
  State<HoleCardsViewAndFooterActionView> createState() =>
      _HoleCardsViewAndFooterActionViewState();
}

class _HoleCardsViewAndFooterActionViewState
    extends State<HoleCardsViewAndFooterActionView> {
  final ValueNotifier<bool> _showDarkBackgroundVn = ValueNotifier(false);
  bool showHelpText = true;
  @override
  void initState() {
    super.initState();
    // appService.appSettings.showHoleCardTip = true;
    // appService.appSettings.showHoleRearrangeTip = true;
    showHelpText = false;
    if (!PlatformUtils.isWeb) {
      showHelpText = appService.appSettings.showHoleRearrangeTip;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = GameState.getState(context);
      if (gameState.gameUIState.rearrangeKey == null ||
          gameState.gameUIState.rearrangeKey.currentContext == null) {
        return;
      }
      final box = gameState.gameUIState.rearrangeKey.currentContext
          .findRenderObject() as RenderBox;
      var position = box.localToGlobal(Offset(0, 0));
      Rect rect = Rect.fromLTWH(position.dx, position.dy,
          box.constraints.maxWidth, box.constraints.maxHeight);
      gameState.gameUIState.rearrangeRect = rect;
      log('$rect');
    });
  }

  // bool _showAllCardSelectionButton(bool isInResult) {
  Widget _buildHoleCardViewAndStraddleDialog(
    GameState gameState,
    BoardAttributesObject boardAttributes,
  ) {
    return Builder(builder: (context) {
      // List<Widget> children = [];
      final gameState = GameState.getState(context);
      final theme = AppTheme.getTheme(context);

      double footerHeight = boardAttributes.footerHeight;
      double footerActionViewHeight = 42;
      footerHeight += boardAttributes.bottomHeightAdjust;
      gameState.gameUIState.holeCardsViewSize = Size(
        gameState.gameUIState.holeCardsViewSize.width,
        footerHeight,
      );

      Widget rankText;
      rankText = Consumer<MyState>(builder: (_, __, ___) {
        bool showHandStrength =
            gameState.playerLocalConfig.showHandRank ?? true;
        if (!(gameState.gameSettings.showHandRank ?? false)) {
          showHandStrength = false;
        }

        if (gameState.customizationMode || TestService.isTesting) {
          showHandStrength = true;
        }
        if (showHandStrength) {
          return _getRankText(gameState, context, boardAttributes);
        } else {
          return Container();
        }
      });

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          gameState.customizationMode
              ? BetIconButton(displayBetText: false)
              : const SizedBox.shrink(),

          // hole card view & rank Text

          DebugBorderWidget(
            color: Colors.red,
            child: GestureDetector(
              onPanEnd: (e) {
                int i = 1;
                if (e.velocity.pixelsPerSecond.dx < 0) {
                  i = -1;
                }
                gameState.changeHoleCardOrder(inc: i);
              },
              onTapUp: (tapDetails) {
                //log(tapDetails.globalPosition.toString());
                //log(gameState.gameUIState.cardEyes.toString());

                // see whether we hit the help text
                if (showHelpText &&
                    gameState.gameUIState.rearrangeRect != null) {
                  if (gameState.gameUIState.rearrangeRect
                      .contains(tapDetails.globalPosition)) {
                    //gameState.gameUIState.rearrangeRect = null;
                    log('Hide help text');
                    showHelpText = false;
                    appService.appSettings.showHoleRearrangeTip = false;
                    setState(() {});
                    return;
                  }
                }

                bool hit = false;
                gameState.gameUIState.cardEyes.forEach((key, value) {
                  if (value.contains(tapDetails.globalPosition)) {
                    log("tap");
                    var cardId = gameState.me.cards.firstWhere(
                      (element) => (key == element),
                      orElse: () => null,
                    );
                    if (cardId == null) return;

                    log(cardId.toString());

                    CardObject card = CardHelper.getCard(cardId);
                    gameState.markedCardsState.mark(card, false);
                    hit = true;
                  }
                });
                if (!hit) {
                  widget.isHoleCardsVisibleVn.value =
                      !widget.isHoleCardsVisibleVn.value;
                }
              },
              child: ValueListenableBuilder(
                  valueListenable: widget.isHoleCardsVisibleVn,
                  child: Container(
                    width: gameState.gameUIState.holeCardsViewSize.width,
                    height: footerHeight - footerActionViewHeight,
                    child: Center(
                      child: Consumer4<StraddlePromptState, HoleCardsState,
                          MyState, MarkedCards>(
                        builder: (_, __, ___, ____, markedCards, _____) {
                          // log('Holecard view: rebuild');
                          // return Container();
                          return _buildHoleCardView(context, rankText);
                        },
                      ),
                    ),
                  ),
                  builder: (context, isVisible, child) {
                    return AbsorbPointer(
                      absorbing: isVisible,
                      child: child,
                    );
                  }),
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
    return DebugBorderWidget(
      color: Colors.red,
      child: FooterActionView(
        gameContext: gco,
        isBetWidgetVisible: (bool isBetWidgetVisible) {
          // _showDarkBackgroundVn.value = isBetWidgetVisible;
        },
        actionState: actionState,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    final gco = context.read<GameContextObject>();
    final boardAttributes = context.read<BoardAttributesObject>();
    log('RedrawFooter: rebuilding HoleCardsViewAndFooterActionView');

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

          // action view (show when it is time for this user to act)
          Align(
              alignment: Alignment.bottomCenter,
              child: FooterGameActionView(gameState: gameState)),

          // show post result options
          Align(
            alignment: Alignment.bottomCenter,
            child: ResultOptionsWidget(
              gameState: gameState,
              isHoleCardsVisibleVn: widget.isHoleCardsVisibleVn,
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

    double rankMarigin = 40.0.ph;
    final boardAttributes = gameState.getBoardAttributes(context);

    var padding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
    if (!boardAttributes.isOrientationHorizontal) {
      rankMarigin = 5.0.ph;
      padding = EdgeInsets.symmetric(horizontal: 8, vertical: 2);
    }

    return DebugBorderWidget(
      color: Colors.amber,
      child: (!me.rankText.isEmpty)
          ? Container(
              padding: padding,
              margin: EdgeInsets.only(bottom: rankMarigin),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 49, 46, 46),
                  border: Border.all(color: theme.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                me.rankText,
                style: AppDecorators.getHeadLine5Style(theme: theme).copyWith(
                    fontSize: 10.dp,
                    color: Color.fromARGB(255, 225, 219, 150),
                    fontWeight: FontWeight.bold),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildHoleCardView(BuildContext context, Widget rankText) {
    final gameState = GameState.getState(context);
    final theme = AppTheme.getTheme(context);
    final playerCards = gameState.getHoleCards();
    final boardAttributes = gameState.getBoardAttributes(context);
    // log('Holecards: rebuilding. Hole cards: ${playerCards}');
    bool playerFolded = false;
    if (widget.playerModel != null) {
      playerFolded = widget.playerModel.playerFolded;
    }

    Widget cardsWidget = cards(
      gameState: gameState,
      playerFolded: playerFolded,
      cardsInt: playerCards,
      straddlePrompt: gameState.straddlePrompt,
    );

    if (gameState.straddlePrompt) return cardsWidget;

    Widget shuffleButton = Container();
    if (widget.playerModel != null && widget.playerModel.cards != null) {
      if (widget.playerModel.cards.length > 2 &&
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

    return GestureDetector(
      onTap: () {
        widget.isHoleCardsVisibleVn.value = !widget.isHoleCardsVisibleVn.value;

        // write the final _isCardVisible value to local storage
        gameState.gameHiveStore.setHoleCardsVisibilityState(
          widget.isHoleCardsVisibleVn.value,
        );

        gameState.holeCardsState.notify();
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: widget.isHoleCardsVisibleVn,
          builder: (_, isCardVisible, __) {
            return Container(
              width: gameState.gameUIState.holeCardsViewSize.width,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isHoleCardsVisibleVn.value
                    ? 8 * playerCards.length.toDouble()
                    : 0,
                vertical:
                    context.read<BoardAttributesObject>().screenDiagnolSize >= 7
                        ? 32
                        : 0,
              ),
              child: Center(
                child: DebugBorderWidget(
                  color: Colors.green,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Align(
                          alignment: (boardAttributes.isOrientationHorizontal)
                              ? Alignment.center
                              : Alignment.bottomCenter,
                          child: cardsWidget),
                      Positioned(
                        bottom: -30,
                        child: rankText,
                      ),
                      // Positioned(
                      //   left: 0,
                      //   bottom: 0,
                      //   child: rankText,
                      // ),

                      Visibility(
                        visible: false, //showHelpText && isCardVisible,
                        child: DebugBorderWidget(
                            color: Colors.red,
                            child: HelpText(
                                key: gameState.gameUIState.rearrangeKey,
                                show:
                                    false, //appService.appSettings.showHoleRearrangeTip,
                                text: 'Swipe left or right to rearrange cards',
                                theme: AppTheme.getTheme(context),
                                onTap: () {
                                  // don't show this again
                                  appService.appSettings.showHoleRearrangeTip =
                                      false;
                                })),
                      ),
                      // Visibility(
                      //   visible: isCardVisible && playerCards.length > 0,
                      //   child:
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
      valueListenable: widget.isHoleCardsVisibleVn,
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
