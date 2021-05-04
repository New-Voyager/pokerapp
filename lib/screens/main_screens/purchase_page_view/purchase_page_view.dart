import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pokerapp/main2.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/test/test_service.dart';

class PurchasePageView extends StatefulWidget {
  @override
  _PurchasePageViewState createState() => _PurchasePageViewState();
}

class _PurchasePageViewState extends State<PurchasePageView> {
  @override
  Widget build(BuildContext context) {
    //return Text("Purchase Page View", style:TextStyle(color: Colors.white),);

    return Scaffold(
          /* FIXME: THIS FLOATING ACTION BUTTON IS FOR SHOWING THE TESTS */
          floatingActionButton: floatingActionButton(
            onReload: () {}, context: context
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: Builder(
            builder: (_) {
              return Text("Purchase Page View", style:TextStyle(color: Colors.white),);
            },
          ),
        );
  }

 /* THIS SPEED DIAL IS JUST FOR SHOWING THE TEST BUTTONS */
  static SpeedDial floatingActionButton({
    Function onReload,
    BuildContext context,
  }) {
    return SpeedDial(
      onOpen: onReload,
      overlayColor: Colors.black,
      visible: TestService.isTesting,
      overlayOpacity: 0.1,
      icon: Icons.all_inclusive_rounded,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Products',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp2()),
            );
          }
        ),        
        SpeedDialChild(
          child: Icon(
            Icons.adb_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          label: 'Inapp Products',
          onTap: () => TestService.testIap(),
        ),
      ],
      backgroundColor: AppColors.appAccentColor,
    );
  }  
}

