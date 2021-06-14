import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class StraddleDialog extends StatelessWidget {
  /* returns [OPTION, VALUE] */
  static Future<List<bool>> show(BuildContext context) =>
      showDialog<List<bool>>(
        context: context,
        builder: (_) => StraddleDialog(),
      );

  final List<bool> optionValue = [true, null];

  void _onValuePress(bool value, BuildContext context) {
    optionValue[1] = value;
    Navigator.pop(context, optionValue);
  }

  Widget _buildButton({
    String text,
    void Function() onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: 32.ph,
          width: 80.pw,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: AppColorsNew.newGreenButtonColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppStyles.clubItemInfoTextStyle.copyWith(
                  fontSize: 10.0.dp,
                  color: AppColorsNew.newGreenButtonColor,
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: AppColors.dialogBorderColor,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* title */
              Text(
                'Straddle?',
                style: TextStyle(fontSize: 20.0),
              ),

              // sep
              const SizedBox(height: 10.0),

              /* option */
              SwitchWidget(
                value: true,
                label: 'Option:',
                onChange: (bool newValue) => optionValue[0] = newValue,
              ),

              // sep
              const SizedBox(height: 10.0),

              /* yes, no button */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // yes button
                  _buildButton(
                    text: 'Yes',
                    onTap: () => _onValuePress(true, context),
                  ),

                  // no button
                  _buildButton(
                    text: 'No',
                    onTap: () => _onValuePress(false, context),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
