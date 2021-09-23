import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/debuglog_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/game_info_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/hand_history_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/last_hand_analyse_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/player_stats_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/bottom_sheets/table_result_bottomsheet.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:provider/provider.dart';

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

  BuildContext _context;
  AppTextScreen _appScreenText;
  bool disposed = false;

  @override
  void initState() {
    disposed = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (mounted) {
        //log('0-0-0-0- inside while Polling for pending approvals');
        await Future.delayed(Duration(seconds: 10));
        _pollPendingApprovals();
      }
    });
    _appScreenText = getAppTextScreen("handAnalyseView");

    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  _pollPendingApprovals() async {
    if (disposed) {
      return;
    }
    //log('0-0-0-0- Polling for pending approvals');
    final approvals = await PlayerService.getPendingApprovals();
    if (disposed) {
      return;
    }
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

  Future<void> onGameInfoBottomSheet(BuildContext context) async {
    // final model = HandHistoryListModel(widget.gameState.gameCode, true);
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GameInfoBottomSheet();
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
                        _appScreenText['pendingApprovals'],
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
                                      return pendingApprovalsItem(theme, item);
                                    },
                                  ),
                                );
                              } else {
                                return Container(
                                  height: height / 4,
                                  child: Center(
                                    child: Text(
                                      _appScreenText['noPendingApprovals'],
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
                                  child: Text(_appScreenText[
                                      'SomethingWentWrongTryAgain']),
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
  }

  Future<void> onClickPendingBuyInApprovals(BuildContext context) async {
    final height = MediaQuery.of(context).size.height;
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildStatefulBuilder(height, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    log('game started: ${widget.gameState.started}');
    final theme = AppTheme.getTheme(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // build the menu widget, and on tap expand the options from left
          _buildMenuWidget(context),
        ],
      ),
    );
  }

  // void onMoreOptionsPress(BuildContext context) {
  //   log('onMoreOptionsPress');
  //   // showMoreOptions(context);

  //   // slide in from left
  //   vnShowMenuItems.value = true;
  // }

  Widget _buildMenuButton({
    @required String title,
    Widget child,
    IconData iconData,
    String imagePath,
    VoidCallback onClick,
  }) {
    final tmp = title.split(' ');
    if (tmp.length > 1) {
      title = tmp[0] + '\n' + tmp[1];
    }

    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: onClick,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // button
            GameCircleButton(
              child: child,
              iconData: iconData,
              imagePath: imagePath,
            ),

            // text
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuWidget(BuildContext context) {
    AppTheme theme = AppTheme.getTheme(context);
    Widget optionButton = Transform.rotate(
        angle: math.pi / 2,
        child: Icon(
          Icons.expand_less,
          color:
              theme.primaryColorWithDark(), //AppColorsNew.newGreenButtonColor,
        ));
    Widget closeButton = Transform.rotate(
        angle: -math.pi / 2,
        child: Icon(
          Icons.expand_less,
          color:
              theme.primaryColorWithDark(), //AppColorsNew.newGreenButtonColor,
        ));
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // MAIN MENU
        GameCircleButton(
          child: optionButton,
          onClickHandler: () => vnShowMenuItems.value = true,
        ),

        // Other options
        ValueListenableBuilder(
          valueListenable: vnShowMenuItems,
          child: Container(
            color: Colors.black,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // other menu buttons

                // menu close button
                _buildMenuButton(
                    title: 'Close',
                    child: closeButton,
                    onClick: () {
                      vnShowMenuItems.value = false;
                    }),

                // last hand
                _buildMenuButton(
                    title: 'Prev',
                    imagePath: AppAssetsNew.lastHandPath,
                    onClick: () {
                      vnShowMenuItems.value = false;
                      onClickViewHand(context);
                    }),

                // game history
                _buildMenuButton(
                    title: 'History',
                    imagePath: AppAssetsNew.handHistoryPath,
                    onClick: () {
                      vnShowMenuItems.value = false;
                      onClickViewHandAnalysis(context);
                    }),

                // game info
                _buildMenuButton(
                    title: 'Info',
                    iconData: Icons.info_outline_rounded,
                    onClick: () {
                      vnShowMenuItems.value = false;
                      // onGameInfoBottomSheet(context);
                    }),

                // result table
                _buildMenuButton(
                    title: 'Result',
                    imagePath: AppAssetsNew.tableResultPath,
                    onClick: () {
                      vnShowMenuItems.value = false;
                      onTableBottomSheet(context);
                    }),

                // player stack
                _buildMenuButton(
                    title: 'Stats',
                    imagePath: AppAssetsNew.playerStatsPath,
                    onClick: () {
                      vnShowMenuItems.value = false;
                      onPlayerStatsBottomSheet(context);
                    }),
              ],
            ),
          ),
          builder: (_, showMenu, child) => AnimatedSwitcher(
            duration: AppConstants.fastestAnimationDuration,
            transitionBuilder: (child, animation) => SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: animation,
              child: child,
            ),
            child: showMenu ? child : const SizedBox.shrink(),
          ),
        ),
      ],
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
                    text: " ${_appScreenText['requestBuyin']}",
                    style: AppDecorators.getSubtitle3Style(theme: theme),
                  ),
                  TextSpan(
                    text: " ${item.amount}",
                    style: AppDecorators.getAccentTextStyle(theme: theme),
                  ),
                ],
              ),
            ),
            Text(
              "${_appScreenText['outstandingBalance']}: ${item.balance}",
              style: AppDecorators.getHeadLine4Style(theme: theme),
            ),
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
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: () async {
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
                  }),
              IconButton(
                icon: Icon(
                  Icons.cancel_rounded,
                  color: theme.negativeOrErrorColor,
                ),
                onPressed: () async {
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
              )
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
