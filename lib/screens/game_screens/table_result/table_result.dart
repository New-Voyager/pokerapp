import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/hand_table_bar_chart_profit.dart';
import 'package:share/share.dart';

class TableResultScreen extends StatefulWidget {
  final String gameCode;
  final bool showBackButton;
  final int playerWidth = 15;
  final int sessionWidth = 20;
  final int numHandsWidth = 15;
  final int buyInWidth = 15;
  final int profitWidth = 15;
  final int rakeWidth = 15;
  final bool showDownload;
  final bool showTips;
  TableResultScreen(
      {this.gameCode, this.showDownload = true, this.showBackButton = false, this.showTips = false});

  @override
  State<StatefulWidget> createState() {
    return _TableResultScreenState();
  }
}

class _TableResultScreenState extends State<TableResultScreen> {
  TableRecord data;

  final SizedBox seprator = SizedBox(
    height: 20.0,
  );

  Map<int, Widget> tableWidgets;
  int _selectedTableWidget = 0;

  _TableResultScreenState();

  void _fetchData() async {
    this.data = await GameService.getGameTableRecord(widget.gameCode);
    print(this.data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  double getTotalRake() {
    if (this.data == null || this.data.rows == null) {
      return 0.0;
    }
    return this.data.rows.fold(
        0.0, (previousValue, element) => previousValue + element.rakePaid);
  }

  initializeTableWidgets() {
    tableWidgets = const <int, Widget>{
      0: Text("Table"),
      1: Text("Graph"),
    };
  }

  Widget getTableOrGraphView(context, int index) {
    Map<int, Widget> segmentedViews = <int, Widget>{
      0: Expanded(
        child: this.data == null
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: this.data.rows.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 70.0,
                      margin: EdgeInsets.all(10),
                      color: Color(0xff313235),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              flex: widget.playerWidth,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Player",
                                    style: TextStyle(color: Color(0xffef9712)),
                                  ))),
                          Expanded(
                              flex: widget.sessionWidth,
                              child: Center(
                                  child: Text(
                                "Session",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.numHandsWidth,
                              child: Center(
                                  child: Text(
                                "#Hands",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.buyInWidth,
                              child: Center(
                                  child: Text(
                                "Buyin",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          Expanded(
                              flex: widget.profitWidth,
                              child: Center(
                                  child: Text(
                                "Profit",
                                style: TextStyle(color: Color(0xffef9712)),
                              ))),
                          widget.showTips ? Expanded(
                              flex: widget.rakeWidth,
                              child: Center(
                                  child: Text(
                                "Tips",
                                style: TextStyle(color: Color(0xffef9712)),
                              )))
                              : Container(),
                        ],
                      ),
                    );
                  } else {
                    int dataIdx = index - 1;
                    return Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: widget.playerWidth,
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  this.data.rows[dataIdx].playerName,
                                  style: TextStyle(color: Color(0xffa09f9e)),
                                )),
                          ),
                          Expanded(
                            flex: widget.sessionWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].sessionTimeStr,
                              style: TextStyle(color: Color(0xffa09f9e)),
                            )),
                          ),
                          Expanded(
                            flex: widget.numHandsWidth,
                            child: Center(
                                child: Text(
                              this.data.rows[dataIdx].handsPlayed.toString(),
                              style: TextStyle(color: Color(0xffa09f9e)),
                            )),
                          ),
                          Expanded(
                            flex: widget.buyInWidth,
                            child: Center(
                                child: Text(
                              DataFormatter.chipsFormat(
                                  this.data.rows[dataIdx].buyIn),
                              style: TextStyle(color: Color(0xffa09f9e)),
                            )),
                          ),
                          Expanded(
                            flex: widget.profitWidth,
                            child: Center(
                                child: Text(
                              DataFormatter.chipsFormat(
                                  this.data.rows[dataIdx].profit),
                              style: this.data.rows[dataIdx].profit >= 0
                                  ? AppStyles.profitStyle
                                  : AppStyles.lossStyle,
                            )),
                          ),
                          widget.showTips ? Expanded(
                            flex: widget.rakeWidth,
                            child: Center(
                                child: Text(
                              DataFormatter.chipsFormat(
                                  this.data.rows[dataIdx].rakePaid),
                              style: TextStyle(color: Color(0xffef9712)),
                            )),
                          ) : Container(),
                        ],
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  if (index == 0) {
                    return Container();
                  } else {
                    return Divider(
                      color: Color(0xff707070),
                    );
                  }
                },
              ),
      ),
      1: Expanded(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 3 / 4,
                child: HandTableBarChartProfit(this.data),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height / 3,
              //   child: HandTableBarChartBalance(this.data),
              // ),
            ],
          ),
        ),
      ),
    };

    return segmentedViews[index];
  }

  @override
  Widget build(BuildContext context) {
    initializeTableWidgets();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar(
        context: context,
        titleText: AppStringsNew.TableRecordTitle,
        subTitleText: "Game code: ${widget.gameCode}",
        showBackButton: widget.showBackButton,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 15.0, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.showTips ? Text(
                            "Tips",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppAssets.fontFamilyLato,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ): Container(),
                          SizedBox(
                            width: 10.0,
                          ),
                          widget.showTips ? Text(
                            getTotalRake().toString(),
                            style: TextStyle(
                              color: Color(0xff1aff22),
                              fontFamily: AppAssets.fontFamilyLato,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ): Container(),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          widget.showDownload
                              ? InkWell(
                                  onTap: () async {
                                    downloadTable(widget.gameCode);
                                  },
                                  child: Text(
                                    "Download",
                                    style: TextStyle(
                                      color: Color(0xff319ffe),
                                      fontFamily: AppAssets.fontFamilyLato,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoSegmentedControl<int>(
                        unselectedColor: AppColors.screenBackgroundColor,
                        selectedColor: AppColors.appAccentColor,
                        children: tableWidgets,
                        borderColor: AppColors.appAccentColor,
                        onValueChanged: (int val) {
                          setState(() {
                            _selectedTableWidget = val;
                          });
                        },
                        groupValue: _selectedTableWidget,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: getTableOrGraphView(context, _selectedTableWidget),
              ),
            ],
          ),
        ),
      ),
    );
  }

  downloadTable(String gameCode) async {
    log('table is downloaded');

    Future.delayed(Duration(seconds: 1), () async {
      try {
        final result = await GameService.downloadResult(gameCode);
        String subject = 'Table result Game: $gameCode';
        Share.share(result, subject: subject);
      } catch (err) {
        log('Error: ${err.toString()}');
      }
    });
  }
}
