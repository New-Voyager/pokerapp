import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/approval_type.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/icon_with_badge.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/firebase/push_notification_service.dart';
import 'package:provider/provider.dart';
import 'hand_history_bottomsheet.dart';
import 'last_hand_analyse_bottomsheet.dart';

class HandAnalyseView extends StatefulWidget {
  final String gameCode;
  final String clubCode;
  HandAnalyseView(this.gameCode, this.clubCode);

  @override
  _HandAnalyseViewState createState() => _HandAnalyseViewState();
}

class _HandAnalyseViewState extends State<HandAnalyseView> {
  Future<void> onClickViewHand() async {
    HandLogModel handLogModel = HandLogModel(widget.gameCode, -1);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LastHandAnalyseBottomSheet(
        handLogModel: handLogModel,
        clubCode: widget.clubCode,
      ),
    );
  }

  Future<void> onClickViewHandAnalysis() async {
    final model = HandHistoryListModel(widget.gameCode, true);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return HandHistoryAnalyseBottomSheet(
          model: model,
        );
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
                                          "Club: ${item.clubName}",
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
          HandAnalysisCardView(
            onClickHandler: onClickViewHand,
          ),
          HandAnalysisCardView(
            onClickHandler: onClickViewHandAnalysis,
          ),
          // Pending approval
          Consumer<PendingApprovalsState>(
            builder: (context, value, child) {
              log("VALUE ======== ${value.totalPending}");
              return IconWithBadge(
                child: Icon(
                  Icons.pending_actions,
                  size: 32,
                  color: AppColors.appAccentColor,
                ),
                count: value.totalPending,
                onClickFunction: onClickPendingBuyInApprovals,
              );
            },
          ),
        ],
      ),
    );
  }
}

class HandAnalysisCardView extends StatelessWidget {
  final VoidCallback onClickHandler;

  const HandAnalysisCardView({Key key, @required this.onClickHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClickHandler,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Image.asset(AppAssets.cardsImage,
            height: 35, color: AppColors.appAccentColor),
      ),
    );
  }
}
