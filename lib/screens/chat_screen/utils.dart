import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String FROM_HOST = 'FROM_HOST';
const String TO_HOST = 'TO_HOST';

Color senderColor = Color.fromARGB(255, 55, 86, 124);
Color receiverColor = Color.fromARGB(255, 32, 41, 51);
Color chatHeaderColor = Color.fromARGB(255, 31, 44, 60);
Color chatBg = Color.fromARGB(255, 21, 28, 34);
Color userBg = Color.fromARGB(255, 0, 160, 233);
Color iconColor = Color.fromARGB(255, 103, 123, 143);

BoxDecoration decoration = BoxDecoration(
  borderRadius: BorderRadius.circular(8.0),
);

DateTime toDateTime(String date) {
  return DateTime.parse(date).toLocal();
}

String formatDate(DateTime date) {
  var dif = date.difference(DateTime.now()).inDays;
  if (dif == 0) {
    return "Today";
  } else {
    return DateFormat("MMMM d").format(date);
  }
}

String dateString(DateTime date) {
  // convert to local time
  return DateFormat.yMd().add_Hm().format(date.toLocal());
}
