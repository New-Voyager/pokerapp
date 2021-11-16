import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';

class MemberActivityFilterWidget extends StatefulWidget {
  const MemberActivityFilterWidget({Key key}) : super(key: key);

  @override
  _MemberActivityFilterWidgetState createState() =>
      _MemberActivityFilterWidgetState();
}

class _MemberActivityFilterWidgetState
    extends State<MemberActivityFilterWidget> {
  AppTextScreen _appTextScreen;
  int groupValue = 0;
  String winnerName = "";
  int winnerId = 0;

  DateTime _fromDate = DateTime.now().subtract(
    Duration(days: 30),
  );
  DateTime _toDate = DateTime.now();
  DateTimeRange _dateTimeRange;
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    _dateTimeRange = DateTimeRange(
      start: _fromDate,
      end: _toDate,
    );
    super.initState();
    _appTextScreen = getAppTextScreen("handHistoryFilter");
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            _appTextScreen['title'],
            style: AppDecorators.getAccentTextStyle(theme: theme),
          ),
        ),

        // Radio items

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: groupValue,
                  title: InkWell(
                    onTap: () {
                      setState(() {
                        groupValue = 1;
                      });
                      _handleDateRangePicker(context, theme);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Date Range"),
                          Visibility(
                            visible: groupValue == 1,
                            child: Text(
                              "${_dateFormat.format(_dateTimeRange.start)}  To  ${_dateFormat.format(_dateTimeRange.end)}",
                              style:
                                  AppDecorators.getSubtitle2Style(theme: theme),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      groupValue = 1;
                    });
                    _handleDateRangePicker(context, theme);
                  },
                ),
                RadioListTile(
                  value: 2,
                  groupValue: groupValue,
                  title: Row(
                    children: [
                      Text("Unsettled Credits"),
                    ],
                  ),
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      groupValue = 2;
                    });
                  },
                ),
                RadioListTile(
                  value: 3,
                  groupValue: groupValue,
                  title: Row(
                    children: [
                      Text("Negative Credits"),
                    ],
                  ),
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      groupValue = 3;
                    });
                  },
                ),
                RadioListTile(
                  value: 4,
                  groupValue: groupValue,
                  title: Row(
                    children: [
                      Text("Positive Credits"),
                    ],
                  ),
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      groupValue = 4;
                    });
                  },
                ),
                RadioListTile(
                  value: 5,
                  groupValue: groupValue,
                  title: Row(
                    children: [
                      Text("Inactive Members"),
                    ],
                  ),
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      groupValue = 5;
                    });
                  },
                ),
                // RadioListTile(
                //   value: 6,
                //   groupValue: groupValue,
                //   title: Row(
                //     children: [
                //       Text("No Filter"),
                //     ],
                //   ),
                //   onChanged: (value) {
                //     FocusScope.of(context).unfocus();
                //     setState(() {
                //       groupValue = 6;
                //     });
                //   },
                // ),
                AppDimensionsNew.getVerticalSizedBox(16),
              ],
            ),
          ),
        ),

        // Button items
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundRectButton(
                text: _appTextScreen['cancel'],
                onTap: () {
                  Map<String, dynamic> ret = Map<String, dynamic>();
                  ret['status'] = false;
                  Navigator.of(context).pop(false);
                },
                theme: theme,
              ),
              RoundRectButton(
                text: _appTextScreen['apply'],
                onTap: () {
                  if (groupValue != 0) {
                    Map<String, dynamic> ret = Map<String, dynamic>();
                    ret['status'] = true;
                    bool valid = false;
                    if (groupValue == 1) {
                      ret['selection'] = 'date';
                      ret['range'] = _dateTimeRange;
                      valid = true;
                    } else if (groupValue == 2) {
                      ret['selection'] = 'unsettled';
                      valid = true;
                    } else if (groupValue == 3) {
                      ret['selection'] = 'negative';
                      valid = true;
                    } else if (groupValue == 4) {
                      ret['selection'] = 'positive';

                      valid = true;
                    } else if (groupValue == 5) {
                      ret['selection'] = 'inactive';

                      valid = true;
                    } else if (groupValue == 6) {
                      ret['selection'] = 'nofilter';
                      valid = true;
                    }
                    if (valid) {
                      // Alerts.showNotification(
                      //   titleText: "${ret['selection']}",
                      // );
                      Navigator.of(context).pop(ret);
                    }
                  }
                },
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _handleDateRangePicker(BuildContext context, AppTheme theme) async {
    final dateRange = await showDateRangePicker(
      initialDateRange: _dateTimeRange,
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 3650)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: theme.primaryColor,
            accentColor: theme.accentColor,
            colorScheme: ColorScheme.light(primary: theme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (dateRange != null) {
      _dateTimeRange = dateRange;
    }
  }
}
