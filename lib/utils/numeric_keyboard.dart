import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

const sizedBox10 = const SizedBox(
  height: 10,
);
const sizedBox5 = const SizedBox(
  height: 5,
);

class NumericKeyboard {
  static Widget _buildTopRow({
    String title = 'Title goes here',
  }) =>
      Text(
        title,
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      );

  static Widget _buildAmountWidget({
    String value,
    Function onCloseTap,
    Function onDoneTap,
  }) =>
      Row(
        children: [
          /* bet amount */
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              decoration: const BoxDecoration(
                border: const Border(
                  bottom: const BorderSide(
                    color: AppColors.appAccentColor,
                    width: 0.50,
                  ),
                ),
              ),
              child: Text(
                value.isEmpty ? '0' : value,
                style: TextStyle(
                  color: AppColors.appAccentColor,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),

          /* close button */
          IconButton(
            iconSize: 30.0,
            padding: const EdgeInsets.all(0),
            icon: Icon(
              Icons.cancel_rounded,
              color: Colors.red,
            ),
            onPressed: onCloseTap,
          ),

          /* done button */
          IconButton(
            iconSize: 30.0,
            padding: const EdgeInsets.all(0),
            icon: Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
            ),
            onPressed: onDoneTap,
          ),
        ],
      );

  /*
  * Util methods, for building the keyboard
  * goes below
  * */

  static void _decideAction(
    ValueNotifier<String> vnValue,
    IconData iconData,
    String buttonValue,
    BuildContext context,
  ) {
    String value = vnValue.value;

    /*
    * backspace action
    * */
    if (iconData == Icons.backspace_rounded) {
      if (value == '0') return;
      String newValue = value.substring(0, value.length - 1);
      if (newValue.isEmpty) newValue = '0';
      vnValue.value = newValue;

      return;
    }

    /* if we already have a decimal, do not allow anymore */
    if (value.contains('.') && buttonValue == '.') return;

    /* numbers and decimal part */
    String newValue = '';
    if (value.length == 1 && value == '0')
      newValue = buttonValue;
    else
      newValue = value + buttonValue;

    vnValue.value = newValue;
  }

  static Widget _buildButton({
    String value,
    IconData icon,
    int flex = 1,
  }) =>
      Expanded(
        flex: flex,
        child: Builder(
          builder: (context) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: icon != null ? Colors.grey : Colors.blue,
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
              splashColor: Colors.transparent,
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
                  icon,
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

  static Widget _buildKeyboard() => Expanded(
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
                  _buildButton(
                    icon: Icons.backspace_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  /* this method shows the keyboard, and returns numeric data */
  static Future<double> show(
    BuildContext context, {
    String title = 'Title goes here',
  }) =>
      showGeneralDialog(
        barrierLabel: "Numeric Keyboard",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.10),
        transitionDuration: Duration(milliseconds: 150),
        context: context,
        pageBuilder: (context, _, __) => Align(
          alignment: Alignment.bottomCenter,
          child: Container(
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
                  create: (_) => ValueNotifier<String>('0'),
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
                        _buildTopRow(
                          title: title,
                        ),

                        /* separator */
                        sizedBox10,

                        /* amount */
                        Consumer<ValueNotifier<String>>(
                          builder: (_, vnValue, __) => _buildAmountWidget(
                            value: vnValue.value,
                            onCloseTap: () => Navigator.pop(context),
                            onDoneTap: () => Navigator.pop(
                              context,
                              double.parse(vnValue.value),
                            ),
                          ),
                        ),

                        /* separator */
                        sizedBox10,

                        /* keyboard */
                        _buildKeyboard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
