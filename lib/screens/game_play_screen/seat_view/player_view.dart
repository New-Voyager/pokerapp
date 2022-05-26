import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/set_credits_dialog.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/displaycards.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/nameplate_dialog.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:provider/provider.dart';

import 'action_status.dart';
import 'animating_widgets/fold_card_animating_widget.dart';
import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'chip_amount_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'nameplate_cards.dart';
import 'open_seat.dart';

/* this contains the player positions <seat-no, position> mapping */
// Map<int, Offset> playerPositions = Map();
const Duration _lottieAnimationDuration = const Duration(milliseconds: 3000);

class PlayerView extends StatefulWidget {
  final Seat seat;
  final Alignment cardsAlignment;
  final Function(Seat seat) onUserTap;
  final GameComService gameComService;
  final BoardAttributesObject boardAttributes;
  final GameContextObject gameContextObject;
  final GameState gameState;

  PlayerView({
    Key key,
    @required this.seat,
    @required this.onUserTap,
    @required this.gameComService,
    @required this.boardAttributes,
    @required this.gameContextObject,
    this.cardsAlignment = Alignment.centerRight,
    this.gameState,
  }) : super(key: key);

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> with TickerProviderStateMixin {
  GameState get gameState => widget.gameState;

  TableState _tableState;

  HandInfoState _handInfoState;

  AnimationController _lottieController;
  AssetImage _gifAssetImage;

  Timer _messagePopupTimer;

  double giphySize = 32.0;

  @override
  void initState() {
    super.initState();

    _handInfoState = context.read<HandInfoState>();

    _lottieController = AnimationController(
      vsync: this,
      duration: _lottieAnimationDuration,
    );
    _lottieController.addListener(() {
      /* after the lottie animation is completed reset everything */
      if (_lottieController.isCompleted) {
        setState(() {});

        _lottieController.reset();
      }
    });

    _tableState = context.read<TableState>();
  }

  @override
  void dispose() {
    super.dispose();
    _lottieController?.dispose();
    _messagePopupTimer?.cancel();
  }

  void _onTap(BuildContext context) async {
    if (widget.gameState.handState == HandState.RESULT &&
        widget.seat.player.winner == true) {
      final enlargeVn = widget.seat.enLargeCardsVn;

      enlargeVn.value = !enlargeVn.value;
      return;
    }

    final seatChangeContext = Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    );

    if (gameState.customizationMode) {
      return;
    }

    if (seatChangeContext != null && seatChangeContext.seatChangeInProgress) {
      return;
    }
    log('seat ${widget.seat.seatPos.toString()} is tapped');
    if (widget.seat.isOpen) {
      final tableState = gameState.tableState;
      if (gameState.myStatus == AppConstants.PLAYING &&
          tableState.gameStatus == AppConstants.GAME_RUNNING) {
        log('Ignoring the open seat tap as the player is sitting and game is running');
        return;
      }
      log('seat no: ${widget.seat.serverSeatPos}');
      // the player tapped to sit-in
      widget.onUserTap(widget.seat);
    } else {
      // the player tapped to see the player profile
      final gameState = Provider.of<GameState>(
        context,
        listen: false,
      );

      final me = gameState.me;
      // If user is not playing do not show dialog
      // if (me == null) {
      //   return;
      // }
      final mySeat = gameState.mySeat;
      if (!gameState.currentPlayer.isAdmin()) {
        if (mySeat == null) {
          return;
        }
      }
      // if (me != null && widget.seat.seatPos == mySeat.seatPos) {
      //   return;
      // }

      final data = await Alerts.showBottomSheetDailog(
        child: NamePlateDailog(
          gameContext: context,
          gameContextObject: widget.gameContextObject,
          gameState: gameState,
          seatKey: widget.seat.key,
          seat: widget.seat,
        ),
        context: context,
      );

      if (data != null && data is Map) {
        if (data != null &&
            data['type'] != null &&
            data['type'] == "animation") {
          final bool result = TestService.isPartialTesting
              ? true
              : await playerState.deductDiamonds(
                  AppConfig.noOfDiamondsForAnimation,
                );
          if (result) {
            gameState.gameComService.gameMessaging.sendAnimation(
              gameState.me?.seatNo,
              widget.seat.player.seatNo,
              data['animationID'],
            );
          }
        }

        if (data != null && data['type'] != null && data['type'] == "buyin") {
          await _handleLimitButtonClick(context, widget.seat);
        }

        if (data != null && data['type'] != null && data['type'] == "host") {
          await _handleHostButtonClick(context);
        }

        if (data != null && data['type'] != null && data['type'] == "credits") {
          // set credits for the player
          bool ret = await SetCreditsDialog.prompt(
              context: context,
              clubCode: gameState.gameInfo.clubCode,
              playerUuid: widget.seat.player.playerUuid,
              name: widget.seat.player.name,
              credits: null);
          if (ret ?? false) {}
        }
      }
    }
  }

