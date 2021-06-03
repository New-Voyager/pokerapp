import 'dart:core';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:provider/provider.dart';

const BACKSPACE_BTN = 'bksp';
const sizedBox20 = const SizedBox(
  height: 20,
);

const sizedBox10 = const SizedBox(
  height: 10,
);

const sizedBox16 = const SizedBox(
  height: 16,
);

const sizedBox8 = const SizedBox(
  height: 8,
);

const sizedBox4 = const SizedBox(
  height: 4,
);
const sizedBox2 = const SizedBox(
  height: 2,
);

class NumericKeyboard2 extends StatelessWidget {
  final double min;
  final double max;
  final bool decimal;
  final String title;
  final double currValue;

  NumericKeyboard2(
      {Key key,
      this.title,
      this.min,
      this.max,
      this.currValue,
      this.decimal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double value = this.currValue;
    if (value <= this.min) {
      value = this.min;
    }
    String valueStr = value.toString();
    if (!decimal) {
      valueStr = value.round().toString();
    }

    return Container(
      decoration: const BoxDecoration(
        border: const Border(
          top: const BorderSide(
            color: AppColors.appAccentColor,
            width: 2.0,
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.45,
      child: MultiProvider(
        providers: [
          /* this provider holds the double value */
          ListenableProvider<ValueNotifier<String>>(
            create: (_) => ValueNotifier<String>(valueStr),
          ),

          /* this provider holds the error state */
          ListenableProvider<ValueNotifier<bool>>(
            create: (_) => ValueNotifier<bool>(false),
          ),
        ],
        builder: (context, __) => Scaffold(
          backgroundColor: AppColors.widgetBackgroundColor,
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /* title & close button */
                  _buildTitle(
                    title: title,
                  ),

                  /* separator */
                  sizedBox20,

                  /* amount */
                  Consumer2<ValueNotifier<String>, ValueNotifier<bool>>(
                    builder: (_, vnValue, vnError, __) => _buildAmountWidget(
                      value: vnValue.value,
                      error: vnError.value,
                      onCloseTab: () => Navigator.pop(context),
                      onDoneTab: () => _onDone(
                        context,
                        vnValue.value,
                        min,
                        max,
                      ),
                    ),
                  ),

                  /* separator */
                  sizedBox20,

                  /* keyboard */
                  _buildKeyboard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle({
    String title = 'Title goes here',
  }) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.white,
      ),
    );
  }

  void _onDone(
    BuildContext context,
    String value,
    double min,
    double max,
  ) {
    double v = double.parse(value);

    if (min == null) min = 0;
    if (max == null) max = double.infinity;

    if (min <= v && v <= max) return Navigator.pop(context, v);

    /* else show error */
    Provider.of<ValueNotifier<bool>>(
      context,
      listen: false,
    ).value = true;
  }

  Widget _buildAmountWidget({
    String value,
    bool error,
    Function onDoneTab,
    Function onCloseTab,
  }) {
    return Row(
      children: [
        /* bet amount */
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: error ? Colors.red : AppColors.appAccentColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: AppColors.appAccentColor,
                fontSize: 18.0,
              ),
            ),
          ),
        ),

        /* separator */
        const SizedBox(width: 15.0),

        /* done button */
        InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: onDoneTab,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 25.0,
              color: Colors.white,
            ),
          ),
        ),

        /* separator */
        const SizedBox(width: 15.0),

        /* close button */
        InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: onCloseTab,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Icon(
              Icons.close_rounded,
              size: 25.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /*
  * Util methods, for building the keyboard
  * goes below
  * */

  void _decideAction(
    ValueNotifier<String> vnValue,
    String buttonValue,
    BuildContext context,
  ) {
    String value = vnValue.value;

    /*
    * backspace action
    * */
    if (buttonValue == 'bksp') {
      if (value == '0') return;
      String newValue = value.substring(0, value.length - 1);
      if (newValue.isEmpty) newValue = '0';
      vnValue.value = newValue;

      return;
    }

    /* if we already have a decimal, do not allow anymore */
    if (buttonValue == '.') {
      if (!decimal) {
        return;
      }
      if (value.contains('.')) return;
    }

    /* numbers and decimal part */
    String newValue = '';
    if (value.length == 1 && value == '0')
      newValue = buttonValue;
    else
      newValue = value + buttonValue;

    vnValue.value = newValue;
  }

  Widget _buildButton1({
    String value,
    int flex = 1,
  }) {
    Color color = Colors.blue;
    Color splashColor = Colors.blue[800];
    IconData icon;
    if (value == BACKSPACE_BTN) {
      color = Colors.lightBlue;
      splashColor = Colors.blue[800];
      icon = Icons.backspace_rounded;
    }

    if (value == '.' && !decimal) {
      color = Colors.grey;
      splashColor = Colors.white70;
    }

    return Expanded(
        flex: flex,
        child: Material(
          color: Colors.blue, // button color
          child: InkWell(
            splashColor: Colors.red, // inkwell color
            //child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu)),
            child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      color: Colors.white,
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
            ),
            onTap: () {},
          ),
        ));
  }

  Widget _buildButton({
    String value,
    int flex = 1,
  }) {
    Color color = Colors.blue;
    Color splashColor = Colors.blue[800];
    IconData icon;
    if (value == BACKSPACE_BTN) {
      color = Colors.lightBlue;
      splashColor = Colors.blue[800];
      icon = Icons.backspace_rounded;
    }

    if (value == '.' && !decimal) {
      color = Colors.grey;
      splashColor = Colors.white70;
    }
    return Expanded(
      flex: flex,
      child: Builder(
        builder: (context) => Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            // border: Border.all(
            //   color: AppColors.appAccentColor,
            //   width: 2.0,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: splashColor, //Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              /* depending upon value, decide */

              final ValueNotifier<String> vnValue =
                  Provider.of<ValueNotifier<String>>(
                context,
                listen: false,
              );

              _decideAction(
                vnValue,
                value,
                context,
              );
            },
            child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      color: Colors.white,
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Expanded(
      child: Column(
        children: [
          /* 7 8 9 */
          Expanded(
            child: Row(
              children: [
                _buildButton(
                  value: '7',
                ),
                _buildButton(
                  value: '8',
                ),
                _buildButton(
                  value: '9',
                ),
              ],
            ),
          ),

          /* 4 5 6 */
          Expanded(
            child: Row(
              children: [
                _buildButton(
                  value: '4',
                ),
                _buildButton(
                  value: '5',
                ),
                _buildButton(
                  value: '6',
                ),
              ],
            ),
          ),

          /* 1 2 3 */
          Expanded(
            child: Row(
              children: [
                _buildButton(
                  value: '1',
                ),
                _buildButton(
                  value: '2',
                ),
                _buildButton(
                  value: '3',
                ),
              ],
            ),
          ),

          /* . 0 <- */
          Expanded(
            child: Row(
              children: [
                _buildButton(
                  value: '.',
                ),
                _buildButton(
                  value: '0',
                ),
                _buildButton(value: BACKSPACE_BTN),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* this method shows the keyboard, and returns numeric data */
  static Future<double> show(
    BuildContext context, {
    bool decimal = false,
    String title = 'Title goes here',
    double min = 0,
    double max,
  }) {
    return showGeneralDialog(
      barrierLabel: "Numeric Keyboard",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.10),
      transitionDuration: Duration(milliseconds: 150),
      context: context,
      pageBuilder: (context, _, __) => Align(
        alignment: Alignment.bottomCenter,
        child: NumericKeyboard2(
          title: title,
          min: min,
          max: max,
          currValue: min,
          decimal: decimal,
        ),
      ),
      transitionBuilder: (context, anim1, _, child) => SlideTransition(
        position: Tween(
          begin: Offset(0, 1),
          end: Offset(0, 0),
        ).animate(anim1),
        child: child,
      ),
    );
  }
}
