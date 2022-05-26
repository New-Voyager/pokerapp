import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/switch_new.dart';
import 'package:provider/provider.dart';

class SwitchWidget2 extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool b) onChange;
  final bool disabled;
  final String activeText;
  final String inactiveText;
  final IconData icon;
  final bool visibleSwitch;
  /* ui variables */
  // final bool useSpacer;

  SwitchWidget2({
    Key key,
    @required this.label,
    @required this.onChange,
    this.icon = null,
    this.value = false,
    // this.useSpacer = true,
    this.disabled = false,
    this.activeText = 'On',
    this.inactiveText = 'Off',
    this.visibleSwitch = true,
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
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...iconChildren,
            /* label */
            (label != "")
                ? Expanded(
                    child: Text(
                      label,
                      style: AppDecorators.getHeadLine5Style(theme: theme),
                    ),
                  )
                : SizedBox.shrink(),

            /* spacer */
            // useSpacer ? const Spacer() : const SizedBox(width: 20.0),
            const SizedBox(width: 10.0),

            visibleSwitch
                ?

                /* switch */
                Consumer<ValueNotifier<bool>>(
                    builder: (_, vnValue, __) => FlutterSwitch2(
                      //width: activeText != 'On' ? 100 : 70.0,
                      width: 50,
                      height: 25,
                      disabled: disabled,
                      activeTextColor: theme.accentColor,
                      inactiveTextColor: theme.supportingColor.withAlpha(150),
                      activeSwitchBorderColor: theme.accentColor,
                      activeSwitchBorderWidth: 1.0,
                      inactiveSwitchBorderColor:
                          theme.supportingColor.withAlpha(100),
                      inactiveSwitchBorderWidth: 1.0,
                      activeColor: theme.accentColor.withAlpha(50),
                      activeToggleColor: theme.accentColor,
                      toggleSize: 15,
                      toggleBorder: Border.all(
                        color: theme.accentColor,
                        width: 0.5,
                      ),
                      inactiveColor: theme.fillInColor,
                      inactiveToggleColor: theme.accentColor,
                      //showOnOff: true,
                      activeText: activeText.toUpperCase(),
                      inactiveText: inactiveText.toUpperCase(),
                      value: vnValue.value ?? false,
                      activeTextFontWeight: FontWeight.w400,
                      inactiveTextFontWeight: FontWeight.w400,
                      showOnOff: true,
                      valueFontSize: 10.0,
                      onToggle: (bool newValue) {
                        vnValue.value = newValue;
                        onChange(newValue);
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
