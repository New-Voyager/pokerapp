import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
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
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("handLogView");

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
        titleText:
            result ? _appScreenText["SUCCESS"] : _appScreenText["FAILED"],
        subTitleText: result
            ? "${_appScreenText['HAND']} " +
                handnum.toString() +
                " ${_appScreenText['REMOVEDFROMBOOKMARKS']}"
            : "${_appScreenText['COULDNOTREMOVEBOOKMARK']}",
      );

      if (result) {
        await _fetchBookmarksForGame(widget.gameCode);
      }
    } else {
      Alerts.showNotification(
        titleText: _appScreenText["FAILED"],
        subTitleText: "${_appScreenText['COULDNOTREMOVEBOOKMARK']}",
      );
    }
  }

  _replayHand() async {
    final handNum = widget.handNum;
    final gameCode = widget.gameCode;
    Future.delayed(Duration(milliseconds: 10), () async {
      try {
        ConnectionDialog.show(
            context: context, loadingText: "${_appScreenText["LOADINGHAND"]}");
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
    final AppTheme theme = AppTheme.getTheme(context);
    List<Widget> children = [];
    if (!this._isLoading) {
      if (_handLogModel == null) {
        children = [
          Center(
              child: Text(
            '${_appScreenText["HANDDATAISNOTAVAILABLE"]}',
            style: TextStyle(color: Colors.white),
          ))
        ];
      } else {
        if (_handLogModel.authorized) {
          children = getHandLog(theme);
        } else {
          children = [
            Center(
                child: Text(
              '${_appScreenText["YOUARENOTALLOWEDTOVIEWTHISHAND"]}',
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
          titleText: _appScreenText['HANDLOG'],
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
                if (_isTheHandBookmarked(_handLogModel.hand.handNum)) {
                  _removeBookmark(_handLogModel.hand.handNum);
                } else {
                  final result = await HandService.bookMarkHand(
                    _handLogModel.hand.gameCode,
                    _handLogModel.hand.handNum,
                  );
                  Alerts.showNotification(
                    titleText: result
                        ? _appScreenText["SUCCESS"]
                        : _appScreenText["FAILED"],
                    subTitleText: result
                        ? "${_appScreenText['HAND']} ${_appScreenText['HASBEENBOOKMARKED']}" +
                            "${_handLogModel.hand.handNum} ."
                        : "${_appScreenText['COULDNOTBOOKMARK']}",
                  );
                  await _fetchBookmarksForGame(widget.gameCode);
                }
              },
              icon: _isTheHandBookmarked(_handLogModel.hand.handNum)
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
                  log("SHARE12: ${_handLogModel.hand.gameCode} : ${_handLogModel.hand.handNum} : ${widget.clubCode}");
                  var result = await HandService.shareHand(
                    _handLogModel.hand.gameCode,
                    _handLogModel.hand.handNum,
                    widget.clubCode,
                  );
                  Alerts.showNotification(
                    titleText: result
                        ? _appScreenText["SUCCESS"]
                        : _appScreenText["FAILED"],
                    subTitleText: result
                        ? "${_appScreenText['HAND']} " +
                            _handLogModel.hand.handNum.toString() +
                            " ${_appScreenText["HASBENSHAREDWITHTHECLUB"]}"
                        : "${_appScreenText["COULDBOTSHAREHAND"]}",
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
      HandLogActionView(
        handLogModel: _handLogModel,
        appTextScreen: _appScreenText,
      ),
      AppDimensionsNew.getVerticalSizedBox(8),
      HandlogSummary(
        handlogModel: _handLogModel,
        appTextScreen: _appScreenText,
      ),
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
        title: Text(_appScreenText['SENDREPORT']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_appScreenText['WOULDYOULIKETOSENDHANDTODEVELOPMENTTEAM']),
          ],
        ),
        actions: [
          RoundedColorButton(
            text: _appScreenText['CANCEL'],
            backgroundColor: Colors.transparent,
            textColor: theme.supportingColor,
            borderColor: theme.accentColor,
            onTapFunction: () {
              Navigator.of(context).pop();
            },
          ),
          RoundedColorButton(
            text: _appScreenText['SEND'],
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
      Alerts.showNotification(
          titleText: _appScreenText['HANDLOGDATASENTTOAPPTEAM']);
    }
  }
}
