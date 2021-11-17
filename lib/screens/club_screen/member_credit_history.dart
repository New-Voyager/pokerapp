import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/set_credits_dialog.dart';
import 'package:pokerapp/screens/club_screen/widgets/activity_bullet.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';

class ClubActivityCreditScreen extends StatefulWidget {
  // final ClubHomePageModel clubHomePageModel;
  final String clubCode;
  final String playerId;
  final bool owner;
  const ClubActivityCreditScreen(this.clubCode, this.playerId, this.owner);

  @override
  State<ClubActivityCreditScreen> createState() =>
      _ClubActivityCreditScreenState();
}

class _ClubActivityCreditScreenState extends State<ClubActivityCreditScreen> {
  AppTheme theme;
  List<MemberCreditHistory> history;
  bool loading;
  ClubMemberModel member;
  bool changed = false;
  DataTableSource _dataTableSource;
  @override
  void initState() {
    super.initState();
    theme = AppTheme.getTheme(context);
    loading = true;
    fetchData();
  }

  void fetchData() async {
    try {
      member = await ClubInteriorService.getClubMemberDetail(
          widget.clubCode, widget.playerId);
      history = await ClubInteriorService.getCreditHistory(
          widget.clubCode, widget.playerId);
      history = MemberCreditHistory.getMockData();
      _dataTableSource = DataCreditSource(items: history, theme: theme);
    } catch (err) {}
    loading = false;
    setState(() {});
  }

  Widget activities() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: history.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = history[index];
              Widget historyItem = Container();
              if (item.updateType == 'GAME_RESULT') {
                historyItem = Container(
                  color: theme.fillInColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('Game Code',
                                      style: AppStylesNew.gameCodeTextStyle),
                                  Text(item.gameCode)
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Stack",
                                    style: AppStylesNew.accentTextStyle
                                        .copyWith(
                                            fontSize: 12.dp,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${DataFormatter.chipsFormat(item.amount)}',
                                    style: TextStyle(
                                      color: item.amount < 0
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                      fontSize: 12.dp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '${DataFormatter.chipsFormat(item.updatedCredits)}',
                                  style: TextStyle(
                                    color: item.updatedCredits < 0
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontSize: 12.dp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(item.updatedDate.toLocal().toString())),
                        Divider(color: Colors.white),
                      ],
                    ),
                  ),
                );
              } else if (item.updateType == 'BUYIN') {
                historyItem = Container(
                  color: theme.fillInColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('Game Code',
                                      style: AppStylesNew.gameCodeTextStyle),
                                  Text(item.gameCode)
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Buyin",
                                    style: AppStylesNew.buyinTextStyle.copyWith(
                                        fontSize: 12.dp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${DataFormatter.chipsFormat(item.amount)}',
                                    style: TextStyle(
                                      color: item.amount < 0
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                      fontSize: 12.dp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '${DataFormatter.chipsFormat(item.updatedCredits)}',
                                  style: TextStyle(
                                    color: item.updatedCredits < 0
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontSize: 12.dp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(DataFormatter.dateFormat(
                                item.updatedDate.toLocal()))),
                        Divider(color: Colors.white),
                      ],
                    ),
                  ),
                );
              } else if (item.updateType == 'CHANGE') {
                historyItem = Container(
                  color: theme.fillInColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(item.notes),
                                ],
                              ),
                              Text(
                                  '${DataFormatter.chipsFormat(item.updatedCredits)}',
                                  style: TextStyle(
                                    color: item.updatedCredits < 0
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontSize: 12.dp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                        SizedBox(
                          height: 5.ph,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('Updated by ${item.adminName}',
                              style: AppStylesNew.footerResultTextStyle3),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(DataFormatter.dateFormat(
                                item.updatedDate.toLocal()))),
                        Divider(color: Colors.white),
                      ],
                    ),
                  ),
                );
              } else if (item.updateType == 'ADD' ||
                  item.updateType == 'DEDUCT') {
                bool add = item.updateType == 'ADD';
                historyItem = Container(
                  color: theme.fillInColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(item.notes),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    item.updateType == 'ADD' ? 'Add' : 'Deduct',
                                    style: AppStylesNew.buyinTextStyle.copyWith(
                                        color: add
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        fontSize: 12.dp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${DataFormatter.chipsFormat(item.amount)}',
                                    style: TextStyle(
                                      color: !add
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                      fontSize: 12.dp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '${DataFormatter.chipsFormat(item.updatedCredits)}',
                                  style: TextStyle(
                                    color: item.updatedCredits < 0
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontSize: 12.dp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(DataFormatter.dateFormat(
                                item.updatedDate.toLocal()))),
                        Divider(color: Colors.white),
                      ],
                    ),
                  ),
                );
              }
              return historyItem;
            }),
      ),
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
          child: Container(
            padding: EdgeInsets.all(16.0.pw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // buildBanner(),
                // dividingSpace(),
                // Divider(color: Colors.white),
                // dividingSpace(),
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
                      Text(
                        DataFormatter.chipsFormat(member.availableCredit),
                        style: AppDecorators.getHeadLine3Style(theme: theme)
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
                                bool ret = await SetCreditsDialog.prompt(
                                    context: context,
                                    clubCode: widget.clubCode,
                                    playerUuid: widget.playerId,
                                    credits: member.availableCredit.toInt());
                                if (ret) {
                                  changed = true;
                                  fetchData();
                                }
                              })
                    ]),
                dividingSpace(),
                /*  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activities",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Balance",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                dividingSpace(),
                activities(), */
                activitiesTable(),
              ],
            ),
          ),
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
    TextStyle headingStyle = AppDecorators.getAccentTextStyle(theme: theme)
        .copyWith(fontWeight: FontWeight.normal);

    return PaginatedDataTable(
      columnSpacing: 10.0,
      rowsPerPage: 10,
      onSelectAll: (b) {},
      showFirstLastButtons: true,
      arrowHeadColor: theme.accentColor,
      columns: [
        DataColumn(
          label: Text(
            "Date",
            style: headingStyle,
          ),
        ),
        DataColumn(
          label: Text(
            "Note",
            style: headingStyle,
          ),
        ),
        DataColumn(
          label: Text(
            "BuyIn",
            style: headingStyle,
          ),
        ),
        DataColumn(
          label: Text(
            "Stack",
            style: headingStyle,
          ),
        ),
        DataColumn(
          label: Text(
            "Adjustment",
            style: headingStyle,
          ),
        ),
        DataColumn(
          label: Text(
            "Amount",
            style: headingStyle,
          ),
        ),
        DataColumn(
          label: Text(
            "Credits",
            style: headingStyle,
          ),
        ),
      ],
      source: _dataTableSource,
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
}

