import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
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
  List<String> preflopOptions = [];
  List<String> postflopOptions = [];
  List<String> raiseOptions = [];

  @override
  void initState() {
    super.initState();
    var bettingOptionsString =
        widget.gameState.playerLocalConfig.bettingOptions;
    print(bettingOptionsString);
    print("ldsfsjfbhsdfj");
    if (bettingOptionsString != null && bettingOptionsString != "") {
      var bettingOptions = json.decode(bettingOptionsString);

      bettingOptions['preflop'].forEach((element) {
        preflopOptions.add(element.toString());
      });
      bettingOptions['postflop'].forEach((element) {
        postflopOptions.add(element);
      });
      bettingOptions['raise'].forEach((element) {
        raiseOptions.add(element);
      });
    } else {
      preflopOptions.add("2");
      preflopOptions.add("3");
      preflopOptions.add("5");

      postflopOptions.add("30");
      postflopOptions.add("50");
      postflopOptions.add("100");

      raiseOptions.add("2");
      raiseOptions.add("3");
      raiseOptions.add("5");
    }
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
                      await onCutomizeButtonPressed(preflopOptions[0]);
                  setState(() {
                    preflopOptions[0] = value;
                  });
                },
                theme: theme,
                text: "${preflopOptions[0]}BB",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(preflopOptions[1]);
                  setState(() {
                    preflopOptions[1] = value;
                  });
                },
                theme: theme,
                text: "${preflopOptions[1]}BB",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(preflopOptions[2]);
                  setState(() {
                    preflopOptions[2] = value;
                  });
                },
                theme: theme,
                text: "${preflopOptions[2]}BB",
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Post-Flop (BB)",
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
                      await onCutomizeButtonPressed(postflopOptions[0]);
                  setState(() {
                    postflopOptions[0] = value;
                  });
                },
                theme: theme,
                text: "${postflopOptions[0]}%",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(postflopOptions[1]);
                  setState(() {
                    postflopOptions[1] = value;
                  });
                },
                theme: theme,
                text: "${postflopOptions[1]}%",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value =
                      await onCutomizeButtonPressed(postflopOptions[2]);
                  setState(() {
                    postflopOptions[2] = value;
                  });
                },
                theme: theme,
                text: "${postflopOptions[2]}%",
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
                  String value = await onCutomizeButtonPressed(raiseOptions[0]);
                  setState(() {
                    raiseOptions[0] = value;
                  });
                },
                theme: theme,
                text: "${raiseOptions[0]} x",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value = await onCutomizeButtonPressed(raiseOptions[1]);
                  setState(() {
                    raiseOptions[1] = value;
                  });
                },
                theme: theme,
                text: "${raiseOptions[1]} x",
              ),
              SizedBox(
                width: 20,
              ),
              BetAmountButton(
                onTap: () async {
                  String value = await onCutomizeButtonPressed(raiseOptions[2]);
                  setState(() {
                    raiseOptions[2] = value;
                  });
                },
                theme: theme,
                text: "${raiseOptions[2]} x",
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
                onTap: () {
                  var bettingOptions = {
                    'preflop': preflopOptions,
                    'postflop': postflopOptions,
                    'raise': raiseOptions
                  };
                  widget.gameState.playerLocalConfig.bettingOptions =
                      json.encode(bettingOptions);

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
    double value = await NumericKeyboard2.show(context, decimalAllowed: false);
    if (value != null) {
      return value.toInt().toString();
    }
    return currentValue;
  }
}
