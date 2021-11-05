import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:pokerapp/screens/game_play_screen/widgets/nameplate_dialog.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/displaycards.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import 'action_status.dart';
import 'animating_widgets/fold_card_animating_widget.dart';
import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'chip_amount_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'open_seat.dart';
import 'dart:math' as math;
import 'package:pokerapp/utils/adaptive_sizer.dart';

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

  PlayerView(
      {Key key,
      @required this.seat,
      @required this.onUserTap,
      @required this.gameComService,
      @required this.boardAttributes,
      @required this.gameContextObject,
      this.cardsAlignment = Alignment.centerRight,
      this.gameState})
      : super(key: key);

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class NeedRecalculating {
  bool value = false;
}

class _PlayerViewState extends State<PlayerView> with TickerProviderStateMixin {
  TableState _tableState;

  HandInfoState _handInfoState;
  NeedRecalculating _seatPosNeedsReCalculating = NeedRecalculating();
  int _lastHandNum = 0;

  AnimationController _lottieController;
  AssetImage _gifAssetImage;
  bool _dragEnter = false;

  void handInfoStateListener() {
    if (_handInfoState.handNum != _lastHandNum) {
      _lastHandNum = _handInfoState.handNum;
      //log('pauldebug: SETTING TRUE');
      _seatPosNeedsReCalculating.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    _handInfoState = context.read<HandInfoState>();

    // setup condition to notify when recalculating is necessary
    _handInfoState.addListener(handInfoStateListener);

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
    _handInfoState?.removeListener(handInfoStateListener);
    _lottieController?.dispose();
  }

  onTap(BuildContext context) async {
    final seatChangeContext = Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    );

    if (widget.gameState.customizationMode) {
      return;
    }

    if (seatChangeContext != null && seatChangeContext.seatChangeInProgress) {
      return;
    }
    log('seat ${widget.seat.seatPos.toString()} is tapped');
    if (widget.seat.isOpen) {
      final tableState = widget.gameState.tableState;
      if (widget.gameState.myStatus == AppConstants.PLAYING &&
          tableState.gameStatus == AppConstants.GAME_RUNNING) {
        log('Ignoring the open seat tap as the player is sitting and game is running');
        return;
      }
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
      if (!widget.gameState.currentPlayer.isAdmin()) {
        if (mySeat == null) {
          return;
        }
      }
      if (me != null && widget.seat.seatPos == mySeat.seatPos) {
        return;
      }

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

      if (data != null && data['type'] != null && data['type'] == "animation") {
        final bool result = await playerState
            .deductDiamonds(AppConfig.noOfDiamondsForAnimation);
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
              gameCode: widget.gameState.gameCode,
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
        "Do you want to assign '${widget.gameState.currentPlayer.name}' as host?",
        positiveButtonText: "Yes", negativeButtonText: "No");
    if (result != null) {
      if (result == true) {
        // setbuyin limit
        try {
          final result = await GameService.assignHost(
            gameCode: widget.gameState.gameCode,
            playerId: widget.gameState.currentPlayer.uuid,
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
    if (handState != HandState.RESULT) {
      return SizedBox(width: 0, height: 0);
    }
    log('HiLo: Status: seat: ${seat.player.name} inhand: ${seat.player.inhand}');
    if (seat.player != null && !seat.player.inhand) {
      return SizedBox(width: 0, height: 0);
    }

    return Transform.translate(
      // TODO: NEED TO VERIFY THIS FOR DIFF SCREEN SIZES
      offset: Offset(0.0, 10.ph),
      child: Container(
        height: widget.boardAttributes.namePlateSize.height,
        width: widget.boardAttributes.namePlateSize.width,
        child: DisplayCardsWidget(
          seat,
          widget.gameState.showdown,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    log('RedrawTop: PlayerView build ${widget.seat.serverSeatPos}:L${widget.seat.localSeatPos} pos: ${widget.seat.seatPos.toString()} player: ${widget.seat.player?.name}');
    // widget.seat.key = GlobalKey(
    //   debugLabel: 'Seat:${widget.seat.serverSeatPos}',
    // ); //this.globalKey;

    // log('potViewPos: Rebuilding Seat: ${widget.seat.serverSeatPos}');

    // the player tapped to see the player profile
    final gameState = GameState.getState(context);
    bool openSeat = widget.seat.isOpen;
    bool isMe = widget.seat.isMe;
    log('SeatView1: seat: ${widget.seat.serverSeatPos} isOpen: ${openSeat} player: ${widget.seat.player}');
    bool showdown = widget.gameState.showdown;

    // if open seat, just show open seat widget
    if (openSeat) {
      bool seatChangeSeat = false;
      if (gameState.playerSeatChangeInProgress) {
        seatChangeSeat =
            widget.seat.seatPos == gameState.seatChangeSeat.seatPos;
      }

      final openSeatWidget = OpenSeat(
        seat: widget.seat,
        onUserTap: this.widget.onUserTap,
        seatChangeInProgress: gameState.hostSeatChangeInProgress,
        seatChangeSeat: seatChangeSeat,
      );

      if (widget.seat.dealer)
        return Stack(
          alignment: Alignment.center,
          children: [
            // dealer button
            DealerButtonWidget(
              widget.seat.seatPos,
              isMe,
              GameType.HOLDEM,
            ),

            // main open seat widget
            openSeatWidget,
          ],
        );

      return openSeatWidget;
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
        recalculatingNeeded: _seatPosNeedsReCalculating,
        animate: animate,
        potKey: boardAttributes.potKey,
        key: widget.seat.betWidgetUIKey,
        seat: widget.seat,
        boardAttributesObject: boardAttributes,
        gameInfo: gameInfo,
      );
    }
    return DragTarget(
      onWillAccept: (data) {
        log("SeatChange: Player onWillAccept $data");
        widget.seat.dragEntered = true;
        setState(() {});
        return true;
      },
      onLeave: (data) {
        log("SeatChange: Player onLeave $data");
        widget.seat.dragEntered = false;
        setState(() {});
      },
      onAccept: (data) {
        log('SeatChange: onDropped ${data}');
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
        SeatPos pos = widget.seat.seatPos ?? SeatPos.bottomLeft;
        double actionLeft;
        double actionRight;
        if (pos == SeatPos.bottomLeft ||
            pos == SeatPos.middleLeft ||
            pos == SeatPos.topLeft ||
            pos == SeatPos.topCenter ||
            pos == SeatPos.topCenter1) {
          actionLeft = 0;
          notesOffset =
              Offset(-((widget.boardAttributes.namePlateSize.width / 1.5)), 0);
        } else {
          actionRight = 0;
          notesOffset =
              Offset(((widget.boardAttributes.namePlateSize.width / 2)), 0);
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
          onTap: () => this.onTap(context),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Container(width: 100, height: 60, color: Colors.grey[900]),
              //SvgPicture.string(namePlateStr, width: 60, height: 50),
              // // main user body
              Opacity(
                  opacity: opacity,
                  child: 
                  Transform.scale(
                    scale: scale,
                    child: 
                    NamePlateWidget(
                      widget.seat,
                      globalKey: key,
                      boardAttributes: boardAttributes,
                    ))
                  ),

              // result cards shown in player view at the time of result
              _buildDisplayCardsWidget(widget.seat, gameState.handState),

              // player action text
              Positioned(
                top: -5.ph,
                left: actionLeft,
                right: actionRight,
                child: ActionStatusWidget(widget.seat, widget.cardsAlignment),
              ),

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
                      await handleNotesPopup(context, widget.seat);
                    },
                  ),
                ),
              ),

              // player hole cards (tilted card on the bottom left)
              Transform.translate(
                offset: boardAttributes.playerHoleCardOffset,
                child: Transform.scale(
                  scale: boardAttributes.playerHoleCardScale,
                  child: gameState.handState == HandState.RESULT
                      ? SizedBox(width: 0, height: 0)
                      : PlayerCardsWidget(
                          widget.seat,
                          this.widget.cardsAlignment,
                          widget.seat.player?.noOfCardsVisible,
                          showdown,
                        ),
                ),
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
                builder: (_, scn, __) => gameState.hostSeatChangeInProgress
                    ? SeatNoWidget(widget.seat)
                    : const SizedBox.shrink(),
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
                          )))
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

class PlayerCardsWidget extends StatelessWidget {
  final Seat seat;
  final Alignment alignment;
  final bool showdown;
  final int noCards;

  const PlayerCardsWidget(
    this.seat,
    this.alignment,
    this.noCards,
    this.showdown,
  );

  @override
  Widget build(BuildContext context) {
    // if (seat.folded ?? false) {
    //   return shrinkedSizedBox;
    // }

    double shiftMultiplier = 1.0;
    if (this.noCards == 5) shiftMultiplier = 1.7;
    if (this.noCards == 4) shiftMultiplier = 1.45;
    if (this.noCards == 3) shiftMultiplier = 1.25;
    log('PlayerCardsWidget: building ${seat.serverSeatPos}');
    double xOffset;
    if (showdown)
      xOffset = (alignment == Alignment.centerLeft ? 1 : -1) *
          25.0 *
          (seat.cards?.length ?? 0.0);
    else {
      xOffset =
          (alignment == Alignment.centerLeft ? 35.0 : -45.0 * shiftMultiplier);
      xOffset = -45.0 * shiftMultiplier;
    }
    if (showdown) {
      return const SizedBox.shrink();
    } else if (seat.folded ?? false) {
      log('PlayerCardsWidget: [${seat.serverSeatPos}] Folded cards');
      return Transform.translate(
        offset: Offset(
          xOffset * 0.30,
          45.0,
        ),
        child: FoldCardAnimatingWidget(seat: seat),
      );
    } else {
      double xoffset = 0.90;
      double scale = 1.0;
      if (this.noCards == 5) {
        scale = 0.75;
        xoffset = 0.55;
      }
      if (this.noCards == 4) {
        scale = 0.75;
        xoffset = 0.75;
      }
      //log('Hole cards');
      log('PlayerCardsWidget: [${seat.serverSeatPos}] Hidden cards');
      return Transform.translate(
        offset: Offset(
          xOffset * xoffset,
          25.0,
        ),
        child: Transform.scale(
          scale: scale,
          child: HiddenCardView(noOfCards: this.noCards),
        ),
      );
    }
  }
}
