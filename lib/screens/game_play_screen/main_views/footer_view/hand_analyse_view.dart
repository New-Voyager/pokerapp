import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/player_stats_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/table_result_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/screens/game_screens/table_result/table_result.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:provider/provider.dart';
import 'hand_history_bottomsheet.dart';
import 'last_hand_analyse_bottomsheet.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandAnalyseView extends StatefulWidget {
  final String clubCode;
  final GameContextObject gameContextObject;
  final GameState gameState;

  HandAnalyseView(this.gameState, this.clubCode, this.gameContextObject);

  @override
  _HandAnalyseViewState createState() => _HandAnalyseViewState();
}

class _HandAnalyseViewState extends State<HandAnalyseView> {
  Future<void> onClickViewHand() async {
    showBottomSheet(
      context: context,

      //isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Provider.value(
        // THIS MAKES SURE, THE LAST HAND ANAYLYSE BOTTOM SHEET
        // GETS THE GameState
        value: context.read<GameState>(),
        child: LastHandAnalyseBottomSheet(
          gameCode: widget.gameState.gameCode,
          clubCode: widget.clubCode,
        ),
      ),
    );
  }

  Future<void> onClickViewHandAnalysis() async {
    final model = HandHistoryListModel(widget.gameState.gameCode, true);
    showBottomSheet(
      context: context,
      //isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return HandHistoryAnalyseBottomSheet(
          model: model,
          clubCode: widget.clubCode,
        );
      },
    );
  }

  Future<void> onPlayerStatsBottomSheet() async {
    showBottomSheet(
      context: context,
      //isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return PlayerStatsBottomSheet(gameCode: widget.gameState.gameCode);
      },
    );
  }

  Future<void> onTableBottomSheet(GameState gameState) async {
    showBottomSheet(
      context: context,
      //  isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return TableResultBottomSheet(
            gameCode: widget.gameState.gameCode, gameState: gameState);
      },
    );
  }

  Future<void> onClickPendingBuyInApprovals() async {
    final height = MediaQuery.of(context).size.height;
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.screenBackgroundColor.withOpacity(0.75),
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, localSetState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    title: Text(
                  "Pending approvals",
                  style: AppStyles.clubCodeStyle,
                )),
                FutureBuilder(
                    future: PlayerService.getPendingApprovals(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          List<PendingApproval> list = snapshot.data;

                          if (list.length > 0) {
                            return Container(
                              constraints: BoxConstraints(
                                  minHeight: height / 3, maxHeight: height / 2),
                              child: ListView.separated(
                                itemCount: list.length,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => Divider(
                                  height: 8,
                                  color: Colors.black45,
                                ),
                                itemBuilder: (context, index) {
                                  final item = list[index];
                                  return ListTile(
                                    tileColor: AppColors.cardBackgroundColor,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          "${item.name} request buyin ${item.amount}",
                                          style: AppStyles.itemInfoTextStyle
                                              .copyWith(fontSize: 14),
                                        ),
                                        Text(
                                            "Outstanding balance: ${item.balance}",
                                            style: AppStyles.itemInfoTextStyle),
                                        SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Game: ${item.gameType}",
                                          style: AppStyles.itemInfoTextStyle,
                                        ),
                                        Text(
                                          "Code: ${item.gameCode}",
                                          style: AppStyles.itemInfoTextStyle,
                                        ),
                                        Text(
                                          "Club: ${item.clubCode}",
                                          style: AppStyles.itemInfoTextStyle,
                                        ),
                                        SizedBox(
                                          height: 16,
                                        )
                                      ],
                                    ),
                                    trailing: Container(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              ),
                                              onPressed: () async {
                                                final bool val =
                                                    await PlayerService
                                                        .approveBuyInRequest(
                                                  item.gameCode,
                                                  item.playerUuid,
                                                );
                                                if (val == null) {
                                                  log("Exception in approve request");
                                                } else if (val) {
                                                  Provider.of<PendingApprovalsState>(
                                                          context,
                                                          listen: false)
                                                      .decreaseTotalPending();
                                                  final List<PendingApproval>
                                                      list = await PlayerService
                                                          .getPendingApprovals();
                                                  Provider.of<PendingApprovalsState>(
                                                          context,
                                                          listen: false)
                                                      .setTotalPending(
                                                          list == null
                                                              ? 0
                                                              : list.length);
                                                  localSetState(() {});
                                                } else {
                                                  log("Failed to approve request");
                                                }
                                              }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.cancel_rounded,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                final bool val =
                                                    await PlayerService
                                                        .declineBuyInRequest(
                                                  item.gameCode,
                                                  item.playerUuid,
                                                );

                                                if (val == null) {
                                                  toast(
                                                      "Exception occured decline Request");
                                                } else if (val) {
                                                  Provider.of<PendingApprovalsState>(
                                                          context,
                                                          listen: false)
                                                      .decreaseTotalPending();
                                                  final List<PendingApproval>
                                                      list = await PlayerService
                                                          .getPendingApprovals();
                                                  Provider.of<PendingApprovalsState>(
                                                          context,
                                                          listen: false)
                                                      .setTotalPending(
                                                          list == null
                                                              ? 0
                                                              : list.length);
                                                  localSetState(() {});
                                                } else {
                                                  toast(
                                                      "Failed to decline Request");
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container(
                              height: height / 4,
                              child: Center(
                                child: Text(
                                  "No pending approvals.",
                                  style: AppStyles.subTitleTextStyle,
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container(
                            height: height / 4,
                            child: Center(
                              child: Text("Something went wrong. Try again!"),
                            ),
                          );
                        }
                      } else {
                        return Container(
                          height: height / 4,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }),
              ],
            ),
          );
        });
  }

  double height;
  double bottomSheetHeight;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    bottomSheetHeight = height / 3;

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          // first
          Consumer<MyState>(builder: (context, myState, child) {
            log('myState.gameStatus = ${myState.gameStatus}, myState.status = ${myState.status}');
            return myState.gameStatus == GameStatus.RUNNING &&
                    myState.status == PlayerStatus.PLAYING
                ? GameCircleButton(
                    onClickHandler: onClickViewHand,
                    imagePath: AppAssetsNew.lastHandPath,
                  )
                : SizedBox();
          }),

          // Pending approval button
          Consumer2<PendingApprovalsState, GameContextObject>(
              builder: (context, value, gameContextObj, child) {
            // log('gameContextObj.isAdmin() = ${gameContextObj.isAdmin()}');
            //  log("VALUE ======== ${value.totalPending}");
            if (!widget.gameContextObject.isAdmin()) {
              return Container();
            }

            return Consumer<PendingApprovalsState>(
              // Pending approval
              builder: (context, value, child) {
                //  log("VALUE ======== ${value.totalPending}");
                final approval = SvgPicture.asset(
                    'assets/images/game/clipboard.svg',
                    width: 16,
                    height: 16,
                    color: Colors.black);
                return IconWithBadge(
                    count: value.totalPending,
                    onClickFunction: onClickPendingBuyInApprovals,
                    child: GameCircleButton(
                      child: approval,
                    ));
              },
            );
          }),
          GameCircleButton(
              iconData: Icons.menu,
              onClickHandler: () => onMoreOptionsPress(context)),

          // rabbit button
          Consumer<RabbitState>(
            builder: (_, rb, __) =>
                rb.show && widget.gameState.gameInfo.allowRabbitHunt
                    ? GameCircleButton(
                        onClickHandler: () => onRabbitTap(rb.copy()),
                        imagePath: AppAssets.rabbit,
                      )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void onMoreOptionsPress(BuildContext context) {
    log('onMoreOptionsPress');
    showMoreOptions(context);
  }

  void showMoreOptions(context) {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final gameState = GameState.getState(context);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(40, 70), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: AppColorsNew.darkGreenShadeColor,
      items: <PopupMenuEntry>[
        PopupMenuItem(
            value: 0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();

                onClickViewHandAnalysis();
              },
              child: Row(
                children: [
                  GameCircleButton(
                    onClickHandler: () {
                      Navigator.of(context).pop();

                      onClickViewHandAnalysis();
                    },
                    imagePath: AppAssetsNew.handHistoryPath,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Hand History',
                    style:
                        AppStylesNew.labelTextStyle.copyWith(fontSize: 12.dp),
                  ),
                ],
              ),
            )),
        PopupMenuItem(
            value: 1,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onTableBottomSheet(gameState);
              },
              child: Row(
                children: [
                  GameCircleButton(
                    onClickHandler: () {
                      Navigator.of(context).pop();
                      onTableBottomSheet(gameState);
                    },
                    imagePath: AppAssetsNew.tableResultPath,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Table',
                    style:
                        AppStylesNew.labelTextStyle.copyWith(fontSize: 12.dp),
                  ),
                ],
              ),
            )),
        PopupMenuItem(
            value: 2,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onPlayerStatsBottomSheet();
              },
              child: Row(
                children: [
                  GameCircleButton(
                    onClickHandler: () {
                      Navigator.of(context).pop();
                      onPlayerStatsBottomSheet();
                    },
                    imagePath: AppAssetsNew.playerStatsPath,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Stack Stats',
                    style:
                        AppStylesNew.labelTextStyle.copyWith(fontSize: 12.dp),
                  ),
                ],
              ),
            )),
      ],
    ).then<void>((delta) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)
      if (delta == null) {
        return;
      } else {
        switch (delta) {
          case 0:
            log('selected hand history');
            break;
          case 1:
            log('selected table result');
            break;
          case 2:
            log('selected stack stats');
            break;
        }
      }
    });
  }

  Offset getOffset(context) {
    RenderBox globalRenderBox = context.findRenderObject();
    Offset globalOffset = globalRenderBox.localToGlobal(Offset(0, 0));
    RenderBox localRenderBox = context.findRenderObject();
    Offset localOffset = localRenderBox.globalToLocal(globalOffset);
    return localOffset;
  }

  void onRabbitTap(RabbitState rs) async {
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

    Widget _buildRevealButton(ValueNotifier<bool> vnIsRevealed) => Row(
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
                color: AppColorsNew.newGreenButtonColor,
                size: 30.0,
              ),
            ),
          ],
        );

    Widget _buildShareButton() => Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _onShareButtonTap,
            child: Icon(
              Icons.share_rounded,
              color: AppColorsNew.newGreenButtonColor,
              size: 30.0,
            ),
          ),
        );

    List<int> _getHiddenCards() {
      List<int> cards = List.of(rs.communityCards);

      if (rs.revealedCards.length == 2) {
        cards[3] = cards[4] = 0;
      } else {
        cards[4] = 0;
      }

      return cards;
    }

    Widget _buildCommunityCardWidget(bool isRevealed) => isRevealed
        ? StackCardView00(
            cards: rs.communityCards,
          )
        : StackCardView00(
            cards: _getHiddenCards(),
          );

    // show a popup
    await showDialog(
      context: context,
      builder: (_) => ListenableProvider(
        create: (_) => ValueNotifier<bool>(false),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.70,
            decoration: BoxDecoration(
              color: AppColorsNew.darkGreenShadeColor,
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
                        ? _buildShareButton()
                        : _buildRevealButton(vnIsRevealed),
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

    // as soon as the dialog is closed, nullify the result
    context.read<RabbitState>().putResult(null);
  }
}
