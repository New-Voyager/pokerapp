import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class StraddleDialog extends StatefulWidget {
  final GameState gameState;
  final bool straddlePrompt;
  final Function(List<bool>) onSelect;

  StraddleDialog({
    @required this.gameState,
    @required this.straddlePrompt,
    @required this.onSelect,
  });

  @override
  _StraddleDialogState createState() => _StraddleDialogState();
}

class _StraddleDialogState extends State<StraddleDialog> {
  bool _option = true;
  bool _auto = false;
  bool _value;

  @override
  void initState() {
    super.initState();

    // fetch the option and auto value from the game state settings object
    _option = widget.gameState.settings.straddleOption;
    _auto = widget.gameState.settings.autoStraddle;
  }

  void _onValuePress(bool value, BuildContext context) {
    _value = value;
    widget.onSelect?.call([_option, _auto, _value]);
  }

  Widget _buildButton({
    String text,
    void Function() onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32.ph,
          width: 80.pw,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: AppColorsNew.newGreenButtonColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
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
      );

  @override
  Widget build(BuildContext context) => widget.straddlePrompt == false
      ? const SizedBox.shrink()
      : Container(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* title */
              Text(
                'Straddle?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23.0),
              ),

              // sep
              const SizedBox(height: 10.0),

              /* option */
              SwitchWidget(
                value: _option,
                label: 'Option:',
                onChange: (bool newValue) => setState(() {
                  _option = newValue;
                  if (_option == false) _auto = false;
                }),
                useSpacer: false,
              ),

              /* auto value */
              SwitchWidget(
                key: UniqueKey(),
                disabled: !_option,
                value: _auto,
                label: 'Auto:',
                onChange: (bool newValue) => _auto = newValue,
                useSpacer: false,
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
        );
}
