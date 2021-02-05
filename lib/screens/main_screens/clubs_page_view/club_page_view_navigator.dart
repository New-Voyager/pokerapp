import 'package:flutter/material.dart';
import 'clubs_page_view.dart';

class ClubPageNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (_) => ClubsPageView());
        },
      ),
    );
  }
}
