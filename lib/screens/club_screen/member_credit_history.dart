import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
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
    'Note',
    'Type',
    'Amount',
    'Credits'
  ];
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
                // header
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
                                  name: member.name,
                                  credits: member.availableCredit.toDouble());

                              if (ret) {
                                changed = true;
                                if (widget.member != null) {
                                  widget.member.refreshCredits = true;
                                }
                                if (member != null) {
                                  member.refreshCredits = true;
                                }
                                fetchData();
                              }
                            },
                          )
                  ],
                ),

                // download button
                Align(
                    alignment: Alignment.topRight,
                    child: RoundRectButton(
                      theme: theme,
                      icon: Icon(
                        Icons.download,
                        size: 24,
                        color: theme.roundButton2TextColor,
                      ),
                      text: 'Download',
                      onTap: () {
                        if (history != null && !history.isEmpty) {
                          _handleDownload();
                        }
                      },
                    )),

                // main table
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: activitiesTable(),
                  ),
                ),
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

    return PaginatedDataTable(
      columnSpacing: 10.0,
      rowsPerPage: 10,
      onSelectAll: (b) {},
      showFirstLastButtons: true,
      arrowHeadColor: theme.accentColor,
      columns: headers
          .map<DataColumn>(
            (header) => DataColumn(
              label: Text(header, style: headingStyle),
            ),
          )
          .toList(),
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
      typeColor = Colors.redAccent;
      notes = '${item.gameCode}';
    }
    if (item.updateType == 'GAME_RESULT') {
      type = 'Result';
      typeColor = Colors.yellowAccent;
      notes = '${item.gameCode}';
    }
    if (item.updateType == 'ADD' || item.updateType == 'DEDUCT') {
      type = 'Adjust';
      typeColor = Colors.lightBlue;
    }

    if (item.updateType == 'CHANGE') {
      type = 'Set';
      amountColor = Colors.white;
      //typeColor = Colors.cyan;
    }

    return DataRow.byIndex(
      index: index,
      cells: [
        item.followup
            ? DataCell(
                Container(
                    width: 10,
                    child: Icon(Icons.flag, color: theme.accentColor)),
                onTap: () async {
                clearFlag(item.transId);
              })
            : DataCell(Container(width: 10)),
        DataCell(
          Container(
            width: 50.pw,
            alignment: Alignment.center,
            child: FittedBox(
                child: Text(
              day,
              textAlign: TextAlign.start,
              style: AppDecorators.getSubtitle1Style(theme: theme)
                  .copyWith(fontSize: 8.dp),
            )),
          ),
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
          Text(
            type,
            style: AppDecorators.getSubtitle1Style(theme: theme)
                .copyWith(color: typeColor),
          ),
          onTap: () async {
            if (onTap != null) {
              await onTap(item.updateType, item.gameCode);
            }
          },
        ),
        DataCell(
          Container(
              alignment: Alignment.bottomRight,
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
              alignment: Alignment.bottomRight,
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
      ],
      color:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (index % 2 == 0) {
          return Colors.blueGrey[800];
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
