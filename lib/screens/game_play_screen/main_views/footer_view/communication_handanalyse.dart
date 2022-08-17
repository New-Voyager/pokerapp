import 'dart:async';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
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
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/communication_view.dart';
import 'package:pokerapp/screens/profile_screens/bug_features_dialog.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class CommunitcationHandAnalyseView extends StatefulWidget {
  final String clubCode;
  final GameContextObject gameContextObject;
  final GameState gameState;

  final Function chatVisibilityChange;
  final GameMessagingService chatService;

  CommunitcationHandAnalyseView({
    @required this.gameState,
    @required this.clubCode,
    @required this.gameContextObject,
    @required this.chatVisibilityChange,
    @required this.chatService,
  });

  @override
  _CommunitcationHandAnalyseViewState createState() =>
      _CommunitcationHandAnalyseViewState();
}

class _CommunitcationHandAnalyseViewState
    extends State<CommunitcationHandAnalyseView> {
  Timer _timer;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    // _timer = Timer.periodic(const Duration(seconds: 10), (_) {
    //   if (mounted) _pollPendingApprovals();
    // });
    // });
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
    return Column(
      children: [
        _buildMenuWidget(),
        // SizedBox(
        //   height: 10,
        // ),
        // Consumer2<GameSettingsState, CommunicationState>(
        //     builder: (_, __, ____, ___) {
        //   return CommunicationView(
        //     widget.chatVisibilityChange,
        //     widget.gameContextObject.gameComService.gameMessaging,
        //     widget.gameContextObject,
        //   );
        // }),
      ],
    );
  }

  List<Widget> getMenuItems(AppTheme theme) {
    bool showResult = widget.gameState.gameSettings.showResult;
    if (widget.gameState.isHost()) {
      showResult = true;
    }

    return [
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
              onClickViewHand(context);
            },
          ),
          InkWell(
            onTap: () {
              onClickViewHand(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Last Hand",
                  style: AppDecorators.getSubtitle1Style(theme: theme)),
            ),
          ),
        ],
      ),
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
                onClickViewHandAnalysis(context);
              }),
          InkWell(
            onTap: () {
              onClickViewHandAnalysis(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Hand History",
                  style: AppDecorators.getSubtitle1Style(theme: theme)),
            ),
          ),
        ],
      ),

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
                      onClickHighHand(context);
                    }),
                InkWell(
                  onTap: () {
                    onClickHighHand(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("High Hand",
                        style: AppDecorators.getSubtitle1Style(theme: theme)),
                  ),
                ),
              ],
            )
          : SizedBox.shrink(),

      // bomb pot
      (widget.gameState.currentPlayer.isHost() ||
              widget.gameState.currentPlayer.isOwner())
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleImageButton(
                    theme: theme,
                    svgAsset:
                        'assets/images/game/bomb1.svg', //AppAssetsNew.lastHandPath,
                    onTap: () async {
                      await BombPotDialog.prompt(
                          context: context,
                          gameCode: widget.gameState.gameCode,
                          gameState: widget.gameState);
                    }),
                InkWell(
                  onTap: () async {
                    await BombPotDialog.prompt(
                        context: context,
                        gameCode: widget.gameState.gameCode,
                        gameState: widget.gameState);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Bomb Pot",
                        style: AppDecorators.getSubtitle1Style(theme: theme)),
                  ),
                ),
              ],
            )
          : SizedBox.shrink(),

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
                onGameInfoBottomSheet(context);
              }),
          InkWell(
            onTap: () {
              onGameInfoBottomSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Game Info",
                  style: AppDecorators.getSubtitle1Style(theme: theme)),
            ),
          ),
        ],
      ),

      showResult ?? false
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
                      onTableBottomSheet(context);
                    }),
                InkWell(
                  onTap: () {
                    onTableBottomSheet(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Result",
                        style: AppDecorators.getSubtitle1Style(theme: theme)),
                  ),
                ),
              ],
            )
          : SizedBox.shrink(),

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
                onPlayerStatsBottomSheet(context);
              }),
          InkWell(
            onTap: () {
              onPlayerStatsBottomSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Stack Stats",
                  style: AppDecorators.getSubtitle1Style(theme: theme)),
            ),
          ),
        ],
      ),

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
                Alerts.showDailog(
                  context: context,
                  child: BugsFeaturesWidget(),
                );
              }),
          InkWell(
            onTap: () {
              Alerts.showDailog(
                context: context,
                child: BugsFeaturesWidget(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Report Issue",
                  style: AppDecorators.getSubtitle1Style(theme: theme)),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildMenuWidget() {
    AppTheme theme = AppTheme.getTheme(context);

    List<Widget> menuItems = getMenuItems(theme);

    menuItems.removeWhere(
        (element) => (element.toString() == SizedBox.shrink().toString()));

    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      customButton: DummyCircleImageButton(
        icon: Icons.more_vert,
        theme: theme,
      ),
      customItemsHeight: 8,
      items: menuItems
          .map(
            (item) => DropdownMenuItem<Widget>(
              value: Container(),
              child: item,
            ),
          )
          .toList(),
      itemPadding: const EdgeInsets.only(left: 16, right: 16),
      onChanged: (value) {},
      dropdownWidth: 200,
    ));
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