class DataCreditSource extends DataTableSource {
  List<MemberCreditHistory> items;

  AppTheme theme;

  DataCreditSource({this.items, this.theme});

  @override
  DataRow getRow(int index) {
    MemberCreditHistory item = items[index];
    print("${item.updateType}");
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            width: 120.0.pw,
            alignment: Alignment.center,
            child: Text(
              DataFormatter.getDDMMMYYYYFormat(item.updatedDate) +
                  "\n" +
                  DataFormatter.getTimeInHHMMFormatFromDate(item.updatedDate),
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
          ),
        ),
        DataCell(
          Container(
            width: 100,
            child: Text(
              item.notes + " asdfasf are ar a r aeraewr ae",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
          ),
        ),
        DataCell(
          ActivityBulletWidget(
            columnType: 'BUYIN',
            type: item.updateType,
          ),
        ),
        DataCell(
          ActivityBulletWidget(
            columnType: 'GAME_RESULT',
            type: item.updateType,
          ),
        ),
        DataCell(
          ActivityBulletWidget(
            columnType: 'ADJUSTMENT',
            type: item.updateType,
          ),
        ),
        DataCell(
          Text(
            DataFormatter.chipsFormat(item.amount),
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
        ),
        DataCell(
          Text(
            DataFormatter.chipsFormat(item.updatedCredits),
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
        ),
      ],
      color:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (index % 2 == 0) {
          return theme.primaryColor;
        } else {
          return theme.primaryColorWithLight(0.1);
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
