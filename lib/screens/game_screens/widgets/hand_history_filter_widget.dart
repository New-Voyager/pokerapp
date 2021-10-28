import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';

class HandHistoryFilterWidget extends StatefulWidget {
  final List<Winner> winners;
  const HandHistoryFilterWidget({Key key, this.winners}) : super(key: key);

  @override
  _HandHistoryFilterWidgetState createState() =>
      _HandHistoryFilterWidgetState();
}

class _HandHistoryFilterWidgetState extends State<HandHistoryFilterWidget> {
  AppTextScreen _appTextScreen;
  int groupValue = 0;
  String winnerName = "";

  @override
  void initState() {
    super.initState();
    _appTextScreen = getAppTextScreen("handHistoryFilter");
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            _appTextScreen['title'],
            style: AppDecorators.getSubtitle2Style(theme: theme),
          ),
        ),

// Radio items

        RadioListTile(
          value: 1,
          groupValue: groupValue,
          title: Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(_appTextScreen['potSizeLabel']),
              ),
              Expanded(
                flex: 4,
                child: CardFormTextField(
                  onTap: () {
                    setState(() {
                      groupValue = 1;
                    });
                  },
                  hintText: "100",
                  theme: theme,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          onChanged: (value) {
            setState(() {
              groupValue = 1;
            });
          },
        ),

        RadioListTile(
          value: 2,
          groupValue: groupValue,
          title: Row(
            children: [
              Text(_appTextScreen['myHeadsLabel']),
            ],
          ),
          onChanged: (value) {
            FocusScope.of(context).unfocus();
            setState(() {
              groupValue = 2;
            });
          },
        ),
        RadioListTile(
          value: 3,
          groupValue: groupValue,
          title: Row(
            children: [
              Expanded(flex: 6, child: Text(_appTextScreen['lostChipsLabel'])),
              Expanded(
                flex: 4,
                child: CardFormTextField(
                  keyboardType: TextInputType.number,
                  hintText: "100",
                  theme: theme,
                  onTap: () {
                    setState(() {
                      groupValue = 3;
                    });
                  },
                ),
              ),
            ],
          ),
          onChanged: (value) {
            setState(() {
              groupValue = 3;
            });
          },
        ),

        RadioListTile(
          value: 4,
          groupValue: groupValue,
          title: Row(
            children: [
              Expanded(flex: 5, child: Text(_appTextScreen['potWinnerLabel'])),
              Expanded(
                flex: 6,
                child: DropdownButton(
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    setState(() {
                      groupValue = 4;
                    });
                  },
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      child: Text(_appTextScreen['select']),
                      value: "",
                    ),
                    ...buildDropDownItems(),
                  ],
                  value: winnerName,
                  onChanged: (val) {
                    setState(() {
                      winnerName = val;
                    });
                  },
                ),
              ),
            ],
          ),
          onChanged: (value) {
            FocusScope.of(context).unfocus();
            setState(() {
              groupValue = 4;
            });
          },
        ),
        AppDimensionsNew.getVerticalSizedBox(16),

        // Button items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoundRectButton(
              text: _appTextScreen['cancel'],
              onTap: () {
                Navigator.of(context).pop();
              },
              theme: theme,
            ),
            RoundRectButton(
              text: _appTextScreen['apply'],
              onTap: () {},
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropDownItems() {
    return List.generate(widget.winners?.length, (index) {
      Winner winner = widget.winners[index];
      return DropdownMenuItem<String>(
        child: Text(winner.name),
        value: winner.id.toString(),
        onTap: () {
          setState(() {
            winnerName = winner.id.toString();
          });
        },
      );
    });
  }
}
