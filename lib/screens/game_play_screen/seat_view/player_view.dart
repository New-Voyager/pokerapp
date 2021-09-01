import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/widgets/blinking_widget.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/displaycards.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:provider/provider.dart';

import 'action_status.dart';
import 'animating_widgets/fold_card_animating_widget.dart';
import 'animating_widgets/stack_switch_seat_animating_widget.dart';
import 'chip_amount_widget.dart';
import 'dealer_button.dart';
import 'name_plate_view.dart';
import 'open_seat.dart';
import 'dart:math' as math;

/* this contains the player positions <seat-no, position> mapping */
// Map<int, Offset> playerPositions = Map();
const Duration _lottieAnimationDuration = const Duration(milliseconds: 3000);

class PlayerView extends StatefulWidget {
  final Seat seat;
  final Alignment cardsAlignment;
  final Function(int) onUserTap;
  final GameComService gameComService;
  final BoardAttributesObject boardAttributes;
  final int seatPosIndex;
  final SeatPos seatPos;
  final GameState gameState;

  PlayerView(
      {Key key,
      @required this.seat,
      @required this.onUserTap,
      @required this.gameComService,
      @required this.boardAttributes,
      @required this.seatPosIndex,
      @required this.seatPos,
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

  void handInfoStateListener() {
    if (_handInfoState.handNum != _lastHandNum) {
      _lastHandNum = _handInfoState.handNum;
      log('pauldebug: SETTING TRUE');
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
    log('seat ${widget.seat.serverSeatPos} is tapped');
    if (widget.seat.isOpen) {
      if (widget.gameState.myState.status == PlayerStatus.PLAYING &&
          widget.gameState.myState.gameStatus == GameStatus.RUNNING) {
        log('Ignoring the open seat tap as the player is sitting and game is running');
        return;
      }
      // the player tapped to sit-in
      widget.onUserTap(widget.seat.serverSeatPos);
    } else {
      // the player tapped to see the player profile
      final gameState = Provider.of<GameState>(
        context,
        listen: false,
      );

      final me = gameState.me(context);
      // If user is not playing do not show dialog
      // if (me == null) {
      //   return;
      // }
      final mySeat = gameState.mySeat(context);
      if (!widget.gameState.currentPlayer.isAdmin() && !(mySeat != null))
        return;

      if (me != null && widget.seat.serverSeatPos == mySeat.serverSeatPos) {
        return;
      }

      // show popup menu
      showPlayerPopup(context, widget.seat.key, widget.gameState, widget.seat);

      // Enable this for popup buttons
      // gameState.setTappedSeatPos(
      //     context, widget.seatPos, widget.seat, widget.gameComService);
    }
  }

  Widget _buildDisplayCardsWidget(
    Seat seat,
    FooterStatus footerStatus,
  ) =>
      Transform.translate(
        // TODO: NEED TO VERIFY THIS FOR DIFF SCREEN SIZES
        offset: const Offset(0.0, 20.0),
        child: Container(
          height: widget.boardAttributes.namePlateSize.height,
          width: widget.boardAttributes.namePlateSize.width,
          child: DisplayCardsWidget(
            seat,
            footerStatus,
          ),
        ),
      );

  bool _showHoleCard(GameState gameState, Seat seat) {
    return gameState.currentPlayerId == seat.player.playerId &&
        gameState.currentPlayerUuid == '';
  }

  @override
  Widget build(BuildContext context) {
    widget.seat.key = GlobalKey(
      debugLabel: 'Seat:${widget.seat.serverSeatPos}',
    ); //this.globalKey;

    // log('potViewPos: Rebuilding Seat: ${widget.seat.serverSeatPos}');

    // the player tapped to see the player profile
    final gameState = GameState.getState(context);
    bool openSeat = widget.seat.isOpen;
    bool isMe = widget.seat.isMe;
    FooterStatus footerStatus = Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value;

    bool showdown = false;
    if (footerStatus == FooterStatus.Result) {
      showdown = true;
    }

    // if open seat, just show open seat widget
    if (openSeat) {
      bool seatChangeSeat = false;
      if (gameState.playerSeatChangeInProgress) {
        seatChangeSeat = widget.seat.serverSeatPos == gameState.seatChangeSeat;
      }

      final openSeatWidget = OpenSeat(
        seatPos: widget.seat.serverSeatPos,
        onUserTap: this.widget.onUserTap,
        seatChangeInProgress: gameState.playerSeatChangeInProgress,
        seatChangeSeat: seatChangeSeat,
      );

      if (widget.seat.isDealer)
        return Stack(
          alignment: Alignment.center,
          children: [
            // dealer button
            DealerButtonWidget(
              widget.seat.uiSeatPos,
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
      if (widget.seat.player.playerType == TablePosition.Dealer) {
        isDealer = true;
      }
    }
    bool showFirework = false;
    if (!openSeat ? widget.seat.player?.showFirework ?? false : false) {
      showFirework = true;
      print('showing firework');
    }

    // we constrain the size to NOT shift the players widgets
    // and for large size fireworks, we use a scaling factor
    Size fireworksContainer = Size(50, 50);
    double fireworksScale = 1.5;

    // if (widget.seat.key != null && widget.seat.key.currentContext != null) {
    //   RenderBox seatBox = widget.seat.key.currentContext.findRenderObject();
    //   fireworksContainer = Size(seatBox.size.width, seatBox.size.height * 2);
    // }

    final boardAttributes = gameState.getBoardAttributes(context);
    widget.seat.betWidgetUIKey = GlobalKey();

    bool animate = widget.seat.player.action.animateAction;

    Widget chipAmountWidget = ChipAmountWidget(
      recalculatingNeeded: _seatPosNeedsReCalculating,
      animate: animate,
      potKey: boardAttributes.getPotsKey(0),
      key: widget.seat.betWidgetUIKey,
      seat: widget.seat,
      boardAttributesObject: boardAttributes,
      gameInfo: gameInfo,
    );
    return DragTarget(
      onWillAccept: (data) {
        print("object data $data");
        return true;
      },
      onAccept: (data) {
        // call the API to make the seat change
        SeatChangeService.hostSeatChangeMove(
          gameCode,
          data,
          widget.seat.serverSeatPos,
        );
      },
      builder: (context, List<int> candidateData, rejectedData) {
        return InkWell(
          onTap: () => this.onTap(context),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // // main user body
              NamePlateWidget(
                widget.seat,
                globalKey: widget.seat.key,
                boardAttributes: boardAttributes,
              ),

              // result cards and show selected cards by a user
              Consumer<ValueNotifier<FooterStatus>>(
                builder: (_, vnFooterStatus, __) => _buildDisplayCardsWidget(
                  widget.seat,
                  vnFooterStatus.value,
                ),
              ),
              // Transform.translate(
              //     offset: Offset(70, 40),
              //     child:
              //         GamePlayScreenUtilMethods.breakBuyIntimer(context, seat)),

              // player action text
              Positioned(
                top: -6,
                left: 0,
                child: ActionStatusWidget(widget.seat, widget.cardsAlignment),
              ),

              // player hole cards
              Transform.translate(
                offset: boardAttributes.playerHoleCardOffset,
                child: Transform.scale(
                  scale: boardAttributes.playerHoleCardScale,
                  child: _showHoleCard(gameState, widget.seat)
                      ? _buildDisplayCardsWidget(
                          widget.seat, FooterStatus.Result)
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
                      widget.seat.uiSeatPos,
                      isMe,
                      GameType.HOLDEM,
                    )
                  : shrinkedSizedBox,

              // /* building the chip amount widget */
              animate
                  ? _animatingChipAmount(chipAmountWidget)
                  : chipAmountWidget,

              Consumer<SeatChangeNotifier>(
                builder: (_, scn, __) => scn.seatChangeInProgress
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
    if (widget.seat.uiSeatPos == SeatPos.topRight ||
        widget.seat.uiSeatPos == SeatPos.middleRight ||
        widget.seat.uiSeatPos == SeatPos.bottomRight) {
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
    if (widget.seat.uiSeatPos == SeatPos.topRight ||
        widget.seat.uiSeatPos == SeatPos.middleRight ||
        widget.seat.uiSeatPos == SeatPos.bottomRight) {
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
              'assets/images/speak/speak-one.svg',
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
      child: Image.asset(
        'assets/images/network_connectivity/network_disconnected.png',
        width: 14,
        color: Colors.cyan,
      ),
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
            seat.serverSeatPos.toString(),
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
      //if (seat.player.animatingFold) {
      return Transform.translate(
        offset: Offset(
          xOffset * 0.50,
          45.0,
        ),
        child: FoldCardAnimatingWidget(seat: seat),
      );
      // } else {
      //   return Transform.translate(
      //     offset: Offset(
      //       xOffset * 0.50,
      //       45.0,
      //     ),
      //     child: Container(),
      //   );
      // }
    } else {
      //log('Hole cards');
      return Transform.translate(
        offset: Offset(
          xOffset * 0.50,
          25.0,
        ),
        child: Transform.scale(
          scale: 0.75,
          child: HiddenCardView(noOfCards: this.noCards),
        ),
      );
    }
  }
}
