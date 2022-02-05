import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime initialDate;
  final String title;
  final AppTheme theme;
  DateRangePicker(
      {Key key,
      this.minimumDate,
      this.maximumDate,
      this.initialDate,
      this.title,
      this.theme})
      : super(key: key);

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();

  static Future<DateTimeRange> show(BuildContext context,
      {@required DateTime minimumDate,
      @required DateTime maximumDate,
      @required DateTime initialDate,
      @required String title,
      @required AppTheme theme}) async {
    ;
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            // insetPadding: EdgeInsets.,
            child: DateRangePicker(
              minimumDate: minimumDate,
              maximumDate: maximumDate,
              initialDate: initialDate,
              title: title,
              theme: theme,
            ),
          );
        });
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTimeRange _dateTimeRange;

  @override
  void initState() {
    _dateTimeRange =
        DateTimeRange(start: widget.initialDate, end: widget.maximumDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String startDateStr =
        DateFormat('dd MMM yyyy').format(_dateTimeRange.start);
    String endDateStr = DateFormat('dd MMM yyyy').format(_dateTimeRange.end);

    return Container(
      decoration: AppDecorators.bgRadialGradient(widget.theme).copyWith(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.theme.accentColor, width: 3),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.ph,
        horizontal: 10.ph,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              widget.title,
              style: AppDecorators.getHeadLine3Style(theme: widget.theme),
            ),
          ),
          SizedBox(
            height: 20.pw,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(flex: 2, child: Text("Start Date:")),
                    SizedBox(
                      width: 10.pw,
                    ),
                    Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          DateTime startDate = await showCustomDatePicker(
                              widget.minimumDate,
                              widget.maximumDate,
                              widget.initialDate);

                          setState(() {
                            _dateTimeRange = DateTimeRange(
                                start: startDate, end: _dateTimeRange.end);
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.pw,
                              vertical: 5.ph,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  100,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(startDateStr)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.pw,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(flex: 2, child: Text("End Date:")),
                    SizedBox(
                      width: 10.pw,
                    ),
                    Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          DateTime endDate = await showCustomDatePicker(
                              _dateTimeRange.start,
                              widget.maximumDate,
                              widget.maximumDate);

                          setState(() {
                            _dateTimeRange = DateTimeRange(
                                start: _dateTimeRange.start, end: endDate);
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.pw,
                              vertical: 5.ph,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  100,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(endDateStr)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.pw,
          ),
          Center(
              child: RoundRectButton(
            text: "OK",
            onTap: () {
              Navigator.pop(context, _dateTimeRange);
            },
            theme: widget.theme,
          )),
        ],
      ),
    );
  }

  Future<DateTime> showCustomDatePicker(
      DateTime minimumDate, DateTime maximumDate, DateTime initialDate) async {
    var themeColor = createMaterialColor(widget.theme.fillInColor);

    return await showRoundedDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimumDate,
      lastDate: maximumDate,
      height: 300.0,
      theme: ThemeData(
        primarySwatch: createMaterialColor(widget.theme.fillInColor),
        accentColor: widget.theme.accentColor,
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        backgroundPicker: themeColor[400],
        textStyleDayHeader: TextStyle(
          color: Colors.white,
        ),
        textStyleCurrentDayOnCalendar:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textStyleDayOnCalendar: TextStyle(color: Colors.white),
        textStyleDayOnCalendarSelected:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textStyleDayOnCalendarDisabled:
            TextStyle(color: Colors.white.withOpacity(0.4)),
        textStyleMonthYearHeader:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        backgroundActionBar: themeColor[400],
        textStyleButtonPositive: TextStyle(color: widget.theme.accentColor),
        textStyleButtonNegative: TextStyle(color: widget.theme.accentColor),
        backgroundHeaderMonth: themeColor[400],
        colorArrowNext: Colors.white,
        colorArrowPrevious: Colors.white,
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        textStyleYear: TextStyle(fontSize: 40, color: Colors.white),
        textStyleYearSelected: TextStyle(
            fontSize: 56, color: Colors.white, fontWeight: FontWeight.bold),
        heightYearRow: 100,
        backgroundPicker: themeColor[400],
      ),
      // background: widget.theme.fillInColor,
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
