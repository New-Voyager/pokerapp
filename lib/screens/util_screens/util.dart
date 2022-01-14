import 'dart:developer';
import 'dart:math' as math;

//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/gql_errors.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:provider/provider.dart';

showAlertDialog(BuildContext context, String title, String message) {
  // set up the button
  Widget okButton = ElevatedButton(
    child: Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    backgroundColor: AppColorsNew.cardBackgroundColor,
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showError(BuildContext context, {GqlError error, String message}) {
  // translate to other languages here
  if (error != null) {
    message = error.message;
  }

  // set up the button
  Widget okButton = ElevatedButton(
    child: Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Error'),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showWaitlistInvitation(
    BuildContext context, String message, int duration) async {
  AppTheme theme = AppTheme.getTheme(context);
  final res = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: theme.fillInColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.accentColor,
        ),
      ),
      buttonPadding: EdgeInsets.all(16),
      title: Text('Waitlist'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
        ],
      ),
      actions: [
        RoundRectButton(
          text: 'No',
          theme: theme,
          onTap: () {
            Navigator.of(context).pop(false);
          },
        ),
        RoundRectButton(
          text: 'Yes',
          theme: theme,
          onTap: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
  final ret = res as bool;
  return ret ?? false;
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  if (duration.inSeconds <= 0) {
    return '0:00';
  }
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
