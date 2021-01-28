import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';

class UserViewUtilMethods {
  UserViewUtilMethods._();

  static TextStyle getStatusTextStyle(String status) {
    Color statusColor = Colors.black; // default color be black
    if (status != null) {
      if (status.toUpperCase().contains('CHECK') ||
          status.toUpperCase().contains('CALL'))
        statusColor = Colors.green;
      else if (status.toUpperCase().contains('RAISE') ||
          status.toUpperCase().contains('BET')) statusColor = Colors.red;
    }

    Color fgColor = Colors.white;
    return AppStyles.userPopUpMessageTextStyle
        .copyWith(fontSize: 10, color: fgColor, backgroundColor: statusColor);
  }
}
