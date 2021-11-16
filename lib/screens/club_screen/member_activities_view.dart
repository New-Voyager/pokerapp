import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/member_activity_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/set_credits_dialog.dart';
import 'package:pokerapp/screens/club_screen/widgets/member_activity_filter_widget.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';

class ClubMemberActivitiesScreen extends StatefulWidget {
  // final ClubHomePageModel clubHomePageModel;
  final String clubCode;
  const ClubMemberActivitiesScreen(this.clubCode);

  @override
  State<ClubMemberActivitiesScreen> createState() =>
      _ClubMemberActivitiesScreenState();
}

class _ClubMemberActivitiesScreenState
    extends State<ClubMemberActivitiesScreen> {
  AppTheme theme;
  List<String> headers = [];
  bool loading;
  bool changed = false;
  DataSource dts;
  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    loading = true;
    fetchData();
  }

  void fetchData() async {
    try {
      final activities = MemberActivity.getMockData();
      bool includeTips = true;
      dts = DataSource(
          activities: activities, includeTips: includeTips, theme: theme);
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
    } catch (err) {}
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

    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          titleText: "Member Activities",
          theme: theme,
          actionsList: [
            IconButton(
              onPressed: () async {
                final ret = await Alerts.showDailog(
                  context: context,
                  child: MemberActivityFilterWidget(),
                );
                if (ret == null) {
                  return;
                }

                log("RET: $ret");
              },
              icon: Icon(
                Icons.filter_alt,
                color: theme.accentColor,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            // getFilterTile(),
            SingleChildScrollView(
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
          ],
        ),
      ),
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

  Widget getFilterTile() {
    return Column(
      children: [
        getDateRange(),
        getUnsettled(),
        getNegative(),
        getPositive(),
        getInactive(),
        getNoFilter(),
      ],
    );
  }

  Widget getDateRange() {
    return Row(
      children: [
        Radio(
          value: 0,
          groupValue: 0,
          onChanged: (int i) {},
        ),
        Text(
          'Date Range',
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget getUnsettled() {
    return Row(
      children: [
        Radio(
          value: 1,
          groupValue: 0,
          onChanged: (int i) {},
        ),
        Text(
          'Unsettled Credits',
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget getNegative() {
    return Row(
      children: [
        Radio(
          value: 2,
          groupValue: 0,
          onChanged: (int i) {},
        ),
        Text(
          'Negative Credits',
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget getPositive() {
    return Row(
      children: [
        Radio(
          value: 3,
          groupValue: 0,
          onChanged: (int i) {},
        ),
        Text(
          'Positive Credits',
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget getInactive() {
    return Row(
      children: [
        Radio(
          value: 4,
          groupValue: 0,
          onChanged: (int i) {},
        ),
        Text(
          'Inactive Members',
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget getNoFilter() {
    return Row(
      children: [
        Radio(
          value: 5,
          groupValue: 0,
          onChanged: (int i) {},
        ),
        Text(
          'No Filter',
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }
}

class DataSource extends DataTableSource {
  List<MemberActivity> activities;
  bool includeTips;
  bool includeLastPlayedDate;
  AppTheme theme;
  DataSource(
      {this.activities,
      this.includeTips = false,
      this.includeLastPlayedDate = false,
      this.theme});
  @override
  DataRow getRow(int index) {
    MemberActivity activity = activities[index];
    List<DataCell> cells = [];
    cells.add(
      DataCell(
        Container(
          width: 50,
          child: Text(activity.name),
        ),
      ),
    );
    cells.add(
      DataCell(
        Container(
          width: 50,
          child: Text(
            DataFormatter.chipsFormat(activity.credits),
          ),
        ),
      ),
    );

    if (includeTips) {
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.tips))),
      );
      cells.add(
        DataCell(Text('${activity.tipsBack}%')),
      );
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.tipsBackAmount))),
      );
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.buyin))),
      );
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.profit))),
      );
    }

    if (includeLastPlayedDate) {
      cells.add(
        DataCell(Text(DataFormatter.chipsFormat(activity.tipsBackAmount))),
      );
    }
    print("INDEX : ---- $index");
    return DataRow.byIndex(
      index: index,
      cells: cells,
      color: MaterialStateColor.resolveWith(
        (states) {
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