  _handleLimitButtonClick(BuildContext context, Seat seat) async {
    final TextEditingController _controller = TextEditingController();
    final result = await showPrompt(
      context,
      "Set Buyin Limit",
      "",
      child: CardFormTextField(
        hintText: "Enter value",
        controller: _controller,
        theme: AppTheme.getTheme(context),
        keyboardType: TextInputType.number,
      ),
    );
    if (result != null) {
      if (result == true) {
        // setbuyin limit
        double limit;
        try {
          limit = double.parse(_controller.text.toString());
          await GameService.setBuyinLimit(
              gameCode: gameState.gameCode,
              playerUuid: seat.player.playerUuid,
              playerId: seat.player.playerId,
              limit: limit);
          Alerts.showNotification(titleText: "Buyin limit applied.");
        } catch (e) {}
      } else {
        return;
      }
    }
  }

  _handleHostButtonClick(BuildContext context) async {
    final result = await showPrompt(context, "Assign Host",
        "Do you want to assign '${gameState.currentPlayer.name}' as host?",
        positiveButtonText: "Yes", negativeButtonText: "No");
    if (result != null) {
      if (result == true) {
        // setbuyin limit
        try {
          final result = await GameService.assignHost(
            gameCode: gameState.gameCode,
            playerId: gameState.currentPlayer.uuid,
          );
          if (result != null && result == true) {
            Alerts.showNotification(titleText: "Assigned a new host.");
          }
        } catch (e) {}
      } else {
        return;
      }
    }
  }

