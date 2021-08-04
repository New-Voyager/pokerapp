import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/hand_table_bar_chart_profit.dart';
import 'package:share/share.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../../routes.dart';

class TableResultScreen extends StatefulWidget {
  final String gameCode;
  final bool showBackButton;
  final int rankWidth = 10;
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
    this.showBackButton = true,
    this.showTips = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _TableResultScreenState();
  }
}

class _TableResultScreenState extends State<TableResultScreen>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.table_result;
  TableRecord data;

  Map<int, Widget> tableWidgets;
  int _selectedTableWidget = 0;

  void _fetchData() async {
    data = await GameService.getGameTableRecord(widget.gameCode);
    data.sort();
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
          child: text.isEmpty
              ? Container()
              : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    text,
                    style: TextStyle(color: Color(0xffef9712)),
                  ),
                ),
        ),
      );

  Widget _buildTableHeader() => Container(
        height: 70.0.ph,
        margin: EdgeInsets.all(10.pw),
        color: Color(0xff313235),
        child: Row(
          children: [
            _buildHeaderChild(
              flex: widget.rankWidth,
              text: '',
            ),
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

  String _getIconByRank(int rank) {
    switch (rank) {
      case 1:
        return AppAssetsNew.standing1;
      case 2:
        return AppAssetsNew.standing2;
      case 3:
        return AppAssetsNew.standing3;
      default:
        return '';
    }
  }

  Color _getColorByRank(int rank) {
    switch (rank) {
      case 1:
        return Colors.yellowAccent;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.transparent;
    }
  }

  Widget _buildTableContentChild({
    int flex = 1,
    var data,
    String icon,
    Color iconColor = Colors.transparent,
  }) =>
      Expanded(
        flex: flex,
        child: icon != null
            ? icon.isEmpty
                ? Container()
                : SvgPicture.asset(
                    icon,
                    color: iconColor,
                    width: 25.0.pw,
                    height: 25.0.pw,
                  )
            : Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    data is double ? DataFormatter.chipsFormat(data) : data,
                    style: TextStyle(
                      color: data is double
                          ? data > 0
                              ? AppStylesNew.profitStyle.color
                              : AppStylesNew.lossStyle.color
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
                    margin: EdgeInsets.symmetric(horizontal: 10.0.pw),
                    height: 50.0.ph,
                    child: Row(
                      children: [
                        _buildTableContentChild(
                          flex: widget.rankWidth,
                          icon: _getIconByRank(index),
                          iconColor: _getColorByRank(index),
                        ),
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
          padding: EdgeInsets.all(15.pw),
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
      backgroundColor: AppColorsNew.screenBackgroundColor,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0.pw,
                    vertical: 5.0.pw,
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
                                    fontSize: 12.0.dp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container(),

                          // sep
                          SizedBox(width: 10.0.pw),

                          widget.showTips
                              ? Text(
                                  getTotalRake().toString(),
                                  style: TextStyle(
                                    color: Color(0xff1aff22),
                                    fontFamily: AppAssets.fontFamilyLato,
                                    fontSize: 12.0.dp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 20.0.pw),
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
                                      fontSize: 12.0.dp,
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
                      unselectedColor: AppColorsNew.screenBackgroundColor,
                      selectedColor: AppColorsNew.appAccentColor,
                      children: tableWidgets,
                      borderColor: AppColorsNew.appAccentColor,
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
