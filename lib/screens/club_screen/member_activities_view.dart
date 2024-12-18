import 'dart:developer';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/member_activity_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/set_credits_dialog.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/date_range_picker.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/credits.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClubMemberActivitiesScreen extends StatefulWidget {
  // final ClubHomePageModel clubHomePageModel;
  final String clubCode;
  final ClubHomePageModel club;
  const ClubMemberActivitiesScreen(this.clubCode, this.club);

  @override
  State<ClubMemberActivitiesScreen> createState() =>
      _ClubMemberActivitiesScreenState();
}

class _ClubMemberActivitiesScreenState
    extends State<ClubMemberActivitiesScreen> {
  AppTheme theme;
  List<String> headers = [];
  final List<MemberActivity> memberActivitiesForDownload = [];
  bool loading;
  bool changed = false;
  DataSource dts;
  bool unsettled = false;
  bool positive = false;
  bool negative = false;
  bool inactive = false;
  bool failed = false;
  bool daterange = false;
  int _selectedDateRangeIndex;
  DateTimeRange _dateTimeRange;
  List<MemberActivity> activities = [];

  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    loading = true;
    initDates();
    fetchData();
  }

  void fetchData() async {
    try {
      DateTime start = _dateTimeRange.start.toUtc();
      DateTime end = _dateTimeRange.end.add(Duration(days: 1)).toUtc();
      final tipsActivities =
          await ClubInteriorService.getMemberActivityDateFilter(
              widget.clubCode, start, end);

      // remove activities that are within this date range
      activities = [];
      for (final activity in tipsActivities) {
        activities.add(activity);
      }
    } catch (err) {
      failed = true;
    }
    if (activities != null && activities.isNotEmpty) {
      memberActivitiesForDownload.clear();
      memberActivitiesForDownload.addAll(activities);
    }

    dts = DataSource(
        context: context,
        clubCode: widget.clubCode,
        club: widget.club,
        openMember: openMember,
        onShare: onShare,
        openCreditHistory: openCreditHistory,
        activities: activities,
        includeTips: true,
        includeShareButton: false,
        theme: theme,
        refresh: fetchData);
    headers = [];
    headers.add('');
    headers.add('Name');
    headers.add('Credits');
    headers.add('Fees');
    headers.add('Fee\nCredits%');
    headers.add('Fee\nCredits');
    headers.add('#Games');
    headers.add('#Hands');
    headers.add('Buyin');
    headers.add('Profit');

    loading = false;
    setState(() {});
  }

  void initDates() {
    var now = DateTime.now();
    var startDate = findFirstDateOfTheWeek(now);
    startDate =
        DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    var endDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
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
    List<DataColumn> columns = [];

    for (final header in headers) {
      columns.add(
        DataColumn2(
          label: Center(
            child: Text(
              header,
              style: AppDecorators.getSubtitle1Style(
                theme: theme,
              ).copyWith(
                color: theme.accentColor,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          size: ColumnSize.L,
        ),
      );
    }

    Widget filter = Container();

    if (unsettled) {
      filter = Text(
        'Unsettled',
        style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (positive) {
      filter = Text(
        'Positive',
        style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (negative) {
      filter = Text(
        'Negative',
        style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (inactive) {
      filter = Text(
        'Inactive',
        style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (daterange) {
      Widget title = Text(
        'Date Range',
        style: AppDecorators.getHeadLine3Style(theme: theme).copyWith(
          fontWeight: FontWeight.w600,
        ),
      );

      String startDate = DateFormat.yMMMd().format(_dateTimeRange.start);
      String endDate = DateFormat.yMMMd().format(_dateTimeRange.end);

      Widget subTitle = Text(
        '$startDate - $endDate',
        style: AppDecorators.getHeadLine4Style(theme: theme),
      );
      filter = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title,
          subTitle,
        ],
      );
    }

    String startDateStr = DateFormat('dd MMM').format(_dateTimeRange.start);
    String endDateStr = DateFormat('dd MMM').format(_dateTimeRange.end);
    if (_dateTimeRange.start.year != DateTime.now().year) {
      startDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.start);
      endDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.end);
    }

    double totalMemberFees = 0;
    for (final activity in activities) {
      totalMemberFees += activity.tips;
    }

    return SafeArea(
      top: false,
      child: Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            titleText: "Players Report",
            theme: theme,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                filter,
                const SizedBox(height: 16.0),
                dateRangeFilter(),
                const SizedBox(height: 16.0),
                Center(
                  child: Text(((startDateStr != endDateStr)
                      ? '${startDateStr} - ${endDateStr}'
                      : '$startDateStr')),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(children: [
                    LabelText(label: 'Total Player Fees:  ', theme: theme),
                    LabelText(
                        label: DataFormatter.chipsFormat(totalMemberFees),
                        theme: theme),
                  ]),
                ),
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
                          if (!memberActivitiesForDownload.isEmpty) {
                            _handleDownload();
                          }
                        },
                        child: Text(
                          'Download',
                          style: AppDecorators.getAccentTextStyle(theme: theme)
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                    alignment: Alignment.topLeft,
                    child: LabelText(
                        label: '*Credits: Shows the current credits',
                        theme: theme)),
                Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: theme.primaryColorWithDark(),
                    secondaryHeaderColor: theme.primaryColorWithDark(),
                    // dividerColor: theme.accentColor,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: PaginatedDataTable(
                      columns: columns,
                      horizontalMargin: 6.0,
                      showFirstLastButtons: true,
                      //arrowHeadColor: theme.accentColor,
                      source: dts,
                      rowsPerPage: 10,
                      columnSpacing: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          var startDate = findFirstDateOfTheWeek(now);
          startDate =
              DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          var endDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          setState(() {});
        } else if (value == 1) {
          var startDate =
              findFirstDateOfTheWeek(now).subtract(Duration(days: 7));
          startDate =
              DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
          var endDate = startDate.add(Duration(days: 6));
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          await fetchData();
          setState(() {});
        } else if (value == 2) {
          var startDate = now.subtract(Duration(days: now.day - 1));
          startDate = DateTime(startDate.year, startDate.month, 1, 0, 0, 0);
          var endDate = startDate.add(Duration(days: now.day - 1));
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          await fetchData();
          setState(() {});
        } else if (value == 3) {
          var startDate = DateTime(now.year, now.month - 1, 1, 0, 0, 0);
          var endDate = DateTime(now.year, now.month, 0, 0, 0, 0);
          _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
          await fetchData();
          setState(() {});
        } else if (value == 4) {
          await _handleDateRangePicker(context, theme);
          await fetchData();
          setState(() {});
        }

        fetchData();
      },
    );
  }

  _handleDateRangePicker(BuildContext context, AppTheme theme) async {
    DateTime now = DateTime.now();

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
  }

  void _handleDownload() async {
    if (memberActivitiesForDownload.isEmpty) return;
    List<String> headers = [];
    String csv;
    headers.addAll([
      "id",
      "name",
      "credits",
      "fees",
      "fee_perc",
      "fee_credits",
      "games_played",
      "hands_played",
      "buyin",
      "profit"
    ]);
    csv = MemberActivity.makeActivitiesFilteredCsv(
      headers: headers,
      activities: memberActivitiesForDownload,
    );

    print(csv);

    final tempDir = await getTemporaryDirectory();

    final file = File('${tempDir.path}/Players Report.csv');
    await file.writeAsString(csv);
    DateTime now = DateTime.now();
    String nowStr = DateFormat("dd-MMM-yyyy HH:MM").format(now);
    String text =
        'Activities of club ${widget.clubCode} recorded as of $nowStr';
    Share.shareFiles(
      [file.path],
      mimeTypes: ['text/csv'],
      subject: 'Players Report',
      text: text,
    );
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
          'Players Report',
          style: TextStyle(
            fontSize: 20.0.pw,
            fontWeight: FontWeight.bold,
          ),
        ),
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

  Widget dividingSpace() {
    return SizedBox(width: 16.0.ph, height: 16.0.ph);
  }

  void onShare(String name, String playerUuid, double credits) async {
    String text = '$name\n${DataFormatter.chipsFormat(credits)}';
    Share.share(text);
  }

  void openMember(String playerUuid) async {
    bool canOpen = false;
    if (widget.club.isOwner) {
      canOpen = true;
    } else {
      if (widget.club.isManager && widget.club.role.canUpdateCredits) {
        canOpen = true;
      }
    }
    if (!canOpen) {
      return;
    }
    log('clubCode: ${widget.clubCode} playerUuid: $playerUuid');

    bool ret = await Navigator.pushNamed(
      context,
      Routes.club_member_detail_view,
      arguments: {
        'clubCode': widget.clubCode,
        'playerId': playerUuid,
        'owner': true,
        'member': null, // widget.member,
      },
    ) as bool;

    if (ret) {
      fetchData();
    }
  }

  void openCreditHistory(String playerUuid) async {
    bool canOpen = false;
    if (widget.club.isOwner) {
      canOpen = true;
    } else {
      if (widget.club.isManager && widget.club.role.canUpdateCredits) {
        canOpen = true;
      }
    }
    if (!canOpen) {
      return;
    }
    log('clubCode: ${widget.clubCode} playerUuid: $playerUuid');

    bool ret = await Navigator.pushNamed(
      context,
      Routes.club_member_credit_detail_view,
      arguments: {
        'clubCode': widget.clubCode,
        'playerId': playerUuid,
        'owner': true,
        'member': null, // widget.member,
      },
    ) as bool;
    appState.cacheService.refreshClubMembers = widget.clubCode;
    await appState.cacheService.getMembers(widget.clubCode);
    fetchData();
  }
}

class DataSource extends DataTableSource {
  List<MemberActivity> activities;
  String clubCode;
  ClubHomePageModel club;
  bool includeTips;
  bool includeShareButton;
  AppTheme theme;
  Function openMember;
  Function openCreditHistory;
  Function onShare;
  Function refresh;
  BuildContext context;
  DataSource(
      {this.context,
      this.clubCode,
      this.club,
      this.activities,
      this.openMember,
      this.openCreditHistory,
      this.onShare,
      this.includeTips = false,
      this.includeShareButton = false,
      this.theme,
      this.refresh});

  @override
  DataRow2 getRow(int index) {
    MemberActivity activity = activities[index];
    List<DataCell> cells = [];

    Color creditColor = Colors.white;
    if (activity.credits < 0) {
      creditColor = Colors.redAccent;
    } else if (activity.credits > 0) {
      creditColor = Colors.greenAccent;
    }

    Color color = null;

    if (activity.followup) {
      cells.add(DataCell(
        Icon(Icons.flag, color: theme.accentColor),
      ));
    } else {
      cells.add(DataCell(
          Container(width: 10, height: 10, color: Colors.transparent)));
    }

    cells.add(
      DataCell(
          Container(
            child: Text(activity.name),
          ), onTap: () {
        openMember(activity.playerUuid);
      }),
    );

    cells.add(DataCell(
      Center(
          child: CreditsWidget(
              theme: theme,
              credits: activity.credits,
              onTap: () {
                if (openCreditHistory != null) {
                  openCreditHistory(activity.playerUuid);
                }
              })),
    ));
    if (includeTips) {
      cells.add(
        DataCell(Center(child: Text(DataFormatter.chipsFormat(activity.tips))),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );
      cells.add(
        DataCell(
            Center(
                child:
                    Text('${DataFormatter.chipsFormat(activity.tipsBack)}%')),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );

      if (activity.tipsBackAmount > 0) {
        cells.add(DataCell(
            Center(
                child: Column(children: [
              Text(DataFormatter.chipsFormat(activity.tipsBackAmount)),
              SizedBox(height: 3),
              Icon(Icons.payment, size: 12),
            ])), onTap: () async {
          // open credit dialog from here
          bool ret = await SetCreditsDialog.prompt(
              context: context,
              clubCode: clubCode,
              playerUuid: activity.playerUuid,
              credits: activity.credits,
              tipCredits: true,
              tipCreditsAmount: activity.tipsBackAmount,
              name: '');
          if (ret) {
            if (this.refresh != null) {
              // refresh the list
              this.refresh();
            }
          }
          //openMember(activity.playerUuid);
        }));
      } else {
        cells.add(DataCell(
            Center(
                child:
                    Text(DataFormatter.chipsFormat(activity.tipsBackAmount))),
            onTap: () {
          openMember(activity.playerUuid);
        }));
      }
      cells.add(
        DataCell(Center(child: Text(activity.gamesPlayed.toString())),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );
      cells.add(
        DataCell(Center(child: Text(activity.handsPlayed.toString())),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );

      cells.add(
        DataCell(Center(child: Text(DataFormatter.chipsFormat(activity.buyin))),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );
      cells.add(
        DataCell(
            Center(child: Text(DataFormatter.chipsFormat(activity.profit))),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );
    }

    if (includeShareButton) {
      cells.add(
        DataCell(Text(activity.contactInfo), onTap: () {
          openMember(activity.playerUuid);
        }),
      );

      cells.add(
        DataCell(Icon(Icons.share), onTap: () {
          // share this data via share app
          onShare(activity.name, activity.playerUuid, activity.credits);
        }),
      );
      // if (activity.lastPlayedDate != null) {
      //   var lastPlayedDate = activity.lastPlayedDate.toLocal();
      //   final diff = DateTime.now().difference(lastPlayedDate);
      //   final ago = new DateTime.now().subtract(diff);
      //   String agoText = timeago.format(ago).replaceAll("about", "");
      //   agoText = agoText.replaceAll("minutes", "mins");
      //   if (agoText == "a moment ago") {
      //     agoText = "a min ago";
      //   }
      //   cells.add(
      //     DataCell(Text(agoText), onTap: () {
      //       openMember(activity.playerUuid);
      //     }),
      //   );
      // }
    }
    if (activity.credits < 0) {
      color = Color.fromRGBO(0x40, 0, 0, 100);
    } else if (activity.credits > 0) {
      color = Color.fromRGBO(0, 0x40, 0, 100);
    } else {
      color = Colors.grey[700];
    }

    return DataRow2.byIndex(
      index: index,
      cells: cells,
      color: MaterialStateColor.resolveWith(
        (states) {
          if (index % 2 == 0) {
            color = theme.primaryColor;
          } else {
            color = Colors.black54;
          }
          // color = theme.fillInColor;
          return color;
        },
      ),
    );
  }

  @override
  int get rowCount =>
      activities.length; // Manipulate this to which ever value you wish

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
