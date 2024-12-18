import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
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
  final ClubHomePageModel club;

  TableResultScreen({
    this.gameCode,
    this.showDownload = true,
    this.showBackButton = true,
    this.showTips = false,
    this.club = null,
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
  AppTextScreen _appScreenText;
  bool showTips = false;
  void _fetchData() async {
    data = await GameService.getGameTableRecord(widget.gameCode);
    data.sort();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("tableResultScreen");
    _fetchData();
    showTips = widget.showTips;
    // // ClubHomePageModel model =
    // //     Provider.of<ClubHomePageModel>(context, listen: false);
    if (widget.club != null) {
      if (widget.club.isManager) {
        if (widget.club.role != null) {
          showTips = widget.club.role.seeTips;
        }
      }
    }
  }

  double getTotalRake() {
    if (this.data == null || this.data.rows == null) return 0.0;

    return this.data.rows.fold(
          0.0,
          (previousValue, element) => previousValue + element.rakePaid,
        );
  }

  initializeTableWidgets() {
    tableWidgets = <int, Widget>{
      0: Text(_appScreenText['table']),
      1: Text(_appScreenText['graph']),
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

  Widget _buildTableHeader(AppTheme theme) => Container(
        height: 70.0.ph,
        margin: EdgeInsets.all(10.pw),
        color: theme.fillInColor,
        child: Row(
          children: [
            _buildHeaderChild(
              flex: widget.rankWidth,
              text: '',
            ),
            _buildHeaderChild(
              flex: widget.playerWidth,
              text: _appScreenText['player'],
            ),
            _buildHeaderChild(
              flex: widget.sessionWidth,
              text: _appScreenText['session'],
            ),
            _buildHeaderChild(
              flex: widget.numHandsWidth,
              text: _appScreenText['hands'],
            ),
            _buildHeaderChild(
              flex: widget.buyInWidth,
              text: _appScreenText['buyin'],
            ),
            _buildHeaderChild(
              flex: widget.profitWidth,
              text: _appScreenText['profit'],
            ),
            showTips
                ? _buildHeaderChild(
                    flex: widget.rakeWidth,
                    text: _appScreenText['tips'],
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
    AppTheme theme,
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
                              ? theme.secondaryColor
                              : theme.negativeOrErrorColor
                          : theme.supportingColor,
                    ),
                  ),
                ),
              ),
      );

  Widget _buildTableView(AppTheme theme) => Expanded(
        child: this.data == null
            ? Center(child: CircularProgressWidget())
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: this.data.rows.length + 1,
                itemBuilder: (context, index) {
                  // index 0 draws the header
                  if (index == 0) return _buildTableHeader(theme);

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
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: widget.playerWidth,
                          data: tableRowRecord.playerName,
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: widget.sessionWidth,
                          data: tableRowRecord.sessionTimeStr,
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: widget.numHandsWidth,
                          data: tableRowRecord.handsPlayed.toString(),
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: widget.buyInWidth,
                          data: DataFormatter.chipsFormat(tableRowRecord.buyIn),
                          theme: theme,
                        ),
                        _buildTableContentChild(
                          flex: widget.profitWidth,
                          data: tableRowRecord.profit,
                          theme: theme,
                        ),
                        showTips
                            ? _buildTableContentChild(
                                flex: widget.rakeWidth,
                                data: DataFormatter.chipsFormat(
                                  tableRowRecord.rakePaid,
                                ),
                                theme: theme,
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

  Widget _buildGraphView(AppTheme theme) => Expanded(
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

  Widget _buildMainView(int index, AppTheme theme) =>
      index == 0 ? _buildTableView(theme) : _buildGraphView(theme);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    initializeTableWidgets();
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: _appScreenText['tableResult'],
          subTitleText: "${_appScreenText['gameCode']}: ${widget.gameCode}",
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
                            showTips
                                ? Text(
                                    _appScreenText['tips'],
                                    style: AppDecorators.getHeadLine3Style(
                                        theme: theme),
                                  )
                                : Container(),

                            // sep
                            SizedBox(width: 10.0.pw),

                            showTips
                                ? Text(
                                    DataFormatter.chipsFormat(getTotalRake())
                                        .toString(),
                                    style: AppDecorators.getHeadLine4Style(
                                        theme: theme),
                                  )
                                : Container(),
                          ],
                        ),
                        widget.showDownload
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: theme.accentColor,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      downloadTable(widget.gameCode);
                                    },
                                    child: Text(
                                      _appScreenText['download'],
                                      style: AppDecorators.getAccentTextStyle(
                                              theme: theme)
                                          .copyWith(
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),

                // table - graph row
                Row(
                  children: [
                    Expanded(
                      child: CupertinoSegmentedControl<int>(
                        unselectedColor: theme.primaryColor,
                        selectedColor: theme.secondaryColorWithDark(),
                        children: tableWidgets,
                        borderColor: theme.secondaryColor,
                        onValueChanged: (int val) {
                          setState(() => _selectedTableWidget = val);
                        },
                        groupValue: _selectedTableWidget,
                      ),
                    )
                  ],
                ),

                // main body
                _buildMainView(_selectedTableWidget, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  downloadTable(String gameCode) async {
    Future.delayed(Duration(seconds: 1), () async {
      try {
        final result =
            data.toCsv(); //await GameService.downloadResult(gameCode);
        String subject = 'Game Result: $gameCode';

        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$gameCode-result.csv');
        await file.writeAsString(result);
        await Share.shareFiles(
          [file.path],
          mimeTypes: ['text/csv'],
          subject: subject,
        );
        file.delete();
      } catch (err) {
        log('Error: ${err.toString()}, ${err.stackTrace}');
      }
    });
  }
}
