import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/animating_widgets/stack_reload_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/help_text.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/milliseconds_counter.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/hole_stack_card_view.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:pokerapp/widgets/text_widgets/name_plate/name_plate_stack_text.dart';
import 'package:provider/provider.dart';

import '../models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';

class HoleCardsNameplate extends StatefulWidget {
  final Key globalKey;
  final Seat seat;
  final BoardAttributesObject boardAttributes;
  final vnIsPlayingTickingSound = ValueNotifier<bool>(false);

  static const highlightColor = const Color(0xfffffff);
  static const shrinkedSizedBox = const SizedBox.shrink();

  HoleCardsNameplate(
    this.seat, {
    @required this.globalKey,
    @required this.boardAttributes,
  });

  @override
  State<HoleCardsNameplate> createState() => _HoleCardsNameplateState();
}

class _HoleCardsNameplateState extends State<HoleCardsNameplate> {
  final ValueNotifier<bool> isHoleCardsVisibleVn = ValueNotifier(false);

  final vnIsPlayingTickingSound = ValueNotifier<bool>(false);

  @override
  void initState() {
    isHoleCardsVisibleVn.value = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);

    Provider.of<RedrawNamePlateSectionState>(context);

    String playerName = '';
    if (widget.seat.player != null) {
      playerName = widget.seat.player.name;
    }
    if (playerName == null) {
      playerName = '';
    }

    Widget progressWidget = SizedBox.shrink();

