import 'package:flutter/material.dart';
import 'package:pokerapp/screens/auth_screens/login_screen.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/played_hands/played_hands.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text('Logout'),
          onPressed: () {
            AuthService.logout();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
