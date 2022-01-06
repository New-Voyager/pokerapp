import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/app/help_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class BugsFeaturesWidget extends StatefulWidget {
  const BugsFeaturesWidget({Key key}) : super(key: key);

  @override
  _BugsFeaturesWidgetState createState() => _BugsFeaturesWidgetState();
}

class _BugsFeaturesWidgetState extends State<BugsFeaturesWidget> {
  TextEditingController _controller = TextEditingController();

  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme)
                      .copyWith(color: theme.accentColor),
                  text: "Join our discord channel: ",
                ),
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme).copyWith(
                    color: Colors.blue.shade700,
                  ),
                  text: "https://discord.gg/AzHcCcFuA2",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = 'https://discord.gg/AzHcCcFuA2';
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceSafariVC: false,
                        );
                      }
                    },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Report",
              textAlign: TextAlign.center,
              style: AppDecorators.getHeadLine3Style(theme: theme)
                  .copyWith(color: theme.accentColor),
            ),
          ),
          AppDimensionsNew.getVerticalSizedBox(8),
          ToggleButtons(
            borderColor: Colors.black,
            constraints: BoxConstraints(
                minWidth: (MediaQuery.of(context).size.width - 60) / 2),
            fillColor: theme.accentColor,
            borderWidth: 2,
            selectedBorderColor: Colors.black,
            selectedColor: Colors.black,
            borderRadius: BorderRadius.circular(0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Report Bug',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Request Feature',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
              });
            },
            isSelected: isSelected,
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          CardFormTextField(
            hintText: "Enter text",
            controller: _controller,
            maxLines: 4,
            theme: theme,
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          RoundRectButton(
            text: "Submit",
            onTap: () async {
              if (_controller.text.isNotEmpty) {
                if (isSelected[0]) {
                  ConnectionDialog.show(
                      context: context, loadingText: "Submitting bug..");
                  await HelpService.reportBug(bug: _controller.text.trim());
                  ConnectionDialog.dismiss(context: context);
                  Alerts.showNotification(titleText: "Bug reported");
                } else {
                  ConnectionDialog.show(
                      context: context, loadingText: "Submitting request..");
                  await HelpService.requestFeature(
                      feature: _controller.text.trim());
                  ConnectionDialog.dismiss(context: context);
                  Alerts.showNotification(titleText: "Request submitted");
                }
              }
              Navigator.of(context).pop();
            },
            theme: theme,
          ),
          AppDimensionsNew.getVerticalSizedBox(16.0),
          Text(
            "By submitting this report, you agree we can use the features and any rights in them in any way we would use.",
            textAlign: TextAlign.center,
            style: AppDecorators.getHeadLine6Style(theme: theme)
                .copyWith(color: theme.secondaryColor),
          ),
        ],
      ),
    );
  }
}
