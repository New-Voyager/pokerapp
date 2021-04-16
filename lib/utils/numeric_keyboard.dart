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
  static Widget _buildAmountWidget({
    String value,
  }) =>
      Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: const BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              color: Colors.white,
              width: 0.50,
            ),
          ),
        ),
        child: Text(
          value.isEmpty ? '0' : value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      );

  static Widget _buildTopRow({
    String title = 'Title goes here',
    Function onCloseTap,
  }) =>
      Row(
        children: [
          /* title */
          Expanded(
            child: Text(
              title,
              style: AppStyles.optionTitle.copyWith(
                fontSize: 18.0,
              ),
            ),
          ),

          /* close button */
          IconButton(
            iconSize: 30.0,
            padding: const EdgeInsets.all(0),
            icon: Icon(
              Icons.close_rounded,
              color: Colors.red,
            ),
            onPressed: onCloseTap,
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
  ) {
    String value = vnValue.value;

    /*
    * backspace action
    * */
    if (iconData == Icons.backspace_rounded) {
      if (value.isEmpty) return;
      vnValue.value = value.substring(0, value.length - 1);
      return;
    }

    /*
    * done action
    * */
    if (iconData != null) {
      // todo: do the DONE part
      return;
    }

    /* if we already have a decimal, do not allow anymore */
    if (value.contains('.') && buttonValue == '.') return;

    /* numbers and decimal part */
    vnValue.value = value + buttonValue;
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
              color: AppColors.buttonBackGroundColor,
              border: Border.all(
                color: AppColors.appAccentColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 10.0,
                  spreadRadius: 10.0,
                ),
              ],
            ),
            child: InkWell(
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
                );
              },
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: AppColors.appAccentColor,
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          color: AppColors.appAccentColor,
                          fontSize: 18.0,
                        ),
                      ),
              ),
            ),
          ),
        ),
      );

  static Widget _buildKeyboard() => Expanded(
        child: Row(
          children: [
            /* numbers and decimal */
            Expanded(
              flex: 4,
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

                  /*  0  . */
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          value: '0',
                          flex: 2,
                        ),
                        _buildButton(
                          value: '.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /* backspace, and done button */
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildButton(
                    icon: Icons.backspace_rounded,
                  ),
                  _buildButton(
                    icon: Icons.check_rounded,
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
        barrierColor: Colors.black.withOpacity(0.20),
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
                  create: (_) => ValueNotifier<String>(''),
                ),
              ],
              builder: (context, __) => Scaffold(
                backgroundColor: AppColors.screenBackgroundColor,
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
                          onCloseTap: () => Navigator.pop(context),
                        ),

                        /* separator */
                        sizedBox10,

                        /* amount */
                        Consumer<ValueNotifier<String>>(
                          builder: (_, vnValue, __) => _buildAmountWidget(
                            value: vnValue.value,
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
