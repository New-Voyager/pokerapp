import 'package:intl/intl.dart';
import 'package:pokerapp/enums/game_type.dart';

final DateFormat _dateFormatter =
    DateFormat.yMd().add_jms(); // internationalize this
final NumberFormat _chipsFormatter = new NumberFormat("0.00");
final NumberFormat _timeFormatter = new NumberFormat("00");

class DataFormatter {
  static String chipsFormat(double value,
      {ChipUnit chipUnit = ChipUnit.DOLLAR}) {
    if (value == null) {
      return '';
    }

    if (chipUnit == ChipUnit.CENT) {
      value = value / 100;
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

  static String timeFormatMMSS(
    double timeLeft, {
    bool hourReq = false,
  }) {
    final Duration duration = Duration(
      seconds: timeLeft.toInt(),
    );

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);

    if (hourReq) return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';

    return '$twoDigitMinutes:$twoDigitSeconds';
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

  static String getTimeInHHMMFormat(int timeInSec) {
    if (timeInSec == null) {
      return "0 Sec";
    }
    if (timeInSec <= 60) {
      return "$timeInSec seconds";
    }
    double mins = timeInSec / 60;
    if (mins > 0 && mins <= 1) {
      return "${mins.toStringAsFixed(0)} min";
    }
    if (mins > 1 && mins < 60) {
      return "${mins.toStringAsFixed(0)} mins";
    }
    return "${(mins / 60).toStringAsFixed(0)}hrs ";
  }

  static String getTimeInHHMMFormatInMin(int timeInMins) {
    if (timeInMins == null) {
      return "0 Sec";
    }
    double mins = timeInMins.toDouble();
    if (mins > 0 && mins <= 1) {
      return "${mins.toStringAsFixed(0)} min";
    }
    if (mins > 1 && mins < 60) {
      return "${mins.toStringAsFixed(0)} mins";
    }
    return "${(mins / 60).toStringAsFixed(0)} hrs";
  }

  static String yymmddhhmmssFormat() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("yyyyMMddhhmmss");
    return format.format(now);
  }

  static String getDDMMMYYYYFormat(DateTime date) {
    if (date == null) {
      return '';
    }
    return DateFormat("dd MMM yyyy").format(date);
  }

  static String getTimeInHHMMFormatFromDate(DateTime local) {
    if (local == null) {
      return "0 Sec";
    }

    return "${local.hour}:${local.minute}";
  }
}
