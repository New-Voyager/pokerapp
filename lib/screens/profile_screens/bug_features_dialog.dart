import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/app/help_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/textfields.dart';
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
          Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              "Report",
              textAlign: TextAlign.center,
              style: AppDecorators.getHeadLine3Style(theme: theme),
            ),
          ),
          AppDimensionsNew.getVerticalSizedBox(4),
          RadioToggleButtonsWidget<String>(
            values: ['Bug', 'Feature'],
            defaultValue: isSelected[0] ? 0 : 1,
            onSelect: (int val) {
              setState(() {
                isSelected[0] = val == 0;
                isSelected[1] = val == 1;
              });
            },
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CardFormTextField(
              hintText: "Enter text",
              controller: _controller,
              elevation: 0,
              maxLines: 3,
              theme: theme,
            ),
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          ThemedButton(
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
            style: theme.blueButton,
          ),
          AppDimensionsNew.getVerticalSizedBox(16.0),
          Text(
            "By submitting this report, you agree we can use the features and any rights in them in any way we would like.",
            textAlign: TextAlign.center,
            style: AppDecorators.getHeadLine6Style(theme: theme)
                .copyWith(color: Colors.grey, fontSize: 10),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme)
                      .copyWith(color: theme.accentColor),
                  text: "Join our discord channel: \n",
                ),
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme).copyWith(
                    color: Color.fromARGB(255, 178, 209, 227),
                  ),
                  text: "https://discord.gg/dxDE9HJFuW",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = 'https://discord.gg/dxDE9HJFuW';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                        );
                      }
                    },
                ),
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme)
                      .copyWith(color: theme.accentColor),
                  text: "\n\nTelegram: ",
                ),
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme).copyWith(
                    color: Color.fromARGB(255, 178, 209, 227),
                  ),
                  text: "@PokerClubApp",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = 'https://t.me/PokerClubApp';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                        );
                      }
                    },
                ),
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme)
                      .copyWith(color: theme.accentColor),
                  text: "\n\nEmail: ",
                ),
                TextSpan(
                  style: AppDecorators.getHeadLine5Style(theme: theme).copyWith(
                    color: Color.fromARGB(255, 178, 209, 227),
                  ),
                  text: "contact@pokerclub.app",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = 'contact@pokerclub.app';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                        );
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
