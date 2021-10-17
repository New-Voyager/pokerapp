import 'dart:developer';

import 'package:pokerapp/main.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_header_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_action.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_showdown.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_summary.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

import '../../../routes.dart';
import 'hand_winners_view2.dart';

class HandLogView extends StatefulWidget {
  final String gameCode;
  final bool isAppbarWithHandNumber;
  final String clubCode;
  final int handNum;
  final HandResultData handResult;
  final bool isBottomSheet;

  HandLogView(this.gameCode, this.handNum,
      {this.isAppbarWithHandNumber = false,
      this.clubCode,
      this.handResult,
      this.isBottomSheet = false});

  @override
  State<StatefulWidget> createState() => _HandLogViewState();
}

class _HandLogViewState extends State<HandLogView> with RouteAwareAnalytics {
  @override
  String get routeName => Routes.hand_log_view;
  bool _isLoading = true;
  List<BookmarkedHand> list = [];
  AppTextScreen _appScreenText;
  HandResultData _handResult;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("handLogView");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchBookmarksForGame(widget.gameCode);
      if (TestService.isTesting && widget.handResult == null) {
        loadJsonData();
      } else {
        _fetchData();
      }
    });
  }

  void _fetchData() async {
    if (widget.handResult != null) {
      _handResult = widget.handResult;
    } else {
      try {
        // dynamic json = jsonDecode(multiPotResult);
        // _handResult = HandResultData.fromJson(json);
        _handResult =
            await HandService.getHandLog(widget.gameCode, widget.handNum);
      } catch (err) {
        log('Error: ${err.toString()}');
      }
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
    // String data = await DefaultAssetBundle.of(context)
    //     .loadString("assets/sample-data/handlog/holdem/flop.json");

    //final jsonResult = json.decode(data);
    //_handLogModel = HandLogModelNew.fromJson(jsonResult);

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
        titleText:
            result ? _appScreenText["SUCCESS"] : _appScreenText["FAILED"],
        subTitleText: result
            ? "${_appScreenText['hand']} " +
                handnum.toString() +
                " ${_appScreenText['bookmarkRemoved']}"
            : "${_appScreenText['couldNotRemoveBookmark']}",
      );

      if (result) {
        await _fetchBookmarksForGame(widget.gameCode);
      }
    } else {
      Alerts.showNotification(
        titleText: _appScreenText["FAILED"],
        subTitleText: "${_appScreenText['couldNotRemoveBookmark']}",
      );
    }
  }

  _replayHand() async {
    final currentUser = await AuthService.get();
    ReplayHandDialog.show(
        gameCode: widget.gameCode,
        handNumber: widget.handNum,
        context: context,
        playerID: currentUser.playerId);
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
    final AppTheme theme = AppTheme.getTheme(context);
    List<Widget> children = [];
    if (!this._isLoading) {
      if (_handResult == null) {
        children = [
          Center(
              child: Text(
            '${_appScreenText["dataNotAvailable"]}',
            style: TextStyle(color: Colors.white),
          ))
        ];
      } else {
        bool authorized = true;
        if (authorized) {
          children = getHandLog(theme);
        } else {
          children = [
            Center(
                child: Text(
              '${_appScreenText["notAllowed"]}',
              style: TextStyle(color: Colors.white),
            ))
          ];
        }
      }
    }

    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: _appScreenText['handLog'],
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
    );
  }

  List<Widget> getHandLog(AppTheme theme) {
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
              onTap: () => _sendHand(theme),
              icon: Icons.developer_board,
              bgColor: theme.accentColor,
              iconColor: theme.primaryColorWithDark(),
            ),
            AppDimensionsNew.getHorizontalSpace(8),
            RoundIconButton(
              onTap: () => _replayHand(),
              icon: Icons.replay,
              bgColor: theme.accentColor,
              iconColor: theme.primaryColorWithDark(),
            ),
            AppDimensionsNew.getHorizontalSpace(8),
            RoundIconButton(
              onTap: () async {
                if (_isTheHandBookmarked(_handResult.handNum)) {
                  _removeBookmark(_handResult.handNum);
                } else {
                  final result = await HandService.bookMarkHand(
                    _handResult.gameCode,
                    _handResult.handNum,
                  );
                  Alerts.showNotification(
                    titleText: result
                        ? _appScreenText["SUCCESS"]
                        : _appScreenText["FAILED"],
                    subTitleText: result
                        ? "${_appScreenText['hand']} ${_appScreenText['bookmarked']}"
                        : "${_appScreenText['bookmarkFailed']}",
                  );
                  await _fetchBookmarksForGame(widget.gameCode);
                }
              },
              icon: _isTheHandBookmarked(_handResult.handNum)
                  ? Icons.star
                  : Icons.star_outline,
              bgColor: theme.accentColor,
              iconColor: theme.primaryColorWithDark(),
            ),
            AppDimensionsNew.getHorizontalSpace(8),
            Visibility(
              visible:
                  ((widget.clubCode != null) && (widget.clubCode.isNotEmpty)),
              child: RoundIconButton(
                onTap: () async {
                  log("SHARE12: ${_handResult.gameCode} : ${_handResult.handNum} : ${widget.clubCode}");
                  var result = await HandService.shareHand(
                    _handResult.gameCode,
                    _handResult.handNum,
                    widget.clubCode,
                  );
                  Alerts.showNotification(
                    titleText: result
                        ? _appScreenText["SUCCESS"]
                        : _appScreenText["FAILED"],
                    subTitleText: result
                        ? "${_appScreenText['hand']} " +
                            " ${_appScreenText["sharedWithClub"]}"
                        : "${_appScreenText["couldNotShare"]}",
                  );
                },
                icon: Icons.share,
                bgColor: theme.accentColor,
                iconColor: theme.primaryColorWithDark(),
              ),
            ),
          ],
        ),
      ),
      HandLogHeaderView(_handResult),
      AppDimensionsNew.getVerticalSizedBox(4),

      HandWinnersView2(handResult: _handResult),
      HandStageView(
        handResult: _handResult,
        stageEnum: GameStages.PREFLOP,
      ),
      HandStageView(
        handResult: _handResult,
        stageEnum: GameStages.FLOP,
      ),
      HandStageView(
        handResult: _handResult,
        stageEnum: GameStages.TURN,
      ),
      HandStageView(
        handResult: _handResult,
        stageEnum: GameStages.RIVER,
      ),
      HandlogShowDown(
        handResult: _handResult,
      ),
      AppDimensionsNew.getVerticalSizedBox(8),
      HandLogActionView(handResult: _handResult, appTextScreen: _appScreenText),
      AppDimensionsNew.getVerticalSizedBox(8),
      HandlogSummary(handResult: _handResult, appTextScreen: _appScreenText),
    ];
  }

  _sendHand(AppTheme theme) async {
    final res = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.fillInColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.secondaryColor,
          ),
        ),
        buttonPadding: EdgeInsets.all(16),
        title: Text(_appScreenText['sendReport']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_appScreenText['debugHand']),
          ],
        ),
        actions: [
          RoundedColorButton(
            text: _appScreenText['cancel'],
            backgroundColor: Colors.transparent,
            textColor: theme.supportingColor,
            borderColor: theme.accentColor,
            onTapFunction: () {
              Navigator.of(context).pop();
            },
          ),
          RoundedColorButton(
            text: _appScreenText['send'],
            backgroundColor: theme.accentColor,
            textColor: theme.primaryColorWithDark(),
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
      Alerts.showNotification(titleText: _appScreenText['sharedToDev']);
    }
  }
}
