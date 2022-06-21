import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/utils.dart';

class LogsScreen extends StatefulWidget {
  LogsScreen({Key key}) : super(key: key);

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    List<String> profileLogs = Profile.profileLogs;
    profileLogs = profileLogs.reversed.toList();
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: "Logs",
        ),
        body: ListView.builder(
          itemCount: profileLogs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: Text(profileLogs[index]),
            );
          },
        ),
      ),
    );
  }
}
