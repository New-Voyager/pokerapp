import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:provider/provider.dart';

class RankCardSelectionDialog extends StatelessWidget {
  final AppTheme appTheme;

  RankCardSelectionDialog({
    @required this.appTheme,
  });

  // returns the list of selected cards
  static Future<List<int>> show({
    @required BuildContext context,
  }) {
    final appTheme = context.read<AppTheme>();
    return showDialog<List<int>>(
      context: context,
      builder: (_) => RankCardSelectionDialog(
        appTheme: appTheme,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
