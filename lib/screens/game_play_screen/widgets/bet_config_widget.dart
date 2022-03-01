import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/data/user_settings.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'dart:convert';

class BetConfigWidget extends StatefulWidget {
  final GameState gameState;
  BetConfigWidget({Key key, @required this.gameState}) : super(key: key);

  @override
  State<BetConfigWidget> createState() => _BetConfigWidgetState();
}

class _BetConfigWidgetState extends State<BetConfigWidget> {
  BettingOptions bettingOptions = BettingOptions();
  @override
  void initState() {
    super.initState();
    bettingOptions = appService.userSettings.getBettingOptions();
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppTheme.getTheme(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Pre-Flop (BB)",
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.preFlop[0]);
                  setState(() {
                    bettingOptions.preFlop[0] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.preFlop[0]}BB",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.preFlop[1]);
                  setState(() {
                    bettingOptions.preFlop[1] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.preFlop[1]}BB",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.preFlop[2]);
                  setState(() {
                    bettingOptions.preFlop[2] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.preFlop[2]}BB",
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Post-Flop (% Pot)",
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.postFlop[0]);
                  setState(() {
                    bettingOptions.postFlop[0] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.postFlop[0]}%",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.postFlop[1]);
                  setState(() {
                    bettingOptions.postFlop[1] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.postFlop[1]}%",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.postFlop[2]);
                  setState(() {
                    bettingOptions.postFlop[2] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.postFlop[2]}%",
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Raise(x times)",
            style: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.raise[0]);
                  setState(() {
                    bettingOptions.raise[0] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.raise[0]} x",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.raise[1]);
                  setState(() {
                    bettingOptions.raise[1] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.raise[1]} x",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(bettingOptions.raise[2]);
                  setState(() {
                    bettingOptions.raise[2] = int.parse(value);
                  });
                },
                theme: theme,
                text: "${bettingOptions.raise[2]} x",
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundRectButton(
                text: "Ok",
                onTap: () async {
                  await appService.userSettings
                      .setBettingOptions(bettingOptions);

                  Navigator.pop(context);
                },
                theme: theme,
              ),
              SizedBox(
                width: 20,
              ),
              RoundRectButton(
                text: "Cancel",
                onTap: () {
                  Navigator.pop(context);
                },
                theme: theme,
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<String> onCutomizeButtonPressed(var currentValue) async {
    double currentVal = currentValue.toDouble();
    double value = await NumericKeyboard2.show(context,
        decimalAllowed: false, currentVal: currentVal);
    if (value != null) {
      return value.toInt().toString();
    }
    return currentValue;
  }
}
