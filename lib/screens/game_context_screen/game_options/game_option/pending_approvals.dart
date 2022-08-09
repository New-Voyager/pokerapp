import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class PendingApprovalsBottomSheet extends StatefulWidget {
  final String gameCode;
  final String playerUuid;
  final GameState gameState;
  PendingApprovalsBottomSheet(this.gameState, this.gameCode, this.playerUuid);

  @override
  _PendingApprovalsBottomSheetState createState() =>
      _PendingApprovalsBottomSheetState();
}

class _PendingApprovalsBottomSheetState
    extends State<PendingApprovalsBottomSheet> {
  double height, width;
  bool ischanged = false;
  bool loading = true;
  AppTextScreen appTextScreen;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    loading = true;
    this.appTextScreen = getAppTextScreen("gameScreen");
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // log('waiting list: build');

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<AppTheme>(
        builder: (_, theme, __) => Container(
              height: height / 2.5,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    decoration: AppDecorators.bgImageGradient(theme),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 13,
                        ),
                        Container(
                            child: Text(
                              appTextScreen['pendingApprovals'],
                              style: AppDecorators.getAccentTextStyle(
                                  theme: theme),
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
                                            style:
                                                AppDecorators.getSubtitle1Style(
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
            ));
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
                    text: item.approvalType == 'RELOAD_REQUEST'
                        ? 'reload'
                        : " ${appTextScreen['requestBuyin']}",
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
                    bool val;
                    if (item.approvalType == 'RELOAD_REQUEST') {
                      val = await PlayerService.approveReloadRequest(
                        item.gameCode,
                        item.playerUuid,
                      );
                    } else {
                      val = await PlayerService.approveBuyInRequest(
                        item.gameCode,
                        item.playerUuid,
                      );
                    }
                    if (val == null) {
                      log("Exception in approve request");
                    } else if (val) {
                      //_pollPendingApprovals(context);
                    } else {
                      log("Failed to approve request");
                    }
                  },
                  theme: theme),
              SizedBox(width: 10),
              ConfirmNoButton(
                  onTap: () async {
                    bool val;
                    if (item.approvalType == 'RELOAD_REQUEST') {
                      val = await PlayerService.declineReloadRequest(
                        item.gameCode,
                        item.playerUuid,
                      );
                    } else {
                      val = await PlayerService.declineBuyInRequest(
                        item.gameCode,
                        item.playerUuid,
                      );
                    }
                    if (val == null) {
                      log("Error occurred when declining request");
                    } else if (val) {
                      //_pollPendingApprovals(context);
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
}
