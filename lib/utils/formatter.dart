import 'package:intl/intl.dart';

final DateFormat _dateFormatter =
    DateFormat.yMd().add_jm(); // internationalize this
final NumberFormat _chipsFormatter = new NumberFormat("0.00");
final NumberFormat _timeFormatter = new NumberFormat("00");

class DataFormatter {
  static String chipsFormat(double value) {
    if (value == null) {
      return '';
    }

    if (value == value.round()) {
      return '${value.toInt()}';
    } else {
      return _chipsFormatter.format(value);
    }
  }

  static String dateFormat(DateTime dt) {
    if (dt == null) {
      return '';
    }
    return _dateFormatter.format(dt);
  }

  static String timeFormat(int timeInSecs) {
    if (timeInSecs < 60) {
      timeInSecs = 60;
    }
    int mins = timeInSecs ~/ 60;
    int hour = mins ~/ 60;
    mins = (mins % 60);
    return '${_timeFormatter.format(hour)}:${_timeFormatter.format(mins)}';
  }

  static String minuteFormat(int timeInSecs) {
    int mins = timeInSecs ~/ 60;
    int seconds = timeInSecs % 60;
    String ret = '';
    if (mins != 0) {
      ret = '$mins minute${mins == 1 ? '' : 's'}';
    }

    if (seconds != 0) {
      ret = ret + ' $seconds seconds';
    }
    return ret;
  }
}
