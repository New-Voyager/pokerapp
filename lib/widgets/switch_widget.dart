import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class SwitchWidget extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool b) onChange;

  SwitchWidget({
    @required this.label,
    @required this.onChange,
    this.value = false,
  });

  @override
  Widget build(BuildContext context) => ListenableProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(value),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              /* label */
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),

              /* switch */
              Consumer<ValueNotifier<bool>>(
                builder: (_, vnValue, __) => FlutterSwitch(
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  activeSwitchBorder: Border.all(
                    color: Color(0xff40D876),
                    width: 2.0,
                  ),
                  inactiveSwitchBorder: Border.all(
                    color: Color(0xff4D4D4D),
                    width: 2.0,
                  ),
                  activeColor: Color(0xff092913),
                  activeToggleColor: Color(0xff40D876),
                  inactiveColor: Color(0xff1C1C1C),
                  inactiveToggleColor: Color(0xff4D4D4D),
                  showOnOff: true,
                  activeText: 'On',
                  inactiveText: 'Off',
                  value: vnValue.value,
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
