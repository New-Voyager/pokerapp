import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/proto/hand.pb.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ResultOptionsWidget extends StatelessWidget {
  final GameState gameState;
  final ValueNotifier<bool> isHoleCardsVisibleVn;

  const ResultOptionsWidget(
      {Key key, this.gameState, this.isHoleCardsVisibleVn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final bool isRabbitHuntAllowed = gameState.gameInfo.allowRabbitHunt;
    return Consumer2<HandResultState, RabbitState>(
      builder: (context, vnfs, rb, __) {
        bool _showEye = false;
        log('ResultOption: Notified');
        if (gameState.mySeat != null && !gameState.mySeat.player.inhand) {
          log('ResultOption: gameState.mySeat != null && !gameState.mySeat.player.inhand');
          return Container();
        }

        if (gameState.handState != HandState.RESULT) {
          log('ResultOption: gameState.handState != HandState.RESULT');
          return Container();
        }
        // Eye: To mark all cards to be revealed
        // If we are in result and this player is a winner, then we show his cards
        // So there is no need to show the eye icon

        // show eye
        if (!gameState.wonAtShowdown) {
          log('ResultOption: gameState.wonAtShowdown');
          // not in show down, show eye
          _showEye = true;
        } else {
          log('ResultOption: 2 gameState.wonAtShowdown');
          // in showdown
          // if the player is a winner, then the cards are shown, no need for eye
          if (gameState.mySeat != null) {
            log('ResultOption: gameState.mySeat != null');
            if (gameState.mySeat.player.winner) {
              log('ResultOption: gameState.mySeat.player.winner');
              _showEye = false;
            } else {
              log('ResultOption: !gameState.mySeat.player.winner');
              // player is not a winner
              // if the player does not muck his cards, then the cards are already shown
              if (!gameState.mySeat.player.muckLosingHand) {
                log('ResultOption: !gameState.mySeat.player.muckLosingHand');
                _showEye = false;
              } else {
                _showEye = true;
              }
            }
          }
        }

        bool _showRabbit = false;
        if (isRabbitHuntAllowed) {
          // if the hand hasn't ended in showdown, don't show the rabbit
          if (gameState.wonat == HandStatus.FLOP ||
              gameState.wonat == HandStatus.TURN) {
            _showRabbit = true;
          }
        }
        final bool visibility = gameState.handState == HandState.RESULT &&
            (_showEye || _showRabbit);
        log('RabbitState: building: visibility: $visibility wonAt: ${gameState.wonat.toString()} community cards: ${rb.communityCards} winner: ${gameState.mySeat.player.winner} handState: ${gameState.handState} _showEye: $_showEye rb.show: ${rb.show} rabbitHuntAllowed: $isRabbitHuntAllowed');
        // bool visibility = true;
        // bool _showRabbit = true;

        return Visibility(
          // if in result and (a reason to show), we show the bar
          visible: visibility,
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
                SizedBox(width: 10.pw),
                // rabbit hunt button
                _showRabbit
                    ? GameCircleButton(
                        onClickHandler: () {
                          onRabbitTap(rb.copy(), context);
                        },
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

  void _markAllCardsAsSelected(BuildContext context) {
    // flip all the cards to front, if not already
    isHoleCardsVisibleVn.value = true;
    final mySeat = gameState.mySeat;
    if (mySeat != null && mySeat.player != null) {
      // mark all the cards for revealing
      gameState.markedCardsState.markAll(mySeat.player.cardObjects);
    }
  }

  void onRabbitTap(RabbitState rs, BuildContext context) async {
    // show a popup
    final AppTheme theme = AppTheme.getTheme(context);
    await showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        //final theme = AppTheme.getTheme(context);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: ListenableProvider(
                create: (_) {
                  return ValueNotifier<bool>(false);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: EdgeInsets.all(16),
                  padding:
                      EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
                  // width: MediaQuery.of(context).size.width * 0.70,
                  // height: 200.ph,
                  decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.accentColor, width: 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // diamond widget
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.cancel,
                              color: theme.accentColor,
                            ),
                          ),
                          Consumer<ValueNotifier<bool>>(
                              builder: (_, __, ___) =>
                                  NumDiamondWidget(gameState.gameHiveStore)),
                        ],
                      ),

                      // sep
                      const SizedBox(height: 8.0),
                      /* hand number */
                      Text(
                        'Hand #${rs.handNo ?? 1}',
                        style: AppDecorators.getHeadLine3Style(theme: theme)
                            .copyWith(color: theme.secondaryColor),
                      ),

                      // sep
                      const SizedBox(height: 15.0),

                      /* your cards */
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Your cards'),
                          const SizedBox(height: 10.0),
                          Transform.scale(
                            scale: 1.5,
                            child: StackCardView00(
                              cards: rs.myCards,
                            ),
                          ),
                        ],
                      ),

                      // sep
                      const SizedBox(height: 15.0),

                      // sep
                      Text("Community cards"),
                      AppDimensionsNew.getVerticalSizedBox(16),
                      // finally show here the community cards
                      Consumer<ValueNotifier<bool>>(
                        builder: (_, vnIsRevealed, __) => Transform.scale(
                          scale: 1.2,
                          child:
                              _buildCommunityCardWidget(rs, vnIsRevealed.value),
                        ),
                      ),

                      AppDimensionsNew.getVerticalSizedBox(32),

                      // show REVEAL button / share button
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Consumer<ValueNotifier<bool>>(
                          builder: (_, vnIsRevealed, __) => vnIsRevealed.value
                              ? _buildShareButton(context, theme, rs)
                              : _buildRevealButton(vnIsRevealed, theme),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0.2, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  // reveal button tap
  void _onRevealButtonTap(ValueNotifier<bool> vnIsRevealed) async {
    // deduct two diamonds
    final bool deducted =
        await playerState.deductDiamonds(AppConfig.noOfDiamondsForReveal);

    // show community cards - only if deduction was possible
    if (deducted) vnIsRevealed.value = true;
  }

  // share button tap
  void _onShareButtonTap(BuildContext context, RabbitState rs) async {
    final bool deducted =
        await playerState.deductDiamonds(AppConfig.noOfDiamondsForReveal);
    if (deducted) {
      // collect all the necessary data and send in the game chat channel
      gameState.gameComService.chat.sendRabbitHunt(rs);

      // pop out the dialog
      Navigator.pop(context);
    }
  }

  Widget _buildDiamond() => SvgPicture.asset(
        AppAssets.diamond,
        width: 20.0,
        color: Colors.cyan,
      );

  Widget _buildRevealButton(ValueNotifier<bool> vnIsRevealed, AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // diamond icons
        Text(
          "${AppConfig.noOfDiamondsForReveal}",
          style: AppDecorators.getAccentTextStyle(theme: theme),
        ),
        _buildDiamond(),

        // sep
        const SizedBox(width: 10.0),

        // visible button

        RoundedColorButton(
          onTapFunction: () => _onRevealButtonTap(vnIsRevealed),
          backgroundColor: theme.accentColor,
          textColor: theme.primaryColorWithDark(),
          text: "Reveal",
          icon: Icon(
            Icons.visibility,
            color: theme.primaryColorWithDark(),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(
      BuildContext context, AppTheme theme, RabbitState rs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // diamond icons
        Text(
          "${AppConfig.noOfDiamondsForShare}",
          style: AppDecorators.getAccentTextStyle(theme: theme),
        ),
        _buildDiamond(),

        // sep
        const SizedBox(width: 10.0),

        RoundedColorButton(
          onTapFunction: () {
            _onShareButtonTap(context, rs);
          },
          text: "Share",
          backgroundColor: theme.accentColor,
          textColor: theme.primaryColorWithDark(),
          icon: Icon(
            Icons.share_rounded,
            color: theme.primaryColorWithDark(),
          ),
        ),
      ],
    );
  }

  List<int> _getHiddenCards(RabbitState rs) {
    List<int> cards = List.of(rs.communityCards);
    if (cards.length >= 5) {
      if (rs.revealedCards.length == 2) {
        cards[3] = cards[4] = 0;
      } else {
        cards[4] = 0;
      }
    }

    return cards;
  }

  Widget _buildCommunityCardWidget(RabbitState rs, bool isRevealed) {
    // return Transform.scale(
    //   scale: 1.5,
    //   child: RabbitCardView(
    //     state: rs,
    //   ),
    // );
    return isRevealed
        ? Transform.scale(
            scale: 1.5,
            child: StackCardView00(
              cards: rs.communityCards,
            ),
          )
        : Transform.scale(
            scale: 1.5,
            child: StackCardView00(
              cards: _getHiddenCards(rs),
            ),
          );
  }

  void onRabbitTap1(RabbitState rs, BuildContext context) async {
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
                    Consumer<ValueNotifier<bool>>(
                      builder: (_, __, ___) =>
                          NumDiamondWidget(gameState.gameHiveStore),
                    ),

                    // sep
                    const SizedBox(height: 15.0),

                    // show REVEAL button / share button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Consumer<ValueNotifier<bool>>(
                        builder: (_, vnIsRevealed, __) => vnIsRevealed.value
                            ? _buildShareButton(context, theme, rs)
                            : _buildRevealButton(vnIsRevealed, theme),
                      ),
                    ),

                    // sep
                    const SizedBox(height: 15.0),

                    // finally show here the community cards
                    Consumer<ValueNotifier<bool>>(
                        builder: (_, vnIsRevealed, __) {
                      log('Building community cards');
                      return Transform.scale(
                        scale: 1.2,
                        child:
                            _buildCommunityCardWidget(rs, vnIsRevealed.value),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // as soon as the dialog is closed, nullify the result
    context.read<RabbitState>().putResultProto(null);
  }
}