  Widget _buildDisplayCardsWidget(
    Seat seat,
    HandState handState,
  ) {
    final bool isReplayHandsActor = seat?.player?.playerUuid == '';

    // the following rules don't apply to the replay hands actor
    bool showDisplayCards = true;

    if (!isReplayHandsActor) {
      if (handState != HandState.RESULT) {
        showDisplayCards = false;
      } else if (seat.player != null && !seat.player.inhand) {
        showDisplayCards = false;
      }
    }

    return ValueListenableBuilder(
      valueListenable: gameState.throwingCardsVn,
      child: DisplayCardsWidget(
        isReplayHandsActor: isReplayHandsActor,
        seat: seat,
        showdown: widget.gameState.showdown,
        colorCards: widget.gameState.playerLocalConfig.colorCards,
      ),
      builder: (_, bool throwCards, Widget child) {
        if (throwCards) {
          return FoldCardAnimatingWidget(
            key: UniqueKey(),
            seat: seat,
            child: child,
          );
        }

        // show the display cards, if required
        return showDisplayCards ? child : const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    bool openSeat = widget.seat.isOpen;
    bool isMe = widget.seat.isMe;
    bool showdown = gameState.showdown;

    // if open seat, just show open seat widget
    if (openSeat) {
      bool seatChangeSeat = false;
      if (gameState.playerSeatChangeInProgress) {
        if (gameState.seatChangeSeat != null) {
          seatChangeSeat =
              widget.seat.seatPos == gameState.seatChangeSeat.seatPos;
        }
      }

      final openSeatWidget = OpenSeat(
        seat: widget.seat,
        onUserTap: this.widget.onUserTap,
        seatChangeInProgress: gameState.hostSeatChangeInProgress,
        seatChangeSeat: seatChangeSeat,
      );

      List<Widget> children = [];

      if (widget.seat.dealer) {
        children.add(
          // dealer button
          DealerButtonWidget(
            widget.seat.seatPos,
            isMe,
            GameType.HOLDEM,
          ),
        );
      }
      children.add(openSeatWidget);

      children.add(
        Consumer<SeatChangeNotifier>(
          builder: (_, scn, __) {
            return (gameState.hostSeatChangeInProgress ||
                    gameState.playerSeatChangeInProgress)
                ? SeatNoWidget(widget.seat)
                : const SizedBox.shrink();
          },
        ),
      );

      return Stack(alignment: Alignment.center, children: children);
    }

    final GameInfoModel gameInfo =
        context.read<ValueNotifier<GameInfoModel>>().value;
    String gameCode = gameInfo.gameCode;
    bool isDealer = false;

    if (!openSeat) {
      if (widget.seat.dealer) {
        isDealer = true;
      }
    }
    bool showFirework = false;
    if (!openSeat ? widget.seat.player?.showFirework ?? false : false) {
      showFirework = true;
    }

    bool showWinnerLottie = false;
    if (widget.seat.player != null && widget.seat.player.winner) {
      showWinnerLottie = true;
    }

    bool highlight = false;
    double scale = 1.0;
    if (widget.seat.player != null) {
      highlight = widget.seat.player.highlight;
      if (highlight) {
        // scale = 1.3;
      }
    }

    // we constrain the size to NOT shift the players widgets
    // and for large size fireworks, we use a scaling factor
    Size fireworksContainer = Size(50, 50);
    double fireworksScale = 1.5;

    final boardAttributes = gameState.getBoardAttributes(context);
    widget.seat.betWidgetUIKey = GlobalKey();

    bool animate = widget.seat.player.action.animateAction;

    Widget chipAmountWidget;

    if (gameState.hostSeatChangeInProgress) {
      chipAmountWidget = SizedBox(width: 5, height: 5);
    } else {
      chipAmountWidget = ChipAmountWidget(
        animate: animate,
        potKey: boardAttributes.potKey,
        key: widget.seat.betWidgetUIKey,
        seat: widget.seat,
        boardAttributesObject: boardAttributes,
        gameInfo: gameInfo,
        reverse: widget.seat.player.winner,
        gameState: widget.gameState,
      );
    }
    return DragTarget(
      onWillAccept: (data) {
        // log("SeatChange: Player onWillAccept $data");
        widget.seat.dragEntered = true;
        setState(() {});
        return true;
      },
      onLeave: (data) {
        // log("SeatChange: Player onLeave $data");
        widget.seat.dragEntered = false;
        setState(() {});
      },
      onAccept: (data) {
        // log('SeatChange: onDropped ${data}');
        widget.seat.dragEntered = false;
        setState(() {});
        // call the API to make the seat change
        SeatChangeService.hostSeatChangeMove(
          gameCode,
          data,
          widget.seat.serverSeatPos,
        );
      },
      builder: (context, List<int> candidateData, rejectedData) {
        Offset notesOffset = Offset(0, 0);
        final double namePlateWidth = NamePlateWidgetParent.namePlateSize.width;
        SeatPos pos = widget.seat.seatPos ?? SeatPos.bottomLeft;
        double actionLeft = null;
        double actionRight = null;
        if (pos == SeatPos.bottomLeft ||
            pos == SeatPos.middleLeft ||
            pos == SeatPos.topLeft ||
            pos == SeatPos.topCenter ||
            pos == SeatPos.topCenter1) {
          //actionLeft = 0;
          notesOffset = Offset(-((namePlateWidth / 1.5)), 0);
        } else {
          //actionRight = 0;
          notesOffset = Offset(((namePlateWidth / 2)), 0);
        }

        if (widget.seat.seatPos == SeatPos.middleLeft ||
            widget.seat.seatPos == SeatPos.topLeft ||
            widget.seat.seatPos == SeatPos.bottomLeft) {
          actionLeft = 0;
          actionRight = null;
        } else {
          actionLeft = null;
          actionRight = 0;
        }

        Key key = widget.seat.key;
        double opacity = 1.0;

        if (!widget.seat.isOpen) {
          if (widget.seat.player.highlight &&
              widget.seat.player.connectivity.connectivityLost) {
            opacity = 0.70;
          }
        }

        return InkWell(
          onTap: () {
            if (gameState.replayMode) {
              return;
            }
            _onTap(context);
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // main body
              Opacity(
                opacity: opacity,
                child: NamePlateWidget(
                  widget.seat,
                  globalKey: key,
                  boardAttributes: boardAttributes,
                ),
              ),

              // result cards shown in player view at the time of result
              _buildDisplayCardsWidget(widget.seat, gameState.handState),

              // player notes text
              Visibility(
                visible: widget.seat.player.hasNotes && !widget.seat.isMe,
                child: Transform.translate(
                  offset: notesOffset,
                  child: IconButton(
                    icon: Icon(
                      Icons.note,
                      color: theme.accentColor,
                      size: 10.dp,
                    ),
                    onPressed: () async {
                      //await handleNotesPopup(context, widget.seat);
                    },
                  ),
                ),
              ),

              Visibility(
                visible: showWinnerLottie,
                child: Transform.scale(
                  scale: 2.5,
                  child: SizedBox.square(
                    dimension: 80,
                    child: Lottie.asset(
                      'assets/animations/winner.json',
                      repeat: false,
                    ),
                  ),
                ),
              ),

              // player hole cards (tilted card on the bottom left)
              PlayerCardsWidget(
                boardAttributes,
                gameState,
                widget.seat,
                this.widget.cardsAlignment,
                widget.seat.player?.noOfCardsVisible,
                showdown,
              ),
              // player action text
              Positioned(
                top: -15,
                left: actionLeft,
                right: actionRight,
                child: ActionStatusWidget(widget.seat, widget.cardsAlignment),
              ),

              // show dealer button, if user is a dealer
              isDealer
                  ? DealerButtonWidget(
                      widget.seat.seatPos,
                      isMe,
                      GameType.HOLDEM,
                    )
                  : shrinkedSizedBox,

              // /* building the chip amount widget */
              animate
                  ? _animatingChipAmount(chipAmountWidget)
                  : chipAmountWidget,

              Consumer<SeatChangeNotifier>(
                builder: (_, scn, __) {
                  return (gameState.hostSeatChangeInProgress ||
                          gameState.playerSeatChangeInProgress)
                      ? SeatNoWidget(widget.seat)
                      : const SizedBox.shrink();
                },
              ),

              playerStatusIcons(),
              widget.seat.player.showMicOff
                  ? Positioned(
                      top: 0,
                      right: -20,
                      child: Container(
                        width: 22,
                        height: 22,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.mic_off,
                          color: Colors.white70,
                        ),
                      ))
                  : SizedBox(),
              widget.seat.player.showMicOn
                  ? Positioned(
                      top: 0,
                      right: -20,
                      child: Container(
                        width: 22,
                        height: 22,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.mic,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  : SizedBox(),

              showFirework
                  ? Builder(
                      builder: (_) {
                        _gifAssetImage =
                            AssetImage('assets/animations/fireworks2.gif');
                        return Transform.scale(
                          scale: fireworksScale,
                          child: Transform.translate(
                            offset: Offset(
                              0.0,
                              -20.0,
                            ),
                            child: Image(
                              image: _gifAssetImage,
                              height: fireworksContainer.height,
                              width: fireworksContainer.width,
                            ),
                          ),
                        );
                      },
                    )
                  : Builder(
                      builder: (_) {
                        _gifAssetImage?.evict();
                        return shrinkedSizedBox;
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  ChipAmountAnimatingWidget _animatingChipAmount(Widget chipAmountWidget) {
    return ChipAmountAnimatingWidget(
      key: ValueKey(_tableState.tableRefresh),
      seatPos: widget.seat.serverSeatPos,
      child: chipAmountWidget,
      reverse: widget.seat.player.action.winner,
    );
  }

  Widget playerStatusIcons() {
    double left;
    double right = -20;
    if (widget.seat.seatPos == SeatPos.topRight ||
        widget.seat.seatPos == SeatPos.middleRight ||
        widget.seat.seatPos == SeatPos.bottomRight) {
      left = -15;
      right = null;
    }
    return Positioned(
        bottom: 0,
        left: left,
        right: right,
        child: Column(
          children: [
            networkConnectivityLostIcon(),
            talkingAnimation(),
          ],
        ));
  }

  Widget talkingAnimation() {
    double talkingAngle = 0;
    if (widget.seat.seatPos == SeatPos.topRight ||
        widget.seat.seatPos == SeatPos.middleRight ||
        widget.seat.seatPos == SeatPos.bottomRight) {
      talkingAngle = -math.pi;
    }

    return Visibility(
      visible: widget.seat.player.talking,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Transform.rotate(
        angle: talkingAngle,
        child: BlinkWidget(
          children: [
            SvgPicture.asset(
              'assets/images/speak/speak-two.svg',
              width: 16,
              height: 16,
              color: Colors.cyan,
            ),
            SvgPicture.asset(
              'assets/images/speak/speak-all.svg',
              width: 16,
              height: 16,
              color: Colors.cyan,
            ),
            SvgPicture.asset(
              'assets/images/speak/speak-two.svg',
              width: 16,
              height: 16,
              color: Colors.cyan,
            ),
            SvgPicture.asset(
              'assets/images/speak/speak-one.svg',
              width: 16,
              height: 16,
              color: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }

  Widget networkConnectivityLostIcon() {
    bool isVisible() {
      return widget.seat.player.highlight &&
          widget.seat.player.connectivity.connectivityLost;
    }

    return Visibility(
      visible: isVisible(),
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Stack(children: [
        Icon(
          Icons.wifi_off_rounded,
          size: 32.pw,
          color: Colors.orange,
        ),
        Container(),
      ]),
    );
  }
}

class SeatNoWidget extends StatelessWidget {
  final Seat seat;

  const SeatNoWidget(this.seat);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Transform.translate(
        offset: const Offset(-10.0, -10.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xff474747),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff14e81b),
              width: 1.0,
            ),
          ),
          child: Text(
            '${seat.serverSeatPos}',
            style: AppStylesNew.itemInfoTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
