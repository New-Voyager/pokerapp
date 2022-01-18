import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/screens/game_play_screen/bombpot_dialog.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/debuglog_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/game_info_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/hand_history_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/highhand_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/last_hand_analyse_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/player_stats_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/table_result_bottomsheet.dart';
import 'package:pokerapp/screens/profile_screens/bug_features_dialog.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';
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
  final ValueNotifier<bool> vnShowMenuItems = ValueNotifier<bool>(false);

  Timer _timer;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
        if (mounted) _pollPendingApprovals();
      });
    });
    _appScreenText = getAppTextScreen("handAnalyseView");

    super.initState();
  }

  @override
  void dispose() {
    // cancel the poll timer
    _timer?.cancel();
    super.dispose();
  }

  _pollPendingApprovals() async {
    if (TestService.isTesting || widget.gameState.customizationMode) {
      return;
    }
    // log('refinements: _pollPendingApprovals is invoked');
    //log('0-0-0-0- Polling for pending approvals');
    final approvals = await PlayerService.getPendingApprovals();

    // if not mounted, return from here
    if (!mounted) return;
    final state = Provider.of<PendingApprovalsState>(context, listen: false);
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

  Future<void> onClickHighHand(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Provider.value(
        // THIS MAKES SURE, THE LAST HAND ANAYLYSE BOTTOM SHEET
        // GETS THE GameState
        value: widget.gameState,
        child: HighHandBottomSheet(
          gameState: widget.gameState,
        ),
      ),
    );
  }

  Future<void> onClickViewHandAnalysis(BuildContext context) async {
    final model = HandHistoryListModel(
        widget.gameState.gameCode, true, widget.gameState.gameInfo.chipUnit);
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

  Future<void> onGameInfoBottomSheet(BuildContext context) async {
    // final model = HandHistoryListModel(widget.gameState.gameCode, true);
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GameInfoBottomSheet(
          gameState: widget.gameState,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMenuWidget();
  }

  Widget _buildMenuButtons(AppTheme theme) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      color: theme.primaryColorWithDark(0.5),
      padding: EdgeInsets.symmetric(horizontal: 5.ph),
      child: RawScrollbar(
        thumbColor: theme.accentColor,
        thickness: 5,
        radius: Radius.circular(20.0),
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // menu close button
                CircleImageButton(
                  theme: theme,
                  //caption: 'Close',
                  icon: Icons.close,
                  onTap: () {
                    vnShowMenuItems.value = false;
                  },
                ),
                SizedBox(height: 10.pw),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleImageButton(
                      theme: theme,
                      //caption: 'Prev',
                      svgAsset:
                          'assets/images/game/lasthand.svg', //AppAssetsNew.lastHandPath,
                      onTap: () {
                        vnShowMenuItems.value = false;
                        onClickViewHand(context);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        vnShowMenuItems.value = false;
                        onClickViewHand(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Last Hand",
                            style:
                                AppDecorators.getSubtitle1Style(theme: theme)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.pw),

                // game history
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleImageButton(
                        theme: theme,
                        //caption: 'History',
                        svgAsset: 'assets/images/game/handhistory.svg',
                        onTap: () {
                          vnShowMenuItems.value = false;
                          onClickViewHandAnalysis(context);
                        }),
                    InkWell(
                      onTap: () {
                        vnShowMenuItems.value = false;
                        onClickViewHandAnalysis(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Hand History",
                            style:
                                AppDecorators.getSubtitle1Style(theme: theme)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.pw),

                // High hand track
                widget.gameState.gameInfo.highHandTracked ?? false
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleImageButton(
                              theme: theme,
                              //caption: 'HH',
                              svgAsset: 'assets/images/game/highhand.svg',
                              onTap: () {
                                vnShowMenuItems.value = false;
                                onClickHighHand(context);
                              }),
                          InkWell(
                            onTap: () {
                              vnShowMenuItems.value = false;
                              onClickHighHand(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("High Hand",
                                  style: AppDecorators.getSubtitle1Style(
                                      theme: theme)),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(width: 10.pw),

                // bomb pot
                !widget.gameState.currentPlayer.isHost()
                    ? Container()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleImageButton(
                              theme: theme,
                              svgAsset:
                                  'assets/images/game/bomb1.svg', //AppAssetsNew.lastHandPath,
                              onTap: () async {
                                vnShowMenuItems.value = false;
                                await BombPotDialog.prompt(
                                    context: context,
                                    gameCode: widget.gameState.gameCode,
                                    gameState: widget.gameState);
                              }),
                          InkWell(
                            onTap: () async {
                              vnShowMenuItems.value = false;
                              await BombPotDialog.prompt(
                                  context: context,
                                  gameCode: widget.gameState.gameCode,
                                  gameState: widget.gameState);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Bomb Pot",
                                  style: AppDecorators.getSubtitle1Style(
                                      theme: theme)),
                            ),
                          ),
                        ],
                      ),
                SizedBox(width: 10.pw),
                SizedBox(height: 10.ph),

                // game info
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleImageButton(
                        theme: theme,
                        //caption: 'Info',
                        icon: Icons.info,
                        onTap: () {
                          vnShowMenuItems.value = false;
                          onGameInfoBottomSheet(context);
                        }),
                    InkWell(
                      onTap: () {
                        vnShowMenuItems.value = false;
                        onGameInfoBottomSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Game Info",
                            style:
                                AppDecorators.getSubtitle1Style(theme: theme)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.ph),

                widget.gameState.gameSettings.showResult ?? false
                    ?
                    // result table
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleImageButton(
                              theme: theme,
                              //caption: 'Result',
                              svgAsset: AppAssetsNew.tableResultPath,
                              onTap: () {
                                vnShowMenuItems.value = false;
                                onTableBottomSheet(context);
                              }),
                          InkWell(
                            onTap: () {
                              vnShowMenuItems.value = false;
                              onTableBottomSheet(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Result",
                                  style: AppDecorators.getSubtitle1Style(
                                      theme: theme)),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 10.ph),

                // player stack
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleImageButton(
                        theme: theme,
                        //caption: 'Stats',
                        svgAsset: AppAssetsNew.playerStatsPath,
                        onTap: () {
                          vnShowMenuItems.value = false;
                          onPlayerStatsBottomSheet(context);
                        }),
                    InkWell(
                      onTap: () {
                        vnShowMenuItems.value = false;
                        onPlayerStatsBottomSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Stack Stats",
                            style:
                                AppDecorators.getSubtitle1Style(theme: theme)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.pw),
                // report issue
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleImageButton(
                        theme: theme,
                        //caption: 'Info',
                        icon: Icons.info,
                        onTap: () {
                          vnShowMenuItems.value = false;
                          Alerts.showDailog(
                            context: context,
                            child: BugsFeaturesWidget(),
                          );
                        }),
                    InkWell(
                      onTap: () {
                        vnShowMenuItems.value = false;
                        Alerts.showDailog(
                          context: context,
                          child: BugsFeaturesWidget(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Report Issue",
                            style:
                                AppDecorators.getSubtitle1Style(theme: theme)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.ph),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuWidget() {
    AppTheme theme = AppTheme.getTheme(context);

    return ValueListenableBuilder(
      valueListenable: vnShowMenuItems,
      child: _buildMenuButtons(theme),
      builder: (_, showMenu, child) => AnimatedSwitcher(
        duration: AppConstants.fastestAnimationDuration,
        transitionBuilder: (child, animation) => SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: animation,
          child: child,
        ),
        child: showMenu
            ? child
            : CircleImageButton(
                icon: Icons.more_vert,
                onTap: () => vnShowMenuItems.value = true,
                theme: theme,
              ),
      ),
    );
  }

  Widget pendingApprovalsItem(AppTheme theme, PendingApproval item) {
    return Container(
      decoration: AppDecorators.tileDecoration(theme),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            RichText(
              text: TextSpan(
                text: "${item.name}",
                style: AppDecorators.getHeadLine4Style(theme: theme),
                children: [
                  TextSpan(
                    text: item.approvalType == 'RELOAD_REQUEST'
                        ? 'reload'
                        : " ${_appScreenText['requestBuyin']}",
                    style: AppDecorators.getSubtitleStyle(theme: theme),
                  ),
                  TextSpan(
                    text: " ${DataFormatter.chipsFormat(item.amount)}",
                    style: AppDecorators.getAccentTextStyle(theme: theme),
                  ),
                ],
              ),
            ),
            // Text(
            //   "${_appScreenText['outstandingBalance']}: ${item.balance}",
            //   style: AppDecorators.getHeadLine4Style(theme: theme),
            // ),
            // SizedBox(
            //   height: 16,
            // ),
          ],
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_appScreenText['game']}: ${item.gameType}",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
            Text(
              "${_appScreenText['code']}: ${item.gameCode}",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
            Text(
              "${_appScreenText['club']}: ${item.clubCode}",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
            SizedBox(
              height: 16,
            )
          ],
        ),
        trailing: Container(
          width: 120.pw,
          child: Row(
            children: [
              ConfirmYesButton(
                theme: theme,
                onTap: () async {
                  final bool val = await PlayerService.approveBuyInRequest(
                    item.gameCode,
                    item.playerUuid,
                  );
                  if (val == null) {
                    log("Exception in approve request");
                  } else if (val) {
                    _pollPendingApprovals();
                  } else {
                    log("Failed to approve request");
                  }
                },
              ),
              SizedBox(width: 5.pw),
              ConfirmNoButton(
                  onTap: () async {
                    final bool val = await PlayerService.declineBuyInRequest(
                      item.gameCode,
                      item.playerUuid,
                    );

                    if (val == null) {
                      toast(_appScreenText['exceptionOccuredDeclineRequest']);
                    } else if (val) {
                      _pollPendingApprovals();
                    } else {
                      toast(
                        _appScreenText['failedToDeclineRequest'],
                      );
                    }
                  },
                  theme: theme),
            ],
          ),
        ),
      ),
    );
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
            CircleImageButton(
              onTap: null,
              theme: theme,
              svgAsset: AppAssetsNew.handHistoryPath,
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
          label: _appScreenText['handHistory'],
          theme: theme,
        ),

        // table
        _buildPopupMenuItem(
          context: context,
          callback: onTableBottomSheet,
          imagePath: AppAssetsNew.tableResultPath,
          value: 1,
          label: _appScreenText['table'],
          theme: theme,
        ),

        // stack stats
        _buildPopupMenuItem(
          context: context,
          callback: onPlayerStatsBottomSheet,
          imagePath: AppAssetsNew.playerStatsPath,
          value: 2,
          label: _appScreenText['stackStats'],
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
}
