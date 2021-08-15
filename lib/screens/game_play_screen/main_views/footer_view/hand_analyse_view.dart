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
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/debuglog_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/player_stats_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/table_result_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/services/app/player_service.dart';
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

  HandAnalyseView({
    @required this.gameState,
    @required this.clubCode,
    @required this.gameContextObject,
  });

  @override
  _HandAnalyseViewState createState() => _HandAnalyseViewState();
}

class _HandAnalyseViewState extends State<HandAnalyseView> {
  BuildContext _context;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (mounted) {
        //log('0-0-0-0- inside while Polling for pending approvals');
        await Future.delayed(Duration(seconds: 10));
        _pollPendingApprovals();
      }
    });
    super.initState();
  }

  _pollPendingApprovals() async {
    //log('0-0-0-0- Polling for pending approvals');
    final approvals = await PlayerService.getPendingApprovals();
    final state = Provider.of<PendingApprovalsState>(_context, listen: false);
    state.setPendingList(approvals);
  }

  Future<void> onClickViewHand(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Provider.value(
        // THIS MAKES SURE, THE LAST HAND ANAYLYSE BOTTOM SHEET
        // GETS THE GameState
        value: widget.gameState,
        child: LastHandAnalyseBottomSheet(
          gameCode: widget.gameState.gameCode,
          clubCode: widget.clubCode,
        ),
      ),
    );
  }

  Future<void> onClickViewHandAnalysis(BuildContext context) async {
    final model = HandHistoryListModel(widget.gameState.gameCode, true);
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return HandHistoryAnalyseBottomSheet(
          model: model,
          clubCode: widget.clubCode,
        );
      },
    );
  }

  Future<void> onPlayerStatsBottomSheet(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return PlayerStatsBottomSheet(gameCode: widget.gameState.gameCode);
      },
    );
  }

  Future<void> onTableBottomSheet(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return TableResultBottomSheet(
          gameCode: widget.gameState.gameCode,
          gameState: widget.gameState,
        );
      },
    );
  }

  Widget _buildStatefulBuilder(double height, BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return StatefulBuilder(builder: (context, localSetState) {
      return Container(
        height: height / 2.5,
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              decoration: AppDecorators.bgRadialGradient(theme),
              child: Column(
                children: [
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                      child: Text(
                        AppStringsNew.pendingApprovalTitleText,
                        style: AppDecorators.getAccentTextStyle(theme: theme),
                      ),
                      padding: EdgeInsets.all(8)),
                  Expanded(
                    child: Consumer<PendingApprovalsState>(
                      builder: (_, pending, __) => // main body
                          FutureBuilder(
                        future: PlayerService.getPendingApprovals(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              List<PendingApproval> list = snapshot.data;

                              if (list.length > 0) {
                                return Container(
                                  constraints: BoxConstraints(
                                      minHeight: height / 3,
                                      maxHeight: height / 2),
                                  child: ListView.separated(
                                    itemCount: list.length,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      height: 8,
                                      color: theme.fillInColor,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = list[index];
                                      return Container(
                                        decoration:
                                            AppDecorators.tileDecoration(theme),
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 16,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: "${item.name}",
                                                  style: AppDecorators
                                                      .getHeadLine4Style(
                                                          theme: theme),
                                                  children: [
                                                    TextSpan(
                                                      text: " request buyin",
                                                      style: AppDecorators
                                                          .getSubtitle3Style(
                                                              theme: theme),
                                                    ),
                                                    TextSpan(
                                                      text: " ${item.amount}",
                                                      style: AppDecorators
                                                          .getAccentTextStyle(
                                                              theme: theme),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "${AppStringsNew.outstandingBalance}: ${item.balance}",
                                                style: AppDecorators
                                                    .getHeadLine4Style(
                                                        theme: theme),
                                              ),
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
                                                style: AppDecorators
                                                    .getSubtitle1Style(
                                                        theme: theme),
                                              ),
                                              Text(
                                                "Code: ${item.gameCode}",
                                                style: AppDecorators
                                                    .getSubtitle1Style(
                                                        theme: theme),
                                              ),
                                              Text(
                                                "Club: ${item.clubCode}",
                                                style: AppDecorators
                                                    .getSubtitle1Style(
                                                        theme: theme),
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
                                                        _pollPendingApprovals();
                                                        // Provider.of<PendingApprovalsState>(
                                                        //         context,
                                                        //         listen: false)
                                                        //     .decreaseTotalPending();
                                                        // final List<
                                                        //         PendingApproval>
                                                        //     list =
                                                        //     await PlayerService
                                                        //         .getPendingApprovals();
                                                        // Provider.of<PendingApprovalsState>(
                                                        //         context,
                                                        //         listen: false)
                                                        //     .setTotalPending(
                                                        //         list == null
                                                        //             ? 0
                                                        //             : list
                                                        //                 .length);
                                                        // localSetState(() {});
                                                      } else {
                                                        log("Failed to approve request");
                                                      }
                                                    }),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    color: theme
                                                        .negativeOrErrorColor,
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
                                                      _pollPendingApprovals();
                                                      // Provider.of<PendingApprovalsState>(
                                                      //         context,
                                                      //         listen: false)
                                                      //     .decreaseTotalPending();
                                                      // final List<
                                                      //         PendingApproval>
                                                      //     list =
                                                      //     await PlayerService
                                                      //         .getPendingApprovals();
                                                      // Provider.of<PendingApprovalsState>(
                                                      //         context,
                                                      //         listen: false)
                                                      //     .setTotalPending(
                                                      //         list == null
                                                      //             ? 0
                                                      //             : list
                                                      //                 .length);
                                                      // localSetState(() {});

                                                    } else {
                                                      toast(
                                                        "Failed to decline Request",
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
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
                                      AppStringsNew.noPendingText,
                                      style: AppDecorators.getSubtitle1Style(
                                          theme: theme),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Container(
                                height: height / 4,
                                child: Center(
                                  child:
                                      Text("Something went wrong. Try again!"),
                                ),
                              );
                            }
                          } else {
                            return Container(
                              height: height / 4,
                              child: Center(
                                child: CircularProgressWidget(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.primaryColorWithDark(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
    /*    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: StatefulBuilder(
        builder: (context, localSetState) => Column(
          mainAxisSize: MainAxisSize.min,

          // title
          children: [
            ListTile(
              title: Text(
                "Pending approvals",
                style: AppStylesNew.clubCodeStyle,
              ),
            ),

            // main body
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
                              tileColor: AppColorsNew.cardBackgroundColor,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "${item.name} request buyin ${item.amount}",
                                    style: AppStylesNew.itemInfoTextStyle
                                        .copyWith(fontSize: 14),
                                  ),
                                  Text("Outstanding balance: ${item.balance}",
                                      style: AppStylesNew.itemInfoTextStyle),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Game: ${item.gameType}",
                                    style: AppStylesNew.itemInfoTextStyle,
                                  ),
                                  Text(
                                    "Code: ${item.gameCode}",
                                    style: AppStylesNew.itemInfoTextStyle,
                                  ),
                                  Text(
                                    "Club: ${item.clubCode}",
                                    style: AppStylesNew.itemInfoTextStyle,
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
                                          final bool val = await PlayerService
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
                                            final List<PendingApproval> list =
                                                await PlayerService
                                                    .getPendingApprovals();
                                            Provider.of<PendingApprovalsState>(
                                                    context,
                                                    listen: false)
                                                .setTotalPending(list == null
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
                                        final bool val = await PlayerService
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
                                          final List<PendingApproval> list =
                                              await PlayerService
                                                  .getPendingApprovals();
                                          Provider.of<PendingApprovalsState>(
                                                  context,
                                                  listen: false)
                                              .setTotalPending(list == null
                                                  ? 0
                                                  : list.length);
                                          localSetState(() {});
                                        } else {
                                          toast(
                                            "Failed to decline Request",
                                          );
                                        }
                                      },
                                    )
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
                            style: AppStylesNew.subTitleTextStyle,
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
              },
            ),
          ],
        ),
      ),
    );
  */
  }

  Future<void> onClickPendingBuyInApprovals(BuildContext context) async {
    final height = MediaQuery.of(context).size.height;
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildStatefulBuilder(height, context),
    );
    // await showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: AppColorsNew.screenBackgroundColor.withOpacity(0.75),
    //   builder:
    // );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    log('game started: ${widget.gameState.started}');
    final theme = AppTheme.getTheme(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          // first
          Consumer<MyState>(
            builder: (context, myState, child) {
              log('myState.gameStatus = ${myState.gameStatus}, myState.status = ${myState.status}');
              return myState.gameStatus == GameStatus.RUNNING &&
                      myState.status == PlayerStatus.PLAYING
                  ? GameCircleButton(
                      onClickHandler: () => onClickViewHand(context),
                      imagePath: AppAssetsNew.lastHandPath,
                    )
                  : const SizedBox.shrink();
            },
          ),

          // Pending approval button
          Consumer2<PendingApprovalsState, GameContextObject>(
            builder: (context, value, gameContextObj, child) {
              if (!widget.gameContextObject.isAdmin())
                return const SizedBox.shrink();

              final approval = SvgPicture.asset(
                'assets/images/game/clipboard.svg',
                width: 16,
                height: 16,
                color: theme.primaryColorWithDark(),
              );

              return IconWithBadge(
                count: value.approvalList.length,
                onClickFunction: () => onClickPendingBuyInApprovals(context),
                child: GameCircleButton(child: approval),
              );
            },
          ),

          GameCircleButton(
            iconData: Icons.menu,
            onClickHandler: () => onMoreOptionsPress(context),
          ),

          // GameCircleButton(
          //   iconData: Icons.adb,
          //   onClickHandler: () => onShowDebugLog(context),
          // ),

          // // rabbit button
          // Consumer<RabbitState>(
          //   builder: (context, rb, __) =>
          //       rb.show && widget.gameState.gameInfo.allowRabbitHunt
          //           ? GameCircleButton(
          //               onClickHandler: () => onRabbitTap(rb.copy(), context),
          //               imagePath: AppAssets.rabbit,
          //             )
          //           : const SizedBox.shrink(),
          // ),
        ],
      ),
    );
  }

  void onMoreOptionsPress(BuildContext context) {
    log('onMoreOptionsPress');
    showMoreOptions(context);
  }

  void onShowDebugLog(BuildContext context) {
    // log('onShowDebugLog');
    // debugLog(widget.gameState.gameCode, 'this is first log');
    // debugLog(widget.gameState.gameCode, 'this is second log');
    // debugLog(widget.gameState.gameCode, 'this is third log');
    // debugLog(widget.gameState.gameCode, 'this is fourth log');
    showBottomSheet(
      context: context,
      //backgroundColor: Colors.transparent,
      builder: (_) => Provider.value(
        // THIS MAKES SURE, THE LAST HAND ANAYLYSE BOTTOM SHEET
        // GETS THE GameState
        value: widget.gameState,
        child: DebugLogBottomSheet(
          gameCode: widget.gameState.gameCode,
        ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem({
    @required BuildContext context,
    @required void Function(BuildContext) callback,
    @required String imagePath,
    @required int value,
    @required String label,
    AppTheme theme,
  }) {
    return PopupMenuItem(
      value: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          callback(context);
        },
        child: Row(
          children: [
            GameCircleButton(
              onClickHandler: null,
              imagePath: AppAssetsNew.handHistoryPath,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: AppDecorators.getHeadLine4Style(theme: theme),
            ),
          ],
        ),
      ),
    );
  }

  void showMoreOptions(context) {
    final theme = AppTheme.getTheme(context);
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

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
      color: theme.fillInColor,
      items: <PopupMenuEntry>[
        // hand history
        _buildPopupMenuItem(
          context: context,
          callback: onClickViewHandAnalysis,
          imagePath: AppAssetsNew.handHistoryPath,
          value: 0,
          label: AppStringsNew.handHistoryTitle,
          theme: theme,
        ),

        // table
        _buildPopupMenuItem(
          context: context,
          callback: onTableBottomSheet,
          imagePath: AppAssetsNew.tableResultPath,
          value: 1,
          label: AppStringsNew.tableText,
          theme: theme,
        ),

        // stack stats
        _buildPopupMenuItem(
          context: context,
          callback: onPlayerStatsBottomSheet,
          imagePath: AppAssetsNew.playerStatsPath,
          value: 2,
          label: AppStringsNew.stackSeats,
          theme: theme,
        ),
      ],
    ).then<void>(
      (delta) {
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
      },
    );
  }

  // void onRabbitTap(RabbitState rs, BuildContext context) async {
  //   // reveal button tap
  //   void _onRevealButtonTap(ValueNotifier<bool> vnIsRevealed) async {
  //     // deduct two diamonds
  //     final bool deducted =
  //         await context.read<GameState>().gameHiveStore.deductDiamonds();

  //     // show community cards - only if deduction was possible
  //     if (deducted) vnIsRevealed.value = true;
  //   }

  //   // share button tap
  //   void _onShareButtonTap() {
  //     // collect all the necessary data and send in the game chat channel
  //     context.read<GameState>().gameComService.chat.sendRabbitHunt(rs);

  //     // pop out the dialog
  //     Navigator.pop(context);
  //   }

  //   Widget _buildDiamond() => SvgPicture.asset(
  //         AppAssets.diamond,
  //         width: 20.0,
  //         color: Colors.cyan,
  //       );

  //   Widget _buildRevealButton(ValueNotifier<bool> vnIsRevealed) => Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           // diamond icons
  //           _buildDiamond(),
  //           _buildDiamond(),

  //           // sep
  //           const SizedBox(width: 10.0),

  //           // visible button
  //           GestureDetector(
  //             onTap: () => _onRevealButtonTap(vnIsRevealed),
  //             child: Icon(
  //               Icons.visibility_outlined,
  //               color: AppColorsNew.newGreenButtonColor,
  //               size: 30.0,
  //             ),
  //           ),
  //         ],
  //       );

  //   Widget _buildShareButton() => Align(
  //         alignment: Alignment.centerRight,
  //         child: GestureDetector(
  //           onTap: _onShareButtonTap,
  //           child: Icon(
  //             Icons.share_rounded,
  //             color: AppColorsNew.newGreenButtonColor,
  //             size: 30.0,
  //           ),
  //         ),
  //       );

  //   List<int> _getHiddenCards() {
  //     List<int> cards = List.of(rs.communityCards);

  //     if (rs.revealedCards.length == 2) {
  //       cards[3] = cards[4] = 0;
  //     } else {
  //       cards[4] = 0;
  //     }

  //     return cards;
  //   }

  //   Widget _buildCommunityCardWidget(bool isRevealed) => isRevealed
  //       ? StackCardView00(
  //           cards: rs.communityCards,
  //         )
  //       : StackCardView00(
  //           cards: _getHiddenCards(),
  //         );

  //   // show a popup
  //   await showDialog(
  //     context: context,
  //     builder: (_) => ListenableProvider.value(
  //       // pass down the cards back string asset to the new dialog
  //       value: context.read<ValueNotifier<String>>(),
  //       child: ListenableProvider(
  //         create: (_) => ValueNotifier<bool>(false),
  //         child: Align(
  //           alignment: Alignment.center,
  //           child: Container(
  //             width: MediaQuery.of(context).size.width * 0.70,
  //             decoration: BoxDecoration(
  //               color: AppColorsNew.darkGreenShadeColor,
  //               borderRadius: BorderRadius.circular(15.0),
  //             ),
  //             padding: const EdgeInsets.all(20.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 /* hand number */
  //                 Text('Hand #${rs.handNo}'),

  //                 // sep
  //                 const SizedBox(height: 15.0),

  //                 /* your cards */
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text('Your cards:'),
  //                     const SizedBox(width: 10.0),
  //                     StackCardView00(
  //                       cards: rs.myCards,
  //                     ),
  //                   ],
  //                 ),

  //                 // sep
  //                 const SizedBox(height: 15.0),

  //                 // diamond widget
  //                 Provider.value(
  //                   value: context.read<GameState>(),
  //                   child: Consumer<ValueNotifier<bool>>(
  //                     builder: (_, __, ___) => NumDiamondWidget(),
  //                   ),
  //                 ),

  //                 // sep
  //                 const SizedBox(height: 15.0),

  //                 // show REVEAL button / share button
  //                 Container(
  //                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: Consumer<ValueNotifier<bool>>(
  //                     builder: (_, vnIsRevealed, __) => vnIsRevealed.value
  //                         ? _buildShareButton()
  //                         : _buildRevealButton(vnIsRevealed),
  //                   ),
  //                 ),

  //                 // sep
  //                 const SizedBox(height: 15.0),

  //                 // finally show here the community cards
  //                 Consumer<ValueNotifier<bool>>(
  //                   builder: (_, vnIsRevealed, __) => Transform.scale(
  //                     scale: 1.2,
  //                     child: _buildCommunityCardWidget(vnIsRevealed.value),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   // as soon as the dialog is closed, nullify the result
  //   context.read<RabbitState>().putResult(null);
  // }
}
