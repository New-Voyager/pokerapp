import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ResultOptionsWidget extends StatelessWidget {
  final GameState gameState;
  final ValueNotifier<bool> isHoleCardsVisibleVn;

  const ResultOptionsWidget({Key key, this.gameState, this.isHoleCardsVisibleVn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final bool isRabbitHuntAllowed = gameState.gameInfo.allowRabbitHunt;

    return Consumer2<HandChangeState, RabbitState>(
      builder: (context, vnfs, rb, __) {
        bool _showEye = false;
        // if (gameState.mySeat != null && !gameState.mySeat.player.inhand) {
        //   return Container();
        // }
        // _showEye = gameState.handState == HandState.RESULT;
        // final bool _showRabbit = rb.show && isRabbitHuntAllowed;
        // final bool visibility = gameState.handState == HandState.RESULT &&
        //       (_showEye || _showRabbit);
        //log('RabbitState: building: visibility: $visibility handState: ${gameState.handState} _showEye: $_showEye rb.show: ${rb.show} rabbitHuntAllowed: $isRabbitHuntAllowed');
        bool visibility = true;
        bool _showRabbit = true;

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
    await showDialog(
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        return ListenableProvider(
            create: (_) {
              return ValueNotifier<bool>(false);
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: 200.ph,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
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
                            ? _buildShareButton(context, theme, rs)
                            : _buildRevealButton(vnIsRevealed, theme),
                      ),
                    ),

                    // sep
                    
                    // finally show here the community cards
                    Consumer<ValueNotifier<bool>>(
                      builder: (_, vnIsRevealed, __) => Transform.scale(
                        scale: 1.2,
                        child: _buildCommunityCardWidget(rs, vnIsRevealed.value),
                      ),
                    ),
                    
                  ],
                ),
              ),
            )
          );
        }
    );
  }
      // reveal button tap
    void _onRevealButtonTap(ValueNotifier<bool> vnIsRevealed) async {
      // deduct two diamonds
      final bool deducted = await gameState.gameHiveStore.deductDiamonds();

      // show community cards - only if deduction was possible
      if (deducted) vnIsRevealed.value = true;
    }

    // share button tap
    void _onShareButtonTap(BuildContext context, RabbitState rs) {
      // collect all the necessary data and send in the game chat channel
      gameState.gameComService.chat.sendRabbitHunt(rs);

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

    Widget _buildShareButton(BuildContext context, AppTheme theme, RabbitState rs) {
      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            _onShareButtonTap(context, rs);
          },
          child: Icon(
            Icons.share_rounded,
            color: theme.accentColor,
            size: 30.0,
          ),
        ),
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
      return isRevealed
          ? StackCardView00(
              cards: rs.communityCards,
            )
          : StackCardView00(
              cards: _getHiddenCards(rs),
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
                              child: _buildCommunityCardWidget(rs, vnIsRevealed.value),
                        );
                      }
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
    context.read<RabbitState>().putResultProto(null);
  }    
}