import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/gif_cache_service.dart';

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
      if (AppConfig.deviceId == null || AppConfig.deviceSecret == null) {
        _moveToLoginScreen();
      } else {
        // generate jwt
        try {
          final resp = await AuthService.newlogin(
              AppConfig.deviceId, AppConfig.deviceSecret);
          if (resp['status']) {
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
            await graphQLConfiguration.init();
          } else {
            _moveToLoginScreen();
            return;
          }
        } catch(err) {
          _moveToLoginScreen();
          return;
        }
        _moveToMainScreen();
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
