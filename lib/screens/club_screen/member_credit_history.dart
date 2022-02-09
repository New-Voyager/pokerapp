import 'dart:io';

import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/set_credits_dialog.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/date_range_picker.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:share/share.dart';

import '../../routes.dart';

class ClubActivityCreditScreen extends StatefulWidget {
  // final ClubHomePageModel clubHomePageModel;
  final String clubCode;
  final String playerId;
  final bool owner;
  final ClubMemberModel member;
  const ClubActivityCreditScreen(
      this.clubCode, this.playerId, this.owner, this.member);

  @override
  State<ClubActivityCreditScreen> createState() =>
      _ClubActivityCreditScreenState();
}

class _ClubActivityCreditScreenState extends State<ClubActivityCreditScreen> {
  AppTheme theme;
  List<MemberCreditHistory> history;

  final List<String> headers = [
    '',
    'Date',
    'Notes',
    'Type',
    'Amount',
    'Credits',
    'Updated By'
  ];
  bool loading;
  ClubMemberModel member;
  bool changed = false;
  DataTableSource _dataTableSource;
  int _selectedDateRangeIndex;
  DateTimeRange _dateTimeRange;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    loading = true;
    initDates();
    fetchData();
  }

  void initDates() {
    var now = DateTime.now();
    var startDate = now.subtract(Duration(days: now.weekday));
    startDate =
        DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    var endDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
  }

  void fetchData() async {
    try {
      loading = true;
      setState(() {});
      member = await ClubInteriorService.getClubMemberDetail(
          widget.clubCode, widget.playerId);
      history = await ClubInteriorService.getCreditHistory(
          widget.clubCode, widget.playerId);
      // history = MemberCreditHistory.getMockData();
      _dataTableSource = DataCreditSource(
        items: history,
        theme: theme,
        onTap: openItem,
        clearFlag: clearFlag,
      );
    } catch (err) {}
    loading = false;
    setState(() {});
  }

  void clearFlag(int transId) async {
    bool ret = await showPrompt(
        context, 'Clear', 'Do you want to clear follow-up flag?',
        positiveButtonText: 'Yes', negativeButtonText: 'No');
    if (ret) {
      await ClubInteriorService.clearFollowupFlag(
          widget.clubCode, widget.playerId, transId);
      fetchData();
    }
  }

  Future<void> openItem(String activity, String gameCode) async {
    if (activity != "BUYIN" && activity != "GAME_RESULT") {
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.game_history_detail_view,
      arguments: {
        'clubCode': widget.clubCode,
        'model': GameHistoryDetailModel(gameCode, false),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    if (loading) {
      return Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressWidget(),
          ),
        ),
      );
    }

    String startDateStr = DateFormat('dd MMM').format(_dateTimeRange.start);
    String endDateStr = DateFormat('dd MMM').format(_dateTimeRange.end);
    if (_dateTimeRange.start.year != DateTime.now().year) {
      startDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.start);
      endDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.end);
    }

    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: member.name,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // header
                Padding(
                  padding: EdgeInsets.all(16.0.pw),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Credits",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                DataFormatter.chipsFormat(
                                    member.availableCredit),
                                style: AppDecorators.getHeadLine3Style(
                                        theme: theme)
                                    .copyWith(
                                        color: member.availableCredit < 0
                                            ? Colors.redAccent
                                            : Colors.greenAccent),
                              ),
                              !widget.owner
                                  ? SizedBox.shrink()
                                  : RoundRectButton(
                                      theme: theme,
                                      text: 'Change',
                                      onTap: () async {
                                        bool ret =
                                            await SetCreditsDialog.prompt(
                                                context: context,
                                                clubCode: widget.clubCode,
                                                playerUuid: widget.playerId,
                                                name: member.name,
                                                credits: member.availableCredit
                                                    .toDouble());

                                        if (ret) {
                                          changed = true;
                                          if (widget.member != null) {
                                            widget.member.refreshCredits = true;
                                          }
                                          if (member != null) {
                                            member.refreshCredits = true;
                                          }
                                          fetchData();

                                          appState.cacheService
                                                  .refreshClubMembers =
                                              widget.clubCode;
                                          await appState.cacheService
                                              .getMembers(widget.clubCode);
                                        }
                                      },
                                    )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      dateRangeFilter(),
                      SizedBox(height: 15),
                      Center(
                        child: Text(((startDateStr != endDateStr)
                            ? '${startDateStr} - ${endDateStr}'
                            : '$startDateStr')),
                      ),
                      SizedBox(height: 15.0),
                      // download button
                      Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: theme.accentColor,
                                ),
                                child: Icon(
                                  Icons.download,
                                  color: theme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 6.0),
                              InkWell(
                                onTap: () async {
                                  if (history != null && !history.isEmpty) {
                                    _handleDownload();
                                  }
                                },
                                child: Text(
                                  'Download',
                                  style: AppDecorators.getAccentTextStyle(
                                          theme: theme)
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          )
                          // RoundRectButton(
                          //   theme: theme,
                          //   icon: Icon(
                          //     Icons.download,
                          //     size: 24,
                          //     color: theme.roundButton2TextColor,
                          //   ),
                          //   text: 'Download',
                          //   onTap: () {
                          //     if (history != null && !history.isEmpty) {
                          //       _handleDownload();
                          //     }
                          //   },
                          // )

                          ),
                    ],
                  ),
                ),

                // main table
                activitiesTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDownload() async {
    if (history == null || history.isEmpty) return;

    final csv = MemberCreditHistory.makeCsv(
      headers: headers,
      history: history,
    );

    print(csv);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/Member Credit History.csv');
    await file.writeAsString(csv);
    await Share.shareFiles(
      [file.path],
      mimeTypes: ['text/csv'],
      subject: 'Member Credit History',
    );
    file.delete();
  }

  Widget buildBanner() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackArrowWidget(
              onBackHandle: () {
                Navigator.of(context).pop(changed);
              },
            ),
            dividingSpace(),
          ],
        ),
        Text(
          member.name,
          style: TextStyle(
            fontSize: 20.0.pw,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // activities table using data source with paginationtableclass
  activitiesTable() {
    TextStyle headingStyle =
        AppDecorators.getAccentTextStyle(theme: theme).copyWith(
      fontSize: 8.dp,
      fontWeight: FontWeight.normal,
    );
    List<DataColumn2> columns = [];
    columns.add(DataColumn2(label: Text('')));
    columns.add(DataColumn2(label: Text('Date'), size: ColumnSize.M));
    columns.add(DataColumn2(label: Text('Type'), size: ColumnSize.M));
    columns.add(
        DataColumn2(label: Text('Amount'), numeric: true, size: ColumnSize.M));
    columns.add(
        DataColumn2(label: Text('Credits'), numeric: true, size: ColumnSize.M));
    columns.add(DataColumn2(label: Text('Notes'), size: ColumnSize.L));
    columns.add(DataColumn2(label: Text('Updated\nby'), size: ColumnSize.M));
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text('Buyin'),
            SizedBox(
              width: 8,
            ),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text('Adjust'),
            SizedBox(
              width: 8,
            ),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text('Fee Credits'),
            SizedBox(
              width: 8,
            ),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text('Result'),
          ],
        ),
        Theme(
            data: Theme.of(context).copyWith(
              cardColor: theme.primaryColorWithDark(),
              dividerColor: theme.accentColor,
            ),
            child: PaginatedDataTable(
              columnSpacing: 10.0,
              showFirstLastButtons: true,
              arrowHeadColor: theme.accentColor,
              columns: columns,
              source: _dataTableSource,
              horizontalMargin: 6.0,
              rowsPerPage: 10,
            )),
      ],
    );
  }

  Widget bannerActionButton({IconData icon, String text, onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40.0.pw,
          width: 40.0.pw,
          child: Icon(
            icon,
            size: 24,
            color: theme.primaryColor,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0.pw),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16.pw, color: Colors.white),
        ),
      ],
    );
  }

  Widget dateRangeFilter() {
    var now = DateTime.now();

    return RadioToggleButtonsWidget<String>(
      defaultValue: _selectedDateRangeIndex,
      values: [
        'This\nWeek',
        'Last\nWeek',
        'This\nMonth',
        'Last\nMonth',
        'Custom',
        // 'Last Week',
        // 'Last Month'
      ],
      onSelect: (int value) async {
        _selectedDateRangeIndex = value;
        if (value == 0) {
          var startDate = now.subtract(Duration(days: now.weekday - 1));
          startDate =
              DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          var endDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          setState(() {});
        } else if (value == 1) {
          var startDate = now
              .subtract(Duration(days: now.weekday))
              .subtract(Duration(days: 7));
          startDate =
              DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          var endDate = startDate.add(Duration(days: 7));
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          setState(() {});
        } else if (value == 2) {
          var startDate = now.subtract(Duration(days: now.day - 1));
          startDate =
              DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          var endDate = startDate.add(Duration(days: now.day - 1));
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          setState(() {});
        } else if (value == 3) {
          var startDate = DateTime(now.year, now.month - 2, 1, 0, 0, 0);
          var endDate = DateTime(now.year, now.month - 1, 0, 0, 0, 0);
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          setState(() {});
        } else if (value == 4) {
          var newDateRange = await DateRangePicker.show(context,
              minimumDate: now.subtract(Duration(days: 90)),
              maximumDate: now,
              initialDate: now.subtract(Duration(days: 7)),
              title: "Custom",
              theme: theme);
          if (newDateRange != null) {
            _dateTimeRange = newDateRange;
            setState(() {});
          }
          setState(() {});
        }

        fetchData();
      },
    );
  }

  Widget dividingSpace() {
    return SizedBox(width: 16.0.ph, height: 16.0.ph);
  }
}

