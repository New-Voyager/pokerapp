import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/screens/auth_screens/login_screen.dart';
import 'package:pokerapp/screens/main_screens/main_screen.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _moveToLoginScreen() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );

  _moveToMainScreen() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(),
        ),
      );

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 400), () async {
      String jwt = await AuthService.getJwt();
      await graphQLConfiguration.init();
      if (jwt == null)
        _moveToLoginScreen();
      else
        _moveToMainScreen();
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
