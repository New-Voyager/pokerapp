import 'dart:core';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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
  final String title;
  final int currValue;
  bool firstKey;

  NumericKeyboard2({
    Key key,
    this.title,
    this.min,
    this.max,
    this.currValue,
    // this.decimal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int value = this.currValue;

    if (value <= this.min) value = this.min.round();

    String valueStr = value.round().toString();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColorsNew.newBorderColor,
            width: 2.ph,
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.45,
      child: MultiProvider(
        providers: [
          /* this provider holds the input value as string */
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
                      vnValue: vnValue,
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
        fontSize: 18.dp,
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
    if (max == null || max == -1) max = double.infinity;

    if (min <= v && v <= max) return Navigator.pop(context, v);

    /* else show error */
    Provider.of<ValueNotifier<bool>>(
      context,
      listen: false,
    ).value = true;
  }

  Widget _buildAmountWidget({
    ValueNotifier<String> vnValue,
    bool error,
    Function onDoneTab,
    Function onCloseTab,
  }) {
    return Row(
      children: [
        /* bet amount */
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: error ? Colors.red : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                /* main bet amount area */
                Expanded(
                  child: Text(
                    vnValue.value.toString(),
                    style: TextStyle(
                      color: AppColorsNew.newTextColor,
                      fontSize: 18.dp,
                    ),
                  ),
                ),

                /* clear text button */
                InkResponse(
                  onTap: () {
                    vnValue.value = '';
                  },
                  child: Icon(
                    Icons.highlight_off_rounded,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ),

        /* separator */
        SizedBox(width: 25.pw),

        /* done button */
        InkResponse(
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
              size: 25.pw,
              color: Colors.white,
            ),
          ),
        ),

        /* separator */
        const SizedBox(width: 15.0),

        /* close button */
        InkResponse(
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
              size: 25.pw,
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

    if (firstKey) {
      value = '';
    }
    firstKey = false;
    /*
    * backspace action
    * */
    if (buttonValue == 'bksp') {
      if (value == '0' || value == '') {
        vnValue.value = '';
        return;
      }
      String newValue = value.substring(0, value.length - 1);
      if (newValue.isEmpty) newValue = '0';
      vnValue.value = newValue;

      return;
    }

    // /* if we already have a decimal, do not allow anymore */
    // if (buttonValue == '.') {
    //   if (!decimal) {
    //     return;
    //   }
    //   if (value.contains('.')) return;
    // }

    /* numbers and decimal part */
    String newValue = '';
    if (value.length == 1 && value == '0')
      newValue = buttonValue;
    else
      newValue = value + buttonValue;

    vnValue.value = newValue;
  }

  Widget _buildButton({
    String value,
    int flex = 1,
    double textSize = 28,
  }) {
    Color color = Colors.blue;
    Color splashColor = Colors.blue[800];
    IconData icon;
    color = AppColorsNew.newBorderColor;
    splashColor = AppColorsNew.newGreenRadialStartColor;
    if (value == BACKSPACE_BTN) {
      color = Colors.blueGrey;
      //splashColor = Colors.blue[800];
      icon = Icons.backspace_rounded;
    }

    if (value == '') {
      color = Colors.transparent;
      splashColor = Colors.transparent;
    }

    // if (value == '.' && !decimal) {
    //   color = Colors.grey;
    //   splashColor = Colors.white70;
    // }
    return Expanded(
      flex: flex,
      child: Builder(
        builder: (context) => Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
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
          child: InkResponse(
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
                        fontSize: textSize,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    int screenSize = Screen.diagonalInches.floor();
    double textSize = 28.dp;
    if (screenSize <= 6) {
      textSize = 16.dp;
    }
    return Expanded(
      child: Column(
        children: [
          /* 7 8 9 */
          Expanded(
            child: Row(
              children: [
                _buildButton(
                  value: '7',
                  textSize: textSize,
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
                  value: '',
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
    double currentVal,
  }) {
    if (currentVal == null) {
      currentVal = 0;
    }
    final val = currentVal.floor();
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
          currValue: val.floor(),
          // decimal: decimal,
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
