import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _moveToLoginScreen() => Navigator.pushReplacementNamed(
        context,
        Routes.registration,
      );

  _moveToMainScreen() => Navigator.pushReplacementNamed(
        context,
        Routes.main,
      );

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 400), () async {
      bool goToLoginScreen = true;
      if (AppConfig.deviceId == null || AppConfig.deviceSecret == null) {
        // go to login screen
      } else {
        try {
          // generate jwt
          final resp = await AuthService.newlogin(
              AppConfig.deviceId, AppConfig.deviceSecret);
          if (resp['status']) {
            // Need to initialize before queries
            await graphQLConfiguration.init();

            // successfully logged in
            AppConfig.jwt = resp['jwt'];
            // save device id, device secret and jwt
            AuthModel currentUser = AuthModel(
                deviceID: AppConfig.deviceId,
                deviceSecret: AppConfig.deviceSecret,
                name: resp['name'],
                uuid: resp['uuid'],
                playerId: resp['id'],
                jwt: resp['jwt']);
            await AuthService.save(currentUser);
            AppConfig.jwt = resp['jwt'];
            final availableCoins = await AppCoinService.availableCoins();
            AppConfig.setAvailableCoins(availableCoins);
            goToLoginScreen = false;
          }
        } catch (err) {
          goToLoginScreen = true;
        }
        
        if(goToLoginScreen) {
          _moveToLoginScreen();
          return;
        } else {
          _moveToMainScreen();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/splash.png'),
      ),
    );
  }
}
