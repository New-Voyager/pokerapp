import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'icon_with_badge.dart';

class PendingApprovalsButton extends StatelessWidget {
  final GameContextObject gameContextObject;
  final AppTheme theme;
  final GameState gameState;
  final bool mounted;
  AppTextScreen appTextScreen;

  PendingApprovalsButton(
      this.theme, this.gameState, this.gameContextObject, this.mounted);

  @override
  Widget build(BuildContext context) {
    appTextScreen = getAppTextScreen("gameScreen");

    return Consumer2<PendingApprovalsState, GameContextObject>(
      builder: (context, value, gameContextObj, child) {
        if (!gameContextObject.isAdmin()) return const SizedBox.shrink();

        Widget button = CircleImageButton(
            onTap: () {
              onClickPendingBuyInApprovals(context);
            },
            svgAsset: 'assets/images/game/tasks.svg',
            //icon: Icons.task_alt,
            theme: theme);
        if (appState.buyinApprovals.shake) {
          button = ShakeAnimatedWidget(
            enabled: true,
            duration: Duration(milliseconds: 500),
            shakeAngle: Rotation.deg(z: 20),
            curve: Curves.linear,
            child: button,
          );
          return button;
        }
        return IconWithBadge(
          count: value.approvalList.length,
          onClickFunction: () => onClickPendingBuyInApprovals(context),
          child: button,
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
                        appTextScreen['pendingApprovals'],
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
                                      return pendingApprovalsItem(
                                          context, theme, item);
                                    },
                                  ),
                                );
                              } else {
                                return Container(
                                  height: height / 4,
                                  child: Center(
                                    child: Text(
                                      appTextScreen['noPendingApprovals'],
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
                                  child: Text(appTextScreen[
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

  Widget pendingApprovalsItem(
      BuildContext context, AppTheme theme, PendingApproval item) {
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
                    text: " ${appTextScreen['requestBuyin']}",
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
            //   "${appTextScreen['outstandingBalance']}: ${item.balance}",
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
              "${appTextScreen['game']}: ${item.gameType}",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
            Text(
              "${appTextScreen['code']}: ${item.gameCode}",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
            Text(
              "${appTextScreen['club']}: ${item.clubCode}",
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
                  onTap: () async {
                    final bool val = await PlayerService.approveBuyInRequest(
                      item.gameCode,
                      item.playerUuid,
                    );
                    if (val == null) {
                      log("Exception in approve request");
                    } else if (val) {
                      _pollPendingApprovals(context);
                    } else {
                      log("Failed to approve request");
                    }
                  },
                  theme: theme),
              SizedBox(width: 10.pw),
              ConfirmNoButton(
                  onTap: () async {
                    final bool val = await PlayerService.declineBuyInRequest(
                      item.gameCode,
                      item.playerUuid,
                    );
                    if (val == null) {
                      log("Error occurred when declining request");
                    } else if (val) {
                      _pollPendingApprovals(context);
                    } else {
                      log("Error occurred when declining request");
                    }
                  },
                  theme: theme),
            ],
          ),
        ),
      ),
    );
  }

  _pollPendingApprovals(BuildContext context) async {
    if (TestService.isTesting || gameState.customizationMode) {
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
}
