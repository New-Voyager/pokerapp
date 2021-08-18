import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToNextScreen(bool isAuthenticated) {
    Navigator.pushReplacementNamed(
      context,
      isAuthenticated ? Routes.main : Routes.registration,
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 400), () async {
      /*
      By default navigate to login screen, 
      if config has device id and device secret then navigates to main screen.
      */
      bool goToLoginScreen = true;
      if (AppConfig.deviceId != null || AppConfig.deviceSecret != null) {
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
      }
      _navigateToNextScreen(!goToLoginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    final themeData = HiveDatasource.getInstance
        .getBox(BoxType.USER_SETTINGS_BOX)
        .get("theme");
    if (themeData != null) {
      theme.updateThemeData(
        AppThemeData(
          primaryColor: Color(themeData['primaryColor']),
          secondaryColor: Color(themeData['secondaryColor']),
          accentColor: Color(themeData['accentColor']),
          fillInColor: Color(themeData['fillInColor']),
          fontFamily: themeData['fontFamily'],
          supportingColor: Color(themeData['supportingColor']),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/splash.png'),
      ),
    );
  }
}
