import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

class RequestFeatureWidget extends StatefulWidget {
  const RequestFeatureWidget({Key key}) : super(key: key);

  @override
  _RequestFeatureWidgetState createState() => _RequestFeatureWidgetState();
}

class _RequestFeatureWidgetState extends State<RequestFeatureWidget> {
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
              "Request Feature",
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
                    context: context, loadingText: "Submitting request..");
                await GameService.requestFeature(
                    feature: _controller.text.trim());
                ConnectionDialog.dismiss(context: context);
                Alerts.showNotification(titleText: "Request submitted");
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
