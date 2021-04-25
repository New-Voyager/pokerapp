import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/services/gql_errors.dart';

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

showWaitlistStatus(BuildContext context, String message, int duration) async {
  Flushbar flush;
  flush = Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.bounceInOut,
    backgroundColor: Colors.red,
    //boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    backgroundGradient: LinearGradient(colors: [Colors.black, Colors.blueGrey]),
    isDismissible: false,
    duration: Duration(seconds: duration),
    icon: Icon(
      Icons.queue_play_next,
      color: Colors.greenAccent,
    ),
    mainButton: 
      Material( // pause button (round)
          borderRadius: BorderRadius.circular(50), // change radius size
          color: Colors.black12, //button colour
          child: InkWell(
            splashColor: Colors.white, // inkwell onPress colour
            child: SizedBox(
              width: 35,height: 35, //customisable size of 'button'
              child: Icon(Icons.close_rounded,color: Colors.blue,size: 16,),
            ),
            onTap: () {
              flush.dismiss();
            }, // or use onPressed: () {}
          ),
        ),    
    showProgressIndicator: false,
    progressIndicatorBackgroundColor: Colors.blueGrey,
    titleText: Text(
      "Waitlist Seating",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
    messageText: Text(
      message,
      style: TextStyle(
          fontSize: 12.0,
          color: Colors.green,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
  )..show(context);
}