class DataCreditSource extends DataTableSource {
  List<MemberCreditHistory> items;
  DateFormat format = DateFormat("dd MMM");
  AppTheme theme;
  Function onTap;
  Function clearFlag;

  DataCreditSource({this.items, this.theme, this.onTap, this.clearFlag}) {
    format.add_jm();
  }

  @override
  DataRow getRow(int index) {
    MemberCreditHistory item = items[index];
    String text = format.format(item.updatedDate.toLocal());
    List<String> toks = text.split(' ');
    String day = '${toks[0]} ${toks[1]}\n${toks[2]}${toks[3]}';
    String type;
    String amount = DataFormatter.chipsFormat(item.amount);
    Color amountColor = Colors.white;
    Color typeColor = Colors.white;
    String notes = item.notes;
    if (item.amount < 0) {
      amountColor = Colors.red;
    } else if (item.amount > 0) {
      amountColor = Colors.green;
    }
    if (item.updateType == 'BUYIN') {
      type = 'Buyin';
      typeColor = Colors.yellow;
      notes = '${item.gameCode}';
    }
    if (item.updateType == 'GAME_RESULT') {
      type = 'Result';
      typeColor = Colors.greenAccent;
      notes = '${item.gameCode}';
    }
    if (item.updateType == 'ADD' || item.updateType == 'DEDUCT') {
      type = 'Adjust';
      typeColor = Colors.blue;
    }
    if (item.updateType == 'FEE_CREDIT') {
      type = 'Fee Credit';
      typeColor = Colors.white;
      notes = '${item.gameCode}';
    }
    if (item.updateType == 'CHANGE') {
      type = 'Set';
      amountColor = Colors.blue;
      //typeColor = Colors.cyan;
    }
    List<DataCell> cells = [
      item.followup
          ? DataCell(
              Container(
                  width: 10, child: Icon(Icons.flag, color: theme.accentColor)),
              onTap: () async {
              clearFlag(item.transId);
            })
          : DataCell(Container(width: 10)),
      DataCell(
        Text(
          day,
          textAlign: TextAlign.start,
          style: AppDecorators.getSubtitle1Style(theme: theme)
              .copyWith(fontSize: 8.dp),
        ),
        onTap: () async {
          if (onTap != null) {
            await onTap(item.updateType, item.gameCode);
          }
        },
      ),
      DataCell(
        // Text(
        //   type,
        //   style: AppDecorators.getSubtitle1Style(theme: theme)
        //       .copyWith(color: typeColor),
        // ),
        Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: typeColor),
          ),
        ),
        onTap: () async {
          if (onTap != null) {
            await onTap(item.updateType, item.gameCode);
          }
        },
      ),
      DataCell(
        Container(
            alignment: Alignment.center,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: AppDecorators.getSubtitle1Style(theme: theme)
                  .copyWith(color: amountColor, fontWeight: FontWeight.bold),
            )),
        onTap: () async {
          if (onTap != null) {
            await onTap(item.updateType, item.gameCode);
          }
        },
      ),
      DataCell(
        Container(
            alignment: Alignment.center,
            child: Text(
              DataFormatter.chipsFormat(item.updatedCredits),
              textAlign: TextAlign.right,
              style: AppDecorators.getSubtitle1Style(theme: theme),
            )),
        onTap: () async {
          if (onTap != null) {
            await onTap(item.updateType, item.gameCode);
          }
        },
      ),
      DataCell(
        Container(
          width: 100,
          child: Text(
            notes,
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
        ),
        onTap: () async {
          if (onTap != null) {
            await onTap(item.updateType, item.gameCode);
          }
        },
      ),
      DataCell(
        Container(
            alignment: Alignment.center,
            child: Text(
              item.adminName ?? "",
              textAlign: TextAlign.right,
              style: AppDecorators.getSubtitle1Style(theme: theme),
            )),
        onTap: () async {
          if (onTap != null) {
            await onTap(item.updateType, item.gameCode);
          }
        },
      ),
    ];
    return DataRow.byIndex(
      index: index,
      cells: cells,
      color:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (index % 2 == 0) {
          return theme.primaryColor;
        } else {
          return Colors.black54;
        }
      }),
    );
  }

  @override
  int get rowCount =>
      items.length; // Manipulate this to which ever value you wish

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
