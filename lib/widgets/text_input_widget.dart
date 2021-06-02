import 'package:flutter/material.dart';
import 'package:pokerapp/utils/numeric_keyboard.dart';
import 'package:provider/provider.dart';

class TextInputWidget extends StatelessWidget {
  static const kEmpty = const SizedBox.shrink();

  final value;
  final String label;
  final String leading;
  final String trailing;
  final FontWeight labelFontWeight;
  final bool small;
  final void Function(int value) onChange;

  final double minValue;
  final double maxValue;

  TextInputWidget({
    this.value,
    this.label,
    this.leading,
    this.trailing,
    this.labelFontWeight = FontWeight.normal,
    this.small = false,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChange,
  });

  Widget _buildLabelAndSep() => label == null
      ? kEmpty
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* label */
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: small ? FontWeight.w300 : labelFontWeight,
              ),
            ),

            /* seperator */
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              height: 40.0,
              width: 0.30,
              color: Colors.white,
            ),
          ],
        );

  Widget _buildInputArea() => Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.only(bottom: 2.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
        ),
        child: Row(
          children: [
            /* leading */
            leading == null
                ? kEmpty
                : Container(
                    margin: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      leading,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: small ? 15.0 : 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),

            /* main value */
            Expanded(
              child: Consumer<ValueNotifier<double>>(
                builder: (_, vnValue, __) => Text(
                  vnValue.value?.toString() ?? (value?.toString() ?? ''),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),

            /* trailing */
            trailing == null
                ? kEmpty
                : Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      trailing,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: small ? 15.0 : 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
          ],
        ),
      );

  @override
  Widget build(BuildContext _) => ListenableProvider<ValueNotifier<double>>(
        create: (_) => ValueNotifier(null),
        builder: (BuildContext context, _) => InkWell(
          onTap: () async {
            /* open the numeric keyboard */
            final double value = await NumericKeyboard.show(
              context,
              title: label ?? 'Enter value',
              min: minValue,
              max: maxValue,
            );

            if (value == null) return;

            Provider.of<ValueNotifier<double>>(
              context,
              listen: false,
            ).value = value;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xff1E2E28),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                /* build label and seperator */
                _buildLabelAndSep(),

                /* main input area */
                Expanded(child: _buildInputArea()),
              ],
            ),
          ),
        ),
      );
}