    if (widget.seat.player?.highlight ?? false) {
      progressWidget = Consumer<ActionTimerState>(
        builder: (_, __, ___) {
          int total = widget.seat.actionTimer.getTotalTime();
          int lastRemainingTime = widget.seat.actionTimer.getRemainingTime();
          int progressTime = widget.seat.actionTimer.getTotalTime() -
              widget.seat.actionTimer.getRemainingTime();

          return CountdownMs(
            key: UniqueKey(),
            totalSeconds: widget.seat.actionTimer.getTotalTime(),
            currentSeconds: progressTime,
            build: (_, time) {
              int remainingTime = time.toInt();
              int remainingTimeInSecs = remainingTime ~/ 1000;
              if (widget.seat.serverSeatPos == 1) {
                if (lastRemainingTime != remainingTimeInSecs) {
                  lastRemainingTime = remainingTimeInSecs;
                }
              }
              widget.seat.actionTimer.setRemainingTime(remainingTimeInSecs);

              if (vnIsPlayingTickingSound.value == false &&
                  remainingTimeInSecs < 7.0) {
                vnIsPlayingTickingSound.value = true;
                AudioService.playClockTicking(mute: false);
              }

              double progressValue = time.toInt() / (total * 1000);
              return Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 6,
                  // backgroundColor: Colors.transparent,
                  color: progressValue < 0.5 ? Colors.red : Colors.green,
                  semanticsLabel: 'Linear progress indicator',
                ),
              );
            },
          );
        },
      );
    }

    double cardsPos = -70;
    bool leftAlign = true;

    if (widget.seat.seatPos == SeatPos.topLeft ||
        widget.seat.seatPos == SeatPos.middleLeft ||
        widget.seat.seatPos == SeatPos.bottomLeft ||
        widget.seat.seatPos == SeatPos.topCenter1 ||
        widget.seat.seatPos == SeatPos.bottomCenter) {
      leftAlign = true;
    } else {
      leftAlign = false;
    }

    return Consumer3<SeatChangeNotifier, GameContextObject, AppTheme>(
      key: widget.globalKey,
      builder: (
        context,
        hostSeatChange,
        gameContextObject,
        theme,
        _,
      ) {
        return Container(
          height: 60,
          width: 150,
          clipBehavior: Clip.none,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 60,
                width: 150,
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Align(
                      alignment: leftAlign
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Padding(
                        padding: leftAlign
                            ? const EdgeInsets.only(left: 30.0)
                            : const EdgeInsets.only(right: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: leftAlign
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              child: Text(
                                playerName,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              "950",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                            ),
                            // _bottomWidget(context, theme),
                          ],
                        ),
                      ),
                    ),
                    progressWidget,
                  ],
                ),
              ),
              leftAlign
                  ? Positioned(
                      left: cardsPos,
                      child: Container(
                        width: 100,
                        height: 60,
                        padding: widget.seat.isMe
                            ? EdgeInsets.zero
                            : EdgeInsets.all(5),
                        child: Center(
                            child: _buildHoleCardView(context, Container())),
                      ),
                    )
                  : Positioned(
                      right: cardsPos,
                      child: Container(
                        width: 100,
                        height: 60,
                        padding: widget.seat.isMe
                            ? EdgeInsets.zero
                            : EdgeInsets.all(5),
                        child: Center(
                            child: _buildHoleCardView(context, Container())),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomWidget(BuildContext context, AppTheme theme) {
    if (widget.seat.player == null) {
      return const SizedBox.shrink();
    }

    if (widget.seat.player.inBreak &&
        widget.seat.player.breakTimeExpAt != null &&
        !widget.seat.player.isMe) {
      return GamePlayScreenUtilMethods.breakBuyIntimer(
        context,
        widget.seat,
      );
    }

    if (widget.seat.player.action.action != HandActions.ALLIN &&
        widget.seat.player.stack == 0 &&
        widget.seat.player.buyInTimeExpAt != null &&
        !widget.seat.player.isMe) {
      return GamePlayScreenUtilMethods.breakBuyIntimer(context, widget.seat);
    } else {
      if (widget.seat.player != null) {
        return Container(
          height: double.infinity,
          child: _buildPlayerStack(context, theme),
        );
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _buildPlayerStack(BuildContext context, AppTheme theme) {
    Widget _buildStackTextWidget(double stack) => FittedBox(
          fit: BoxFit.fitHeight,
          child: NamePlateStackText(stack),
        );

    if (widget.seat.player.reloadAnimation == true)
      return StackReloadAnimatingWidget(
        seat: widget.seat,
        stackReloadState: widget.seat.player.stackReloadState,
        stackTextBuilder: _buildStackTextWidget,
      );

    return _buildStackTextWidget(widget.seat.player.stack);
  }

  Widget _buildHoleCardView(BuildContext context, Widget rankText) {
    final gameState = GameState.getState(context);
    final theme = AppTheme.getTheme(context);
    final playerCards = gameState.getHoleCards();
    final boardAttributes = gameState.getBoardAttributes(context);
    // log('Holecards: rebuilding. Hole cards: ${playerCards}');
    bool playerFolded = false;
    if (gameState.me != null) {
      playerFolded = gameState.me.playerFolded;
    }

    Widget cardsWidget = cards(
      gameState: gameState,
      playerFolded: playerFolded,
      cardsInt: playerCards,
      straddlePrompt: gameState.straddlePrompt,
    );

    if (gameState.straddlePrompt) return cardsWidget;

    Widget shuffleButton = Container();
    if (gameState.me != null && gameState.me.cards != null) {
      if (gameState.me.cards.length > 2 &&
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
        isHoleCardsVisibleVn.value = !isHoleCardsVisibleVn.value;

        // write the final _isCardVisible value to local storage
        gameState.gameHiveStore.setHoleCardsVisibilityState(
          isHoleCardsVisibleVn.value,
        );

        gameState.holeCardsState.notify();
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: isHoleCardsVisibleVn,
          builder: (_, isCardVisible, __) {
            return Container(
              child: Center(
                child: DebugBorderWidget(
                  color: Colors.green,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Align(
                          // alignment: (boardAttributes.isOrientationHorizontal)
                          //     ? Alignment.center
                          //     : Alignment.bottomCenter,
                          alignment: Alignment.center,
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
          isCardVisible: (widget.seat.player == gameState.me)
              ? straddlePrompt
                  ? false
                  : cardVisible
              : false,
        );
      },
    );
  }
}
