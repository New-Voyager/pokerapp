import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

class SwitchWidget extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool b) onChange;
  final bool disabled;
  final String activeText;
  final String inactiveText;
  final IconData icon;
  /* ui variables */
  // final bool useSpacer;

  SwitchWidget({
    Key key,
    @required this.label,
    @required this.onChange,
    this.icon = null,
    this.value = false,
    // this.useSpacer = true,
    this.disabled = false,
    this.activeText = 'On',
    this.inactiveText = 'Off',
  }) : super(key: key == null ? UniqueKey() : key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    List<Widget> iconChildren = [];
    if (this.icon != null) {
      iconChildren.add(Icon(icon, color: theme.accentColor));
      iconChildren.add(SizedBox(width: 20));
    }
    return ListenableProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...iconChildren,
            /* label */
            Expanded(
              child: Text(
                label,
                style: AppDecorators.getHeadLine4Style(theme: theme),
              ),
            ),

            /* spacer */
            // useSpacer ? const Spacer() : const SizedBox(width: 20.0),
            const SizedBox(width: 20.0),

            /* switch */
            Consumer<ValueNotifier<bool>>(
              builder: (_, vnValue, __) => FlutterSwitch(
                width: activeText != 'On' ? 100 : 70.0,
                disabled: disabled,
                activeTextColor: theme.supportingColor,
                inactiveTextColor: theme.supportingColor.withAlpha(100),
                activeSwitchBorder: Border.all(
                  color: theme.accentColor,
                  width: 2.0,
                ),
                inactiveSwitchBorder: Border.all(
                  color: theme.supportingColor.withAlpha(100),
                  width: 2.0,
                ),
                activeColor: theme.fillInColor,
                activeToggleColor: theme.accentColor,
                inactiveColor: theme.fillInColor,
                inactiveToggleColor: theme.supportingColor.withAlpha(100),
                showOnOff: true,
                activeText: activeText,
                inactiveText: inactiveText,
                value: vnValue.value ?? false,
                onToggle: (bool newValue) {
                  vnValue.value = newValue;
                  onChange(newValue);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
