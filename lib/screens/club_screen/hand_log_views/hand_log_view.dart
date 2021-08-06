import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_header_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_action.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_showdown.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_summary.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class HandLogView extends StatefulWidget {
  final String gameCode;
  final bool isAppbarWithHandNumber;
  final String clubCode;
  final int handNum;
  final HandLogModelNew handLogModel;
  final bool isBottomSheet;

  HandLogView(this.gameCode, this.handNum,
      {this.isAppbarWithHandNumber = false,
      this.clubCode,
      this.handLogModel,
      this.isBottomSheet = false});

  @override
  State<StatefulWidget> createState() => _HandLogViewState();
}

class _HandLogViewState extends State<HandLogView> with RouteAwareAnalytics {
  @override
  String get routeName => Routes.hand_log_view;
  bool _isLoading = true;
  var handLogjson;
  List<BookmarkedHand> list = [];
  HandLogModelNew _handLogModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchBookmarksForGame(widget.gameCode);
      if (TestService.isTesting && widget.handLogModel == null) {
        loadJsonData();
      } else {
        _fetchData();
      }
    });
  }

  void _fetchData() async {
    if (widget.handLogModel != null) {
      _handLogModel = widget.handLogModel;
    } else {
      _handLogModel =
          await HandService.getHandLog(widget.gameCode, widget.handNum);
    }
    _isLoading = false;
    setState(() {
      // update ui
    });
  }

  _fetchBookmarksForGame(String gameCode) async {
    list.clear();
    var result = await HandService.getBookmarkedHandsForGame(widget.gameCode);
    BookmarkedHandModel model = BookmarkedHandModel.fromJson(result);

    for (var item in model.bookmarkedHands) {
      list.add(item);
    }
    setState(() {});
  }

  loadJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/handlog/holdem/flop.json");

    final jsonResult = json.decode(data);
    _handLogModel = HandLogModelNew.fromJson(jsonResult);

    setState(() {
      _isLoading = false;
    });
  }

  _removeBookmark(int handnum) async {
    var hand =
        list.firstWhere((element) => element.handNum == handnum, orElse: null);
    if (hand != null) {
      var result = await HandService.removeBookmark(hand.id);
      Alerts.showNotification(
        titleText: result ? "SUCCESS" : "FAILED",
        subTitleText: result
            ? "Hand " + handnum.toString() + " removed from bookmarks"
            : "Couldn't remove bookmark",
      );

      if (result) {
        await _fetchBookmarksForGame(widget.gameCode);
      }
    } else {
      Alerts.showNotification(
        titleText: "FAILED",
        subTitleText: "Couldn't remove bookmark",
      );
    }
  }

  _replayHand() async {
    final handNum = widget.handNum;
    final gameCode = widget.gameCode;
    Future.delayed(Duration(milliseconds: 10), () async {
      try {
        ConnectionDialog.show(
            context: context, loadingText: "Loading hand ...");
        final handLogModel = await HandService.getHandLog(gameCode, handNum);
        Navigator.pop(context);

        ReplayHandDialog.show(
          context: context,
          hand: jsonDecode(handLogModel.handData),
          playerID: handLogModel.myInfo.id,
        );
      } catch (err) {
        // ignore the error
        log('error: ${err.toString()}');
      }
    });
  }

  bool _isTheHandBookmarked(int handNum) {
    // log("HAND UNDER TEST : $handNum");
    final index = list.indexWhere((element) => element.handNum == handNum);
    if (index < 0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // String title = "Last Hand Log";
    // if (widget.isAppbarWithHandNumber && widget.handNum != -1) {
    //   title = "Hand Log #" + widget.handNum.toString();
    // }
    List<Widget> children = [];
    if (!this._isLoading) {
      if (_handLogModel == null) {
        children = [
          Center(
              child: Text(
            'Hand data is not available',
            style: TextStyle(color: Colors.white),
          ))
        ];
      } else {
        if (_handLogModel.authorized) {
          children = getHandLog();
        } else {
          children = [
            Center(
                child: Text(
              'You are not allowed to view this hand',
              style: TextStyle(color: Colors.white),
            ))
          ];
        }
      }
    }

    return Consumer<AppTheme>(builder: (_,theme,__)=> Container(
        decoration: theme.bgRadialGradient,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: AppStringsNew.HandlogTitle,
            showBackButton: !(widget.isBottomSheet ?? false),
          ),
          body: this._isLoading == true
              ? Center(
                  child: CircularProgressWidget(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: children,
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> getHandLog() {
    return [
      // main top header
      Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // replay, share, bookmark buttons
            RoundIconButton(
                onTap: () => _sendHand(), icon: Icons.developer_board),
            AppDimensionsNew.getHorizontalSpace(8),
            RoundIconButton(onTap: () => _replayHand(), icon: Icons.replay),
            AppDimensionsNew.getHorizontalSpace(8),
            RoundIconButton(
              onTap: () async {
                if (_isTheHandBookmarked(_handLogModel.hand.handNum)) {
                  _removeBookmark(_handLogModel.hand.handNum);
                } else {
                  final result = await HandService.bookMarkHand(
                    _handLogModel.hand.gameCode,
                    _handLogModel.hand.handNum,
                  );
                  Alerts.showNotification(
                    titleText: result ? "SUCCESS" : "FAILED",
                    subTitleText: result
                        ? "Hand ${_handLogModel.hand.handNum} has been bookmarked."
                        : "Couldn't bookmark this hand! Please try again.",
                  );
                  await _fetchBookmarksForGame(widget.gameCode);
                }
              },
              icon: _isTheHandBookmarked(_handLogModel.hand.handNum)
                  ? Icons.star
                  : Icons.star_outline,
            ),
            AppDimensionsNew.getHorizontalSpace(8),
            Visibility(
              visible:
                  ((widget.clubCode != null) && (widget.clubCode.isNotEmpty)),
              child: RoundIconButton(
                onTap: () async {
                  log("SHARE12: ${_handLogModel.hand.gameCode} : ${_handLogModel.hand.handNum} : ${widget.clubCode}");
                  var result = await HandService.shareHand(
                    _handLogModel.hand.gameCode,
                    _handLogModel.hand.handNum,
                    widget.clubCode,
                  );
                  Alerts.showNotification(
                    titleText: result ? "SUCCESS" : "FAILED",
                    subTitleText: result
                        ? "Hand " +
                            _handLogModel.hand.handNum.toString() +
                            " has been shared with the club"
                        : "Couldn't share the hand. Please try again later",
                  );
                },
                icon: Icons.share,
              ),
            ),
          ],
        ),
      ),
      HandLogHeaderView(_handLogModel),
      AppDimensionsNew.getVerticalSizedBox(4),

      HandWinnersView(handLogModel: _handLogModel),
      HandStageView(
        handLogModel: _handLogModel,
        stageEnum: GameStages.PREFLOP,
      ),
      HandStageView(
        handLogModel: _handLogModel,
        stageEnum: GameStages.FLOP,
      ),
      HandStageView(
        handLogModel: _handLogModel,
        stageEnum: GameStages.TURN,
      ),
      HandStageView(
        handLogModel: _handLogModel,
        stageEnum: GameStages.RIVER,
      ),
      HandlogShowDown(
        handLogModel: _handLogModel,
      ),
      AppDimensionsNew.getVerticalSizedBox(8),
      HandLogActionView(handLogModel: _handLogModel),
      AppDimensionsNew.getVerticalSizedBox(8),
      HandlogSummary(handlogModel: _handLogModel),
    ];
  }

  _sendHand() async {
    final res = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorsNew.newDialogBgColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColorsNew.newBorderColor,
          ),
        ),
        buttonPadding: EdgeInsets.all(16),
        title: Text(AppStringsNew.sendReportText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStringsNew.handlogSendToDevTeam,
            ),
          ],
        ),
        actions: [
          RoundedColorButton(
            text: AppStringsNew.cancelButtonText,
            backgroundColor: Colors.transparent,
            textColor: AppColorsNew.newGreenButtonColor,
            borderColor: AppColorsNew.newGreenButtonColor,
            onTapFunction: () {
              Navigator.of(context).pop();
            },
          ),
          RoundedColorButton(
            text: AppStringsNew.sendButtonText,
            backgroundColor: AppColorsNew.yellowAccentColor,
            textColor: AppColorsNew.darkGreenShadeColor,
            onTapFunction: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    if (res != null) {
      await HandService.debugHandLog(widget.gameCode, widget.handNum);
      // Make API Call
      Alerts.showNotification(titleText: "Handlog data sent to App team.");
    }
  }
}
