import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class ConnectionDialog {
  static show({@required BuildContext context, String loadingText}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: AppColors.plateBorderColor,
              width: 2,
            ),
          ),
          elevation: 5,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                loadingText ?? "Reconnecting..",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  static dismiss({@required BuildContext context}) {
    // Root navigator need to be true as showDailog also pushes to the same stack
    Navigator.of(context, rootNavigator: true).pop();
  }
}
