import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/member_activity_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/widgets/member_activity_filter_widget.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/custom_icon_button.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
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
  List<MemberActivity> allActivities;
  bool filtered = false;
  bool loading;
  bool changed = false;
  DataSource dts;
  bool unsettled = false;
  bool positive = false;
  bool negative = false;
  bool inactive = false;
  bool failed = false;
  bool daterange = false;
  DateTime start;
  DateTime end;
  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    loading = true;
    fetchData();
  }

  void fetchData() async {
    bool includeTips = false;
    bool includeLastPlayedDate = false;
    List<MemberActivity> activities = [];
    try {
      if (allActivities == null) {
        allActivities =
            await ClubInteriorService.getMemberActivity(widget.clubCode);

        // sort by last played date
        allActivities
            .sort((a, b) => b.lastPlayedDate.compareTo(a.lastPlayedDate));
      }

      if (!filtered) {
        includeLastPlayedDate = true;
        activities.addAll(allActivities);
      } else {
        if (daterange) {
          includeTips = true;
          // final activities = MemberActivity.getMockData();
          final tipsActivities =
              await ClubInteriorService.getMemberActivityDateFilter(
                  widget.clubCode, start, end);

          // remove activities that are within this date range
          activities = [];
          for (final activity in tipsActivities) {
            final date = activity.lastPlayedDate.toLocal();
            if (date.isAfter(start) && date.isBefore(end)) {
              activities.add(activity);
            }
          }
        } else {
          includeLastPlayedDate = true;
          DateTime inactiveDate = null;
          String inactiveDateStr;
          if (inactive) {
            inactiveDate = DateTime.now();
            inactiveDate = inactiveDate.subtract(Duration(days: 30));
            inactiveDateStr = inactiveDate.toUtc().toIso8601String();
          }
          // final activities = MemberActivity.getMockData();
          activities = await ClubInteriorService.getMemberActivity(
              widget.clubCode,
              unsettled: unsettled,
              positive: positive,
              negative: negative,
              inactiveDate: inactiveDateStr);
        }
      }
    } catch (err) {
      failed = true;
    }
    dts = DataSource(
        clubCode: widget.clubCode,
        club: widget.club,
        openMember: openMember,
        activities: activities,
        includeTips: includeTips,
        includeLastPlayedDate: includeLastPlayedDate,
        theme: theme);
    headers = [];

    headers.add('Name');
    headers.add('Credits');
    if (includeTips) {
      headers.add('Tips');
      headers.add('TB %');
      headers.add('TB');
      headers.add('Buyin');
      headers.add('Profit');
    }
    if (includeLastPlayedDate) {
      headers.add('Contact');
      headers.add('Last Active');
    }

    loading = false;
    setState(() {});
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
        DataColumn(
          label: Text(
            header,
            style: AppDecorators.getSubtitle1Style(theme: theme)
                .copyWith(color: theme.accentColor),
          ),
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
      String startDate = DateFormat.yMMMd().format(start);
      String endDate = DateFormat.yMMMd().format(end);
      Widget subTitle = Text('$startDate - $endDate',
          style: AppDecorators.getHeadLine4Style(theme: theme));
      filter = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        title,
        subTitle,
      ]);
    }
    return SafeArea(
      top: false,
      child: Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            titleText: "Member Activities",
            theme: theme,
            actionsList: [
              IconButton(
                onPressed: () async {
                  if (filtered) {
                    filtered = false;
                    unsettled = false;
                    negative = false;
                    positive = false;
                    inactive = false;
                    daterange = false;
                    loading = true;
                    setState(() {});
                    await fetchData();
                    return;
                  }
                  final ret = await Alerts.showDailog(
                    context: context,
                    child: MemberActivityFilterWidget(),
                  );
                  if (ret == null) {
                    return;
                  }

                  if (ret is bool) {
                    if (!ret) {
                      return;
                    }
                  }

                  if (ret['status'] ?? false) {
                    unsettled = false;
                    negative = false;
                    positive = false;
                    inactive = false;
                    daterange = false;
                    filtered = true;
                    var option = ret['selection'];
                    if (option == 'unsettled') {
                      // unsettled members
                      unsettled = true;
                    } else if (option == 'negative') {
                      negative = true;
                    } else if (option == 'positive') {
                      positive = true;
                    } else if (option == 'inactive') {
                      inactive = true;
                    } else if (option == 'date') {
                      daterange = true;
                      var range = ret['range'] as DateTimeRange;
                      start = DateTime(range.start.year, range.start.month,
                              range.start.day, 0, 0, 0)
                          .toUtc();
                      end = DateTime(range.end.year, range.end.month,
                              range.end.day, 23, 59, 59)
                          .toUtc();
                      log('start: ${start.toIso8601String()} end: ${end.toIso8601String()}');
                    }
                    loading = true;
                    setState(() {});
                    await fetchData();
                  }

                  log("RET: $ret");
                },
                icon: filtered
                    ? Icon(
                        Icons.cancel_outlined,
                        color: theme.accentColor,
                      )
                    : Icon(
                        Icons.filter_alt,
                        color: theme.accentColor,
                      ),
              )
            ],
          ),
          body: Column(
            children: [
              filter,
              Expanded(
                child: PaginatedDataTable(
                  // header: Text('Member Activities'),
                  columns: columns,
                  showFirstLastButtons: true,
                  arrowHeadColor: theme.accentColor,

                  source: dts,
                  rowsPerPage: 10,
                  columnSpacing: 15,
                ),
              ),
              const SizedBox(height: 20.0),
              CustomTextButton(
                onTap: _handleDownload,
                text: 'Download',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDownload() async {
    final csv = MemberActivity.makeCsv(
      headers: headers,
      activities: allActivities,
    );

    print(csv);

    final tempDir = await getTemporaryDirectory();

    final file = File('${tempDir.path}/Member Activities.csv');
    await file.writeAsString(csv);

    Share.shareFiles(
      [file.path],
      mimeTypes: ['text/csv'],
      subject: 'Member Activities',
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
          'Member Activities',
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
    bool updated = await Navigator.pushNamed(
      context,
      Routes.club_member_detail_view,
      arguments: {
        "clubCode": widget.clubCode,
        "playerId": playerUuid,
        "currentOwner": true,
      },
    ) as bool;
    if (updated) {
      await fetchData();
    }
  }
}

class DataSource extends DataTableSource {
  List<MemberActivity> activities;
  String clubCode;
  ClubHomePageModel club;
  bool includeTips;
  bool includeLastPlayedDate;
  AppTheme theme;
  Function openMember;
  DataSource(
      {this.clubCode,
      this.club,
      this.activities,
      this.openMember,
      this.includeTips = false,
      this.includeLastPlayedDate = false,
      this.theme});

  @override
  DataRow getRow(int index) {
    MemberActivity activity = activities[index];
    List<DataCell> cells = [];

    Color creditColor = Colors.white;
    if (activity.credits < 0) {
      creditColor = Colors.redAccent;
    } else if (activity.credits > 0) {
      creditColor = Colors.greenAccent;
    }

    Color color = null;
    cells.add(
      DataCell(
          Container(
            width: 50,
            child: Text(activity.name),
          ), onTap: () {
        openMember(activity.playerUuid);
      }),
    );
    cells.add(DataCell(
        Container(
          width: 50,
          child: Text(
            DataFormatter.chipsFormat(activity.credits),
            style: TextStyle(color: creditColor, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ), onTap: () {
      openMember(activity.playerUuid);
    }));

    if (includeTips) {
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.tips)), onTap: () {
          openMember(activity.playerUuid);
        }),
      );
      cells.add(
        DataCell(Text('${DataFormatter.chipsFormat(activity.tipsBack)}%'),
            onTap: () {
          openMember(activity.playerUuid);
        }),
      );
      cells.add(DataCell(
          Text(DataFormatter.chipsFormat(activity.tipsBackAmount)), onTap: () {
        openMember(activity.playerUuid);
      }));
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.buyin)), onTap: () {
          openMember(activity.playerUuid);
        }),
      );
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.profit)), onTap: () {
          openMember(activity.playerUuid);
        }),
      );
    }

    if (includeLastPlayedDate) {
      cells.add(
        DataCell(Text(activity.contactInfo), onTap: () {
          openMember(activity.playerUuid);
        }),
      );

      if (activity.lastPlayedDate != null) {
        var lastPlayedDate = activity.lastPlayedDate.toLocal();
        final diff = DateTime.now().difference(lastPlayedDate);
        final ago = new DateTime.now().subtract(diff);
        String agoText = timeago.format(ago).replaceAll("about", "");
        agoText = agoText.replaceAll("minutes", "mins");
        cells.add(
          DataCell(Text(agoText), onTap: () {
            openMember(activity.playerUuid);
          }),
        );
      }
    }
    if (activity.credits < 0) {
      color = Color.fromRGBO(0x40, 0, 0, 100);
    } else if (activity.credits > 0) {
      color = Color.fromRGBO(0, 0x40, 0, 100);
    } else {
      color = Colors.grey[700];
    }

    return DataRow.byIndex(
      index: index,
      cells: cells,
      color: MaterialStateColor.resolveWith(
        (states) {
          if (index % 2 == 0) {
            color = Colors.blueGrey[800];
          } else {
            color = Colors.black54;
          }
          return color;
          if (theme != null) {
            if (index % 2 == 0) {
              return theme.primaryColorWithDark(0.1);
            } else {
              return theme.primaryColorWithLight(0.1);
            }
          }

          if (index % 2 == 0) {
            return Colors.blueGrey[600];
          } else {
            return Colors.grey[500];
          }
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
