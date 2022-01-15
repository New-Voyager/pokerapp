import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/app/help_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/textfields.dart';

class ReportBugWidget extends StatefulWidget {
  const ReportBugWidget({Key key}) : super(key: key);

  @override
  _ReportBugWidgetState createState() => _ReportBugWidgetState();
}

class _ReportBugWidgetState extends State<ReportBugWidget> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Report Bug",
              textAlign: TextAlign.center,
              style: AppDecorators.getHeadLine3Style(theme: theme)
                  .copyWith(color: theme.accentColor),
            ),
          ),
          CardFormTextField(
            hintText: "Enter text",
            controller: _controller,
            maxLines: 10,
            theme: theme,
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          RoundRectButton(
            text: "Submit",
            onTap: () async {
              if (_controller.text.isNotEmpty) {
                ConnectionDialog.show(
                    context: context, loadingText: "Submitting bug..");
                await HelpService.requestFeature(
                    feature: _controller.text.trim());
                ConnectionDialog.dismiss(context: context);
                Alerts.showNotification(titleText: "Bug reported");
              }
              Navigator.of(context).pop();
            },
            theme: theme,
          ),
        ],
      ),
    );
  }
}
