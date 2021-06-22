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
  TableResultScreen({
    this.gameCode,
    this.showDownload = true,
    this.showBackButton = false,
    this.showTips = false,
  });

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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  double getTotalRake() {
    if (this.data == null || this.data.rows == null) return 0.0;

    return this.data.rows.fold(
          0.0,
          (previousValue, element) => previousValue + element.rakePaid,
        );
  }

  initializeTableWidgets() {
    tableWidgets = const <int, Widget>{
      0: Text("Table"),
      1: Text("Graph"),
    };
  }

  Widget _buildHeaderChild({int flex = 1, String text = 'Player'}) => Expanded(
        flex: flex,
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              text,
              style: TextStyle(color: Color(0xffef9712)),
            ),
          ),
        ),
      );

  Widget _buildTableHeader() => Container(
        height: 70.0,
        margin: EdgeInsets.all(10),
        color: Color(0xff313235),
        child: Row(
          children: [
            _buildHeaderChild(
              flex: widget.playerWidth,
              text: 'Player',
            ),
            _buildHeaderChild(
              flex: widget.sessionWidth,
              text: 'Session',
            ),
            _buildHeaderChild(
              flex: widget.numHandsWidth,
              text: '#Hands',
            ),
            _buildHeaderChild(
              flex: widget.buyInWidth,
              text: 'Buyin',
            ),
            _buildHeaderChild(
              flex: widget.profitWidth,
              text: 'Profit',
            ),
            widget.showTips
                ? _buildHeaderChild(
                    flex: widget.rakeWidth,
                    text: 'Tips',
                  )
                : Container(),
          ],
        ),
      );

  Widget _buildTableContentChild({int flex = 1, var data}) => Expanded(
        flex: flex,
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              data is double ? DataFormatter.chipsFormat(data) : data,
              style: TextStyle(
                color: data is double
                    ? data > 0
                        ? AppStyles.profitStyle.color
                        : AppStyles.lossStyle.color
                    : Color(0xffa09f9e),
              ),
            ),
          ),
        ),
      );

  Widget _buildTableView() => Expanded(
        child: this.data == null
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: this.data.rows.length + 1,
                itemBuilder: (context, index) {
                  // index 0 draws the header
                  if (index == 0) return _buildTableHeader();

                  final tableRowRecord = this.data.rows[index - 1];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 50.0,
                    child: Row(
                      children: [
                        _buildTableContentChild(
                          flex: widget.playerWidth,
                          data: tableRowRecord.playerName,
                        ),
                        _buildTableContentChild(
                          flex: widget.sessionWidth,
                          data: tableRowRecord.sessionTimeStr,
                        ),
                        _buildTableContentChild(
                          flex: widget.numHandsWidth,
                          data: tableRowRecord.handsPlayed.toString(),
                        ),
                        _buildTableContentChild(
                          flex: widget.buyInWidth,
                          data: DataFormatter.chipsFormat(tableRowRecord.buyIn),
                        ),
                        _buildTableContentChild(
                          flex: widget.profitWidth,
                          data: tableRowRecord.profit,
                        ),
                        widget.showTips
                            ? _buildTableContentChild(
                                flex: widget.rakeWidth,
                                data: DataFormatter.chipsFormat(
                                  tableRowRecord.rakePaid,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  if (index == 0)
                    return Container();
                  else
                    return Divider(color: Color(0xff707070));
                },
              ),
      );

  Widget _buildGraphView() => Expanded(
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
      );

  Widget _buildMainView(int index) =>
      index == 0 ? _buildTableView() : _buildGraphView();

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
        physics: BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              // table result heading widget
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 15.0,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.showTips
                              ? Text(
                                  "Tips",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppAssets.fontFamilyLato,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container(),

                          // sep
                          SizedBox(width: 10.0),

                          widget.showTips
                              ? Text(
                                  getTotalRake().toString(),
                                  style: TextStyle(
                                    color: Color(0xff1aff22),
                                    fontFamily: AppAssets.fontFamilyLato,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 20.0),
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

              // table - graph row
              Row(
                children: [
                  Expanded(
                    child: CupertinoSegmentedControl<int>(
                      unselectedColor: AppColors.screenBackgroundColor,
                      selectedColor: AppColors.appAccentColor,
                      children: tableWidgets,
                      borderColor: AppColors.appAccentColor,
                      onValueChanged: (int val) {
                        setState(() => _selectedTableWidget = val);
                      },
                      groupValue: _selectedTableWidget,
                    ),
                  )
                ],
              ),

              // main body
              _buildMainView(_selectedTableWidget),
            ],
          ),
        ),
      ),
    );
  }

  downloadTable(String gameCode) async {
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
